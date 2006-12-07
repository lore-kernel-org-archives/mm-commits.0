From: akpm@osdl.org
Subject: - kernel-doc-stricter-function-pointer-recognition.patch removed from -mm tree
Date: Thu, 07 Dec 2006 15:07:08 -0800
Message-ID: <200612072307.kB7N78pQ030333@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:52768 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163940AbWLGXH1 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 18:07:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, mm-commits@vger.kernel.org


The patch titled
     kernel-doc: stricter function pointer recognition
has been removed from the -mm tree.  Its filename was
     kernel-doc-stricter-function-pointer-recognition.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: kernel-doc: stricter function pointer recognition
From: Randy Dunlap <randy.dunlap@oracle.com>

Be more careful about function pointer args:
look for "(...*" instead of just "(".

This line in include/linux/input.h fools the current kernel-doc script
into deciding that this is a function pointer:

	unsigned long ffbit[NBITS(FF_MAX)];

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 scripts/kernel-doc |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN scripts/kernel-doc~kernel-doc-stricter-function-pointer-recognition scripts/kernel-doc
--- a/scripts/kernel-doc~kernel-doc-stricter-function-pointer-recognition
+++ a/scripts/kernel-doc
@@ -1430,7 +1430,7 @@ sub create_parameterlist($$$) {
 	    # corresponding data structures "correctly". Catch it later in
 	    # output_* subs.
 	    push_parameter($arg, "", $file);
-	} elsif ($arg =~ m/\(/) {
+	} elsif ($arg =~ m/\(.*\*/) {
 	    # pointer-to-function
 	    $arg =~ tr/#/,/;
 	    $arg =~ m/[^\(]+\(\*([^\)]+)\)/;
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
git-acpi.patch
git-alsa.patch
cpufreq-select-consistently-re-2619-rc5-mm1.patch
git-ieee1394.patch
git-input.patch
git-mtd.patch
mtd-esb2rom-uses-pci.patch
parisc-fix-module_param-iommu-permission.patch
scsi-advansys-wrap-pci-table-inside-ifdef-config_pci.patch
generic-bug-implementation-handle-bug=n.patch
reiser4-use-null-for-pointers.patch
visws-sgivwfb-is-module-needs-exports.patch
linux-fbdev-devel-is-subscribers-only.patch
extend-notifier_call_chain-to-count-nr_calls-made-fixes.patch
kvm-fix-null-and-c99-init-sparse-warnings.patch
profile_likely-export-do_check_likely.patch

