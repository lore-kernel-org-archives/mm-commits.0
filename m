From: akpm@linux-foundation.org
Subject: +
 ext4-return-back-to-starting-transaction-in-ext4_dax_huge_fault.patch added to -mm tree
Date: Wed, 10 May 2017 13:54:49 -0700
Message-ID: <59137e19.lTDL5ZaozPdhq5se%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33944 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753771AbdEJUzA (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 10 May 2017 16:55:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jack@suse.cz, dan.j.williams@intel.com, ross.zwisler@linux.intel.com, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: ext4: return to starting transaction in ext4_dax_huge_fault()
has been added to the -mm tree.  Its filename is
     ext4-return-back-to-starting-transaction-in-ext4_dax_huge_fault.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ext4-return-back-to-starting-transaction-in-ext4_dax_huge_fault.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ext4-return-back-to-starting-transaction-in-ext4_dax_huge_fault.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jan Kara <jack@suse.cz>
Subject: ext4: return to starting transaction in ext4_dax_huge_fault()

DAX will return to locking exceptional entry before mapping blocks for a
page fault to fix possible races with concurrent writes.  To avoid lock
inversion between exceptional entry lock and transaction start, start the
transaction already in ext4_dax_huge_fault().

Fixes: 9f141d6ef6258a3a37a045842d9ba7e68f368956
Link: http://lkml.kernel.org/r/20170510085419.27601-4-jack@suse.cz
Signed-off-by: Jan Kara <jack@suse.cz>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext4/file.c |   21 +++++++++++++++++----
 1 file changed, 17 insertions(+), 4 deletions(-)

diff -puN fs/ext4/file.c~ext4-return-back-to-starting-transaction-in-ext4_dax_huge_fault fs/ext4/file.c
--- a/fs/ext4/file.c~ext4-return-back-to-starting-transaction-in-ext4_dax_huge_fault
+++ a/fs/ext4/file.c
@@ -257,6 +257,7 @@ static int ext4_dax_huge_fault(struct vm
 		enum page_entry_size pe_size)
 {
 	int result;
+	handle_t *handle = NULL;
 	struct inode *inode = file_inode(vmf->vma->vm_file);
 	struct super_block *sb = inode->i_sb;
 	bool write = vmf->flags & FAULT_FLAG_WRITE;
@@ -264,12 +265,24 @@ static int ext4_dax_huge_fault(struct vm
 	if (write) {
 		sb_start_pagefault(sb);
 		file_update_time(vmf->vma->vm_file);
+		down_read(&EXT4_I(inode)->i_mmap_sem);
+		handle = ext4_journal_start_sb(sb, EXT4_HT_WRITE_PAGE,
+					       EXT4_DATA_TRANS_BLOCKS(sb));
+	} else {
+		down_read(&EXT4_I(inode)->i_mmap_sem);
 	}
-	down_read(&EXT4_I(inode)->i_mmap_sem);
-	result = dax_iomap_fault(vmf, pe_size, &ext4_iomap_ops);
-	up_read(&EXT4_I(inode)->i_mmap_sem);
-	if (write)
+	if (!IS_ERR(handle))
+		result = dax_iomap_fault(vmf, pe_size, &ext4_iomap_ops);
+	else
+		result = VM_FAULT_SIGBUS;
+	if (write) {
+		if (!IS_ERR(handle))
+			ext4_journal_stop(handle);
+		up_read(&EXT4_I(inode)->i_mmap_sem);
 		sb_end_pagefault(sb);
+	} else {
+		up_read(&EXT4_I(inode)->i_mmap_sem);
+	}
 
 	return result;
 }
_

Patches currently in -mm which might be from jack@suse.cz are

mm-fix-data-corruption-due-to-stale-mmap-reads.patch
ext4-return-back-to-starting-transaction-in-ext4_dax_huge_fault.patch
dax-fix-data-corruption-when-fault-races-with-write.patch

