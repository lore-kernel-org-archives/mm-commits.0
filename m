From: akpm@linux-foundation.org
Subject: + kernel-doc-include-struct-short-description-in-title.patch added to -mm tree
Date: Wed, 14 Feb 2007 14:27:47 -0800
Message-ID: <200702142227.l1EMRl8g011211@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:48960 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932607AbXBNW1z (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 14 Feb 2007 17:27:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, johannes@sipsolutions.net


The patch titled
     kernel-doc: include struct short description in title output
has been added to the -mm tree.  Its filename is
     kernel-doc-include-struct-short-description-in-title.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: kernel-doc: include struct short description in title output
From: Randy Dunlap <randy.dunlap@oracle.com>

Output of a function or struct in html mode needs to include the short
description from the function/struct name line in the output title line.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Acked-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/kernel-doc |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff -puN scripts/kernel-doc~kernel-doc-include-struct-short-description-in-title scripts/kernel-doc
--- a/scripts/kernel-doc~kernel-doc-include-struct-short-description-in-title
+++ a/scripts/kernel-doc
@@ -452,7 +452,7 @@ sub output_struct_html(%) {
     my %args = %{$_[0]};
     my ($parameter);
 
-    print "<h2>".$args{'type'}." ".$args{'struct'}."</h2>\n";
+    print "<h2>".$args{'type'}." ".$args{'struct'}. " - " .$args{'purpose'}."</h2>\n";
     print "<b>".$args{'type'}." ".$args{'struct'}."</b> {<br>\n";
     foreach $parameter (@{$args{'parameterlist'}}) {
 	if ($parameter =~ /^#/) {
@@ -498,8 +498,8 @@ sub output_function_html(%) {
     my %args = %{$_[0]};
     my ($parameter, $section);
     my $count;
-    print "<h2>Function</h2>\n";
 
+    print "<h2>" .$args{'function'}." - ".$args{'purpose'}."</h2>\n";
     print "<i>".$args{'functiontype'}."</i>\n";
     print "<b>".$args{'function'}."</b>\n";
     print "(";
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
qconf-immediately-update-integer-and-string-values-in-xconfig-display-take-2.patch
git-drm.patch
git-netdev-all.patch
phy-layer-add-kernel-doc-docbook.patch
parisc-fix-module_param-iommu-permission.patch
pci-sysfs-kobject-kernel-doc-fixes.patch
ueagle-atmc-needs-schedh.patch
kernel-doc-include-struct-short-description-in-title.patch
irq-kernel-doc-fixes.patch
extend-notifier_call_chain-to-count-nr_calls-made-fixes.patch
reiser4-use-null-for-pointers.patch
profile_likely-export-do_check_likely.patch
