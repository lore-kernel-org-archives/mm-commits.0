From: akpm@linux-foundation.org
Subject: +
 mm-migrate-allow-migrate_vma-to-alloc-new-page-on-empty-entry-fix.patch
 added to -mm tree
Date: Mon, 10 Apr 2017 13:57:51 -0700
Message-ID: <58ebf1cf.DTAxfa8Vh/y7sADj%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54144 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751585AbdDJU5w (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 10 Apr 2017 16:57:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sfr@canb.auug.org.au, jglisse@redhat.com, kirill.shutemov@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/migrate: allow migrate_vma() to alloc new page on empty entry fix
has been added to the -mm tree.  Its filename is
     mm-migrate-allow-migrate_vma-to-alloc-new-page-on-empty-entry-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-migrate-allow-migrate_vma-to-alloc-new-page-on-empty-entry-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-migrate-allow-migrate_vma-to-alloc-new-page-on-empty-entry-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: mm/migrate: allow migrate_vma() to alloc new page on empty entry fix

Link: http://lkml.kernel.org/r/20170410175103.1a534c7d@canb.auug.org.au
Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Jérôme Glisse <jglisse@redhat.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff -puN mm/migrate.c~mm-migrate-allow-migrate_vma-to-alloc-new-page-on-empty-entry-fix mm/migrate.c
--- a/mm/migrate.c~mm-migrate-allow-migrate_vma-to-alloc-new-page-on-empty-entry-fix
+++ a/mm/migrate.c
@@ -2478,6 +2478,7 @@ static void migrate_vma_insert_page(stru
 	struct mem_cgroup *memcg;
 	spinlock_t *ptl;
 	pgd_t *pgdp;
+	p4d_t *p4dp;
 	pud_t *pudp;
 	pmd_t *pmdp;
 	pte_t *ptep;
@@ -2488,7 +2489,10 @@ static void migrate_vma_insert_page(stru
 		goto abort;
 
 	pgdp = pgd_offset(mm, addr);
-	pudp = pud_alloc(mm, pgdp, addr);
+	p4dp = p4d_alloc(mm, pgdp, addr);
+	if (!p4dp)
+		goto abort;
+	pudp = pud_alloc(mm, p4dp, addr);
 	if (!pudp)
 		goto abort;
 	pmdp = pmd_alloc(mm, pudp, addr);
_

Patches currently in -mm which might be from sfr@canb.auug.org.au are

mm-introduce-kvalloc-helpers-fix.patch
mm-migrate-allow-migrate_vma-to-alloc-new-page-on-empty-entry-fix.patch

