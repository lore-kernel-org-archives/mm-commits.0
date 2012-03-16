From: akpm@linux-foundation.org
Subject: + kdump-x86-fix-total-mem-size-calculation-for-reservation.patch added to -mm tree
Date: Fri, 16 Mar 2012 13:56:22 -0700
Message-ID: <20120316205624.2467BA0128@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vx0-f202.google.com ([209.85.220.202]:38499 "EHLO
	mail-vx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965332Ab2CPU42 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 16 Mar 2012 16:56:28 -0400
Received: by vcbfk26 with SMTP id fk26so741898vcb.1
        for <mm-commits@vger.kernel.org>; Fri, 16 Mar 2012 13:56:27 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dyoung@redhat.com, horms@verge.net.au, xiyou.wangcong@gmail.com


The patch titled
     Subject: kdump x86: fix total mem size calculation for reservation
has been added to the -mm tree.  Its filename is
     kdump-x86-fix-total-mem-size-calculation-for-reservation.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
-
 /*
  * Keep the crash kernel below this limit.  On 32 bits earlier kernels
  * would limit the kernel to the low 512 MiB due to mapping restrictions.
@@ -536,7 +527,7 @@ static void __init reserve_crashkernel(v
 	unsigned long long crash_size, crash_base;
 	int ret;
 
-	total_mem = get_total_mem();
+	total_mem = memblock_phys_mem_size();
 
 	ret = parse_crashkernel(boot_command_line, total_mem,
 			&crash_size, &crash_base);
_
Subject: Subject: kdump x86: fix total mem size calculation for reservation

Patches currently in -mm which might be from dyoung@redhat.com are

linux-next.patch
kdump-x86-fix-total-mem-size-calculation-for-reservation.patch
selftests-launch-individual-selftests-from-the-main-makefile.patch
move-page-typesc-from-documentation-to-tools-vm.patch
move-slabinfoc-to-tools-vm.patch
move-hugepage-test-examples-to-tools-testing-selftests-vm.patch
move-hugepage-test-examples-to-tools-testing-selftests-vm-fix.patch
move-hugepage-test-examples-to-tools-testing-selftests-vm-fix-fix.patch

