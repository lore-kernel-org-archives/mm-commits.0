From: akpm@linux-foundation.org
Subject: + mm-bdi-allow-setting-a-maximum-for-the-bdi-dirty-limit-fix.patch added to -mm tree
Date: Sat, 02 Feb 2008 15:26:17 -0800
Message-ID: <200802022325.m12NPwDQ021295@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41665 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763559AbYBBX0a (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sat, 2 Feb 2008 18:26:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mszeredi@suse.cz


The patch titled
     mm: bdi: fix read_ahead_kb_store()
has been added to the -mm tree.  Its filename is
     mm-bdi-allow-setting-a-maximum-for-the-bdi-dirty-limit-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: bdi: fix read_ahead_kb_store()
From: Miklos Szeredi <mszeredi@suse.cz>

This managed to completely evade testing :(

Fix return value to be count or -errno.  Also bring the function in
line with the other store functions on this object, which have more
strict input checking.

Also fix bdi_set_max_ratio() to actually return an error, instead of
always zero.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page-writeback.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/page-writeback.c~mm-bdi-allow-setting-a-maximum-for-the-bdi-dirty-limit-fix mm/page-writeback.c
--- a/mm/page-writeback.c~mm-bdi-allow-setting-a-maximum-for-the-bdi-dirty-limit-fix
+++ a/mm/page-writeback.c
@@ -288,7 +288,7 @@ int bdi_set_max_ratio(struct backing_dev
 	}
 	spin_unlock_irqrestore(&bdi_lock, flags);
 
-	return 0;
+	return ret;
 }
 EXPORT_SYMBOL(bdi_set_max_ratio);
 
_

Patches currently in -mm which might be from mszeredi@suse.cz are

origin.patch
sys_remap_file_pages-fix-vm_file-accounting.patch
fuse-fix-attribute-caching-after-create.patch
fuse-save-space-in-struct-fuse_req.patch
fuse-limit-queued-background-requests.patch
mount-options-add-documentation.patch
mount-options-add-generic_show_options.patch
mount-options-fix-adfs.patch
mount-options-fix-affs.patch
mount-options-fix-afs.patch
mount-options-fix-autofs4.patch
mount-options-fix-autofs.patch
mount-options-fix-befs.patch
mount-options-fix-capifs.patch
mount-options-fix-devpts.patch
mount-options-fix-ext2.patch
mount-options-fix-fat.patch
mount-options-fix-fuse.patch
mount-options-fix-hostfs.patch
mount-options-fix-hpfs.patch
mount-options-fix-hugetlbfs.patch
mount-options-fix-isofs.patch
mount-options-fix-ncpfs.patch
mount-options-fix-reiserfs.patch
mount-options-fix-spufs.patch
mount-options-fix-tmpfs.patch
mount-options-fix-tmpfs-fix.patch
mount-options-fix-udf.patch
vfs-create-proc-pid-mountinfo.patch
mm-bdi-export-bdi-attributes-in-sysfs.patch
mm-bdi-export-bdi-attributes-in-sysfs-fix.patch
mm-bdi-expose-the-bdi-object-in-sysfs-for-nfs.patch
mm-bdi-expose-the-bdi-object-in-sysfs-for-fuse.patch
mm-bdi-allow-setting-a-minimum-for-the-bdi-dirty-limit.patch
mm-bdi-allow-setting-a-maximum-for-the-bdi-dirty-limit.patch
mm-bdi-allow-setting-a-maximum-for-the-bdi-dirty-limit-fix.patch
mm-bdi-use-majorminor-in-sys-class-bdi.patch
mm-bdi-move-statistics-to-debugfs.patch
