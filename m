From: akpm@linux-foundation.org
Subject: [patch 15/20] vmlinux.lds: account for destructor sections
Date: Thu, 14 Jul 2016 12:07:29 -0700
Message-ID: <5787e2f1.qnxlIUIgHV9UAuzu%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41010 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751224AbcGNTHa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 14 Jul 2016 15:07:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, dvyukov@google.com, aryabinin@virtuozzo.com, stable@vger.kernel.org

From: Dmitry Vyukov <dvyukov@google.com>
Subject: vmlinux.lds: account for destructor sections

If CONFIG_KASAN is enabled and gcc is configured with
--disable-initfini-array and/or gold linker is used, gcc emits
.ctors/.dtors and .text.startup/.text.exit sections instead of
.init_array/.fini_array.  .dtors section is not explicitly accounted in
the linker script and messes vvar/percpu layout.  Want:

ffffffff822bfd80 D _edata
ffffffff822c0000 D __vvar_beginning_hack
ffffffff822c0000 A __vvar_page
ffffffff822c0080 0000000000000098 D vsyscall_gtod_data
ffffffff822c1000 A __init_begin
ffffffff822c1000 D init_per_cpu__irq_stack_union
ffffffff822c1000 A __per_cpu_load
ffffffff822d3000 D init_per_cpu__gdt_page

Got:

ffffffff8279a600 D _edata
ffffffff8279b000 A __vvar_page
ffffffff8279c000 A __init_begin
ffffffff8279c000 D init_per_cpu__irq_stack_union
ffffffff8279c000 A __per_cpu_load
ffffffff8279e000 D __vvar_beginning_hack
ffffffff8279e080 0000000000000098 D vsyscall_gtod_data
ffffffff827ae000 D init_per_cpu__gdt_page

This happens because __vvar_page and .vvar get different
addresses in arch/x86/kernel/vmlinux.lds.S:

	. = ALIGN(PAGE_SIZE);
	__vvar_page = .;

	.vvar : AT(ADDR(.vvar) - LOAD_OFFSET) {
		/* work around gold bug 13023 */
		__vvar_beginning_hack = .;

Discard .dtors/.fini_array/.text.exit, since we don't call dtors.
Merge .text.startup into init text.

Link: http://lkml.kernel.org/r/1467386363-120030-1-git-send-email-dvyukov@google.com
Signed-off-by: Dmitry Vyukov <dvyukov@google.com>
Reviewed-by: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: <stable@vger.kernel.org>	[4.0+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/vmlinux.lds.h |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN include/asm-generic/vmlinux.lds.h~vmlinuxlds-account-for-destructor-sections include/asm-generic/vmlinux.lds.h
--- a/include/asm-generic/vmlinux.lds.h~vmlinuxlds-account-for-destructor-sections
+++ a/include/asm-generic/vmlinux.lds.h
@@ -542,15 +542,19 @@
 
 #define INIT_TEXT							\
 	*(.init.text)							\
+	*(.text.startup)						\
 	MEM_DISCARD(init.text)
 
 #define EXIT_DATA							\
 	*(.exit.data)							\
+	*(.fini_array)							\
+	*(.dtors)							\
 	MEM_DISCARD(exit.data)						\
 	MEM_DISCARD(exit.rodata)
 
 #define EXIT_TEXT							\
 	*(.exit.text)							\
+	*(.text.exit)							\
 	MEM_DISCARD(exit.text)
 
 #define EXIT_CALL							\
_
