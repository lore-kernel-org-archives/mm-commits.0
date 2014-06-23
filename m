From: akpm@linux-foundation.org
Subject: + arch-x86-replace-strict_strto-calls.patch added to -mm tree
Date: Mon, 23 Jun 2014 16:29:49 -0700
Message-ID: <53a8b86d.v2+hlLVa1GQiBWYj%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53957 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752793AbaFWX3u (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 Jun 2014 19:29:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dwalter@google.com, bp@suse.de, hpa@zytor.com, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: arch/x86: replace strict_strto calls
has been added to the -mm tree.  Its filename is
     arch-x86-replace-strict_strto-calls.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/arch-x86-replace-strict_strto-calls.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/arch-x86-replace-strict_strto-calls.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Daniel Walter <dwalter@google.com>
Subject: arch/x86: replace strict_strto calls

Replace obsolete strict_strto calls with appropriate kstrto calls

Signed-off-by: Daniel Walter <dwalter@google.com>
Acked-by: Borislav Petkov <bp@suse.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/cpu/intel_cacheinfo.c |    4 ++--
 arch/x86/kernel/cpu/mcheck/mce.c      |    6 +++---
 arch/x86/kernel/cpu/mcheck/mce_amd.c  |    4 ++--
 arch/x86/kvm/mmu_audit.c              |    2 +-
 arch/x86/platform/uv/tlb_uv.c         |    2 +-
 5 files changed, 9 insertions(+), 9 deletions(-)

diff -puN arch/x86/kernel/cpu/intel_cacheinfo.c~arch-x86-replace-strict_strto-calls arch/x86/kernel/cpu/intel_cacheinfo.c
--- a/arch/x86/kernel/cpu/intel_cacheinfo.c~arch-x86-replace-strict_strto-calls
+++ a/arch/x86/kernel/cpu/intel_cacheinfo.c
@@ -461,7 +461,7 @@ static ssize_t store_cache_disable(struc
 
 	cpu = cpumask_first(to_cpumask(this_leaf->shared_cpu_map));
 
-	if (strict_strtoul(buf, 10, &val) < 0)
+	if (kstrtoul(buf, 10, &val) < 0)
 		return -EINVAL;
 
 	err = amd_set_l3_disable_slot(this_leaf->base.nb, cpu, slot, val);
@@ -511,7 +511,7 @@ store_subcaches(struct _cpuid4_info *thi
 	if (!this_leaf->base.nb || !amd_nb_has_feature(AMD_NB_L3_PARTITIONING))
 		return -EINVAL;
 
-	if (strict_strtoul(buf, 16, &val) < 0)
+	if (kstrtoul(buf, 16, &val) < 0)
 		return -EINVAL;
 
 	if (amd_set_subcaches(cpu, val))
diff -puN arch/x86/kernel/cpu/mcheck/mce.c~arch-x86-replace-strict_strto-calls arch/x86/kernel/cpu/mcheck/mce.c
--- a/arch/x86/kernel/cpu/mcheck/mce.c~arch-x86-replace-strict_strto-calls
+++ a/arch/x86/kernel/cpu/mcheck/mce.c
@@ -2136,7 +2136,7 @@ static ssize_t set_bank(struct device *s
 {
 	u64 new;
 
-	if (strict_strtoull(buf, 0, &new) < 0)
+	if (kstrtou64(buf, 0, &new) < 0)
 		return -EINVAL;
 
 	attr_to_bank(attr)->ctl = new;
@@ -2174,7 +2174,7 @@ static ssize_t set_ignore_ce(struct devi
 {
 	u64 new;
 
-	if (strict_strtoull(buf, 0, &new) < 0)
+	if (kstrtou64(buf, 0, &new) < 0)
 		return -EINVAL;
 
 	if (mca_cfg.ignore_ce ^ !!new) {
@@ -2198,7 +2198,7 @@ static ssize_t set_cmci_disabled(struct
 {
 	u64 new;
 
-	if (strict_strtoull(buf, 0, &new) < 0)
+	if (kstrtou64(buf, 0, &new) < 0)
 		return -EINVAL;
 
 	if (mca_cfg.cmci_disabled ^ !!new) {
diff -puN arch/x86/kernel/cpu/mcheck/mce_amd.c~arch-x86-replace-strict_strto-calls arch/x86/kernel/cpu/mcheck/mce_amd.c
--- a/arch/x86/kernel/cpu/mcheck/mce_amd.c~arch-x86-replace-strict_strto-calls
+++ a/arch/x86/kernel/cpu/mcheck/mce_amd.c
@@ -353,7 +353,7 @@ store_interrupt_enable(struct threshold_
 	if (!b->interrupt_capable)
 		return -EINVAL;
 
-	if (strict_strtoul(buf, 0, &new) < 0)
+	if (kstrtoul(buf, 0, &new) < 0)
 		return -EINVAL;
 
 	b->interrupt_enable = !!new;
@@ -372,7 +372,7 @@ store_threshold_limit(struct threshold_b
 	struct thresh_restart tr;
 	unsigned long new;
 
-	if (strict_strtoul(buf, 0, &new) < 0)
+	if (kstrtoul(buf, 0, &new) < 0)
 		return -EINVAL;
 
 	if (new > THRESHOLD_MAX)
diff -puN arch/x86/kvm/mmu_audit.c~arch-x86-replace-strict_strto-calls arch/x86/kvm/mmu_audit.c
--- a/arch/x86/kvm/mmu_audit.c~arch-x86-replace-strict_strto-calls
+++ a/arch/x86/kvm/mmu_audit.c
@@ -273,7 +273,7 @@ static int mmu_audit_set(const char *val
 	int ret;
 	unsigned long enable;
 
-	ret = strict_strtoul(val, 10, &enable);
+	ret = kstrtoul(val, 10, &enable);
 	if (ret < 0)
 		return -EINVAL;
 
diff -puN arch/x86/platform/uv/tlb_uv.c~arch-x86-replace-strict_strto-calls arch/x86/platform/uv/tlb_uv.c
--- a/arch/x86/platform/uv/tlb_uv.c~arch-x86-replace-strict_strto-calls
+++ a/arch/x86/platform/uv/tlb_uv.c
@@ -1479,7 +1479,7 @@ static ssize_t ptc_proc_write(struct fil
 		return count;
 	}
 
-	if (strict_strtol(optstr, 10, &input_arg) < 0) {
+	if (kstrtol(optstr, 10, &input_arg) < 0) {
 		printk(KERN_DEBUG "%s is invalid\n", optstr);
 		return -EINVAL;
 	}
_

Patches currently in -mm which might be from dwalter@google.com are

arch-arm-mach-omap2-replace-strict_strto-with-kstrto.patch
arch-arm-mach-pxa-replace-strict_strto-call-with-kstrto.patch
arch-arm-mach-s3c24xx-mach-jivec-replace-strict_strto-with-kstrto.patch
arch-arm-mach-w90x900-cpuc-replace-obsolete-strict_strto.patch
arch-powerpc-replace-obsolete-strict_strto-calls.patch
arch-x86-replace-strict_strto-calls.patch
drivers-scsi-replace-strict_strto-calls.patch
net-sunrpc-replace-strict_strto-calls.patch
include-linux-remove-strict_strto-definitions.patch

