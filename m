From: akpm@linux-foundation.org
Subject: [merged] kdump-x86-fix-total-mem-size-calculation-for-reservation.patch removed from -mm tree
Date: Thu, 29 Mar 2012 12:13:50 -0700
Message-ID: <20120329191350.7D9E7A01E3@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-we0-f202.google.com ([74.125.82.202]:52280 "EHLO
	mail-we0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933735Ab2C2TNw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 29 Mar 2012 15:13:52 -0400
Received: by wejx9 with SMTP id x9so96325wej.1
        for <mm-commits@vger.kernel.org>; Thu, 29 Mar 2012 12:13:51 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dyoung@redhat.com, horms@verge.net.au, xiyou.wangcong@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kdump x86: fix total mem size calculation for reservation
has been removed from the -mm tree.  Its filename was
     kdump-x86-fix-total-mem-size-calculation-for-reservation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Dave Young <dyoung@redhat.com>
Subject: kdump x86: fix total mem size calculation for reservation

crashkernel reservation need know the total memory size.  Current
get_total_mem simply use max_pfn - min_low_pfn.  It is wrong because it
will including memory holes in the middle.

Especially for kvm guest with memory > 0xe0000000, there's below in qemu
code: qemu split memory as below:

    if (ram_size >= 0xe0000000 ) {
        above_4g_mem_size = ram_size - 0xe0000000;
        below_4g_mem_size = 0xe0000000;
    } else {
        below_4g_mem_size = ram_size;
    }

So for 4G mem guest, seabios will insert a 512M usable region beyond of
4G.  Thus in above case max_pfn - min_low_pfn will be more than original
memsize.

Fixing this issue by using memblock_phys_mem_size() to get the total
memsize.

Signed-off-by: Dave Young <dyoung@redhat.com>
Reviewed-by: WANG Cong <xiyou.wangcong@gmail.com>
Reviewed-by: Simon Horman <horms@verge.net.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/setup.c |   11 +----------
 1 file changed, 1 insertion(+), 10 deletions(-)

diff -puN arch/x86/kernel/setup.c~kdump-x86-fix-total-mem-size-calculation-for-reservation arch/x86/kernel/setup.c
--- a/arch/x86/kernel/setup.c~kdump-x86-fix-total-mem-size-calculation-for-reservation
+++ a/arch/x86/kernel/setup.c
@@ -509,15 +509,6 @@ static void __init memblock_x86_reserve_
 
 #ifdef CONFIG_KEXEC
 
-static inline unsigned long long get_total_mem(void)
-{
-	unsigned long long total;
-
-	total = max_pfn - min_low_pfn;
-
-	return total << PAGE_SHIFT;
-}
