From: akpm@linux-foundation.org
Subject: + kernel-doc-fix-leading-dot-in-man-mode-output.patch added to -mm tree
Date: Thu, 24 May 2007 15:19:03 -0700
Message-ID: <200705242219.l4OMJ3H9004691@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:45929 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752278AbXEXWTk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 May 2007 18:19:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com


The patch titled
     kernel-doc: fix leading dot in man-mode output
has been added to the -mm tree.  Its filename is
     kernel-doc-fix-leading-dot-in-man-mode-output.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: kernel-doc: fix leading dot in man-mode output
From: Randy Dunlap <randy.dunlap@oracle.com>

If a parameter description begins with a '.', this indicates a "request"
for "man" mode output (*roff), so it needs special handling.

Problem case is in include/asm-i386/atomic.h for function
atomic_add_unless():
 * @u: ...unless v is equal to u.
This parameter description is currently not printed in man mode output.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/kernel-doc |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletion(-)

diff -puN scripts/kernel-doc~kernel-doc-fix-leading-dot-in-man-mode-output scripts/kernel-doc
--- a/scripts/kernel-doc~kernel-doc-fix-leading-dot-in-man-mode-output
+++ a/scripts/kernel-doc
@@ -404,7 +404,12 @@ sub output_highlight {
 	    print $lineprefix, $blankline;
 	} else {
 	    $line =~ s/\\\\\\/\&/g;
-	    print $lineprefix, $line;
+	    if ($output_mode eq "man" && substr($line, 0, 1) eq ".") {
+		print "\\&$line";
+	    }
+	    else {
+		print $lineprefix, $line;
+	    }
 	}
 	print "\n";
     }
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

documentation-fix-the-explanation-of-kconfig-files.patch
update-dontdiff-file.patch
doc-clocksources.patch
mm-merge-populate-and-nopage-into-fault-fixes-nonlinear.patch
romfs-printk-format-warnings.patch
add-pci_try_set_mwi.patch
git-unionfs.patch
add-pci_try_set_mwi-prism54pci.patch
git-ipwireless_cs.patch
doc-kernel-parameters-use-x86-32-tag-instead-of-ia-32.patch
add-argv_split-fix.patch
add-common-orderly_poweroff-fix.patch
add-notime-boot-option.patch
kernel-doc-add-tools-doc-in-makefile.patch
kernel-doc-fix-unnamed-struct-union-warning.patch
kernel-doc-strip-c99-comments.patch
kernel-doc-fix-leading-dot-in-man-mode-output.patch
kernel-doc-fix-leading-dot-in-man-mode-output-fix.patch
profile-likely-unlikely-macros.patch
