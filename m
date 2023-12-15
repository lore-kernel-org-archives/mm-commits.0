Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3921A30104;
	Fri, 15 Dec 2023 18:51:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="GirJx3Aq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C325DC433C8;
	Fri, 15 Dec 2023 18:51:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702666287;
	bh=m+LRD05sZwv1eLX69sqSl3PqhK+Y6cv7VSvOgDCC+cM=;
	h=Date:To:From:Subject:From;
	b=GirJx3AqZew5BVPwou9uUvPOELJUVEYCxTWDneNXsJXrTHeCP1dixU3RqMZy/g8ZG
	 7haNSE+D+litRoiRNef96RGK44wufwW1eYbJJ6yK5XsRGiDFVgMtQL4cfUAng9hyPl
	 yDfI5T7lIUfzXwoOT+E60ZdRizwQ5n4QbV3ljsBc=
Date: Fri, 15 Dec 2023 10:51:27 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ying.huang@intel.com,xuyu@linux.alibaba.com,willy@infradead.org,stable@vger.kernel.org,david@redhat.com,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-migrate-fix-getting-incorrect-page-mapping-during-page-migration.patch added to mm-unstable branch
Message-Id: <20231215185127.C325DC433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: migrate: fix getting incorrect page mapping during page migration
has been added to the -mm mm-unstable branch.  Its filename is
     mm-migrate-fix-getting-incorrect-page-mapping-during-page-migration.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-migrate-fix-getting-incorrect-page-mapping-during-page-migration.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: mm: migrate: fix getting incorrect page mapping during page migration
Date: Fri, 15 Dec 2023 20:07:52 +0800

When running stress-ng testing, we found below kernel crash after a few hours:

Unable to handle kernel NULL pointer dereference at virtual address 0000000000000000
pc : dentry_name+0xd8/0x224
lr : pointer+0x22c/0x370
sp : ffff800025f134c0
......
Call trace:
  dentry_name+0xd8/0x224
  pointer+0x22c/0x370
  vsnprintf+0x1ec/0x730
  vscnprintf+0x2c/0x60
  vprintk_store+0x70/0x234
  vprintk_emit+0xe0/0x24c
  vprintk_default+0x3c/0x44
  vprintk_func+0x84/0x2d0
  printk+0x64/0x88
  __dump_page+0x52c/0x530
  dump_page+0x14/0x20
  set_migratetype_isolate+0x110/0x224
  start_isolate_page_range+0xc4/0x20c
  offline_pages+0x124/0x474
  memory_block_offline+0x44/0xf4
  memory_subsys_offline+0x3c/0x70
  device_offline+0xf0/0x120
  ......

After analyzing the vmcore, I found this issue is caused by page migration.
The scenario is that, one thread is doing page migration, and we will use the
target page's ->mapping field to save 'anon_vma' pointer between page unmap and
page move, and now the target page is locked and refcount is 1.

Currently, there is another stress-ng thread performing memory hotplug,
attempting to offline the target page that is being migrated. It discovers that
the refcount of this target page is 1, preventing the offline operation, thus
proceeding to dump the page. However, page_mapping() of the target page may
return an incorrect file mapping to crash the system in dump_mapping(), since
the target page->mapping only saves 'anon_vma' pointer without setting
PAGE_MAPPING_ANON flag.

There are seveval ways to fix this issue:
(1) Setting the PAGE_MAPPING_ANON flag for target page's ->mapping when saving
'anon_vma', but this can confuse PageAnon() for PFN walkers, since the target
page has not built mappings yet.
(2) Getting the page lock to call page_mapping() in __dump_page() to avoid crashing
the system, however, there are still some PFN walkers that call page_mapping()
without holding the page lock, such as compaction.
(3) Using target page->private field to save the 'anon_vma' pointer and 2 bits
page state, just as page->mapping records an anonymous page, which can remove
the page_mapping() impact for PFN walkers and also seems a simple way.

So I choose option 3 to fix this issue, and this can also fix other potential
issues for PFN walkers, such as compaction.

Link: https://lkml.kernel.org/r/e60b17a88afc38cb32f84c3e30837ec70b343d2b.1702641709.git.baolin.wang@linux.alibaba.com
Fixes: 64c8902ed441 ("migrate_pages: split unmap_and_move() to _unmap() and _move()")
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Xu Yu <xuyu@linux.alibaba.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |   27 ++++++++++-----------------
 1 file changed, 10 insertions(+), 17 deletions(-)

--- a/mm/migrate.c~mm-migrate-fix-getting-incorrect-page-mapping-during-page-migration
+++ a/mm/migrate.c
@@ -1025,38 +1025,31 @@ out:
 }
 
 /*
- * To record some information during migration, we use some unused
- * fields (mapping and private) of struct folio of the newly allocated
- * destination folio.  This is safe because nobody is using them
- * except us.
+ * To record some information during migration, we use unused private
+ * field of struct folio of the newly allocated destination folio.
+ * This is safe because nobody is using it except us.
  */
-union migration_ptr {
-	struct anon_vma *anon_vma;
-	struct address_space *mapping;
-};
-
 enum {
 	PAGE_WAS_MAPPED = BIT(0),
 	PAGE_WAS_MLOCKED = BIT(1),
+	PAGE_OLD_STATES = PAGE_WAS_MAPPED | PAGE_WAS_MLOCKED,
 };
 
 static void __migrate_folio_record(struct folio *dst,
-				   unsigned long old_page_state,
+				   int old_page_state,
 				   struct anon_vma *anon_vma)
 {
-	union migration_ptr ptr = { .anon_vma = anon_vma };
-	dst->mapping = ptr.mapping;
-	dst->private = (void *)old_page_state;
+	dst->private = (void *)anon_vma + old_page_state;
 }
 
 static void __migrate_folio_extract(struct folio *dst,
 				   int *old_page_state,
 				   struct anon_vma **anon_vmap)
 {
-	union migration_ptr ptr = { .mapping = dst->mapping };
-	*anon_vmap = ptr.anon_vma;
-	*old_page_state = (unsigned long)dst->private;
-	dst->mapping = NULL;
+	unsigned long private = (unsigned long)dst->private;
+
+	*anon_vmap = (struct anon_vma *)(private & ~PAGE_OLD_STATES);
+	*old_page_state = private & PAGE_OLD_STATES;
 	dst->private = NULL;
 }
 
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are

mm-migrate-fix-getting-incorrect-page-mapping-during-page-migration.patch

