From: akpm@linux-foundation.org
Subject: - mm-filemapc-generic_write_checks-mustnt-be-inline.patch removed from -mm tree
Date: Thu, 01 May 2008 01:16:03 -0700
Message-ID: <200805010816.m418G3fq027823@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56823 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754434AbYEAIQ2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 May 2008 04:16:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@kernel.org, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     mm/filemap.c:generic_write_checks() mustn't be inline
has been removed from the -mm tree.  Its filename was
     mm-filemapc-generic_write_checks-mustnt-be-inline.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm/filemap.c:generic_write_checks() mustn't be inline
From: Adrian Bunk <bunk@kernel.org>

Fix the following build error with UML and gcc 4.3:

/home/bunk/linux/kernel-2.6/git/linux-2.6/mm/filemap.c: In function `__generic_file_aio_write_nolock':
/home/bunk/linux/kernel-2.6/git/linux-2.6/mm/filemap.c:1831: sorry, unimplemented: inlining failed in call to `generic_write_checks': function body not available
/home/bunk/linux/kernel-2.6/git/linux-2.6/mm/filemap.c:2383: sorry, unimplemented: called from here

Reported-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Adrian Bunk <bunk@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN mm/filemap.c~mm-filemapc-generic_write_checks-mustnt-be-inline mm/filemap.c
--- a/mm/filemap.c~mm-filemapc-generic_write_checks-mustnt-be-inline
+++ a/mm/filemap.c
@@ -1829,7 +1829,8 @@ EXPORT_SYMBOL(iov_iter_single_seg_count)
  * Returns appropriate error code that caller should return or
  * zero in case that write should be allowed.
  */
-inline int generic_write_checks(struct file *file, loff_t *pos, size_t *count, int isblk)
+int generic_write_checks(struct file *file, loff_t *pos, size_t *count,
+			 int isblk)
 {
 	struct inode *inode = file->f_mapping->host;
 	unsigned long limit = current->signal->rlim[RLIMIT_FSIZE].rlim_cur;
_

Patches currently in -mm which might be from bunk@kernel.org are

origin.patch
make-marker_debug-static.patch
mm-filemapc-generic_write_checks-mustnt-be-inline.patch
fs-block_devc-i_bdev-mustnt-be-inline.patch
reiserfs-some-functions-mustnt-be-inline.patch
git-acpi.patch
git-x86.patch
arch-x86-video-fbdevc-add-module_license.patch
md-make-dm_dirty_log_initexit-static.patch
drm-make-drm_minors_cleanup-static.patch
git-m32r.patch
net-ipv4-ip_outputc-ip_send_check-mustnt-be-inline.patch
nfs-make-nfs4_drop_state_owner-static.patch
git-ocfs2.patch
show_schedstat-fix-memleak.patch
git-sh.patch
if-0-ses_match_host.patch
git-watchdog.patch
xen-drivers-xen-balloonc-make-a-function-static.patch
reiser4.patch

