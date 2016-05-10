From: akpm@linux-foundation.org
Subject: + nilfs2-remove-loops-of-single-statement-macros.patch added to
 -mm tree
Date: Tue, 10 May 2016 12:23:51 -0700
Message-ID: <57323547.7ia/OvIOHcJ/m4gg%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54456 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751479AbcEJTXw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 10 May 2016 15:23:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: konishi.ryusuke@lab.ntt.co.jp, mm-commits@vger.kernel.org


The patch titled
     Subject: nilfs2: remove loops of single statement macros
has been added to the -mm tree.  Its filename is
     nilfs2-remove-loops-of-single-statement-macros.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/nilfs2-remove-loops-of-single-statement-macros.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/nilfs2-remove-loops-of-single-statement-macros.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: nilfs2: remove loops of single statement macros

This fixes checkpatch.pl warning "WARNING: Single statement macros
should not use a do {} while (0) loop".

Link: http://lkml.kernel.org/r/1462886671-3521-7-git-send-email-konishi.ryusuke@lab.ntt.co.jp
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/the_nilfs.h |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff -puN fs/nilfs2/the_nilfs.h~nilfs2-remove-loops-of-single-statement-macros fs/nilfs2/the_nilfs.h
--- a/fs/nilfs2/the_nilfs.h~nilfs2-remove-loops-of-single-statement-macros
+++ a/fs/nilfs2/the_nilfs.h
@@ -222,15 +222,14 @@ THE_NILFS_FNS(SB_DIRTY, sb_dirty)
  * Mount option operations
  */
 #define nilfs_clear_opt(nilfs, opt)  \
-	do { (nilfs)->ns_mount_opt &= ~NILFS_MOUNT_##opt; } while (0)
+	((nilfs)->ns_mount_opt &= ~NILFS_MOUNT_##opt)
 #define nilfs_set_opt(nilfs, opt)  \
-	do { (nilfs)->ns_mount_opt |= NILFS_MOUNT_##opt; } while (0)
+	((nilfs)->ns_mount_opt |= NILFS_MOUNT_##opt)
 #define nilfs_test_opt(nilfs, opt) ((nilfs)->ns_mount_opt & NILFS_MOUNT_##opt)
 #define nilfs_write_opt(nilfs, mask, opt)				\
-	do { (nilfs)->ns_mount_opt =					\
+	((nilfs)->ns_mount_opt =					\
 		(((nilfs)->ns_mount_opt & ~NILFS_MOUNT_##mask) |	\
-		 NILFS_MOUNT_##opt);					\
-	} while (0)
+		 NILFS_MOUNT_##opt))					\
 
 /**
  * struct nilfs_root - nilfs root object
_

Patches currently in -mm which might be from konishi.ryusuke@lab.ntt.co.jp are

nilfs2-fix-white-space-issue-in-nilfs_mount.patch
nilfs2-remove-space-before-comma.patch
nilfs2-remove-fsf-mailing-address-from-gpl-notices.patch
nilfs2-clean-up-old-e-mail-addresses.patch
maintainers-add-web-link-for-nilfs-project.patch
nilfs2-clarify-permission-to-replicate-the-design.patch
nilfs2-get-rid-of-nilfs_mdt_mark_block_dirty.patch
nilfs2-move-cleanup-code-of-metadata-file-from-inode-routines.patch
nilfs2-replace-__attribute__packed-with-__packed.patch
nilfs2-add-missing-line-spacing.patch
nilfs2-clean-trailing-semicolons-in-macros.patch
nilfs2-clean-trailing-semicolons-in-macros-fix.patch
nilfs2-do-not-emit-extra-newline-on-nilfs_warning-and-nilfs_error.patch
nilfs2-remove-space-before-semicolon.patch
nilfs2-fix-code-indent-coding-style-issue.patch
nilfs2-avoid-bare-use-of-unsigned.patch
nilfs2-remove-unnecessary-else-after-return-or-break.patch
nilfs2-remove-loops-of-single-statement-macros.patch
nilfs2-fix-block-comments.patch

