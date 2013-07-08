From: akpm@linux-foundation.org
Subject: [merged]
 avr32-normalize-global-variables-exported-by-vmlinuxlds.patch removed from
 -mm tree
Date: Mon, 08 Jul 2013 12:26:36 -0700
Message-ID: <51db126c.Msra48NCf0vLuROo%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50820 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752987Ab3GHT0h (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Jul 2013 15:26:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, jiang.liu@huawei.com, hskinnemoen@gmail.com, egtvedt@samfundet.no, liuj97@gmail.com

Subject: [merged] avr32-normalize-global-variables-exported-by-vmlinuxlds.patch removed from -mm tree
To: liuj97@gmail.com,egtvedt@samfundet.no,hskinnemoen@gmail.com,jiang.liu@huawei.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 08 Jul 2013 12:26:36 -0700


The patch titled
     Subject: avr32: normalize global variables exported by vmlinux.lds
has been removed from the -mm tree.  Its filename was
     avr32-normalize-global-variables-exported-by-vmlinuxlds.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jiang Liu <liuj97@gmail.com>
Subject: avr32: normalize global variables exported by vmlinux.lds

Normalize global variables exported by vmlinux.lds to conform usage
guidelines from include/asm-generic/sections.h.

Use _text to mark the start of the kernel image including the head text,
and _stext to mark the start of the .text section.

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Acked-by: Hans-Christian Egtvedt <egtvedt@samfundet.no>
Cc: Haavard Skinnemoen <hskinnemoen@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/avr32/kernel/setup.c       |    2 +-
 arch/avr32/kernel/vmlinux.lds.S |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff -puN arch/avr32/kernel/setup.c~avr32-normalize-global-variables-exported-by-vmlinuxlds arch/avr32/kernel/setup.c
--- a/arch/avr32/kernel/setup.c~avr32-normalize-global-variables-exported-by-vmlinuxlds
+++ a/arch/avr32/kernel/setup.c
@@ -555,7 +555,7 @@ void __init setup_arch (char **cmdline_p
 {
 	struct clk *cpu_clk;
 
-	init_mm.start_code = (unsigned long)_text;
+	init_mm.start_code = (unsigned long)_stext;
 	init_mm.end_code = (unsigned long)_etext;
 	init_mm.end_data = (unsigned long)_edata;
 	init_mm.brk = (unsigned long)_end;
diff -puN arch/avr32/kernel/vmlinux.lds.S~avr32-normalize-global-variables-exported-by-vmlinuxlds arch/avr32/kernel/vmlinux.lds.S
--- a/arch/avr32/kernel/vmlinux.lds.S~avr32-normalize-global-variables-exported-by-vmlinuxlds
+++ a/arch/avr32/kernel/vmlinux.lds.S
@@ -23,7 +23,7 @@ SECTIONS
 {
 	. = CONFIG_ENTRY_ADDRESS;
 	.init		: AT(ADDR(.init) - LOAD_OFFSET) {
-		_stext = .;
+		_text = .;
 		__init_begin = .;
 			_sinittext = .;
 			*(.text.reset)
@@ -46,7 +46,7 @@ SECTIONS
 
 	.text		: AT(ADDR(.text) - LOAD_OFFSET) {
 		_evba = .;
-		_text = .;
+		_stext = .;
 		*(.ex.text)
 		*(.irq.text)
 		KPROBES_TEXT
_

Patches currently in -mm which might be from liuj97@gmail.com are

origin.patch
linux-next.patch

