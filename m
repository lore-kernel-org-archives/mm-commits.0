Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793301234;
	b=mxypMv5XUCOPFNvf49sA4FEF+SfPfDZkiPrXYRZysgm7NN9A4cu1oeL2/p1YJVv52rAX
	 YigHBhZ51ZphBuJf4bcOLs6KE/6o9S8sK+rCAKIL3istBFkbHA3TVddtGymnDLwDkuLV+
	 H85bTo0mfigxVpgeKh0llt7vv8HB8bYldkBFqnbLk2GMY9R//AFClAx80ug7aQ8ZQGtYU
	 JEiLkFDf6LubgDP7aaHDtWQrfwK6A1fdlIKJ3ro6ntJpF0oDnCn3fq92wO9JIVOQ+Uon3
	 uByNT1IszUaWwWdVh4a6/n/CC/xWYDShlIwqt+fF+9KOVpK5oXnCVEsE1sriwGL7kjA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793301234;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=2MGMyIg1qXUEqxfKy2C47xzQFj9yzlBNV/lcmrxbsQk=;
	b=2s4UI/6rNMTgRF9PkgTMWYFpBeEHbmQLaf0/nxu7BzCps1WSmjrJ8RinR4KZab1nI7yp
	 Al22K4ZPRevNtOcGaO7T97RCdoZ1olRF0HfiBgpRP2AxaHcLZ8RBUhWiA7JaJABfP8QJB
	 7oNhy0sZLs+Wm1OWOh1uBxpA9SCvJqc9/152BKmEx6hcnrpWqKgwENTkGjm2yBZoToEyj
	 EpG2twhRcL3UYy4a+WMGF/vIVq6eWxDF3HZnCKjNFi7tQOxm25Yce9sxJ8Vhq3JByRVlA
	 ag/+Yw9QFzzEdPnSjegT23504qgH5Zd9i/JiyZpl14qamGtFjNszcBvM1+MEPBnlowQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=uwyapzsh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C077606A31A;
	Thu, 29 Oct 2026 19:13:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=uwyapzsh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 443E11F01816;
	Thu, 29 Oct 2026 19:13:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793301233;
	bh=2MGMyIg1qXUEqxfKy2C47xzQFj9yzlBNV/lcmrxbsQk=;
	h=Date:To:From:Subject;
	b=uwyapzshJbWk6MagV1A7kt1LXPVaVCEEMiBTr9RWLxTUyatUODIx+Aa6n8rulc2ks
	 udv2Ign5OfIzaX5lt61utP/GV3tR3+obYhAdZUbRZFgiPByVeBguVll011bgKBGg/v
	 6QT0Sfyh2j5lvvAfafrexCAclZT5R9VX5EUx7Z2U=
Date: Thu, 29 Oct 2026 12:13:52 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,mark@fasheh.com,
	joseph.qi@linux.alibaba.com,jlbec@evilplan.org,jjzuming@gmail.com,
	heming.zhao@suse.com,baijiaju1990@gmail.com,zzzccc427@gmail.com,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-keep-locking_state-within-the-cluster-connection-lifetime.patch added to mm-nonmm-hotfixes-unstable branch
Message-Id: <20261029191353.443E11F01816@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: ocfs2: keep locking_state within the cluster connection lifetime
has been added to the -mm mm-nonmm-hotfixes-unstable branch.  Its filename is
     ocfs2-keep-locking_state-within-the-cluster-connection-lifetime.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-keep-locking_state-within-the-cluster-connection-lifetime.patch

This patch will later appear in the mm-nonmm-hotfixes-unstable branch at
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
Subject: ocfs2: keep locking_state within the cluster connection lifetime
Date: Tue, 27 Oct 2026 12:31:44 +0800

The locking_state reader calls ocfs2_dlm_lvb() through the selected
cluster stack.  Its debug-object reference keeps the tracking list alive,
but does not keep that stack selected without a cluster connection.

DLM initialization publishes the file before establishing its connection,
and DLM shutdown drops the connection while the file still exists.  Both
the mount error unwind in ocfs2_mount_volume() and ocfs2_dismount_volume()
remove the debugfs subtree only after ocfs2_dlm_shutdown() has returned. 
Whenever the disconnect releases the last stack reference, which is the
case for a failed mount and for any unmount without a pending hangup, a
concurrent reader dereferences a NULL active_stack:

  Mount error unwind                  Debugfs reader
  ------------------                  --------------
  ocfs2_mount_volume(): out_dlm
    ocfs2_dlm_shutdown()
      disconnect last cluster
        clear active_stack
                                      read locking_state
                                        ocfs2_dlm_seq_show()
                                          ocfs2_dlm_lvb()
                                            dereference active_stack
  fill_super(): out_debugfs
    remove debugfs subtree

