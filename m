From: akpm@linux-foundation.org
Subject: [merged]
 vmlinuxlds-add-comments-for-global-variables-and-clean-up-useless-declarations.patch removed from -mm tree
Date: Mon, 08 Jul 2013 12:26:34 -0700
Message-ID: <51db126a.8MpoZ0K5zsiEDrsx%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50816 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752980Ab3GHT0f (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Jul 2013 15:26:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, vgupta@synopsys.com, jiang.liu@huawei.com, arnd@arndb.de, liuj97@gmail.com

Subject: [merged] vmlinuxlds-add-comments-for-global-variables-and-clean-up-useless-declarations.patch removed from -mm tree
To: liuj97@gmail.com,arnd@arndb.de,jiang.liu@huawei.com,vgupta@synopsys.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 08 Jul 2013 12:26:34 -0700


The patch titled
     Subject: vmlinux.lds: add comments for global variables and clean up useless declarations
has been removed from the -mm tree.  Its filename was
     vmlinuxlds-add-comments-for-global-variables-and-clean-up-useless-declarations.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jiang Liu <liuj97@gmail.com>
Subject: vmlinux.lds: add comments for global variables and clean up useless declarations

The original goal of this patchset is to fix the bug reported by
https://bugzilla.kernel.org/show_bug.cgi?id=53501 Now it has also been
expanded to reduce common code used by memory initializion.

Patch 1-7: 
	1) add comments for global variables exported by vmlinux.lds
	2) normalize global variables exported by vmlinux.lds
Patch 8:
	Introduce helper functions mem_init_print_info() and
	get_num_physpages()
Patch 9:
	Avoid using global variable num_physpages at runtime
Patch 10:
	Don't update num_physpages in memory_hotplug.c
Patch 11-40:
	Modify arch mm initialization code to:
	1) Simplify mem_init() by using mem_init_print_info()
	2) Prepare for killing global variable num_physpages
Patch 41:
	Kill the global variable num_physpages

With all patches applied, mem_init(), free_initmem(), free_initrd_mem()
could be as simple as below.  This patch series has reduced about 1.2K
lines of code in total.

#ifndef CONFIG_DISCONTIGMEM
void __init
mem_init(void)
{
	max_mapnr = max_low_pfn;
	free_all_bootmem();
	high_memory = (void *) __va(max_low_pfn * PAGE_SIZE);

	mem_init_print_info(NULL);
}
#endif /* CONFIG_DISCONTIGMEM */

void
free_initmem(void)
{
	free_initmem_default(-1);
}

#ifdef CONFIG_BLK_DEV_INITRD
void
free_initrd_mem(unsigned long start, unsigned long end)
{
	free_reserved_area(start, end, -1, "initrd");
}
#endif

Due to hardware resource limitations, I have only tested this on x86_64. 
And the messages reported on an x86_64 system are:

Log message before applying patches:
Memory: 7745676k/8910848k available (6934k kernel code, 836024k absent, 329148k reserved, 6343k data, 1012k init)

Log message after applying patches:
Memory: 7744624K/8074824K available (6969K kernel code, 1011K data, 2828K rodata, 1016K init, 9640K bss, 330200K reserved)

Great thanks to Vineet Gupta for testing on ARC.


This patch:

Document global variables exported from vmlinux.lds.

1) Add comments about usage guidelines for global variables exported
   from vmlinux.lds.S.
2) Remove unused __initdata_begin[] and __initdata_end[].

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Vineet Gupta <vgupta@synopsys.com> 
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/sections.h |   21 ++++++++++++++++++++-
 1 file changed, 20 insertions(+), 1 deletion(-)

diff -puN include/asm-generic/sections.h~vmlinuxlds-add-comments-for-global-variables-and-clean-up-useless-declarations include/asm-generic/sections.h
--- a/include/asm-generic/sections.h~vmlinuxlds-add-comments-for-global-variables-and-clean-up-useless-declarations
+++ a/include/asm-generic/sections.h
@@ -3,6 +3,26 @@
 
 /* References to section boundaries */
 
+/*
+ * Usage guidelines:
+ * _text, _data: architecture specific, don't use them in arch-independent code
+ * [_stext, _etext]: contains .text.* sections, may also contain .rodata.*
+ *                   and/or .init.* sections
+ * [_sdata, _edata]: contains .data.* sections, may also contain .rodata.*
+ *                   and/or .init.* sections.
+ * [__start_rodata, __end_rodata]: contains .rodata.* sections
+ * [__init_begin, __init_end]: contains .init.* sections, but .init.text.*
+ *                   may be out of this range on some architectures.
+ * [_sinittext, _einittext]: contains .init.text.* sections
+ * [__bss_start, __bss_stop]: contains BSS sections
+ *
+ * Following global variables are optional and may be unavailable on some
+ * architectures and/or kernel configurations.
+ *	_text, _data
+ *	__kprobes_text_start, __kprobes_text_end
+ *	__entry_text_start, __entry_text_end
+ *	__ctors_start, __ctors_end
+ */
 extern char _text[], _stext[], _etext[];
 extern char _data[], _sdata[], _edata[];
 extern char __bss_start[], __bss_stop[];
@@ -12,7 +32,6 @@ extern char _end[];
 extern char __per_cpu_load[], __per_cpu_start[], __per_cpu_end[];
 extern char __kprobes_text_start[], __kprobes_text_end[];
 extern char __entry_text_start[], __entry_text_end[];
-extern char __initdata_begin[], __initdata_end[];
 extern char __start_rodata[], __end_rodata[];
 
 /* Start and end of .ctors section - used for constructor calls. */
_

Patches currently in -mm which might be from liuj97@gmail.com are

origin.patch
linux-next.patch

