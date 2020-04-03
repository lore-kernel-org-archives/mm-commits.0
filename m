From: akpm@linux-foundation.org
Subject: [merged]
 mm-memblock-remove-redundant-assignment-to-variable-max_addr.patch removed
 from -mm tree
Date: Fri, 03 Apr 2020 13:40:23 -0700
Message-ID: <20200403204023.gN3cUju37%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:36402 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727835AbgDCUkY (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 3 Apr 2020 16:40:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: colin.king@canonical.com, mm-commits@vger.kernel.org, pankaj.gupta.linux@gmail.com, rppt@linux.ibm.com


The patch titled
     Subject: mm/memblock.c: remove redundant assignment to variable max_addr
has been removed from the -mm tree.  Its filename was
     mm-memblock-remove-redundant-assignment-to-variable-max_addr.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Colin Ian King <colin.king@canonical.com>
Subject: mm/memblock.c: remove redundant assignment to variable max_addr

The variable max_addr is being initialized with a value that is never read
and it is being updated later with a new value.  The initialization is
redundant and can be removed.

Addresses-Coverity: ("Unused value")
Link: http://lkml.kernel.org/r/20200228235003.112718-1-colin.king@canonical.com
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Reviewed-by: Pankaj Gupta <pankaj.gupta.linux@gmail.com>
Reviewed-by: Mike Rapoport <rppt@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memblock.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memblock.c~mm-memblock-remove-redundant-assignment-to-variable-max_addr
+++ a/mm/memblock.c
@@ -1698,7 +1698,7 @@ static phys_addr_t __init_memblock __fin
 
 void __init memblock_enforce_memory_limit(phys_addr_t limit)
 {
-	phys_addr_t max_addr = PHYS_ADDR_MAX;
+	phys_addr_t max_addr;
 
 	if (!limit)
 		return;
_

Patches currently in -mm which might be from colin.king@canonical.com are

lib-test_lockup-fix-spelling-mistake-iteraions-iterations.patch
reiserfs-clean-up-several-indentation-issues.patch
