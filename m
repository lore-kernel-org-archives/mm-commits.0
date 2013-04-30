From: akpm@linux-foundation.org
Subject: [merged] checkpatch-only-warn-for-empty-lines-before-closing-braces-by-themselves.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:53:35 -0700
Message-ID: <20130430185335.AE8A75A41E9@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qe0-f74.google.com ([209.85.128.74]:60217 "EHLO
	mail-qe0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933146Ab3D3Sxg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:53:36 -0400
Received: by mail-qe0-f74.google.com with SMTP id a11so86562qen.3
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:53:36 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: matthijs@stdin.nl, apw@canonical.com, joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: only warn for empty lines before closing braces by themselves
has been removed from the -mm tree.  Its filename was
     checkpatch-only-warn-for-empty-lines-before-closing-braces-by-themselves.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Matthijs Kooijman <matthijs@stdin.nl>
Subject: checkpatch: only warn for empty lines before closing braces by themselves

This check was intended to catch extra newlines at the end of a function
definition, but it would trigger on any closing brace, including those of
inline functions and macro definitions, triggering false positives.  Now,
only closing braces on a line by themselves trigger this check.

Tested with:

$ cat test.h
/* test.h - Test file */

static inline int foo(void) { return 0; }

static inline int bar(void)
{
        return 1;

}

$ ./scripts/checkpatch.pl --strict -f test.h # Before this commit
CHECK: Blank lines aren't necessary before a close brace '}'
+
+static inline int foo(void) { return 0; }

CHECK: Blank lines aren't necessary before a close brace '}'
+
+}

total: 0 errors, 0 warnings, 2 checks, 9 lines checked

$ ./scripts/checkpatch.pl --strict -f test.h # After this commit
CHECK: Blank lines aren't necessary before a close brace '}'
+
+}

total: 0 errors, 0 warnings, 1 checks, 9 lines checked

Signed-off-by: Matthijs Kooijman <matthijs@stdin.nl>
Cc: Andy Whitcroft <apw@canonical.com>
Acked-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN scripts/checkpatch.pl~checkpatch-only-warn-for-empty-lines-before-closing-braces-by-themselves scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-only-warn-for-empty-lines-before-closing-braces-by-themselves
+++ a/scripts/checkpatch.pl
@@ -3229,7 +3229,7 @@ sub process {
 		}
 
 # check for unnecessary blank lines around braces
-		if (($line =~ /^..*}\s*$/ && $prevline =~ /^.\s*$/)) {
+		if (($line =~ /^.\s*}\s*$/ && $prevline =~ /^.\s*$/)) {
 			CHK("BRACES",
 			    "Blank lines aren't necessary before a close brace '}'\n" . $hereprev);
 		}
_

Patches currently in -mm which might be from matthijs@stdin.nl are

origin.patch

