Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795369235;
	b=XhtaFgn+bZp+2riqNoAN0tzRz4C/XN0rquBzutnSCWMXDK/YmWUAMYJ1eT+keMhUCrmH
	 tRS1OIH9mu9A0mQGy02AgpLlLD4Ghl0ZX0YK1Wwt5bCydoCkztgR/hm4ivZl22eyDI/2s
	 kUynQUcNz4k/YDsc2bKcnSujBAB8MEyK3Bbm3zDPcrb0fLyxYu2+pBvcb2TMWAieh8j7n
	 scWbQam8LrZz13n4UkEWspukUv0XpeuLWG8MHfWgLaGeTzduaJ1YvFL1htqV1glumR8Nv
	 SXfcxsdD/42WuEFmnQI7Q22oHmy02l9/7704IZty+fZVc0b+pSG1jYQWWBoaQcjbjLA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795369235;
	h=Received:DKIM-Signature:Date:To:From:In-Reply-To:References:Subject:
	 Message-Id;
	bh=H4CSd8Kdm7y1+HrYCLDqaB2X6obYudiWRGQ1P2y5tbY=;
	b=FQgWsrbCHuBd4OKY2YfeOgnekU2KSBMOOgyKIP4KPOE+S4I6k4fg/XcwERKCqyH7870u
	 s7aalr7hDRYEkKjTqtZOU6pnF2+QwdzNoOF5tod2VU81QQnOxcKKH6ky0wjyVRkQVBAu2
	 WY/hLmBlMWgVLZoa98dSVoAB3gUD6QP8DJmw5cU6n0M2Qwj4KlzmyCwXdsWF5+534QIt2
	 PeGt6Nf0BjPkyvKzaf/d3QgESxKYQwWJzQunyYofmpQ4VSsUP3b23kvzJpNGRJhZ9zODV
	 NPz3uxu544iuDmfN2ImSWcCiY4OBfneZdskVQWQtkIGXYqTmgle+Crz+mi4XWSGq75w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=EYAqLD8A;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5248F606A32A;
	Sun, 22 Nov 2026 17:40:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=EYAqLD8A
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92F571F000CF;
	Sun, 22 Nov 2026 17:40:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795369234;
	bh=H4CSd8Kdm7y1+HrYCLDqaB2X6obYudiWRGQ1P2y5tbY=;
	h=Date:To:From:In-Reply-To:References:Subject;
	b=EYAqLD8A457jWzV9Gbg2BAL9Dmg5y1RUp2cJWiW4EFKqZFXv5Z9hedM3swyQHge2R
	 AZZ6XvhX1XIhWzUJ8uEAdQcfrvTadldQS5PqBCpMHel4MJuPHUdbdDZ3wmMeGsYws8
	 JaQbuoQ3gQMHYUsmW/g9UzFGqVUhgO8FaN+pYeHo=
Date: Sun, 22 Nov 2026 09:40:34 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,mark@fasheh.com,
	joseph.qi@linux.alibaba.com,jlbec@evilplan.org,jjzuming@gmail.com,
	heming.zhao@suse.com,baijiaju1990@gmail.com,zzzccc427@gmail.com,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <pm-ocfs2-objects-candidate-0003-v8-8fb510a5c52b337960c9@gmail.com>
References: <pm-ocfs2-objects-candidate-0003-v8-8fb510a5c52b337960c9@gmail.com>
Subject: + ocfs2-drain-fs_state-readers-before-journal-teardown.patch added to mm-nonmm-unstable branch
Message-Id: <20261122174034.92F571F000CF@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: ocfs2: drain fs_state readers before journal teardown
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ocfs2-drain-fs_state-readers-before-journal-teardown.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-drain-fs_state-readers-before-journal-teardown.patch

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
Subject: ocfs2: drain fs_state readers before journal teardown
Date: Sat, 21 Nov 2026 15:51:57 +0800

The fs_state debugfs open callback builds a snapshot from mount state,
including the journal and cluster connection.  The file is published
before ocfs2_mount_volume() and removed after journal and DLM shutdown, so
an open can overlap teardown on unmount or mount failure.

Publish fs_state at the successful end of ocfs2_fill_super(), after the
last fallible mount step.  Remove it in ocfs2_put_super() before calling
ocfs2_dismount_volume().  Debugfs removal excludes new opens and drains
active callbacks.  The release callback only frees the per-open snapshot.

KASAN reported:

    BUG: KASAN: slab-use-after-free in ocfs2_osb_debug_open+0x967/0x15e0
    Read of size 4 at addr ffff888116a56028 by task cat/502
    ...
    Freed by task 504:
     kfree+0x308/0x580
     ocfs2_journal_shutdown+0x10a/0xc20
     ocfs2_dismount_volume+0x315/0x940

Link: https://patch.msgid.link/pm-ocfs2-objects-candidate-0003-v8-8fb510a5c52b337960c9@gmail.com
Fixes: da5e7c87827e ("ocfs2: cleanup journal init and shutdown")
Signed-off-by: Cen Zhang <zzzccc427@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Heming Zhao <heming.zhao@suse.com>
Cc: Jia-Ju Bai <baijiaju1990@gmail.com>
Cc: <jjzuming@gmail.com>
Cc: <stable@vger.kernel.org>

 fs/ocfs2/super.c |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

--- a/fs/ocfs2/super.c~ocfs2-drain-fs_state-readers-before-journal-teardown
+++ a/fs/ocfs2/super.c
@@ -1072,9 +1072,6 @@ static int ocfs2_fill_super(struct super
 	osb->osb_debug_root = debugfs_create_dir(osb->uuid_str,
 						 ocfs2_debugfs_root);
 
-	debugfs_create_file("fs_state", S_IFREG|S_IRUSR, osb->osb_debug_root,
-			    osb, &ocfs2_osb_debug_fops);
-
 	if (ocfs2_meta_ecc(osb)) {
 		ocfs2_initialize_journal_triggers(sb, osb->s_journal_triggers);
 		ocfs2_blockcheck_stats_debugfs_install( &osb->osb_ecc_stats,
@@ -1158,6 +1155,10 @@ static int ocfs2_fill_super(struct super
 	/* Start this when the mount is almost sure of being successful */
 	ocfs2_orphan_scan_start(osb);
 
+	/* Publish fs_state only after all fallible mount steps. */
+	debugfs_create_file("fs_state", 0400, osb->osb_debug_root,
+			    osb, &ocfs2_osb_debug_fops);
+
 	return status;
 
 out_dismount:
@@ -1555,8 +1556,13 @@ static void __exit ocfs2_exit(void)
 
 static void ocfs2_put_super(struct super_block *sb)
 {
+	struct ocfs2_super *osb = OCFS2_SB(sb);
+
 	trace_ocfs2_put_super(sb);
 
+	/* Drain fs_state opens before releasing their backing state. */
+	debugfs_lookup_and_remove("fs_state", osb->osb_debug_root);
+
 	ocfs2_sync_blockdev(sb);
 	ocfs2_dismount_volume(sb, 0);
 }
_

Patches currently in -mm which might be from zzzccc427@gmail.com are

ocfs2-drain-domain-handlers-before-destroying-the-dlm-worker.patch
ocfs2-drain-fs_state-readers-before-journal-teardown.patch

