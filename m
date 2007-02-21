From: akpm@linux-foundation.org
Subject: - kernel-doc-include-struct-short-description-in-title.patch removed from -mm tree
Date: Wed, 21 Feb 2007 02:45:52 -0800
Message-ID: <200702211045.l1LAjqLw006404@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:46934 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932503AbXBUKqZ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 21 Feb 2007 05:46:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, johannes@sipsolutions.net, mm-commits@vger.kernel.org


The patch titled
     kernel-doc: include struct short description in title output
has been removed from the -mm tree.  Its filename was
     kernel-doc-include-struct-short-description-in-title.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
 1 file changed, 2 insertions(+), 2 deletions(-)

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

git-drm.patch
git-libata-all.patch
phy-layer-add-kernel-doc-docbook.patch
git-parisc.patch
x86-dont-probe-for-ddc-on-vbe12.patch
extend-notifier_call_chain-to-count-nr_calls-made-fixes.patch
reiser4-use-null-for-pointers.patch
profile_likely-export-do_check_likely.patch
