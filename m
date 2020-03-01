From: akpm@linux-foundation.org
Subject: +
 mm-memblock-remove-redundant-assignment-to-variable-max_addr.patch added to
 -mm tree
Date: Sat, 29 Feb 2020 18:07:32 -0800
Message-ID: <20200301020732.-bKRyvtte%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:35056 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727268AbgCACHd (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 29 Feb 2020 21:07:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: colin.king@canonical.com, mm-commits@vger.kernel.org, pankaj.gupta.linux@gmail.com


The patch titled
     Subject: mm/memblock.c: remove redundant assignment to variable max_addr
has been added to the -mm tree.  Its filename is
     mm-memblock-remove-redundant-assignment-to-variable-max_addr.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memblock-remove-redundant-assignment-to-variable-max_addr.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memblock-remove-redundant-assignment-to-variable-max_addr.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-memblock-remove-redundant-assignment-to-variable-max_addr.patch
lib-test_lockup-fix-spelling-mistake-iteraions-iterations.patch
