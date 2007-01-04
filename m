From: akpm@osdl.org
Subject: - fix-implicit-declarations-in-i386-processc.patch removed from -mm tree
Date: Thu, 04 Jan 2007 15:13:28 -0800
Message-ID: <200701042313.l04NDSnL002097@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:35042 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030259AbXADXNj (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 4 Jan 2007 18:13:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: davej@redhat.com, ak@suse.de, mm-commits@vger.kernel.org


The patch titled
     Fix implicit declarations in i386 process.c
has been removed from the -mm tree.  Its filename was
     fix-implicit-declarations-in-i386-processc.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: Fix implicit declarations in i386 process.c
From: Dave Jones <davej@redhat.com>

Building the kernel with -Werror-implicit fails pretty fast with this..

arch/i386/kernel/process.c: In function '__switch_to':
arch/i386/kernel/process.c:645: error: implicit declaration of function 'load_user_cs_desc'
arch/i386/kernel/process.c: In function 'arch_add_exec_range':
arch/i386/kernel/process.c:915: error: implicit declaration of function 'set_user_cs'

Signed-off-by: Dave Jones <davej@redhat.com>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 include/asm-i386/desc.h |   14 ++++++++++++++
 1 files changed, 14 insertions(+)

diff -puN include/asm-i386/desc.h~fix-implicit-declarations-in-i386-processc include/asm-i386/desc.h
--- a/include/asm-i386/desc.h~fix-implicit-declarations-in-i386-processc
+++ a/include/asm-i386/desc.h
@@ -185,6 +185,20 @@ static inline unsigned long get_desc_bas
 	return base;
 }
 
+static inline void set_user_cs(struct desc_struct *desc, unsigned long limit)
+{
+	limit = (limit - 1) / PAGE_SIZE;
+	desc->a = limit & 0xffff;
+	desc->b = (limit & 0xf0000) | 0x00c0fb00;
+}
+
+#define load_user_cs_desc(cpu, mm) \
+	get_cpu_gdt_table(cpu)[GDT_ENTRY_DEFAULT_USER_CS] = (mm)->context.user_cs
+
+extern void arch_add_exec_range(struct mm_struct *mm, unsigned long limit);
+extern void arch_remove_exec_range(struct mm_struct *mm, unsigned long limit);
+extern void arch_flush_exec_range(struct mm_struct *mm);
+
 #else /* __ASSEMBLY__ */
 
 /*
_

Patches currently in -mm which might be from davej@redhat.com are

fix-implicit-declarations-in-via-pmu.patch
git-agpgart.patch
git-cpufreq.patch
remove-hotplug-cpu-crap-from-cpufreq.patch
fix-implicit-declarations-in-i386-processc.patch
