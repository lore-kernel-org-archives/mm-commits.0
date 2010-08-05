From: akpm@linux-foundation.org
Subject: + checkpatch-fix-extraneous-export_symbol-warnings.patch added to -mm tree
Date: Thu, 05 Aug 2010 13:44:33 -0700
Message-ID: <201008052044.o75KiZZ0003565@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53821 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758935Ab0HEUpk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Aug 2010 16:45:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ppannuto@codeaurora.org, apw@shadowen.org


The patch titled
     checkpatch: fix extraneous EXPORT_SYMBOL* warnings
has been added to the -mm tree.  Its filename is
     checkpatch-fix-extraneous-export_symbol-warnings.patch

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
Subject: checkpatch: fix extraneous EXPORT_SYMBOL* warnings
From: Patrick Pannuto <ppannuto@codeaurora.org>

These are caused by checkpatch incorrectly parsing its internal
representation of a statement block for struct's (or anything else that is
a statement block encapsulated in {}'s that also ends with a ';').  Fix
this by properly parsing a statement block.

An example:

	+struct dummy_type dummy = {
	+	.foo	= "baz",
	+};
	+EXPORT_SYMBOL_GPL(dummy);
	+
	+static int dummy_func(void)
	+{
	+	return -EDUMMYCODE;
	+}
	+EXPORT_SYMBOL_GPL(dummy_func);

	WARNING: EXPORT_SYMBOL(foo); should immediately \
		follow its function/variable
	#19: FILE: dummy.c:4:
	+EXPORT_SYMBOL_GPL(dummy);

The above warning is issued when it should not be.

Signed-off-by: Patrick Pannuto <ppannuto@codeaurora.org>
Cc: Andy Whitcroft <apw@shadowen.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    3 +++
 1 file changed, 3 insertions(+)

diff -puN scripts/checkpatch.pl~checkpatch-fix-extraneous-export_symbol-warnings scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-fix-extraneous-export_symbol-warnings
+++ a/scripts/checkpatch.pl
@@ -558,6 +558,9 @@ sub ctx_statement_block {
 			$type = ($level != 0)? '{' : '';
 
 			if ($level == 0) {
+				if (substr($blk, $off + 1, 1) eq ';') {
+					$off++;
+				}
 				last;
 			}
 		}
_

Patches currently in -mm which might be from ppannuto@codeaurora.org are

linux-next.patch
revert-old-timer-added-usleep_range-timer.patch
timer-added-usleep_range-timer.patch
documentation-add-timers-timers-howtotxt.patch
checkpatch-prefer-usleep_range-over-udelay.patch
checkpatch-prefer-usleep_range-over-udelay-fix.patch
checkpatch-warn-about-unexpectedly-long-msleeps.patch
checkpatch-fix-extraneous-export_symbol-warnings.patch

