From: akpm@linux-foundation.org
Subject: + checkpatch-make-utf-8-test-strict.patch added to -mm tree
Date: Fri, 01 Jul 2011 14:48:19 -0700
Message-ID: <201107012148.p61LmJOU017555@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38452 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757733Ab1GAVsu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 1 Jul 2011 17:48:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe@perches.com


The patch titled
     checkpatch: kake utf-8 test --strict
has been added to the -mm tree.  Its filename is
     checkpatch-make-utf-8-test-strict.patch

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
Subject: checkpatch: kake utf-8 test --strict
From: Joe Perches <joe@perches.com>

Some patches are sent in using ISO-8859 or even Windows codepage 1252.

Make checkpatch accept these by default and only emit the "Invalid UTF-8"
message when using --strict.

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN scripts/checkpatch.pl~checkpatch-make-utf-8-test-strict scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-make-utf-8-test-strict
+++ a/scripts/checkpatch.pl
@@ -1609,8 +1609,8 @@ sub process {
 			my $ptr = substr($blank, 0, length($utf8_prefix)) . "^";
 			my $hereptr = "$hereline$ptr\n";
 
-			ERROR("INVALID_UTF8",
-			      "Invalid UTF-8, patch and commit message should be encoded in UTF-8\n" . $hereptr);
+			CHK("INVALID_UTF8",
+			    "Invalid UTF-8, patch and commit message should be encoded in UTF-8\n" . $hereptr);
 		}
 
 # ignore non-hunk lines and lines being removed
_

Patches currently in -mm which might be from joe@perches.com are

linux-next.patch
drivers-use-kzalloc-kcalloc-instead-of-kmallocmemset-where-possible.patch
get_maintainerspl-improve-mailmap-parsing.patch
maintainers-update-high-resolution-timers-patterns.patch
maintainers-remove-section-usb-se401-driver.patch
checkpatch-suggest-using-min_t-or-max_t-v2.patch
checkpatch-add-__rcu-as-a-sparse-modifier.patch
checkpatch-validate-signature-styles-and-to-and-cc-lines.patch
checkpatch-add-a-prefer-__aligned-check.patch
checkpatchpl-add-ability-to-ignore-various-messages.patch
checkpatch-make-utf-8-test-strict.patch
ramoops-use-module-parameters-instead-of-platform-data-if-not-available.patch
ramoops-use-module-parameters-instead-of-platform-data-if-not-available-checkpatch-fixes.patch
ramoops-add-new-line-to-each-print.patch

