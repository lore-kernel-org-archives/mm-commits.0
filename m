From: akpm@linux-foundation.org
Subject: - remove-is_tty.patch removed from -mm tree
Date: Thu, 24 Jul 2008 16:20:09 -0700
Message-ID: <200807242320.m6ONK9g9010325@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40012 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752543AbYGXXV2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Jul 2008 19:21:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@kernel.org, alan@redhat.com, mm-commits@vger.kernel.org


The patch titled
     remove is_tty()
has been removed from the -mm tree.  Its filename was
     remove-is_tty.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: remove is_tty()
From: Adrian Bunk <bunk@kernel.org>

This patch removes the no longer used is_tty().

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Acked-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/tty_io.c |   13 -------------
 1 file changed, 13 deletions(-)

diff -puN drivers/char/tty_io.c~remove-is_tty drivers/char/tty_io.c
--- a/drivers/char/tty_io.c~remove-is_tty
+++ a/drivers/char/tty_io.c
@@ -1119,19 +1119,6 @@ int tty_hung_up_p(struct file *filp)
 
 EXPORT_SYMBOL(tty_hung_up_p);
 
-/**
- *	is_tty	-	checker whether file is a TTY
- *	@filp:		file handle that may be a tty
- *
- *	Check if the file handle is a tty handle.
- */
-
-int is_tty(struct file *filp)
-{
-	return filp->f_op->read == tty_read
-		|| filp->f_op->read == hung_up_tty_read;
-}
-
 static void session_clear_tty(struct pid *session)
 {
 	struct task_struct *p;
_

Patches currently in -mm which might be from bunk@kernel.org are

origin.patch
linux-next.patch
m32r-remove-the-unused-nohighmem-option.patch
if-0-ses_match_host.patch
git-xtensa.patch
init-do_mountsc-should-include-linux-initrdh.patch
build-kernel-profileo-only-when-requested.patch
build-kernel-profileo-only-when-requested-cleanups.patch
asm-generic-int-ll64h-always-provide-__su64.patch
remove-some-more-tipar-bits.patch
include-linux-kernelh-userspace-header-cleanup.patch
minix-remove-no_truncate-code.patch
jbd-unexport-journal_update_superblock.patch
coda-remove-coda_fs_old_api.patch
fat-dirc-switch-to-struct-__fat_dirent.patch
remove-the-in-kernel-struct-dirent64.patch
remove-unused-include-linux-direnths.patch
include-asm-ptraceh-userspace-headers-cleanup.patch
pty-remove-unused-unix98_pty_count-options.patch
proper-extern-for-mwave_s_mdd.patch
if-0-hpet_unregister.patch
unexport-proc_clear_tty.patch
move-proc_kmsg_operations-to-fs-proc-internalh.patch
proper-pidhashmap_init-prototypes.patch
unexport-uts_sem.patch
parport-sharec-proper-externs.patch
tpm_biosc-make-2-structs-static.patch
drm-make-drm_minors_cleanup-static.patch
make-cgroup_seqfile_release-static.patch
make-pnp_add_card_id-static.patch
make-parport_cs_release-static.patch
make-mm-sparsec-make-a-function-static.patch
mm-allocpercpuc-make-4-functions-static.patch
make-mm-memoryc-print_bad_pte-static.patch
mm-swapfilec-make-code-static.patch
make-mm-rmapc-anon_vma_cachep-static.patch
drivers-char-rtcc-make-2-functions-static.patch
make-init-do_mountsc-root_device_name-static.patch
make-macfb_setup-static.patch
video-console-sticonrec-make-code-static.patch
video-console-sticonrec-make-code-static-checkpatch-fixes.patch
video-stifbc-make-2-functions-static.patch
reiser4.patch

