From: akpm@linux-foundation.org
Subject: + kernel-doc-move-ignoring-kmemcheck.patch added to -mm tree
Date: Mon, 29 Jun 2009 15:33:50 -0700
Message-ID: <200906292233.n5TMXo4r013082@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39061 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752298AbZF2Wd4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 29 Jun 2009 18:33:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, sam@ravnborg.org


The patch titled
     kernel-doc: move ignoring kmemcheck
has been added to the -mm tree.  Its filename is
     kernel-doc-move-ignoring-kmemcheck.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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
kernel-doc-move-ignoring-kmemcheck.patch
mm-make-swap-token-dummies-static-inlines-fix-2.patch
readahead-add-blk_run_backing_dev-fix-fix-2.patch
page_alloc-fix-kernel-doc-warning.patch
reiser4-export-remove_from_page_cache-fix.patch

