From: akpm@linux-foundation.org
Subject: + hfsplus-add-error-message-for-the-case-of-failure-of-sync-fs-in-delayed_sync_fs-method.patch added to -mm tree
Date: Tue, 04 Dec 2012 13:11:59 -0800
Message-ID: <20121204211159.AD97E8200A0@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f202.google.com ([209.85.213.202]:59957 "EHLO
	mail-ye0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751943Ab2LDVMA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Dec 2012 16:12:00 -0500
Received: by mail-ye0-f202.google.com with SMTP id l7so544847yen.1
        for <mm-commits@vger.kernel.org>; Tue, 04 Dec 2012 13:12:00 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: slava@dubeyko.com, hch@infradead.org, htl10@users.sourceforge.net, viro@zeniv.linux.org.uk


The patch titled
     Subject: hfsplus: add error message for the case of failure of sync fs in delayed_sync_fs() method
has been added to the -mm tree.  Its filename is
     hfsplus-add-error-message-for-the-case-of-failure-of-sync-fs-in-delayed_sync_fs-method.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -242,6 +242,7 @@ out:
 
 static void delayed_sync_fs(struct work_struct *work)
 {
+	int err;
 	struct hfsplus_sb_info *sbi;
 
 	sbi = container_of(work, struct hfsplus_sb_info, sync_work.work);
@@ -250,7 +251,9 @@ static void delayed_sync_fs(struct work_
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

hfsplus-avoid-crash-on-failed-block-map-free.patch
hfsplus-add-osx-prefix-for-handling-namespace-of-mac-os-x-extended-attributes.patch
hfsplus-add-osx-prefix-for-handling-namespace-of-mac-os-x-extended-attributes-checkpatch-fixes.patch
hfsplus-add-on-disk-layout-declarations-related-to-attributes-tree.patch
hfsplus-add-functionality-of-manipulating-by-records-in-attributes-tree.patch
hfsplus-rework-functionality-of-getting-setting-and-deleting-of-extended-attributes.patch
hfsplus-rework-functionality-of-getting-setting-and-deleting-of-extended-attributes-fix.patch
hfsplus-add-support-of-manipulation-by-attributes-file.patch
hfsplus-rework-processing-errors-in-hfsplus_free_extents.patch
hfsplus-rework-processing-of-hfs_btree_write-returned-error.patch
hfsplus-rework-processing-of-hfs_btree_write-returned-error-fix.patch
hfsplus-add-error-message-for-the-case-of-failure-of-sync-fs-in-delayed_sync_fs-method.patch

