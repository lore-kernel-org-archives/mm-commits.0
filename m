From: akpm@linux-foundation.org
Subject: [merged] arch-x86-replace-strict_strto-calls.patch removed from
 -mm tree
Date: Tue, 12 Aug 2014 12:42:12 -0700
Message-ID: <53ea6e14.70zmTcKEv52OyoMk%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-pa0-f73.google.com ([209.85.220.73]:63157 "EHLO
	mail-pa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753505AbaHLTmN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 12 Aug 2014 15:42:13 -0400
Received: by mail-pa0-f73.google.com with SMTP id kx10so2666702pab.4
        for <mm-commits@vger.kernel.org>; Tue, 12 Aug 2014 12:42:12 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dwalter@google.com, bp@suse.de, hpa@zytor.com, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: arch/x86: replace strict_strto calls
has been removed from the -mm tree.  Its filename was
     arch-x86-replace-strict_strto-calls.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
linux-next.patch
include-linux-remove-strict_strto-definitions.patch

