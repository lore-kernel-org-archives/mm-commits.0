From: akpm@linux-foundation.org
Subject: [to-be-updated] x86-mm-limit-2-4m-size-calculation-to-x86_32.patch removed from -mm tree
Date: Fri, 07 Sep 2012 15:56:32 -0700
Message-ID: <20120907225632.7AFCC1001AD@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:52752 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751686Ab2IGW4e (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 7 Sep 2012 18:56:34 -0400
Received: by qafl39 with SMTP id l39so6085qaf.1
        for <mm-commits@vger.kernel.org>; Fri, 07 Sep 2012 15:56:33 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: stefan.bader@canonical.com, hpa@zytor.com, mingo@elte.hu, stable@vger.kernel.org, tglx@linutronix.de, tj@kernel.org, xiyou.wangcong@gmail.com, yinghai@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: x86/mm: limit extra padding calculation to x86_32
has been removed from the -mm tree.  Its filename was
     x86-mm-limit-2-4m-size-calculation-to-x86_32.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Stefan Bader <stefan.bader@canonical.com>
Subject: x86/mm: limit extra padding calculation to x86_32

Starting with kernel v3.5 kexec based crash dumping was observed to fail
(without any apparent message) on x86_64 machines.  This was traced to a
lack of memory triggered by a substantial increase (several megabyes) in
the size of the initial page tables.

 After regression (on a VM with 2GB of memory):
 kernel direct mapping tables up to 0x7fffcfff @ [mem 0x1fbfd000-0x1fffffff]
 size = 4206591 bytes

 With this patch applied:
 kernel direct mapping tables up to 0x7fffcfff @ [mem 0x1fffc000-0x1fffffff]
 size = 16383 bytes

A bisection lead to commit 722bc6b ("x86/mm: Fix the size calculation of
mapping tables")

This change modified the extra space calculation to take into account that
the first 2/4M range of memory would be mapped as 4K pages as suggested in
chapter 11.11.9 of the Intel software developer's manual.

However this is currently only true for x86_32 (the reasons behind that
are unclear but apparently the whole page table setup needs to be re-
visited as it turns out to be very easy to break and has flaws in its
current form).

Until the logic can be revisited and combined, pair up the extra space
calculation with the logic which creates the extra mappings.

Signed-off-by: Stefan Bader <stefan.bader@canonical.com>
Cc: WANG Cong <xiyou.wangcong@gmail.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: <stable@vger.kernel.org>	[v3.5+]
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/init.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN arch/x86/mm/init.c~x86-mm-limit-2-4m-size-calculation-to-x86_32 arch/x86/mm/init.c
--- a/arch/x86/mm/init.c~x86-mm-limit-2-4m-size-calculation-to-x86_32
+++ a/arch/x86/mm/init.c
@@ -60,10 +60,11 @@ static void __init find_early_table_spac
 		extra = end - ((end>>PMD_SHIFT) << PMD_SHIFT);
 #ifdef CONFIG_X86_32
 		extra += PMD_SIZE;
-#endif
+
 		/* The first 2/4M doesn't use large pages. */
 		if (mr->start < PMD_SIZE)
 			extra += mr->end - mr->start;
+#endif
 
 		ptes = (extra + PAGE_SIZE - 1) >> PAGE_SHIFT;
 	} else
_

Patches currently in -mm which might be from stefan.bader@canonical.com are


