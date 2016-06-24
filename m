From: akpm@linux-foundation.org
Subject: [patch 27/41] Revert "mm: disable fault around on emulated access bit architecture"
Date: Fri, 24 Jun 2016 14:49:48 -0700
Message-ID: <576daafc.De+eURB9sE45ycds%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41011 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751474AbcFXVtt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 24 Jun 2016 17:49:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, kirill.shutemov@linux.intel.com, dave.hansen@linux.intel.com, mgorman@suse.de, mhocko@suse.com, minchan@kernel.org, riel@redhat.com, vinmenon@codeaurora.org, ying.huang@intel.com

From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: Revert "mm: disable fault around on emulated access bit architecture"

This reverts commit d0834a6c2c5b0c76cfb806bd7dba6556d8b4edbb.

After revert of 5c0a85fad949 ("mm: make faultaround produce old ptes")
faultaround doesn't have dependencies on hardware accessed bit, so let's
revert this one too.

Link: http://lkml.kernel.org/r/1465893750-44080-3-git-send-email-kirill.shutemov@linux.intel.com
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Reported-by: "Huang, Ying" <ying.huang@intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Rik van Riel <riel@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Vinayak Menon <vinmenon@codeaurora.org>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    8 --------
 1 file changed, 8 deletions(-)

diff -puN mm/memory.c~revert-mm-disable-fault-around-on-emulated-access-bit-architecture mm/memory.c
--- a/mm/memory.c~revert-mm-disable-fault-around-on-emulated-access-bit-architecture
+++ a/mm/memory.c
@@ -2898,16 +2898,8 @@ void do_set_pte(struct vm_area_struct *v
 	update_mmu_cache(vma, address, pte);
 }
 
-/*
- * If architecture emulates "accessed" or "young" bit without HW support,
- * there is no much gain with fault_around.
- */
 static unsigned long fault_around_bytes __read_mostly =
-#ifndef __HAVE_ARCH_PTEP_SET_ACCESS_FLAGS
-	PAGE_SIZE;
-#else
 	rounddown_pow_of_two(65536);
-#endif
 
 #ifdef CONFIG_DEBUG_FS
 static int fault_around_bytes_get(void *data, u64 *val)
_
