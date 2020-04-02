From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 138/155] mm/memblock.c: remove redundant
 assignment to variable max_addr
Date: Wed, 01 Apr 2020 21:11:01 -0700
Message-ID: <20200402041101.wNZJJ4wMk%akpm@linux-foundation.org>
References: <20200401210155.09e3b9742e1c6e732f5a7250@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:37260 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726136AbgDBELC (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 2 Apr 2020 00:11:02 -0400
In-Reply-To: <20200401210155.09e3b9742e1c6e732f5a7250@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, colin.king@canonical.com, linux-mm@kvack.org, mm-commits@vger.kernel.org, pankaj.gupta.linux@gmail.com, rppt@linux.ibm.com, torvalds@linux-foundation.org

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
