From: akpm@linux-foundation.org
Subject: + befs-replace-kmalloc-memset-0-by-kzalloc.patch added to -mm
 tree
Date: Wed, 19 Feb 2014 12:45:02 -0800
Message-ID: <530517ce.JPEOkxUgVCBCbKCV%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33183 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753503AbaBSUpD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 19 Feb 2014 15:45:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, fabf@skynet.be

Subject: + befs-replace-kmalloc-memset-0-by-kzalloc.patch added to -mm tree
To: fabf@skynet.be
From: akpm@linux-foundation.org
Date: Wed, 19 Feb 2014 12:45:02 -0800


The patch titled
     Subject: befs: replace kmalloc/memset 0 by kzalloc
has been added to the -mm tree.  Its filename is
     befs-replace-kmalloc-memset-0-by-kzalloc.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/befs-replace-kmalloc-memset-0-by-kzalloc.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/befs-replace-kmalloc-memset-0-by-kzalloc.patch

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
Subject: befs: replace kmalloc/memset 0 by kzalloc

Use kzalloc for clean fs_info allocation like other filesystems.

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/befs/linuxvfs.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN fs/befs/linuxvfs.c~befs-replace-kmalloc-memset-0-by-kzalloc fs/befs/linuxvfs.c
--- a/fs/befs/linuxvfs.c~befs-replace-kmalloc-memset-0-by-kzalloc
+++ a/fs/befs/linuxvfs.c
@@ -791,7 +791,7 @@ befs_fill_super(struct super_block *sb,
 
 	save_mount_options(sb, data);
 
-	sb->s_fs_info = kmalloc(sizeof (*befs_sb), GFP_KERNEL);
+	sb->s_fs_info = kzalloc(sizeof(*befs_sb), GFP_KERNEL);
 	if (sb->s_fs_info == NULL) {
 		printk(KERN_ERR
 		       "BeFS(%s): Unable to allocate memory for private "
@@ -799,7 +799,6 @@ befs_fill_super(struct super_block *sb,
 		goto unacquire_none;
 	}
 	befs_sb = BEFS_SB(sb);
-	memset(befs_sb, 0, sizeof(befs_sb_info));
 
 	if (!parse_options((char *) data, &befs_sb->mount_opts)) {
 		befs_error(sb, "cannot parse mount options");
_

Patches currently in -mm which might be from fabf@skynet.be are

fs-cifs-cifsfsc-add-__init-to-cifs_init_inodecache.patch
fs-udf-superc-add-__init-to-init_inodecache.patch
sys_sysfs-add-config_sysfs_syscall.patch
sys_sysfs-add-config_sysfs_syscall-fix.patch
fs-efs-superc-add-__init-to-init_inodecache.patch
fs-minix-inodec-add-__init-to-init_inodecache.patch
befs-replace-kmalloc-memset-0-by-kzalloc.patch
fs-ufs-superc-add-__init-to-init_inodecache.patch
ufs-sb-mutex-merge-mutex_destroy.patch
fs-adfs-superc-add-__init-to-init_inodecache.patch
kernel-panicc-display-reason-at-end-pr_emerg.patch
kernel-panicc-display-reason-at-end-pr_emerg-fix.patch
linux-next.patch

