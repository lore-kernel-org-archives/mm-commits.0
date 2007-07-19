From: akpm@linux-foundation.org
Subject: - kernel-doc-fix-leading-dot-in-man-mode-output.patch removed from -mm tree
Date: Thu, 19 Jul 2007 13:02:08 -0700
Message-ID: <200707192002.l6JK28vK019629@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33671 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761640AbXGSUQk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 16:16:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, mm-commits@vger.kernel.org


The patch titled
     kernel-doc: fix leading dot in man-mode output
has been removed from the -mm tree.  Its filename was
     kernel-doc-fix-leading-dot-in-man-mode-output.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: kernel-doc: fix leading dot in man-mode output
From: Randy Dunlap <randy.dunlap@oracle.com>

If a parameter description begins with a '.', this indicates a "request"
for "man" mode output (*roff), so it needs special handling.

Problem case is in include/asm-i386/atomic.h for function
atomic_add_unless():
 * @u: ...unless v is equal to u.
This parameter description is currently not printed in man mode output.

[akpm@linux-foundation.org: cleanup]
Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/kernel-doc |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff -puN scripts/kernel-doc~kernel-doc-fix-leading-dot-in-man-mode-output scripts/kernel-doc
--- a/scripts/kernel-doc~kernel-doc-fix-leading-dot-in-man-mode-output
+++ a/scripts/kernel-doc
@@ -404,7 +404,11 @@ sub output_highlight {
 	    print $lineprefix, $blankline;
 	} else {
 	    $line =~ s/\\\\\\/\&/g;
-	    print $lineprefix, $line;
+	    if ($output_mode eq "man" && substr($line, 0, 1) eq ".") {
+		print "\\&$line";
+	    } else {
+		print $lineprefix, $line;
+	    }
 	}
 	print "\n";
     }
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
git-acpi.patch
git-alsa.patch
git-mtd.patch
aha152x-in-debug-mode.patch
git-unionfs.patch
git-ipwireless_cs.patch
doc-kernel-parameters-use-x86-32-tag-instead-of-ia-32.patch
profile-likely-unlikely-macros.patch