Publish the debug files only after the connection and the mount lock
resources are initialized, so a failed DLM initialization has no debug
reference to drop.  Remove them again in the common DLM shutdown helper
before the connection is dropped: debugfs removal waits for readers that
are inside the file operations, and the parent directory is still present
at that point in every caller.  This covers the mount error unwind, the
ocfs2_fill_super() failures after a successful mount that dismount with
mnt_err set, and unmounts whose disconnect releases the stack directly.

Only the relevant frames of the report are kept:

Oops: general protection fault, probably for non-canonical address 0xdffffc0000000001: 0000 [#1] SMP KASAN NOPTI
KASAN: null-ptr-deref in range [0x0000000000000008-0x000000000000000f]
RIP: 0010:ocfs2_dlm_lvb+0x38/0xf0
Call Trace:
 <TASK>
 ocfs2_dlm_seq_show+0x36a/0xb70
 seq_read_iter+0x480/0x1110
 seq_read+0x362/0x5a0
 full_proxy_read+0x11f/0x180
 vfs_read+0x1a0/0xc20
 ksys_read+0x111/0x200
 </TASK>

Link: https://lore.kernel.org/pm-ocfs2-objects-candidate-0011-v7-61e3ef8b1ad44ac2e817@gmail.com
Fixes: 286eaa95c5c5 ("ocfs2: Break out stackglue into modules.")
Signed-off-by: Cen Zhang <zzzccc427@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Assisted-by: LLM
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Heming Zhao <heming.zhao@suse.com>
Cc: Jia-Ju Bai <baijiaju1990@gmail.com>
Cc: <jjzuming@gmail.com>
Cc: <stable@vger.kernel.org>
---

 fs/ocfs2/dlmglue.c |   18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

--- a/fs/ocfs2/dlmglue.c~ocfs2-keep-locking_state-within-the-cluster-connection-lifetime
+++ a/fs/ocfs2/dlmglue.c
@@ -3356,6 +3356,14 @@ static void ocfs2_dlm_shutdown_debug(str
 {
 	struct ocfs2_dlm_debug *dlm_debug = osb->osb_dlm_debug;
 
+	/*
+	 * Drain the readers before the cluster stack goes away: the
+	 * locking_state reader resolves ocfs2_dlm_lvb() through the
+	 * stack. Every caller removes the parent directory later.
+	 */
+	debugfs_lookup_and_remove("locking_state", osb->osb_debug_root);
+	debugfs_lookup_and_remove("locking_filter", osb->osb_debug_root);
+
 	if (dlm_debug)
 		ocfs2_put_dlm_debug(dlm_debug);
 }
@@ -3370,8 +3378,6 @@ int ocfs2_dlm_init(struct ocfs2_super *o
 		goto local;
 	}
 
-	ocfs2_dlm_init_debug(osb);
-
 	/* launch downconvert thread */
 	osb->dc_task = kthread_run(ocfs2_downconvert_thread, osb, "ocfs2dc-%s",
 			osb->uuid_str);
@@ -3411,9 +3417,10 @@ local:
 	ocfs2_orphan_scan_lock_res_init(&osb->osb_orphan_scan.os_lockres, osb);
 
 	osb->cconn = conn;
+	if (conn)
+		ocfs2_dlm_init_debug(osb);
 bail:
 	if (status < 0) {
-		ocfs2_dlm_shutdown_debug(osb);
 		if (osb->dc_task)
 			kthread_stop(osb->dc_task);
 	}
@@ -3443,10 +3450,11 @@ void ocfs2_dlm_shutdown(struct ocfs2_sup
 	ocfs2_lock_res_free(&osb->osb_orphan_scan.os_lockres);
 
 	if (osb->cconn) {
+		/* The disconnect below may release the selected stack. */
+		ocfs2_dlm_shutdown_debug(osb);
+
 		ocfs2_cluster_disconnect(osb->cconn, hangup_pending);
 		osb->cconn = NULL;
-
-		ocfs2_dlm_shutdown_debug(osb);
 	}
 }
 
_

Patches currently in -mm which might be from zzzccc427@gmail.com are

ocfs2-validate-move-extents-against-a-stable-eof.patch
ocfs2-keep-locking_state-within-the-cluster-connection-lifetime.patch
ocfs2-wait-for-filecheck-kobject-release-after-a-failed-add.patch
ocfs2-cache-the-mount-context-for-dentry-lock-callbacks.patch

