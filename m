From: akpm@osdl.org
Subject: + x86-smp-export-smp_num_siblings-for-oprofile.patch added to -mm tree
Date: Sat, 09 Dec 2006 00:51:19 -0800
Message-ID: <200612090851.kB98pJiK021595@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:57256 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936410AbWLIIvY (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sat, 9 Dec 2006 03:51:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com


The patch titled
     x86 smp: export smp_num_siblings for oprofile
has been added to the -mm tree.  Its filename is
     x86-smp-export-smp_num_siblings-for-oprofile.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: x86 smp: export smp_num_siblings for oprofile
From: Randy Dunlap <randy.dunlap@oracle.com>

oprofile uses smp_num_siblings without testing for CONFIG_X86_HT.  I looked at
modifying oprofile, but this way is cleaner & simpler.

WARNING: "smp_num_siblings" [arch/i386/oprofile/oprofile.ko] undefined!

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/i386/kernel/smpboot.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN arch/i386/kernel/smpboot.c~x86-smp-export-smp_num_siblings-for-oprofile arch/i386/kernel/smpboot.c
--- a/arch/i386/kernel/smpboot.c~x86-smp-export-smp_num_siblings-for-oprofile
+++ a/arch/i386/kernel/smpboot.c
@@ -69,9 +69,7 @@ static int __devinitdata smp_b_stepping;
 
 /* Number of siblings per CPU package */
 int smp_num_siblings = 1;
-#ifdef CONFIG_X86_HT
 EXPORT_SYMBOL(smp_num_siblings);
-#endif
 
 /* Last level cache ID of each logical CPU */
 int cpu_llc_id[NR_CPUS] __cpuinitdata = {[0 ... NR_CPUS-1] = BAD_APICID};
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
x86-smp-export-smp_num_siblings-for-oprofile.patch
ucb1400_ts-depends-snd_ac97_bus.patch
ipc-procfs-sysctl-mixups.patch
git-acpi.patch
git-alsa.patch
cpufreq-select-consistently-re-2619-rc5-mm1.patch
git-mtd.patch
mtd-esb2rom-uses-pci.patch
parisc-fix-module_param-iommu-permission.patch
scsi-advansys-wrap-pci-table-inside-ifdef-config_pci.patch
codingstyle-updates.patch
freezerh-uses-task_struct-fields.patch
geode-crypto-is-pci-device.patch
ipmi-remove-zero-inits.patch
reiser4-use-null-for-pointers.patch
extend-notifier_call_chain-to-count-nr_calls-made-fixes.patch
kvm-fix-null-and-c99-init-sparse-warnings.patch
profile_likely-export-do_check_likely.patch

