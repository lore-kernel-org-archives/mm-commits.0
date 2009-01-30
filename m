From: akpm@linux-foundation.org
Subject: + checkpatch-make-in_atomic-ok-in-the-core.patch added to -mm tree
Date: Fri, 30 Jan 2009 13:53:44 -0800
Message-ID: <200901302153.n0ULriCN031077@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53712 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752898AbZA3Vxs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 30 Jan 2009 16:53:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: apw@canonical.com


The patch titled
     checkpatch: make in_atomic ok in the core
has been added to the -mm tree.  Its filename is
     checkpatch-make-in_atomic-ok-in-the-core.patch

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
Subject: checkpatch: make in_atomic ok in the core
From: Andy Whitcroft <apw@canonical.com>

We say that in_atomic() is ok in the core kernel, but then always report
it regardless of where in the kernel it is.  Keep quiet if it is used in
kernel/*.

Signed-off-by: Andy Whitcroft <apw@canonical.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN scripts/checkpatch.pl~checkpatch-make-in_atomic-ok-in-the-core scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-make-in_atomic-ok-in-the-core
+++ a/scripts/checkpatch.pl
@@ -2560,7 +2560,7 @@ sub process {
 		if ($line =~ /\bin_atomic\s*\(/) {
 			if ($realfile =~ m@^drivers/@) {
 				ERROR("do not use in_atomic in drivers\n" . $herecurr);
-			} else {
+			} elsif ($realfile !~ m@^kernel/@) {
 				WARN("use of in_atomic() is incorrect outside core kernel code\n" . $herecurr);
 			}
 		}
_

Patches currently in -mm which might be from apw@canonical.com are

mmc-add-modalias-linkage-for-mmc-sd-devices.patch
checkpatch-make-in_atomic-ok-in-the-core.patch
checkpatch-do-not-warn-about-p0-patches-when-checking-files.patch
checkpatch-correctly-handle-type-spacing-in-the-face-of-modifiers.patch
checkpatch-pointer-type-star-may-have-modifiers-following.patch
checkpatch-a-modifier-is-not-an-identifier-at-the-end-of-a-type.patch
checkpatch-extend-attribute-testing-to-all-modifiers.patch
checkpatch-add-__ref-as-a-sparse-modifier.patch
checkpatch-version-028.patch

