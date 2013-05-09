From: akpm@linux-foundation.org
Subject: + x86-mm-add-missing-comments-for-initial-kernel-direct-mapping.patch added to -mm tree
Date: Thu, 09 May 2013 13:17:32 -0700
Message-ID: <20130509201732.89AA15A4251@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:45156 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751935Ab3EIURd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 May 2013 16:17:33 -0400
Received: by mail-gg0-f202.google.com with SMTP id 4so329631ggm.3
        for <mm-commits@vger.kernel.org>; Thu, 09 May 2013 13:17:33 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: zhangyanfei@cn.fujitsu.com, hpa@zytor.com, isimatu.yasuaki@jp.fujitsu.com, konrad.wilk@oracle.com, mingo@redhat.com, tglx@linutronix.de, yinghai@kernel.org


The patch titled
     Subject: x86: mm: add missing comments for initial kernel direct mapping
has been added to the -mm tree.  Its filename is
     x86-mm-add-missing-comments-for-initial-kernel-direct-mapping.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Subject: x86: mm: add missing comments for initial kernel direct mapping

For some reason, comments below are lost:
  - comments for init_range_memory_mapping()
  - comments in init_mem_mapping that is helpful for reminding people
    that the pagetable is setup top-down

The comments were written by Yinghai in his patch in
https://lkml.org/lkml/2012/11/28/620

Signed-off-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/init.c |   19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

diff -puN arch/x86/mm/init.c~x86-mm-add-missing-comments-for-initial-kernel-direct-mapping arch/x86/mm/init.c
--- a/arch/x86/mm/init.c~x86-mm-add-missing-comments-for-initial-kernel-direct-mapping
+++ a/arch/x86/mm/init.c
@@ -359,7 +359,17 @@ unsigned long __init_refok init_memory_m
 }
 
 /*
- * would have hole in the middle or ends, and only ram parts will be mapped.
+ * We need to iterate through E820 memory map and create direct mappings
+ * for only E820_RAM and E820_KERN_RESERVED regions. We cannot simply
+ * create direct mappings for all pfns from [0 to max_low_pfn) and
+ * [4GB to max_pfn) because of possible memory holes in high addresses
+ * that cannot be marked as UC by fixed/variable range MTRRs.
+ * Depending on the alignment of E820 ranges, this may possibly result
+ * in using smaller size (i.e. 4K instead of 2M or 1G) page tables.
+ *
+ * init_mem_mapping call init_range_memory_mapping with big range.
+ * That range would have hole in the middle or ends, and only ram parts
+ * will be mapped in init_range_memory_mapping.
  */
 static unsigned long __init init_range_memory_mapping(
 					   unsigned long r_start,
@@ -419,6 +429,13 @@ void __init init_mem_mapping(void)
 	max_pfn_mapped = 0; /* will get exact value next */
 	min_pfn_mapped = real_end >> PAGE_SHIFT;
 	last_start = start = real_end;
+
+	/*
+	 * We start from the top (end of memory) and go to the bottom.
+	 * The memblock_find_in_range gets us a block of RAM from the
+	 * end of RAM in [min_pfn_mapped, max_pfn_mapped) as new pages
+	 * for page table.
+	 */
 	while (last_start > ISA_END_ADDRESS) {
 		if (last_start > step_size) {
 			start = round_down(last_start - 1, step_size);
_

Patches currently in -mm which might be from zhangyanfei@cn.fujitsu.com are

origin.patch
x86-mm-add-missing-comments-for-initial-kernel-direct-mapping.patch
ipvs-change-type-of-netns_ipvs-sysctl_sync_qlen_max.patch

