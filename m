From: akpm@linux-foundation.org
Subject: [patch 01/13] mm: fix overflow check in expand_upwards()
Date: Fri, 14 Jul 2017 14:49:38 -0700
Message-ID: <59693c72.eKWYyvnqqdzX2aP4%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55726 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751012AbdGNVtj (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 14 Jul 2017 17:49:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, deller@gmx.de, hughd@google.com, joern@purestorage.com, oleg@redhat.com, stable@vger.kernel.org

From: Helge Deller <deller@gmx.de>
Subject: mm: fix overflow check in expand_upwards()

Jörn Engel noticed that the expand_upwards() function might not return
-ENOMEM in case the requested address is (unsigned long)-PAGE_SIZE and if
the architecture didn't defined TASK_SIZE as multiple of PAGE_SIZE.

Affected architectures are arm, frv, m68k, blackfin, h8300 and xtensa
which all define TASK_SIZE as 0xffffffff, but since none of those have an
upwards-growing stack we currently have no actual issue.

Nevertheless let's fix this just in case any of the architectures with an
upward-growing stack (currently parisc, metag and partly ia64) define
TASK_SIZE similar.

Link: http://lkml.kernel.org/r/20170702192452.GA11868@p100.box
Fixes: bd726c90b6b8 ("Allow stack to grow up to address space limit")
Signed-off-by: Helge Deller <deller@gmx.de>
Reported-by: Jörn Engel <joern@purestorage.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/mmap.c~mm-fix-overflow-check-in-expand_upwards mm/mmap.c
--- a/mm/mmap.c~mm-fix-overflow-check-in-expand_upwards
+++ a/mm/mmap.c
@@ -2231,7 +2231,7 @@ int expand_upwards(struct vm_area_struct
 
 	/* Guard against exceeding limits of the address space. */
 	address &= PAGE_MASK;
-	if (address >= TASK_SIZE)
+	if (address >= (TASK_SIZE & PAGE_MASK))
 		return -ENOMEM;
 	address += PAGE_SIZE;
 
_
