From: akpm@linux-foundation.org
Subject: +
 ocfs2-fix-a-deadlock-while-o2net_wq-doing-direct-memory-reclaim.patch added to -mm tree
Date: Thu, 18 Sep 2014 13:01:44 -0700
Message-ID: <541b3a28.YhNjuSVskZVaIX+i%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40997 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757243AbaIRUBp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 18 Sep 2014 16:01:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xuejiufei@huawei.com, jlbec@evilplan.org, junxiao.bi@oracle.com, mfasheh@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: fix a deadlock while o2net_wq doing direct memory reclaim
has been added to the -mm tree.  Its filename is
     ocfs2-fix-a-deadlock-while-o2net_wq-doing-direct-memory-reclaim.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-fix-a-deadlock-while-o2net_wq-doing-direct-memory-reclaim.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-fix-a-deadlock-while-o2net_wq-doing-direct-memory-reclaim.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Xue jiufei <xuejiufei@huawei.com>
Subject: ocfs2: fix a deadlock while o2net_wq doing direct memory reclaim

Fix a deadlock problem caused by direct memory reclaim in o2net_wq.  The
situation is as follows:

1) Receive a connect message from another node, node queues a
   work_struct o2net_listen_work.

2) o2net_wq processes this work and call the following functions:

o2net_wq
-> o2net_accept_one
  -> sock_create_lite
    -> sock_alloc()
      -> kmem_cache_alloc with GFP_KERNEL
        -> ____cache_alloc_node
          ->__alloc_pages_nodemask
            -> do_try_to_free_pages
              -> shrink_slab
                -> evict
                  -> ocfs2_evict_inode
                    -> ocfs2_drop_lock
                      -> dlmunlock
                        -> o2net_send_message_vec

   then o2net_wq wait for the unlock reply from master.

3) tcp layer received the reply, call o2net_data_ready() and queue
   sc_rx_work, waiting o2net_wq to process this work.

4) o2net_wq is a single thread workqueue, it process the work one by
   one.  Right now it is still doing o2net_listen_work and cannot handle
   sc_rx_work.  so we deadlock.

Junxiao Bi's patch "mm: clear __GFP_FS when PF_MEMALLOC_NOIO is set"
(http://ozlabs.org/~akpm/mmots/broken-out/mm-clear-__gfp_fs-when-pf_memalloc_noio-is-set.patch)
clears __GFP_FS in memalloc_noio_flags() besides __GFP_IO.  We use
memalloc_noio_save() to set process flag PF_MEMALLOC_NOIO so that all
allocations done by this process are done as if GFP_NOIO was specified. 
We are not reentering filesystem while doing memory reclaim.

Signed-off-by: joyce.xue <xuejiufei@huawei.com>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Mark Fasheh <mfasheh@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/cluster/tcp.c |   20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff -puN fs/ocfs2/cluster/tcp.c~ocfs2-fix-a-deadlock-while-o2net_wq-doing-direct-memory-reclaim fs/ocfs2/cluster/tcp.c
--- a/fs/ocfs2/cluster/tcp.c~ocfs2-fix-a-deadlock-while-o2net_wq-doing-direct-memory-reclaim
+++ a/fs/ocfs2/cluster/tcp.c
@@ -1601,7 +1601,15 @@ static void o2net_start_connect(struct w
 	struct sockaddr_in myaddr = {0, }, remoteaddr = {0, };
 	int ret = 0, stop;
 	unsigned int timeout;
+	unsigned int noio_flag;
 
+	/*
+	 * sock_create allocates the sock with GFP_KERNEL. We must set
+	 * per-process flag PF_MEMALLOC_NOIO so that all allocations done
+	 * by this process are done as if GFP_NOIO was specified. So we
+	 * are not reentering filesystem while doing memory reclaim.
+	 */
+	noio_flag = memalloc_noio_save();
 	/* if we're greater we initiate tx, otherwise we accept */
 	if (o2nm_this_node() <= o2net_num_from_nn(nn))
 		goto out;
@@ -1710,6 +1718,7 @@ out:
 	if (mynode)
 		o2nm_node_put(mynode);
 
+	memalloc_noio_restore(noio_flag);
 	return;
 }
 
@@ -1835,6 +1844,15 @@ static int o2net_accept_one(struct socke
 	struct o2nm_node *local_node = NULL;
 	struct o2net_sock_container *sc = NULL;
 	struct o2net_node *nn;
+	unsigned int noio_flag;
+
+	/*
+	 * sock_create_lite allocates the sock with GFP_KERNEL. We must set
+	 * per-process flag PF_MEMALLOC_NOIO so that all allocations done
+	 * by this process are done as if GFP_NOIO was specified. So we
+	 * are not reentering filesystem while doing memory reclaim.
+	 */
+	noio_flag = memalloc_noio_save();
 
 	BUG_ON(sock == NULL);
 	*more = 0;
@@ -1951,6 +1969,8 @@ out:
 		o2nm_node_put(local_node);
 	if (sc)
 		sc_put(sc);
+
+	memalloc_noio_restore(noio_flag);
 	return ret;
 }
 
_

Patches currently in -mm which might be from xuejiufei@huawei.com are

ocfs2-free-vol_lable-in-ocfs2_delete_osb.patch
ocfs2-call-o2quo_exit-if-malloc-failed-in-o2net_init.patch
ocfs2-remove-unused-code-in-dlm_new_lockres.patch
ocfs2-free-inode-when-i_count-becomes-zero.patch
ocfs2-dlm-fix-race-between-dispatched_work-and-dlm_lockres_grab_inflight_worker.patch
mm-clear-__gfp_fs-when-pf_memalloc_noio-is-set.patch
ocfs2-fix-a-deadlock-while-o2net_wq-doing-direct-memory-reclaim.patch

