From: akpm@linux-foundation.org
Subject: + kstrtox-simpler-code-in-_kstrtoull.patch added to -mm tree
Date: Wed, 30 Mar 2011 14:49:03 -0700
Message-ID: <201103302149.p2ULn3Ot012749@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35015 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933097Ab1C3WNn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Mar 2011 18:13:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adobriyan@gmail.com


The patch titled
     kstrtox: simpler code in _kstrtoull()
has been added to the -mm tree.  Its filename is
     kstrtox-simpler-code-in-_kstrtoull.patch

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
Subject: kstrtox: simpler code in _kstrtoull()
From: Alexey Dobriyan <adobriyan@gmail.com>

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/kstrtox.c |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff -puN lib/kstrtox.c~kstrtox-simpler-code-in-_kstrtoull lib/kstrtox.c
--- a/lib/kstrtox.c~kstrtox-simpler-code-in-_kstrtoull
+++ a/lib/kstrtox.c
@@ -49,12 +49,9 @@ static int _kstrtoull(const char *s, uns
 			val = *s - '0';
 		else if ('a' <= _tolower(*s) && _tolower(*s) <= 'f')
 			val = _tolower(*s) - 'a' + 10;
-		else if (*s == '\n') {
-			if (*(s + 1) == '\0')
-				break;
-			else
-				return -EINVAL;
-		} else
+		else if (*s == '\n' && *(s + 1) == '\0')
+			break;
+		else
 			return -EINVAL;
 
 		if (val >= base)
_

Patches currently in -mm which might be from adobriyan@gmail.com are

kstrtox-fix-compile-warnings-in-test.patch
kstrtox-simpler-code-in-_kstrtoull.patch
kstrtox-convert-fs-proc.patch
proc-constify-status-array.patch
proc-stat-use-defined-macro-kmalloc_max_size.patch
sysctl-add-proc_dointvec_bool-handler.patch

