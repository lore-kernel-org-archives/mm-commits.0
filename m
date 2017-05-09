From: akpm@linux-foundation.org
Subject: [merged]
 checkpatch-add-ability-to-find-bad-uses-of-vsprintf-%pfoo-extensions.patch
 removed from -mm tree
Date: Tue, 09 May 2017 11:01:07 -0700
Message-ID: <20170509180107.4uXwhobf8%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34332 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753901AbdEISBI (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 9 May 2017 14:01:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, keescook@chromium.org, mm-commits@vger.kernel.org, william.c.roberts@intel.com


The patch titled
     Subject: checkpatch: add ability to find bad uses of vsprintf %p<foo> extensions
has been removed from the -mm tree.  Its filename was
     checkpatch-add-ability-to-find-bad-uses-of-vsprintf-%pfoo-extensions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: checkpatch: add ability to find bad uses of vsprintf %p<foo> extensions

%pK was at least once misused at %pk in an out-of-tree module.  This lead
to some security concerns.  Add the ability to track single and multiple
line statements for misuses of %p<foo>.

[akpm@linux-foundation.org: add helpful comment into lib/vsprintf.c]
[akpm@linux-foundation.org: text tweak]
Link: http://lkml.kernel.org/r/163a690510e636a23187c0dc9caa09ddac6d4cde.1488228427.git.joe@perches.com
Signed-off-by: Joe Perches <joe@perches.com>
Acked-by: Kees Cook <keescook@chromium.org>
Acked-by: William Roberts <william.c.roberts@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/vsprintf.c        |    3 +++
 scripts/checkpatch.pl |   26 ++++++++++++++++++++++++++
 2 files changed, 29 insertions(+)

diff -puN lib/vsprintf.c~checkpatch-add-ability-to-find-bad-uses-of-vsprintf-%pfoo-extensions lib/vsprintf.c
--- a/lib/vsprintf.c~checkpatch-add-ability-to-find-bad-uses-of-vsprintf-%pfoo-extensions
+++ a/lib/vsprintf.c
@@ -1477,6 +1477,9 @@ int kptr_restrict __read_mostly;
  * by an extra set of alphanumeric characters that are extended format
  * specifiers.
  *
+ * Please update scripts/checkpatch.pl when adding/removing conversion
+ * characters.  (Search for "check for vsprintf extension").
+ *
  * Right now we handle:
  *
  * - 'F' For symbolic function descriptor pointers with offset
diff -puN scripts/checkpatch.pl~checkpatch-add-ability-to-find-bad-uses-of-vsprintf-%pfoo-extensions scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-add-ability-to-find-bad-uses-of-vsprintf-%pfoo-extensions
+++ a/scripts/checkpatch.pl
@@ -5663,6 +5663,32 @@ sub process {
 			}
 		}
 
+		# check for vsprintf extension %p<foo> misuses
+		if ($^V && $^V ge 5.10.0 &&
+		    defined $stat &&
+		    $stat =~ /^\+(?![^\{]*\{\s*).*\b(\w+)\s*\(.*$String\s*,/s &&
+		    $1 !~ /^_*volatile_*$/) {
+			my $bad_extension = "";
+			my $lc = $stat =~ tr@\n@@;
+			$lc = $lc + $linenr;
+		        for (my $count = $linenr; $count <= $lc; $count++) {
+				my $fmt = get_quoted_string($lines[$count - 1], raw_line($count, 0));
+				$fmt =~ s/%%//g;
+				if ($fmt =~ /(\%[\*\d\.]*p(?![\WFfSsBKRraEhMmIiUDdgVCbGN]).)/) {
+					$bad_extension = $1;
+					last;
+				}
+			}
+			if ($bad_extension ne "") {
+				my $stat_real = raw_line($linenr, 0);
+				for (my $count = $linenr + 1; $count <= $lc; $count++) {
+					$stat_real = $stat_real . "\n" . raw_line($count, 0);
+				}
+				WARN("VSPRINTF_POINTER_EXTENSION",
+				     "Invalid vsprintf pointer extension '$bad_extension'\n" . "$here\n$stat_real\n");
+			}
+		}
+
 # Check for misused memsets
 		if ($^V && $^V ge 5.10.0 &&
 		    defined $stat &&
_

Patches currently in -mm which might be from joe@perches.com are


