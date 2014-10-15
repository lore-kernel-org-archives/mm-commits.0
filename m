From: akpm@linux-foundation.org
Subject: +
 checkpatch-add-error-on-use-of-attributeweak-or-__weak-declarations.patch
 added to -mm tree
Date: Wed, 15 Oct 2014 14:58:50 -0700
Message-ID: <543eee1a.qdv3oj4rGhmwJ60k%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37549 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751183AbaJOV6u (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 15 Oct 2014 17:58:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, bhelgaas@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: add error on use of attribute((weak)) or __weak declarations
has been added to the -mm tree.  Its filename is
     checkpatch-add-error-on-use-of-attributeweak-or-__weak-declarations.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/checkpatch-add-error-on-use-of-attributeweak-or-__weak-declarations.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-add-error-on-use-of-attributeweak-or-__weak-declarations.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
checkpatch-add-an-error-test-for-no-space-before-comma.patch
checkpatch-add-error-on-use-of-attributeweak-or-__weak-declarations.patch
fs-affs-amigaffsc-use-va_format-instead-of-buffer-vnsprintf.patch
linux-next.patch

