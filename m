From: akpm@osdl.org
Subject: + parse-boot-parameter-error.patch added to -mm tree
Date: Wed, 13 Dec 2006 13:04:45 -0800
Message-ID: <200612132104.kBDL4jI5019979@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:41521 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750934AbWLMVEt (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Dec 2006 16:04:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: shaohua.li@intel.com


The patch titled
     Parse boot parameter error
has been added to the -mm tree.  Its filename is
     parse-boot-parameter-error.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Parse boot parameter error
From: Shaohua Li <shaohua.li@intel.com>

Say a boot parameter is "xxx", if you give a string "xxxy", then the
boot parameter's corresponding function is executed.


Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 init/main.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletion(-)

diff -puN init/main.c~parse-boot-parameter-error init/main.c
--- a/init/main.c~parse-boot-parameter-error
+++ a/init/main.c
@@ -185,7 +185,8 @@ static int __init obsolete_checksetup(ch
 	p = __setup_start;
 	do {
 		int n = strlen(p->str);
-		if (!strncmp(line, p->str, n)) {
+		if (((!strncmp(line, p->str, n)) && (p->str[n-1] == '='))
+				|| !strcmp(line, p->str)) {
 			if (p->early) {
 				/* Already done in parse_early_param?
 				 * (Needs exact match on param part).
_

Patches currently in -mm which might be from shaohua.li@intel.com are

origin.patch
git-acpi.patch
acpi-disable-irq-balance-even-in-apic-mode.patch
acpi-dont-enable-link-device-in-ioapic-mode.patch
revert-x86_64-mm-add-genapic_force.patch
revert-x86_64-mm-fix-the-irqbalance-quirk-for-e7320-e7520-e7525.patch
genapic-optimize-fix-apic-mode-setup-2.patch
genapic-always-use-physical-delivery-mode-on-8-cpus.patch
genapic-remove-es7000-workaround.patch
genapic-remove-clustered-apic-mode.patch
genapic-default-to-physical-mode-on-hotplug-cpu-kernels.patch
parse-boot-parameter-error.patch

