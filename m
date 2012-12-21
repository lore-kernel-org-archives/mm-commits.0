From: akpm@linux-foundation.org
Subject: [merged] hfsplus-add-error-message-for-the-case-of-failure-of-sync-fs-in-delayed_sync_fs-method.patch removed from -mm tree
Date: Fri, 21 Dec 2012 12:39:50 -0800
Message-ID: <20121221203950.B147B82004A@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f73.google.com ([209.85.212.73]:58833 "EHLO
	mail-vb0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751611Ab2LUUjv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 21 Dec 2012 15:39:51 -0500
Received: by mail-vb0-f73.google.com with SMTP id l1so517116vba.2
        for <mm-commits@vger.kernel.org>; Fri, 21 Dec 2012 12:39:51 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: slava@dubeyko.com, hch@infradead.org, htl10@users.sourceforge.net, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: hfsplus: add error message for the case of failure of sync fs in delayed_sync_fs() method
has been removed from the -mm tree.  Its filename was
     hfsplus-add-error-message-for-the-case-of-failure-of-sync-fs-in-delayed_sync_fs-method.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vyacheslav Dubeyko <slava@dubeyko.com>
Subject: hfsplus: add error message for the case of failure of sync fs in delayed_sync_fs() method

Add an error message for the case of failure of sync fs in
delayed_sync_fs() method.

Signed-off-by: Vyacheslav Dubeyko <slava@dubeyko.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Hin-Tak Leung <htl10@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hfsplus/super.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN fs/hfsplus/super.c~hfsplus-add-error-message-for-the-case-of-failure-of-sync-fs-in-delayed_sync_fs-method fs/hfsplus/super.c
--- a/fs/hfsplus/super.c~hfsplus-add-error-message-for-the-case-of-failure-of-sync-fs-in-delayed_sync_fs-method
+++ a/fs/hfsplus/super.c
@@ -232,6 +232,7 @@ out:
 
 static void delayed_sync_fs(struct work_struct *work)
 {
+	int err;
 	struct hfsplus_sb_info *sbi;
 
 	sbi = container_of(work, struct hfsplus_sb_info, sync_work.work);
@@ -240,7 +241,9 @@ static void delayed_sync_fs(struct work_
 	sbi->work_queued = 0;
 	spin_unlock(&sbi->work_lock);
 
-	hfsplus_sync_fs(sbi->alloc_file->i_sb, 1);
+	err = hfsplus_sync_fs(sbi->alloc_file->i_sb, 1);
+	if (err)
+		printk(KERN_ERR "hfs: delayed sync fs err %d\n", err);
 }
 
 void hfsplus_mark_mdb_dirty(struct super_block *sb)
_

Patches currently in -mm which might be from slava@dubeyko.com are

origin.patch
hfsplus-add-osx-prefix-for-handling-namespace-of-mac-os-x-extended-attributes.patch
hfsplus-add-on-disk-layout-declarations-related-to-attributes-tree.patch
hfsplus-add-functionality-of-manipulating-by-records-in-attributes-tree.patch
hfsplus-rework-functionality-of-getting-setting-and-deleting-of-extended-attributes.patch
hfsplus-add-support-of-manipulation-by-attributes-file.patch

