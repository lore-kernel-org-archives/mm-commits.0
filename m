From: akpm@osdl.org
Subject: - fix-section-mismatch-in-parainstructions.patch removed from -mm tree
Date: Wed, 13 Dec 2006 22:01:44 -0800
Message-ID: <200612140601.kBE61ir8001712@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:51491 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751832AbWLNGCF (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 14 Dec 2006 01:02:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, ak@suse.de, rusty@rustcorp.com.au, mm-commits@vger.kernel.org


The patch titled
     Fix section mismatch in parainstructions
has been removed from the -mm tree.  Its filename was
     fix-section-mismatch-in-parainstructions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Fix section mismatch in parainstructions
From: Randy Dunlap <randy.dunlap@oracle.com>

Section .parainstructions should not warn about section mismatches.

WARNING: drivers/net/hamradio/scc.o - Section mismatch: reference to .exit.text: from .parainstructions after '' (at offset 0x0)
WARNING: drivers/net/hamradio/scc.o - Section mismatch: reference to .exit.text: from .parainstructions after '' (at offset 0x8)

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Andi Kleen <ak@suse.de>
Acked-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 scripts/mod/modpost.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN scripts/mod/modpost.c~fix-section-mismatch-in-parainstructions scripts/mod/modpost.c
--- a/scripts/mod/modpost.c~fix-section-mismatch-in-parainstructions
+++ a/scripts/mod/modpost.c
@@ -997,6 +997,7 @@ static int exit_section_ref_ok(const cha
 		"__bug_table", /* used by powerpc for BUG() */
 		".exitcall.exit",
 		".eh_frame",
+		".parainstructions",
 		".stab",
 		"__ex_table",
 		".fixup",
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

git-acpi.patch
git-alsa.patch
cpufreq-select-consistently-re-2619-rc5-mm1.patch
git-mtd.patch
parisc-fix-module_param-iommu-permission.patch
scsi-advansys-wrap-pci-table-inside-ifdef-config_pci.patch
kbuild-make-fusion-mpt-selectable-from-device-drivers.patch
reiser4-use-null-for-pointers.patch
extend-notifier_call_chain-to-count-nr_calls-made-fixes.patch
profile_likely-export-do_check_likely.patch

