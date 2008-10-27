From: akpm@linux-foundation.org
Subject: + checkpatch-add-checks-for-in_atomic.patch added to -mm tree
Date: Mon, 27 Oct 2008 14:32:03 -0700
Message-ID: <200810272132.m9RLW3c9005103@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46893 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751771AbYJ0VcN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 27 Oct 2008 17:32:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: apw@shadowen.org


The patch titled
     checkpatch: add checks for in_atomic()
has been added to the -mm tree.  Its filename is
     checkpatch-add-checks-for-in_atomic.patch

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
Subject: checkpatch: add checks for in_atomic()
From: Andy Whitcroft <apw@shadowen.org>

in_atomic() is not for driver use so report any such use as an ERROR. 
Also in_atomic() is often used to determine if we may sleep, but it is not
reliable in this use model therefore strongly discourage its use.

Signed-off-by: Andy Whitcroft <apw@shadowen.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    9 +++++++++
 1 file changed, 9 insertions(+)

diff -puN scripts/checkpatch.pl~checkpatch-add-checks-for-in_atomic scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-add-checks-for-in_atomic
+++ a/scripts/checkpatch.pl
@@ -2466,6 +2466,15 @@ sub process {
 				last;
 			}
 		}
+
+# whine mightly about in_atomic
+		if ($line =~ /\bin_atomic\s*\(/) {
+			if ($realfile =~ m@^drivers/@) {
+				ERROR("do not use in_atomic in drivers\n" . $herecurr);
+			} else {
+				WARN("use of in_atomic() is incorrect outside core kernel code\n" . $herecurr);
+			}
+		}
 	}
 
 	# If we have no input at all, then there is nothing to report on
_

Patches currently in -mm which might be from apw@shadowen.org are

checkpatch-add-checks-for-in_atomic.patch
checkpatch-comment-detection-may-miss-an-implied-comment-on-the-last-hunk.patch
checkpatch-widen-implied-comment-detection-to-allow-multiple-stars.patch
checkpatch-structure-member-assignments-are-not-complex.patch
checkpatch-__weak-is-an-official-attribute.patch
checkpatch-detect-multiple-bitfield-declarations.patch
checkpatch-comment-ends-inside-strings-is-most-likely-not-an-open-comment.patch
checkpatch-dissallow-spaces-between-stars-in-pointer-types.patch
checkpatch-version-025.patch

