From: akpm@linux-foundation.org
Subject: + fs-affs-affsh-add-mount-option-manipulation-macros.patch added
 to -mm tree
Date: Fri, 20 Feb 2015 14:35:02 -0800
Message-ID: <54e7b696.GEfyLnRqw66ADoXn%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44881 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754615AbbBTWfD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 Feb 2015 17:35:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fabf@skynet.be, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/affs/affs.h: add mount option manipulation macros
has been added to the -mm tree.  Its filename is
     fs-affs-affsh-add-mount-option-manipulation-macros.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-affs-affsh-add-mount-option-manipulation-macros.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-affs-affsh-add-mount-option-manipulation-macros.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Fabian Frederick <fabf@skynet.be>
Subject: fs/affs/affs.h: add mount option manipulation macros

Add clear/set/test affs mount option macros.

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/affs/affs.h |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN fs/affs/affs.h~fs-affs-affsh-add-mount-option-manipulation-macros fs/affs/affs.h
--- a/fs/affs/affs.h~fs-affs-affsh-add-mount-option-manipulation-macros
+++ a/fs/affs/affs.h
@@ -119,6 +119,10 @@ struct affs_sb_info {
 #define AFFS_MOUNT_SF_VERBOSE		0x0800 /* Talk about fs when mounting */
 #define AFFS_MOUNT_SF_NO_TRUNCATE	0x1000 /* Don't truncate filenames */
 
+#define affs_clear_opt(o, opt)    (o &= ~AFFS_MOUNT_##opt)
+#define affs_set_opt(o, opt)      (o |= AFFS_MOUNT_##opt)
+#define affs_test_opt(o, opt)     ((o) & AFFS_MOUNT_##opt)
+
 /* short cut to get to the affs specific sb data */
 static inline struct affs_sb_info *AFFS_SB(struct super_block *sb)
 {
_

Patches currently in -mm which might be from fabf@skynet.be are

origin.patch
fs-ext4-fsyncc-generic_file_fsync-call-based-on-barrier-flag.patch
fs-affs-use-affs_mount-prefix-for-mount-options.patch
fs-affs-affsh-add-mount-option-manipulation-macros.patch
fs-affs-superc-use-affs_set_opt.patch
fs-affs-use-affs_test_opt.patch

