Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792469190;
	b=ZiR8Hajp00ca31Y+d/ivrLGAAY1TBa755yx/outPBltYAlnHRQdcdXiPLq3qzeXWVSBK
	 Qge6FZRjiJkAslyUc8A1OSUH+Hxzig2DLJK/dlC0JYLYIJgDmc2CSKpN7vAcXwj3oEuJY
	 M868YS+spTvS5bJ/VJqAQ3dxcsPsHM69soYGzXqKrxoFyCewRfpgob+RpNFMKj/7OFSM0
	 6p+ObaUo2FOeQ0cnDxdMGW6AGfXRPM/nLTIugPg0bMbozxTXdQw0QjuIB213+r2JgrwCx
	 1YU0TRDOdmddQ7ZYSb6iXBp2f6aw0fhHpQUY9WuqDGgQ7xiVcADLkALAKzAFvEM60Ug==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792469190;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=Rw3WTCfzr5tJ+o80s3+ES6ASulrkLzXMOK1uMc6FTXM=;
	b=PIOhcEC+svHNHsWfhHdSVyrFZLgKXdkaqufxSo6SlbsmRnhNX1zFwXjGteNhCUuhiKiE
	 Qe3by6FLhpTYkUomEmR5yjXNEatj77xfDmARBUX06/l8SAovsqUb2LihmEx5G2sQfm4cM
	 H0qirzygW2sSzO6Ghn5n4MSwSioihAvL5nlz9uqijluQaUKXFDfKDo1Iu9b6DJwtyFHF4
	 oPkKPnVRJjRIQuvsvErPLj/00MKwkNrvOqxqCDGGA48Ngt6hNYLfh5QlLCdIgdggNDSbF
	 OCUtKbryTnwYiES9dF7KWHVYfj8zUdpUb/uToBw1OdIrDmyQ29m2xSyfvafbNJRdlAQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=cX2EfIK7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20C8C606A32E;
	Tue, 20 Oct 2026 04:06:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=cX2EfIK7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AC341F000C5;
	Tue, 20 Oct 2026 04:06:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792469189;
	bh=Rw3WTCfzr5tJ+o80s3+ES6ASulrkLzXMOK1uMc6FTXM=;
	h=Date:To:From:Subject;
	b=cX2EfIK79qowIBwB74v+Hp1Swqib98uGaWt05DakkblJLFMdPFMqvNAVc+ewdRVHB
	 pqx7jbO/XPNyp+Cz9IhjTm/qnvUE9tRdae5bXWKsSShtu/qMImeXmfaoN267lyt6Sm
	 C+HlKb9L9IPF2NRLJ2+A90rSQ4F8i7FrnrQMbPBc=
Date: Mon, 19 Oct 2026 21:06:29 -0700
To: mm-commits@vger.kernel.org,sunil.mushran@oracle.com,stable@vger.kernel.org,mark@fasheh.com,kmehltretter@gmail.com,kees@kernel.org,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,jjzuming@gmail.com,heming.zhao@suse.com,ericterminal@gmail.com,christophe.jaillet@wanadoo.fr,baijiaju1990@gmail.com,zzzccc427@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-cluster-initialize-heartbeat-regions-before-publishing-them.patch added to mm-nonmm-unstable branch
Message-Id: <20261020040629.8AC341F000C5@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: ocfs2/cluster: Initialize heartbeat regions before publishing them
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ocfs2-cluster-initialize-heartbeat-regions-before-publishing-them.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-cluster-initialize-heartbeat-regions-before-publishing-them.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Cen Zhang <zzzccc427@gmail.com>
Subject: ocfs2/cluster: Initialize heartbeat regions before publishing them
Date: Fri, 16 Oct 2026 00:58:38 +0800

A region on o2hb_all_regions must have an initialized config item and
name. o2hb_heartbeat_group_make_item() currently links the zeroed region
under o2hb_live_lock, drops the lock, and only then initializes hr_item.
The lock therefore protects the list without protecting initialization
from readers of the published item.

