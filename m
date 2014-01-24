From: akpm@linux-foundation.org
Subject: [merged]
 checkpatch-add-tests-for-function-pointer-style-misuses.patch removed from
 -mm tree
Date: Fri, 24 Jan 2014 11:01:59 -0800
Message-ID: <52e2b8a7.Rxbebx/cWyDgeS7l%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43659 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752946AbaAXTB7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 24 Jan 2014 14:01:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, d.roc16@gmail.com, apw@shadowen.org, joe@perches.com

Subject: [merged] checkpatch-add-tests-for-function-pointer-style-misuses.patch removed from -mm tree
To: joe@perches.com,apw@shadowen.org,d.roc16@gmail.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 24 Jan 2014 11:01:59 -0800


The patch titled
     Subject: checkpatch: add tests for function pointer style misuses
has been removed from the -mm tree.  Its filename was
     checkpatch-add-tests-for-function-pointer-style-misuses.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: checkpatch: add tests for function pointer style misuses

Kernel style uses function pointers in this form:
	"type (*funcptr)(args...)"

Emit warnings when this function pointer form isn't used.

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Andy Whitcroft <apw@shadowen.org>
Cc: Derek Perrin <d.roc16@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   59 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 59 insertions(+)

diff -puN scripts/checkpatch.pl~checkpatch-add-tests-for-function-pointer-style-misuses scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-add-tests-for-function-pointer-style-misuses
+++ a/scripts/checkpatch.pl
@@ -2811,6 +2811,65 @@ sub process {
 			}
 		}
 
+# Function pointer declarations
+# check spacing between type, funcptr, and args
+# canonical declaration is "type (*funcptr)(args...)"
+#
+# the $Declare variable will capture all spaces after the type
+# so check it for trailing missing spaces or multiple spaces
+		if ($line =~ /^.\s*($Declare)\((\s*)\*(\s*)$Ident(\s*)\)(\s*)\(/) {
+			my $declare = $1;
+			my $pre_pointer_space = $2;
+			my $post_pointer_space = $3;
+			my $funcname = $4;
+			my $post_funcname_space = $5;
+			my $pre_args_space = $6;
+
+			if ($declare !~ /\s$/) {
+				WARN("SPACING",
+				     "missing space after return type\n" . $herecurr);
+			}
+
+# unnecessary space "type  (*funcptr)(args...)"
+			elsif ($declare =~ /\s{2,}$/) {
+				WARN("SPACING",
+				     "Multiple spaces after return type\n" . $herecurr);
+			}
+
+# unnecessary space "type ( *funcptr)(args...)"
+			if (defined $pre_pointer_space &&
+			    $pre_pointer_space =~ /^\s/) {
+				WARN("SPACING",
+				     "Unnecessary space after function pointer open parenthesis\n" . $herecurr);
+			}
+
+# unnecessary space "type (* funcptr)(args...)"
+			if (defined $post_pointer_space &&
+			    $post_pointer_space =~ /^\s/) {
+				WARN("SPACING",
+				     "Unnecessary space before function pointer name\n" . $herecurr);
+			}
+
+# unnecessary space "type (*funcptr )(args...)"
+			if (defined $post_funcname_space &&
+			    $post_funcname_space =~ /^\s/) {
+				WARN("SPACING",
+				     "Unnecessary space after function pointer name\n" . $herecurr);
+			}
+
+# unnecessary space "type (*funcptr) (args...)"
+			if (defined $pre_args_space &&
+			    $pre_args_space =~ /^\s/) {
+				WARN("SPACING",
+				     "Unnecessary space before function pointer arguments\n" . $herecurr);
+			}
+
+			if (show_type("SPACING") && $fix) {
+				$fixed[$linenr - 1] =~
+				    s/^(.\s*$Declare)\(\s*\*\s*($Ident)\s*\)\s*\(/rtrim($1) . " " . "\(\*$2\)\("/ex;
+			}
+		}
+
 # check for spacing round square brackets; allowed:
 #  1. with a type on the left -- int [] a;
 #  2. at the beginning of a line for slice initialisers -- [0...10] = 5,
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
lib-genallocc-add-check-gen_pool_dma_alloc-if-dma-pointer-is-not-null.patch
ipc-whitespace-cleanup.patch
linux-next.patch
softirq-use-ffs-in-__do_softirq.patch
softirq-convert-printks-to-pr_level.patch
softirq-use-const-char-const-for-softirq_to_name-whitespace-neatening.patch
checkpatchpl-check-for-function-declarations-without-arguments.patch

