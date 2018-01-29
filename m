From: akpm@linux-foundation.org
Subject: + mm-numa-rework-do_pages_move-fix.patch added to -mm tree
Date: Mon, 29 Jan 2018 14:35:34 -0800
Message-ID: <5a6fa1b6.kllw/74KIYfcj7eb%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57226 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751833AbeA2Wff (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 29 Jan 2018 17:35:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: zi.yan@cs.rutgers.edu, kirill@shutemov.name, mhocko@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-numa-rework-do_pages_move-fix
has been added to the -mm tree.  Its filename is
     mm-numa-rework-do_pages_move-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-numa-rework-do_pages_move-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-numa-rework-do_pages_move-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Zi Yan" <zi.yan@cs.rutgers.edu>
Subject: mm-numa-rework-do_pages_move-fix

I discover that this patch does not hold mmap_sem while migrating pages i=
n do_move_pages_to_node().

A simple fix below moves mmap_sem from add_page_for_migration()
to the outmost do_pages_move():

Cc: Michal Hocko <mhocko@suse.com>
Cc: Kirill A. Shutemov <kirill@shutemov.name>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/migrate.c~mm-numa-rework-do_pages_move-fix mm/migrate.c
--- a/mm/migrate.c~mm-numa-rework-do_pages_move-fix
+++ a/mm/migrate.c
@@ -1486,7 +1486,6 @@ static int add_page_for_migration(struct
 	unsigned int follflags;
 	int err;
 
-	down_read(&mm->mmap_sem);
 	err = -EFAULT;
 	vma = find_vma(mm, addr);
 	if (!vma || addr < vma->vm_start || !vma_migratable(vma))
@@ -1541,7 +1540,6 @@ out_putpage:
 	 */
 	put_page(page);
 out:
-	up_read(&mm->mmap_sem);
 	return err;
 }
 
@@ -1562,6 +1560,7 @@ static int do_pages_move(struct mm_struc
 
 	migrate_prep();
 
+	down_read(&mm->mmap_sem);
 	for (i = start = 0; i < nr_pages; i++) {
 		const void __user *p;
 		unsigned long addr;
@@ -1629,6 +1628,7 @@ out_flush:
 	if (!err)
 		err = err1;
 out:
+	up_read(&mm->mmap_sem);
 	return err;
 }
 
_

Patches currently in -mm which might be from zi.yan@cs.rutgers.edu are

mm-numa-rework-do_pages_move-fix.patch

