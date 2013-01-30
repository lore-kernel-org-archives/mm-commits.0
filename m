From: akpm@linux-foundation.org
Subject: + ia64-mm-fix-a-bad_page-bug-when-crash-kernel-booting.patch added to -mm tree
Date: Tue, 29 Jan 2013 16:27:49 -0800
Message-ID: <20130130002750.1250E31C1CB@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:42904 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751775Ab3A3A1w (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 29 Jan 2013 19:27:52 -0500
Received: by mail-vb0-f74.google.com with SMTP id r6so103408vbi.1
        for <mm-commits@vger.kernel.org>; Tue, 29 Jan 2013 16:27:50 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: qiuxishi@huawei.com, tony.luck@intel.com


The patch titled
     Subject: ia64/mm: fix a bad_page bug when crash kernel booting
has been added to the -mm tree.  Its filename is
     ia64-mm-fix-a-bad_page-bug-when-crash-kernel-booting.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Xishi Qiu <qiuxishi@huawei.com>
Subject: ia64/mm: fix a bad_page bug when crash kernel booting

On ia64 platform, I set "crashkernel=1024M-:600M", and dmesg shows
128M-728M memory is reserved for crash kernel.  Then "echo c >
/proc/sysrq-trigger" to test kdump.

When crash kernel booting, efi_init() will aligns the memory address in
IA64_GRANULE_SIZE(16M), so 720M-728M memory will be dropped, It means
crash kernel only manage 128M-720M memory.

But initrd start and end are fixed in boot loader, it is before
efi_init(), so initrd size maybe overflow when free_initrd_mem().

Here is the dmesg when crash kernel booting:

...
Ignoring memory below 128MB
Ignoring memory above 720MB
    // aligns the address in IA64_GRANULE_SIZE(16M)
...
Initial ramdisk at: 0xe00000002c3f0000 (20176579 bytes)
    // initrd uses 707M-726M memory
...
Kernel command line:  root=/dev/disk/by-id/ata-STEC_MACH16_M16ISD2-100UCT_STM000142A2D-part3
console=ttyS0,115200n8 console=tty0 initcall_debug elevator=deadline sysrq=1 reset_devices
irqpoll maxcpus=1 initcall_debug linuxrc=trace elfcorehdr=745216K max_addr=728M min_addr=128M
    // show crash kernel parameters
...
Unpacking initramfs...
    // called by populate_rootfs()
Freeing initrd memory: 19648kB freed
    // called by free_initrd()->free_initrd_mem()
BUG: Bad page state in process swapper  pfn:02d00
    // it is a mistake to free over 720M memory to OS (ia64's page size is 64KB)
page:e0000000102dd800 flags:(null) count:0 mapcount:1 mapping:(null) index:0

Call Trace:
 [<a000000100018dc0>] show_stack+0x80/0xa0
                                sp=e000000021e8fbd0 bsp=e000000021e81360
 [<a00000010090fcc0>] dump_stack+0x30/0x50
                                sp=e000000021e8fda0 bsp=e000000021e81348
 [<a0000001001a3180>] bad_page+0x280/0x380
                                sp=e000000021e8fda0 bsp=e000000021e81308
 [<a0000001001a8740>] free_hot_cold_page+0x3a0/0x5c0
                                sp=e000000021e8fda0 bsp=e000000021e812a0
 [<a0000001001a8a50>] free_hot_page+0x30/0x60
                                sp=e000000021e8fda0 bsp=e000000021e81280
 [<a0000001001a8b30>] __free_pages+0xb0/0xe0
                                sp=e000000021e8fda0 bsp=e000000021e81258
 [<a0000001001a8c00>] free_pages+0xa0/0xc0
                                sp=e000000021e8fda0 bsp=e000000021e81230
 [<a000000100bb40c0>] free_initrd_mem+0x230/0x290
                                sp=e000000021e8fda0 bsp=e000000021e811d8
 [<a000000100ba6620>] populate_rootfs+0x1c0/0x280
                                sp=e000000021e8fdb0 bsp=e000000021e811a0
 [<a00000010000ac30>] do_one_initcall+0x3b0/0x3e0
                                sp=e000000021e8fdb0 bsp=e000000021e81158
 [<a000000100ba0a90>] kernel_init+0x3f0/0x4b0
                                sp=e000000021e8fdb0 bsp=e000000021e81108
 [<a000000100016890>] kernel_thread_helper+0xd0/0x100
                                sp=e000000021e8fe30 bsp=e000000021e810e0
 [<a00000010000a4c0>] start_kernel_thread+0x20/0x40
                                sp=e000000021e8fe30 bsp=e000000021e810e0
Disabling lock debugging due to kernel taint
BUG: Bad page state in process swapper  pfn:02d01
page:e0000000102dd838 flags:(null) count:0 mapcount:1 mapping:(null) index:0

Call Trace:
 [<a000000100018dc0>] show_stack+0x80/0xa0
                                sp=e000000021e8fbd0 bsp=e000000021e81360
 [<a00000010090fcc0>] dump_stack+0x30/0x50
                                sp=e000000021e8fda0 bsp=e000000021e81348
 [<a0000001001a3180>] bad_page+0x280/0x380
                                sp=e000000021e8fda0 bsp=e000000021e81308
 [<a0000001001a8740>] free_hot_cold_page+0x3a0/0x5c0
                                sp=e000000021e8fda0 bsp=e000000021e812a0
 [<a0000001001a8a50>] free_hot_page+0x30/0x60
                                sp=e000000021e8fda0 bsp=e000000021e81280
 [<a0000001001a8b30>] __free_pages+0xb0/0xe0
                                sp=e000000021e8fda0 bsp=e000000021e81258
 [<a0000001001a8c00>] free_pages+0xa0/0xc0
                                sp=e000000021e8fda0 bsp=e000000021e81230
 [<a000000100bb40c0>] free_initrd_mem+0x230/0x290
                                sp=e000000021e8fda0 bsp=e000000021e811d8
 [<a000000100ba6620>] populate_rootfs+0x1c0/0x280
                                sp=e000000021e8fdb0 bsp=e000000021e811a0
 [<a00000010000ac30>] do_one_initcall+0x3b0/0x3e0
                                sp=e000000021e8fdb0 bsp=e000000021e81158
 [<a000000100ba0a90>] kernel_init+0x3f0/0x4b0
                                sp=e000000021e8fdb0 bsp=e000000021e81108
 [<a000000100016890>] kernel_thread_helper+0xd0/0x100
                                sp=e000000021e8fe30 bsp=e000000021e810e0
 [<a00000010000a4c0>] start_kernel_thread+0x20/0x40
                                sp=e000000021e8fe30 bsp=e000000021e810e0
...

Signed-off-by: Xishi Qiu <qiuxishi@huawei.com>
Cc: "Luck, Tony" <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/include/asm/meminit.h |    2 ++
 arch/ia64/kernel/efi.c          |    2 +-
 arch/ia64/mm/init.c             |   11 +++++++++++
 3 files changed, 14 insertions(+), 1 deletion(-)

diff -puN arch/ia64/include/asm/meminit.h~ia64-mm-fix-a-bad_page-bug-when-crash-kernel-booting arch/ia64/include/asm/meminit.h
--- a/arch/ia64/include/asm/meminit.h~ia64-mm-fix-a-bad_page-bug-when-crash-kernel-booting
+++ a/arch/ia64/include/asm/meminit.h
@@ -49,6 +49,8 @@ extern int reserve_elfcorehdr(u64 *start
 #define GRANULEROUNDDOWN(n)	((n) & ~(IA64_GRANULE_SIZE-1))
 #define GRANULEROUNDUP(n)	(((n)+IA64_GRANULE_SIZE-1) & ~(IA64_GRANULE_SIZE-1))
 
+extern u64 max_addr;
+
 #ifdef CONFIG_NUMA
   extern void call_pernode_memory (unsigned long start, unsigned long len, void *func);
 #else
diff -puN arch/ia64/kernel/efi.c~ia64-mm-fix-a-bad_page-bug-when-crash-kernel-booting arch/ia64/kernel/efi.c
--- a/arch/ia64/kernel/efi.c~ia64-mm-fix-a-bad_page-bug-when-crash-kernel-booting
+++ a/arch/ia64/kernel/efi.c
@@ -49,7 +49,7 @@ extern efi_status_t efi_call_phys (void 
 struct efi efi;
 EXPORT_SYMBOL(efi);
 static efi_runtime_services_t *runtime;
-static u64 mem_limit = ~0UL, max_addr = ~0UL, min_addr = 0UL;
+u64 mem_limit = ~0UL, max_addr = ~0UL, min_addr = 0UL;
 
 #define efi_call_virt(f, args...)	(*(f))(args)
 
diff -puN arch/ia64/mm/init.c~ia64-mm-fix-a-bad_page-bug-when-crash-kernel-booting arch/ia64/mm/init.c
--- a/arch/ia64/mm/init.c~ia64-mm-fix-a-bad_page-bug-when-crash-kernel-booting
+++ a/arch/ia64/mm/init.c
@@ -207,6 +207,17 @@ free_initrd_mem (unsigned long start, un
 	start = PAGE_ALIGN(start);
 	end = end & PAGE_MASK;
 
+	/*
+	 * Initrd size is fixed in boot loader, but kernel parameter max_addr
+	 * which aligns in granules is fixed after boot loader, so initrd size
+	 * maybe overflow.
+	 */
+	if (max_addr != ~0UL) {
+		end = GRANULEROUNDDOWN(end);
+		if (start > end)
+			start = end;
+	}
+
 	if (start < end)
 		printk(KERN_INFO "Freeing initrd memory: %ldkB freed\n", (end - start) >> 10);
 
_

Patches currently in -mm which might be from qiuxishi@huawei.com are

ia64-mm-fix-a-bad_page-bug-when-crash-kernel-booting.patch
memory-failure-fix-an-error-of-mce_bad_pages-statistics.patch
memory-failure-do-code-refactor-of-soft_offline_page.patch
memory-failure-use-num_poisoned_pages-instead-of-mce_bad_pages.patch
memory-failure-use-num_poisoned_pages-instead-of-mce_bad_pages-fix.patch
mm-memory-failurec-clean-up-soft_offline_page.patch