With global heartbeat enabled, a DLM_QUERY_REGION from the current
joining node can pass the existing-domain and protocol checks while a
configfs mkdir creates another region. The DLM locks are not taken by
the constructor, and the network worker does not take the configfs
subsystem mutex. The following ordering is possible:

  Configfs mkdir                     O2net receive worker
  --------------                     --------------------
  Allocate reg
  Lock o2hb_live_lock
  Link into o2hb_all_regions
  Unlock o2hb_live_lock
                                     dlm_query_region_handler()
                                       dlm_match_regions()
                                         o2hb_get_all_regions()
                                           Lock o2hb_live_lock
                                           Copy 32 bytes from NULL name
                                           Unlock o2hb_live_lock
  config_item_init_type_name()

The query thus dereferences NULL. Initialize hr_item before linking the
region so the existing list lock also orders name initialization before
any reader. Reject a failed name allocation, since the initialization
helper does not propagate that error.

Use config_item_put() on initialized constructor failures to release the
name and respect references retained by o2hb_region_pin(). Initialize
the list heads, mutex and delayed works needed by o2hb_region_release()
before any such put, and leave the list node self-linked after rollback.
Keep the existing handler drain before removing a failed published item.

KASAN report as below:

    ==================================================================
    BUG: KASAN: null-ptr-deref in o2hb_get_all_regions+0xbb/0x1f0
    Read of size 32 at addr 0000000000000000 by task kworker/u16:1/14

    CPU: 2 UID: 0 PID: 14 Comm: kworker/u16:1 Not tainted 7.3.0-rc4-next-20260921-pmb-ocfs2-functional-v1+ #1 PREEMPT(lazy)
    Hardware name: QEMU Ubuntu 24.04 PC v2 (i440FX + PIIX, arch_caps fix, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
    Workqueue: o2net o2net_rx_until_empty
    Call Trace:
     <TASK>
     dump_stack_lvl+0x93/0xd0
     kasan_report+0xe0/0x110
     ? o2hb_get_all_regions+0xbb/0x1f0
     kasan_check_range+0x105/0x1b0
     __asan_memcpy+0x23/0x60
     o2hb_get_all_regions+0xbb/0x1f0
     dlm_query_region_handler+0x4c2/0xc20
     ? __pfx_dlm_query_region_handler+0x10/0x10
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? trace_hardirqs_on+0x18/0x160
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? kvm_clock_get_cycles+0x31/0x60
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? __pfx_dlm_query_region_handler+0x10/0x10
     o2net_rx_until_empty+0x1a50/0x3200
     ? reacquire_held_locks+0xdd/0x200
     ? __pfx_o2net_rx_until_empty+0x10/0x10
     ? lock_acquire+0x190/0x300
     ? process_one_work+0x935/0x1b40
     ? process_one_work+0x834/0x1b40
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? lock_release+0xc8/0x290
     ? srso_alias_return_thunk+0x5/0xfbef5
     process_one_work+0x9a8/0x1b40
     ? __pfx_process_one_work+0x10/0x10
     ? lock_acquire+0x190/0x300
     ? lock_is_held_type+0x8f/0x100
     ? srso_alias_return_thunk+0x5/0xfbef5
     worker_thread+0x65c/0xe40
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? __kthread_parkme+0x177/0x220
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? __pfx_worker_thread+0x10/0x10
     kthread+0x351/0x460
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? __pfx_kthread+0x10/0x10
     ret_from_fork+0x659/0x940
     ? __pfx_ret_from_fork+0x10/0x10
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? __switch_to+0x74f/0xf70
     ? __pfx_kthread+0x10/0x10
     ret_from_fork_asm+0x1a/0x30
     </TASK>
    ==================================================================

Link: https://lore.kernel.org/pm-ocfs2-objects-candidate-0079-v5-f931a29339cadc0a2a70@gmail.com
Fixes: 536f0741f324 ("ocfs2/cluster: Track number of global heartbeat regions")
Signed-off-by: Cen Zhang <zzzccc427@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Assisted-by: LLM
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Heming Zhao <heming.zhao@suse.com>
Cc: Yufan Chen <ericterminal@gmail.com>
Cc: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc: Kees Cook <kees@kernel.org>
Cc: Karl Mehltretter <kmehltretter@gmail.com>
Cc: Sunil Mushran <sunil.mushran@oracle.com>
Cc: Jia-Ju Bai <baijiaju1990@gmail.com>
Cc: <jjzuming@gmail.com>
Cc: <stable@vger.kernel.org>
---

 fs/ocfs2/cluster/heartbeat.c |   26 +++++++++++++++++---------
 1 file changed, 17 insertions(+), 9 deletions(-)

--- a/fs/ocfs2/cluster/heartbeat.c~ocfs2-cluster-initialize-heartbeat-regions-before-publishing-them
+++ a/fs/ocfs2/cluster/heartbeat.c
@@ -2140,6 +2140,18 @@ static struct config_item *o2hb_heartbea
 	}
 	reg->hr_node_num = O2NM_MAX_NODES;
 
