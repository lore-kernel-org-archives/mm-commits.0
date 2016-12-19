From: akpm@linux-foundation.org
Subject: +
 scripts-spellingtxt-add-embeded-pattern-and-fix-typo-instances.patch added
 to -mm tree
Date: Mon, 19 Dec 2016 14:26:30 -0800
Message-ID: <58585e96.Djg7ez3pD+8jCGct%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43886 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932519AbcLSWZa (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 19 Dec 2016 17:25:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yamada.masahiro@socionext.com, mm-commits@vger.kernel.org


The patch titled
     Subject: scripts/spelling.txt: add "embeded" pattern and fix typo instances
has been added to the -mm tree.  Its filename is
     scripts-spellingtxt-add-embeded-pattern-and-fix-typo-instances.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/scripts-spellingtxt-add-embeded-pattern-and-fix-typo-instances.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/scripts-spellingtxt-add-embeded-pattern-and-fix-typo-instances.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Masahiro Yamada <yamada.masahiro@socionext.com>
Subject: scripts/spelling.txt: add "embeded" pattern and fix typo instances

Fix typos and add the following to the scripts/spelling.txt:

  embeded||embedded

Link: http://lkml.kernel.org/r/1481573103-11329-12-git-send-email-yamada.masahiro@socionext.com
Signed-off-by: Masahiro Yamada <yamada.masahiro@socionext.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 block/blk-throttle.c             |    2 +-
 drivers/nvme/host/rdma.c         |    2 +-
 drivers/scsi/osd/osd_initiator.c |    2 +-
 scripts/spelling.txt             |    1 +
 4 files changed, 4 insertions(+), 3 deletions(-)

diff -puN block/blk-throttle.c~scripts-spellingtxt-add-embeded-pattern-and-fix-typo-instances block/blk-throttle.c
--- a/block/blk-throttle.c~scripts-spellingtxt-add-embeded-pattern-and-fix-typo-instances
+++ a/block/blk-throttle.c
@@ -185,7 +185,7 @@ static struct throtl_grp *sq_to_tg(struc
  * sq_to_td - return throtl_data the specified service queue belongs to
  * @sq: the throtl_service_queue of interest
  *
- * A service_queue can be embeded in either a throtl_grp or throtl_data.
+ * A service_queue can be embedded in either a throtl_grp or throtl_data.
  * Determine the associated throtl_data accordingly and return it.
  */
 static struct throtl_data *sq_to_td(struct throtl_service_queue *sq)
diff -puN drivers/nvme/host/rdma.c~scripts-spellingtxt-add-embeded-pattern-and-fix-typo-instances drivers/nvme/host/rdma.c
--- a/drivers/nvme/host/rdma.c~scripts-spellingtxt-add-embeded-pattern-and-fix-typo-instances
+++ a/drivers/nvme/host/rdma.c
@@ -1066,7 +1066,7 @@ static int nvme_rdma_post_send(struct nv
 	 * sequencer is not allocated in our driver's tagset and it's
 	 * triggered to be freed by blk_cleanup_queue(). So we need to
 	 * always mark it as signaled to ensure that the "wr_cqe", which is
-	 * embeded in request's payload, is not freed when __ib_process_cq()
+	 * embedded in request's payload, is not freed when __ib_process_cq()
 	 * calls wr_cqe->done().
 	 */
 	if ((++queue->sig_count % 32) == 0 || flush)
diff -puN drivers/scsi/osd/osd_initiator.c~scripts-spellingtxt-add-embeded-pattern-and-fix-typo-instances drivers/scsi/osd/osd_initiator.c
--- a/drivers/scsi/osd/osd_initiator.c~scripts-spellingtxt-add-embeded-pattern-and-fix-typo-instances
+++ a/drivers/scsi/osd/osd_initiator.c
@@ -1675,7 +1675,7 @@ int osd_finalize_request(struct osd_requ
 		}
 	} else {
 		/* TODO: I think that for the GET_ATTR command these 2 should
-		 * be reversed to keep them in execution order (for embeded
+		 * be reversed to keep them in execution order (for embedded
 		 * targets with low memory footprint)
 		 */
 		ret = _osd_req_finalize_set_attr_list(or);
diff -puN scripts/spelling.txt~scripts-spellingtxt-add-embeded-pattern-and-fix-typo-instances scripts/spelling.txt
--- a/scripts/spelling.txt~scripts-spellingtxt-add-embeded-pattern-and-fix-typo-instances
+++ a/scripts/spelling.txt
@@ -386,6 +386,7 @@ efficently||efficiently
 ehther||ether
 eigth||eight
 eletronic||electronic
+embeded||embedded
 enabledi||enabled
 enchanced||enhanced
 encorporating||incorporating
_

Patches currently in -mm which might be from yamada.masahiro@socionext.com are

scripts-spellingtxt-add-swith-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-swithc-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-an-user-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-an-union-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-an-one-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-partiton-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-aligment-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-algined-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-efective-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-varible-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-embeded-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-againt-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-neded-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-unneded-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-intialization-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-initialiazation-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-intialised-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-comsumer-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-disbled-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-overide-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-overrided-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-configuartion-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-applys-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-explictely-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-omited-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-disassocation-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-deintialized-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-overwritting-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-overwriten-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-therfore-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-followings-pattern-and-fix-typo-instances.patch

