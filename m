From: akpm@linux-foundation.org
Subject: [merged] checkpatch-handle-missing-if-open-in-context.patch removed from -mm tree
Date: Fri, 16 Jan 2009 11:17:08 -0800
Message-ID: <200901161917.n0GJH8Zo025718@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45622 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S936615AbZAPTRg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 16 Jan 2009 14:17:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: apw@canonical.com, dhaval@linux.vnet.ibm.com, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     checkpatch: handle missing #if open in context
has been removed from the -mm tree.  Its filename was
     checkpatch-handle-missing-if-open-in-context.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
mmc-add-modalias-linkage-for-mmc-sd-devices.patch

