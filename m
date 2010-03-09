From: akpm@linux-foundation.org
Subject: + scripts-kernel-doc-fix-empty-function-description-section.patch added to -mm tree
Date: Tue, 09 Mar 2010 11:47:59 -0800
Message-ID: <201003091947.o29JlxVh001284@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39153 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752058Ab0CITsF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Mar 2010 14:48:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com


The patch titled
     scripts/kernel-doc: fix empty function description section
has been added to the -mm tree.  Its filename is
     scripts-kernel-doc-fix-empty-function-description-section.patch

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

linux-next.patch
xfs-needs-list_sort.patch
vmwgfx-depends-on-fb.patch
dib3000mc-reduce-large-stack-usage.patch
dib7000p-reduce-large-stack-usage.patch
documentation-timers-split-txt-and-source-files.patch
documentation-laptop-split-txt-and-source-files.patch
documentation-fs-split-txt-and-source-files.patch
documentation-vm-split-txt-and-source-files.patch
doc-submitchecklist-add-rule-1.patch
scripts-kernel-doc-fix-empty-function-description-section.patch
cgroups-subsystem-module-unloading-fix.patch
memcg-move-charges-of-anonymous-swap-fix.patch
memcg-improve-performance-in-moving-swap-charge-fix.patch
cgroup-implement-eventfd-based-generic-api-for-notifications-kconfig-fix.patch
dma-mappingh-add-the-dma_unmap-state-api-fix-2.patch
reiser4-export-remove_from_page_cache-fix.patch
mutex-subsystem-synchro-test-module-add-missing-header-file.patch