+	INIT_LIST_HEAD(&reg->hr_all_item);
+	mutex_init(&reg->hr_arming_mutex);
+	reg->hr_stopping = true;
+	INIT_DELAYED_WORK(&reg->hr_write_timeout_work, o2hb_write_timeout);
+	INIT_DELAYED_WORK(&reg->hr_nego_timeout_work, o2hb_nego_timeout);
+	INIT_LIST_HEAD(&reg->hr_handler_list);
+	config_item_init_type_name(&reg->hr_item, name, &o2hb_region_type);
+	if (!config_item_name(&reg->hr_item)) {
+		ret = -ENOMEM;
+		goto put_item;
+	}
+
 	spin_lock(&o2hb_live_lock);
 	reg->hr_region_num = 0;
 	if (o2hb_global_heartbeat_active()) {
@@ -2148,26 +2160,19 @@ static struct config_item *o2hb_heartbea
 		if (reg->hr_region_num >= O2NM_MAX_REGIONS) {
 			spin_unlock(&o2hb_live_lock);
 			ret = -EFBIG;
-			goto free;
+			goto put_item;
 		}
 		set_bit(reg->hr_region_num, o2hb_region_bitmap);
 	}
 	list_add_tail(&reg->hr_all_item, &o2hb_all_regions);
 	spin_unlock(&o2hb_live_lock);
 
-	config_item_init_type_name(&reg->hr_item, name, &o2hb_region_type);
-
 	/* this is the same way to generate msg key as dlm, for local heartbeat,
 	 * name is also the same, so make initial crc value different to avoid
 	 * message key conflict.
 	 */
 	reg->hr_key = crc32_le(reg->hr_region_num + O2NM_MAX_REGIONS,
 		name, strlen(name));
-	mutex_init(&reg->hr_arming_mutex);
-	reg->hr_stopping = true;
-	INIT_DELAYED_WORK(&reg->hr_write_timeout_work, o2hb_write_timeout);
-	INIT_DELAYED_WORK(&reg->hr_nego_timeout_work, o2hb_nego_timeout);
-	INIT_LIST_HEAD(&reg->hr_handler_list);
 	ret = o2net_register_handler(O2HB_NEGO_TIMEOUT_MSG, reg->hr_key,
 			sizeof(struct o2hb_nego_msg),
 			o2hb_nego_timeout_handler,
@@ -2190,10 +2195,13 @@ unregister_handler:
 	o2net_unregister_and_flush_handler_list(&reg->hr_handler_list);
 remove_item:
 	spin_lock(&o2hb_live_lock);
-	list_del(&reg->hr_all_item);
+	list_del_init(&reg->hr_all_item);
 	if (o2hb_global_heartbeat_active())
 		clear_bit(reg->hr_region_num, o2hb_region_bitmap);
 	spin_unlock(&o2hb_live_lock);
+put_item:
+	config_item_put(&reg->hr_item);
+	return ERR_PTR(ret);
 free:
 	kfree(reg);
 	return ERR_PTR(ret);
_

Patches currently in -mm which might be from zzzccc427@gmail.com are

ocfs2-heartbeat-unlink-live-slots-when-their-node-is-missing.patch
ocfs2-initialize-status-waiters-before-publishing-them.patch
ocfs2-publish-the-filecheck-owner-before-adding-sysfs-attributes.patch
ocfs2-dlm-hold-a-lock-reference-across-grant-ast-enqueue.patch
ocfs2-cancel-quota-sync-work-before-freeing-quota-info.patch
ocfs2-pin-refcount-trees-before-dropping-the-lookup-lock.patch
ocfs2-cluster-initialize-heartbeat-regions-before-publishing-them.patch

