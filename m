From: akpm@osdl.org
Subject: + kernel-doc-allow-unnamed-structs-unions.patch added to -mm tree
Date: Wed, 20 Dec 2006 20:43:00 -0800
Message-ID: <200612210443.kBL4h0LV015788@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:37397 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422695AbWLUEnG (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 20 Dec 2006 23:43:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com


The patch titled
     kernel-doc: allow unnamed structs/unions
has been added to the -mm tree.  Its filename is
     kernel-doc-allow-unnamed-structs-unions.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: kernel-doc: allow unnamed structs/unions
From: Randy Dunlap <randy.dunlap@oracle.com>

Make kernel-doc support unnamed (anonymous) structs and unions.  There is
one (union) in include/linux/skbuff.h (inside struct sk_buff) that is
currently generating a kernel-doc warning, so this fixes that warning.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 scripts/kernel-doc |   17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff -puN scripts/kernel-doc~kernel-doc-allow-unnamed-structs-unions scripts/kernel-doc
--- a/scripts/kernel-doc~kernel-doc-allow-unnamed-structs-unions
+++ a/scripts/kernel-doc
@@ -1469,6 +1469,7 @@ sub push_parameter($$$) {
 	my $param = shift;
 	my $type = shift;
 	my $file = shift;
+	my $anon = 0;
 
 	my $param_name = $param;
 	$param_name =~ s/\[.*//;
@@ -1484,9 +1485,20 @@ sub push_parameter($$$) {
 	    $param="void";
 	    $parameterdescs{void} = "no arguments";
 	}
+	elsif ($type eq "" && ($param eq "struct" or $param eq "union"))
+	# handle unnamed (anonymous) union or struct:
+	{
+		$type = $param;
+		$param = "{unnamed_" . $param. "}";
+		$parameterdescs{$param} = "anonymous\n";
+		$anon = 1;
+	}
+
 	# warn if parameter has no description
-	# (but ignore ones starting with # as these are no parameters
-	# but inline preprocessor statements
+	# (but ignore ones starting with # as these are not parameters
+	# but inline preprocessor statements);
+	# also ignore unnamed structs/unions;
+	if (!$anon) {
 	if (!defined $parameterdescs{$param_name} && $param_name !~ /^#/) {
 
 	    $parameterdescs{$param_name} = $undescribed;
@@ -1500,6 +1512,7 @@ sub push_parameter($$$) {
 	                 " No description found for parameter '$param'\n";
 	    ++$warnings;
         }
+        }
 
 	push @parameterlist, $param;
 	$parametertypes{$param} = $type;
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

fix-kernel-doc-warnings-in-2620-rc1.patch
add-a-new-section-to-codingstyle-promoting-include-linux-kernelh.patch
handle-slob-with-sparsemen.patch
kernel-doc-allow-unnamed-structs-unions.patch
git-acpi.patch
git-alsa.patch
cpufreq-select-consistently-re-2619-rc5-mm1.patch
git-gfs2-nmw.patch
git-mtd.patch
parisc-fix-module_param-iommu-permission.patch
scsi-advansys-wrap-pci-table-inside-ifdef-config_pci.patch
reiser4-use-null-for-pointers.patch
extend-notifier_call_chain-to-count-nr_calls-made-fixes.patch
profile_likely-export-do_check_likely.patch

