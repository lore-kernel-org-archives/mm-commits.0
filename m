From: akpm@linux-foundation.org
Subject: [merged] scripts-kernel-doc-fix-empty-function-description-section.patch removed from -mm tree
Date: Sun, 14 Mar 2010 23:58:01 -0400
Message-ID: <201003150658.o2F6wZb0016463@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58109 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935700Ab0COG6k (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Mar 2010 02:58:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, mm-commits@vger.kernel.org


The patch titled
     scripts/kernel-doc: fix empty function description section
has been removed from the -mm tree.  Its filename was
     scripts-kernel-doc-fix-empty-function-description-section.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: scripts/kernel-doc: fix empty function description section
From: Randy Dunlap <randy.dunlap@oracle.com>

scripts/kernel-doc mishandles a function that has a multi-line function
short description and no function parameters.  The observed problem was
from drivers/scsi/scsi_netlink.c:

/**
 * scsi_netlink_init - Called by SCSI subsystem to intialize
 * 	the SCSI transport netlink interface
 *
 **/

kernel-doc treated the " * " line as a Description: section with only a
newline character in the Description contents.  This caused
output_highlight() to complain: "output_highlight got called with no
args?", plus produce a perl call stack backtrace.

The fix is just to ignore Description sections if they only contain "\n".

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/kernel-doc |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN scripts/kernel-doc~scripts-kernel-doc-fix-empty-function-description-section scripts/kernel-doc
--- a/scripts/kernel-doc~scripts-kernel-doc-fix-empty-function-description-section
+++ a/scripts/kernel-doc
@@ -2103,7 +2103,7 @@ sub process_file($) {
 		$section = $newsection;
 	    } elsif (/$doc_end/) {
 
-		if ($contents ne "") {
+		if (($contents ne "") && ($contents ne "\n")) {
 		    dump_section($file, $section, xml_escape($contents));
 		    $section = $section_default;
 		    $contents = "";
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
linux-next.patch
vmwgfx-depends-on-fb.patch
dib3000mc-reduce-large-stack-usage.patch
dib7000p-reduce-large-stack-usage.patch
reiser4-export-remove_from_page_cache-fix.patch
mutex-subsystem-synchro-test-module-add-missing-header-file.patch

