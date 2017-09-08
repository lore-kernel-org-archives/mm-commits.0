From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-thp-enable-thp-migration-in-generic-path-fix.patch removed from -mm tree
Date: Fri, 08 Sep 2017 15:56:02 -0700
Message-ID: <59b32002.tFjvULOyXoO9XJ6u%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47810 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752952AbdIHW4D (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 8 Sep 2017 18:56:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: zi.yan@cs.rutgers.edu, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-thp-enable-thp-migration-in-generic-path-fix
has been removed from the -mm tree.  Its filename was
     mm-thp-enable-thp-migration-in-generic-path-fix.patch

This patch was dropped because it was folded into mm-thp-enable-thp-migration-in-generic-path.patch

------------------------------------------------------
From: "Zi Yan" <zi.yan@cs.rutgers.edu>
Subject: mm-thp-enable-thp-migration-in-generic-path-fix

fix gcc-4.9.0 -Wmissing-braces warning

Link: http://lkml.kernel.org/r/A0ABA698-7486-46C3-B209-E95A9048B22C@cs.rutgers.edu

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swapops.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/swapops.h~mm-thp-enable-thp-migration-in-generic-path-fix include/linux/swapops.h
--- a/include/linux/swapops.h~mm-thp-enable-thp-migration-in-generic-path-fix
+++ a/include/linux/swapops.h
@@ -217,7 +217,7 @@ static inline swp_entry_t pmd_to_swp_ent
 
 static inline pmd_t swp_entry_to_pmd(swp_entry_t entry)
 {
-	return (pmd_t){ 0 };
+	return __pmd(0);
 }
 
 static inline int is_pmd_migration_entry(pmd_t pmd)
_

Patches currently in -mm which might be from zi.yan@cs.rutgers.edu are

mm-thp-enable-thp-migration-in-generic-path.patch
mm-thp-check-pmd-migration-entry-in-common-path.patch

