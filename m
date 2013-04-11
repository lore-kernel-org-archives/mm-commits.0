From: akpm@linux-foundation.org
Subject: + checkpatch-only-warn-for-empty-lines-before-closing-braces-by-themselves.patch added to -mm tree
Date: Thu, 11 Apr 2013 15:07:51 -0700
Message-ID: <20130411220751.AB4585A4228@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ve0-f201.google.com ([209.85.128.201]:40539 "EHLO
	mail-ve0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753186Ab3DKWHw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 11 Apr 2013 18:07:52 -0400
Received: by mail-ve0-f201.google.com with SMTP id ox1so192238veb.0
        for <mm-commits@vger.kernel.org>; Thu, 11 Apr 2013 15:07:52 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: matthijs@stdin.nl, apw@canonical.com, joe@perches.com


The patch titled
     Subject: checkpatch: only warn for empty lines before closing braces by themselves
has been added to the -mm tree.  Its filename is
     checkpatch-only-warn-for-empty-lines-before-closing-braces-by-themselves.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

linux-next.patch
checkpatch-only-warn-for-empty-lines-before-closing-braces-by-themselves.patch

