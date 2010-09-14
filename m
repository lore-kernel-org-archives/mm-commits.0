From: akpm@linux-foundation.org
Subject: + x86-use-clear_page-copy_page-and-__gfp_zero-in-favor-of-memset-memcpy-on-whole-pages.patch added to -mm tree
Date: Tue, 14 Sep 2010 15:57:21 -0700
Message-ID: <201009142257.o8EMvLME023364@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37228 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755718Ab0INW5j (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 14 Sep 2010 18:57:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: JBeulich@novell.com, hpa@zytor.com, jbeulich@novell.com, mingo@elte.hu, tglx@linutronix.de


The patch titled
     x86: use clear_page(), copy_page() and __GFP_ZERO in favor of memset()/memcpy() on whole pages
has been added to the -mm tree.  Its filename is
     x86-use-clear_page-copy_page-and-__gfp_zero-in-favor-of-memset-memcpy-on-whole-pages.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: x86: use clear_page(), copy_page() and __GFP_ZERO in favor of memset()/memcpy() on whole pages
From: "Jan Beulich" <JBeulich@novell.com>

After all that's what they are intended for.

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/machine_kexec_64.c |    4 ++--
 arch/x86/kvm/lapic.c               |    3 +--
 arch/x86/mm/init_32.c              |    4 ++--
 arch/x86/mm/init_64.c              |    2 +-
 4 files changed, 6 insertions(+), 7 deletions(-)

diff -puN arch/x86/kernel/machine_kexec_64.c~x86-use-clear_page-copy_page-and-__gfp_zero-in-favor-of-memset-memcpy-on-whole-pages arch/x86/kernel/machine_kexec_64.c
--- a/arch/x86/kernel/machine_kexec_64.c~x86-use-clear_page-copy_page-and-__gfp_zero-in-favor-of-memset-memcpy-on-whole-pages
+++ a/arch/x86/kernel/machine_kexec_64.c
@@ -36,7 +36,7 @@ static int init_one_level2_page(struct k
 		if (!page)
 			goto out;
 		pud = (pud_t *)page_address(page);
-		memset(pud, 0, PAGE_SIZE);
+		clear_page(pud);
 		set_pgd(pgd, __pgd(__pa(pud) | _KERNPG_TABLE));
 	}
 	pud = pud_offset(pgd, addr);
@@ -45,7 +45,7 @@ static int init_one_level2_page(struct k
 		if (!page)
 			goto out;
 		pmd = (pmd_t *)page_address(page);
-		memset(pmd, 0, PAGE_SIZE);
+		clear_page(pmd);
 		set_pud(pud, __pud(__pa(pmd) | _KERNPG_TABLE));
 	}
 	pmd = pmd_offset(pud, addr);
diff -puN arch/x86/kvm/lapic.c~x86-use-clear_page-copy_page-and-__gfp_zero-in-favor-of-memset-memcpy-on-whole-pages arch/x86/kvm/lapic.c
--- a/arch/x86/kvm/lapic.c~x86-use-clear_page-copy_page-and-__gfp_zero-in-favor-of-memset-memcpy-on-whole-pages
+++ a/arch/x86/kvm/lapic.c
@@ -1056,14 +1056,13 @@ int kvm_create_lapic(struct kvm_vcpu *vc
 
 	vcpu->arch.apic = apic;
 
-	apic->regs_page = alloc_page(GFP_KERNEL);
+	apic->regs_page = alloc_page(GFP_KERNEL|__GFP_ZERO);
 	if (apic->regs_page == NULL) {
 		printk(KERN_ERR "malloc apic regs error for vcpu %x\n",
 		       vcpu->vcpu_id);
 		goto nomem_free_apic;
 	}
 	apic->regs = page_address(apic->regs_page);
-	memset(apic->regs, 0, PAGE_SIZE);
 	apic->vcpu = vcpu;
 
 	hrtimer_init(&apic->lapic_timer.timer, CLOCK_MONOTONIC,
diff -puN arch/x86/mm/init_32.c~x86-use-clear_page-copy_page-and-__gfp_zero-in-favor-of-memset-memcpy-on-whole-pages arch/x86/mm/init_32.c
--- a/arch/x86/mm/init_32.c~x86-use-clear_page-copy_page-and-__gfp_zero-in-favor-of-memset-memcpy-on-whole-pages
+++ a/arch/x86/mm/init_32.c
@@ -67,7 +67,7 @@ static __init void *alloc_low_page(void)
 		panic("alloc_low_page: ran out of memory");
 
 	adr = __va(pfn * PAGE_SIZE);
-	memset(adr, 0, PAGE_SIZE);
+	clear_page(adr);
 	return adr;
 }
 
@@ -558,7 +558,7 @@ char swsusp_pg_dir[PAGE_SIZE]
 
 static inline void save_pg_dir(void)
 {
-	memcpy(swsusp_pg_dir, swapper_pg_dir, PAGE_SIZE);
+	copy_page(swsusp_pg_dir, swapper_pg_dir);
 }
 #else /* !CONFIG_ACPI_SLEEP */
 static inline void save_pg_dir(void)
diff -puN arch/x86/mm/init_64.c~x86-use-clear_page-copy_page-and-__gfp_zero-in-favor-of-memset-memcpy-on-whole-pages arch/x86/mm/init_64.c
--- a/arch/x86/mm/init_64.c~x86-use-clear_page-copy_page-and-__gfp_zero-in-favor-of-memset-memcpy-on-whole-pages
+++ a/arch/x86/mm/init_64.c
@@ -323,7 +323,7 @@ static __ref void *alloc_low_page(unsign
 		panic("alloc_low_page: ran out of memory");
 
 	adr = early_memremap(pfn * PAGE_SIZE, PAGE_SIZE);
-	memset(adr, 0, PAGE_SIZE);
+	clear_page(adr);
 	*phys  = pfn * PAGE_SIZE;
 	return adr;
 }
_

Patches currently in -mm which might be from JBeulich@novell.com are

linux-next.patch
x86-use-clear_page-copy_page-and-__gfp_zero-in-favor-of-memset-memcpy-on-whole-pages.patch
modules-no-need-to-align-modinfo-strings.patch

