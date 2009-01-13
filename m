From: akpm@linux-foundation.org
Subject: + checkpatch-handle-missing-if-open-in-context.patch added to -mm tree
Date: Tue, 13 Jan 2009 14:24:03 -0800
Message-ID: <200901132224.n0DMO3Bg027651@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56359 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755447AbZAMWYs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 13 Jan 2009 17:24:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: apw@canonical.com, dhaval@linux.vnet.ibm.com, mingo@elte.hu


The patch titled
     checkpatch: handle missing #if open in context
has been added to the -mm tree.  Its filename is
     checkpatch-handle-missing-if-open-in-context.patch

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
Subject: checkpatch: handle missing #if open in context
From: Andy Whitcroft <apw@canonical.com>

If the #if opening statement is not in the context then the context stack
can be empty.  Handle this by ensuring there is always a blank entry in
the stack.

Signed-off-by: Andy Whitcroft <apw@canonical.com>
Tested-by: Dhaval Giani <dhaval@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN scripts/checkpatch.pl~checkpatch-handle-missing-if-open-in-context scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-handle-missing-if-open-in-context
+++ a/scripts/checkpatch.pl
@@ -411,13 +411,15 @@ sub ctx_statement_block {
 
 	my $type = '';
 	my $level = 0;
-	my @stack = ([$type, $level]);
+	my @stack = ();
 	my $p;
 	my $c;
 	my $len = 0;
 
 	my $remainder;
 	while (1) {
+		@stack = (['', 0]) if ($#stack == -1);
+
 		#warn "CSB: blk<$blk> remain<$remain>\n";
 		# If we are about to drop off the end, pull in more
 		# context.
_

Patches currently in -mm which might be from apw@canonical.com are

sysrq-documentation-remove-the-redundant-updated-date.patch
sysrq-documentation-document-why-the-command-header-only-is-shown.patch
sysrq-add-commentary-on-why-we-use-the-console-loglevel-over-using-kern_emerg.patch
checkpatch-handle-missing-if-open-in-context.patch
checkpatch-type-cast-spacing-should-not-check-prefix-spacing.patch
checkpatch-allow-parentheses-on-return-handle-array-values.patch
checkpatch-if-should-not-continue-a-preceeding-brace.patch
checkpatch-struct-seq_operations-should-normally-be-const.patch
checkpatch-version-027.patch
mmc-add-modalias-linkage-for-mmc-sd-devices.patch

