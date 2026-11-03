Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793675989;
	b=XP3z9Lz9fOJb2ouyATlO01a/Ikf/VaaV7qk80V2gTDWK/fG9iCYgBfeMzu9fPPY6xj6F
	 vhYlqIeW5ngupBxQEohE6tZitAleY+LbyZqPtmACseT/RDfi+TA+3yea27zqR7HGCEkC0
	 nvqE3vdCLuD/s+O84R9Bn2R0C4/3wWkR4SPqfLG8Jdi/mtaJ/9bYUnvqulgYf5HarRCXL
	 xgwYs6pb2VWDXGuf9BEIaAQa37ZzFQ6d7AIale/9IEZF3fLU2ZVYLrRNga641FofXpM1H
	 KVT2eYGJZGUDsUZjF1hTsV5e+0z1kjzPGrtFdr9TgKgJxIT4Of412OjReK7O4Kh1dxg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793675989;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=mmgjyTzDT/nPmZhFsjLSVjTEy7UpM2Hvve127ffzSOY=;
	b=kiW8hyJbHiTNj4KfzAyqjkhYfWv3hopuiQdgWog5kbQ2h0rXrMtiblWGMqH7e6OjPxn1
	 c3Mrc8bVoIUAnLF4dl5mSsuCpvg0Vtr7cqLLWk0Hb5lDKbiY4Y12aVPLl8Yt/RytJmTmX
	 ifEGE66avCtVaSl/NTxGR4/EVC9YZdvVK01XYlyBP/NdAkHuq6rA7xEecHAjAq+Q78M8z
	 EAKRA3aRhJvWSPGRPdDAM2PWTgseEmJY1AnPCyNdxT1Z1jdj/QrSJnJAZGXWuepi0HbTA
	 7n5eye6EWROlLTppZqZV8BrQl2QirSY/eMHfE6LYu9rdNUus6gfdTC3H+FAbgbN5t6Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=jI+UJZs3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27F02606A326;
	Tue,  3 Nov 2026 03:19:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=jI+UJZs3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6C6B1F000C1;
	Tue,  3 Nov 2026 03:19:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793675988;
	bh=mmgjyTzDT/nPmZhFsjLSVjTEy7UpM2Hvve127ffzSOY=;
	h=Date:To:From:Subject;
	b=jI+UJZs3iV9lkuB1VLYSDHoO9ZxdsELCy8Xslv01X0iaePl8kqG4u57hX7J3r5zb0
	 vR3Lql8YbH4OZOxDVZeClOBUCMiQVz86RZ3vZX5DZuqog/DGhFoag2pXeyPZFTvZ6Z
	 xy3h+LPN8yyi/F7qu+DsIisibDl3Tg99Fa8DyY0c=
Date: Mon, 02 Nov 2026 19:19:48 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,mark@fasheh.com,
	joseph.qi@linux.alibaba.com,jlbec@evilplan.org,jjzuming@gmail.com,
	heming.zhao@suse.com,baijiaju1990@gmail.com,zzzccc427@gmail.com,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-hotfixes-stable] ocfs2-keep-locking_state-within-the-cluster-connection-lifetime.patch removed from -mm tree
Message-Id: <20261103031948.B6C6B1F000C1@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: ocfs2: keep locking_state within the cluster connection lifetime
has been removed from the -mm tree.  Its filename was
     ocfs2-keep-locking_state-within-the-cluster-connection-lifetime.patch

This patch was dropped because it was merged into the mm-nonmm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


