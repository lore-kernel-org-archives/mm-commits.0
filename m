From: akpm@linux-foundation.org
Subject: [merged] mm-mark-fault_around_bytes-__read_mostly.patch removed
 from -mm tree
Date: Thu, 07 Aug 2014 13:06:31 -0700
Message-ID: <53e3dc47.qtm7aiGemxwOJ3dA%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-pa0-f74.google.com ([209.85.220.74]:34765 "EHLO
	mail-pa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755130AbaHGUGc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Aug 2014 16:06:32 -0400
Received: by mail-pa0-f74.google.com with SMTP id lj1so1178065pab.1
        for <mm-commits@vger.kernel.org>; Thu, 07 Aug 2014 13:06:31 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, a.ryabinin@samsung.com, dave.hansen@intel.com, rientjes@google.com, sasha.levin@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: mark fault_around_bytes __read_mostly
has been removed from the -mm tree.  Its filename was
     mm-mark-fault_around_bytes-__read_mostly.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: mm: mark fault_around_bytes __read_mostly

fault_around_bytes can only be changed via debugfs. Let's mark it
read-mostly.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Suggested-by: David Rientjes <rientjes@google.com>
Acked-by: David Rientjes <rientjes@google.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Andrey Ryabinin <a.ryabinin@samsung.com>
Cc: Sasha Levin <sasha.levin@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN mm/memory.c~mm-mark-fault_around_bytes-__read_mostly mm/memory.c
--- a/mm/memory.c~mm-mark-fault_around_bytes-__read_mostly
+++ a/mm/memory.c
@@ -2766,7 +2766,8 @@ void do_set_pte(struct vm_area_struct *v
 	update_mmu_cache(vma, address, pte);
 }
 
-static unsigned long fault_around_bytes = rounddown_pow_of_two(65536);
+static unsigned long fault_around_bytes __read_mostly =
+	rounddown_pow_of_two(65536);
 
 #ifdef CONFIG_DEBUG_FS
 static int fault_around_bytes_get(void *data, u64 *val)
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

origin.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
linux-next.patch
mm-replace-remap_file_pages-syscall-with-emulation.patch
mm-replace-remap_file_pages-syscall-with-emulation-fix.patch
mm-replace-remap_file_pages-syscall-with-emulation-fix-2.patch
mm-replace-remap_file_pages-syscall-with-emulation-fix-3.patch

