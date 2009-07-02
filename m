From: akpm@linux-foundation.org
Subject: [merged] kernel-doc-move-ignoring-kmemcheck.patch removed from -mm tree
Date: Thu, 02 Jul 2009 11:33:19 -0700
Message-ID: <200907021833.n62IXJ0b017935@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56302 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751707AbZGBSde (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 2 Jul 2009 14:33:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, sam@ravnborg.org, mm-commits@vger.kernel.org


The patch titled
     kernel-doc: move ignoring kmemcheck
has been removed from the -mm tree.  Its filename was
     kernel-doc-move-ignoring-kmemcheck.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kernel-doc: move ignoring kmemcheck
From: Randy Dunlap <randy.dunlap@oracle.com>

Somehow I managed to generate a diff that put these 2 lines into the wrong
function: should have been in dump_struct() instead of in dump_enum().

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/kernel-doc |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN scripts/kernel-doc~kernel-doc-move-ignoring-kmemcheck scripts/kernel-doc
--- a/scripts/kernel-doc~kernel-doc-move-ignoring-kmemcheck
+++ a/scripts/kernel-doc
@@ -1426,6 +1426,8 @@ sub dump_struct($$) {
 	# strip comments:
 	$members =~ s/\/\*.*?\*\///gos;
 	$nested =~ s/\/\*.*?\*\///gos;
+	# strip kmemcheck_bitfield_{begin,end}.*;
+	$members =~ s/kmemcheck_bitfield_.*?;//gos;
 
 	create_parameterlist($members, ';', $file);
 	check_sections($file, $declaration_name, "struct", $sectcheck, $struct_actual, $nested);
@@ -1468,8 +1470,6 @@ sub dump_enum($$) {
 	    }
 
 	}
-	# strip kmemcheck_bitfield_{begin,end}.*;
-	$members =~ s/kmemcheck_bitfield_.*?;//gos;
 
 	output_declaration($declaration_name,
 			   'enum',
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
linux-next.patch
input-drivers-input-xpadc-improve-xbox-360-wireless-support-and-add-sysfs-interface.patch
kernel-hacking-move-strip_asm_syms-from-general.patch
mm-make-swap-token-dummies-static-inlines-fix-2.patch
readahead-add-blk_run_backing_dev-fix-fix-2.patch
page_alloc-fix-kernel-doc-warning.patch
lis3-add-power-management-functions-fix.patch
reiser4-export-remove_from_page_cache-fix.patch

