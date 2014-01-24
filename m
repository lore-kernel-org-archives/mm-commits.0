From: akpm@linux-foundation.org
Subject: + x86-fix-numa-by-reverting-wrong-memblock-setting.patch added to -mm tree
Date: Fri, 24 Jan 2014 11:17:37 -0800
Message-ID: <52e2bc51.Y3EA+1oW6gb9K0iy%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43956 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752094AbaAXTRi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 24 Jan 2014 14:17:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tj@kernel.org, santosh.shilimkar@ti.com, mingo@elte.hu, hpa@zytor.com, grygorii.strashko@ti.com, dave.hansen@intel.com, yinghai@kernel.org

Subject: + x86-fix-numa-by-reverting-wrong-memblock-setting.patch added to -mm tree
To: yinghai@kernel.org,dave.hansen@intel.com,grygorii.strashko@ti.com,hpa@zytor.com,mingo@elte.hu,santosh.shilimkar@ti.com,tj@kernel.org
From: akpm@linux-foundation.org
Date: Fri, 24 Jan 2014 11:17:37 -0800


The patch titled
     Subject: x86: fix numa by reverting wrong memblock setting
has been added to the -mm tree.  Its filename is
     x86-fix-numa-by-reverting-wrong-memblock-setting.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/x86-fix-numa-by-reverting-wrong-memblock-setting.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/x86-fix-numa-by-reverting-wrong-memblock-setting.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Yinghai Lu <yinghai@kernel.org>
Subject: x86: fix numa by reverting wrong memblock setting

Dave reported Numa on x86 is broken on system with 1T memory.

It turns out
| commit 5b6e529521d35e1bcaa0fe43456d1bbb335cae5d
| Author: Santosh Shilimkar <santosh.shilimkar@ti.com>
| Date:   Tue Jan 21 15:50:03 2014 -0800
|
|    x86: memblock: set current limit to max low memory address

set limit to low wrongly.

max_low_pfn_mapped is different from max_pfn_mapped.
max_low_pfn_mapped is always under 4G.

That will memblock_alloc_nid all go under 4G.

Revert that offending patch.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Reported-by: Dave Hansen <dave.hansen@intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>
Cc: Grygorii Strashko <grygorii.strashko@ti.com>
Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/page_types.h |    4 ++--
 arch/x86/kernel/setup.c           |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff -puN arch/x86/include/asm/page_types.h~x86-fix-numa-by-reverting-wrong-memblock-setting arch/x86/include/asm/page_types.h
--- a/arch/x86/include/asm/page_types.h~x86-fix-numa-by-reverting-wrong-memblock-setting
+++ a/arch/x86/include/asm/page_types.h
@@ -51,9 +51,9 @@ extern int devmem_is_allowed(unsigned lo
 extern unsigned long max_low_pfn_mapped;
 extern unsigned long max_pfn_mapped;
 
-static inline phys_addr_t get_max_low_mapped(void)
+static inline phys_addr_t get_max_mapped(void)
 {
-	return (phys_addr_t)max_low_pfn_mapped << PAGE_SHIFT;
+	return (phys_addr_t)max_pfn_mapped << PAGE_SHIFT;
 }
 
 bool pfn_range_is_mapped(unsigned long start_pfn, unsigned long end_pfn);
diff -puN arch/x86/kernel/setup.c~x86-fix-numa-by-reverting-wrong-memblock-setting arch/x86/kernel/setup.c
--- a/arch/x86/kernel/setup.c~x86-fix-numa-by-reverting-wrong-memblock-setting
+++ a/arch/x86/kernel/setup.c
@@ -1119,7 +1119,7 @@ void __init setup_arch(char **cmdline_p)
 
 	setup_real_mode();
 
-	memblock_set_current_limit(get_max_low_mapped());
+	memblock_set_current_limit(get_max_mapped());
 	dma_contiguous_reserve(0);
 
 	/*
_

Patches currently in -mm which might be from yinghai@kernel.org are

origin.patch
revert-xxx.patch
x86-fix-numa-by-reverting-wrong-memblock-setting.patch

