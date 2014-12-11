From: akpm@linux-foundation.org
Subject: [merged]
 checkpatch-add-error-on-use-of-attributeweak-or-__weak-declarations.patch
 removed from -mm tree
Date: Thu, 11 Dec 2014 11:05:22 -0800
Message-ID: <5489eaf2.AH03R9RAild9Oa4f%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45666 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755883AbaLKTFX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 11 Dec 2014 14:05:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, bhelgaas@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: add error on use of attribute((weak)) or __weak declarations
has been removed from the -mm tree.  Its filename was
     checkpatch-add-error-on-use-of-attributeweak-or-__weak-declarations.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: checkpatch: add error on use of attribute((weak)) or __weak declarations

Using weak declarations can have unintended link defects.  The __weak on
the declaration causes non-weak definitions to become weak.

Emit an error on its use.

Signed-off-by: Joe Perches <joe@perches.com>
Reported-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    9 +++++++++
 1 file changed, 9 insertions(+)

diff -puN scripts/checkpatch.pl~checkpatch-add-error-on-use-of-attributeweak-or-__weak-declarations scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-add-error-on-use-of-attributeweak-or-__weak-declarations
+++ a/scripts/checkpatch.pl
@@ -4671,6 +4671,15 @@ sub process {
 			}
 		}
 
+# Check for __attribute__ weak, or __weak declarations (may have link issues)
+		if ($^V && $^V ge 5.10.0 &&
+		    $line =~ /(?:$Declare|$DeclareMisordered)\s*$Ident\s*$balanced_parens\s*(?:$Attribute)?\s*;/ &&
+		    ($line =~ /\b__attribute__\s*\(\s*\(.*\bweak\b/ ||
+		     $line =~ /\b__weak\b/)) {
+			ERROR("WEAK_DECLARATION",
+			      "Using weak declarations can have unintended link defects\n" . $herecurr);
+		}
+
 # check for sizeof(&)
 		if ($line =~ /\bsizeof\s*\(\s*\&/) {
 			WARN("SIZEOF_ADDRESS",
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
mm-utilc-add-kstrimdup.patch
fs-affs-amigaffsc-use-va_format-instead-of-buffer-vnsprintf.patch
linux-next.patch

