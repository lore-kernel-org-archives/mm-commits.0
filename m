From: akpm@linux-foundation.org
Subject: + checkpatch-exclude-asm-volatile-from-complex-macro-check.patch
 added to -mm tree
Date: Tue, 01 Mar 2016 13:36:48 -0800
Message-ID: <56d60b70.1ddbESm4/U5eYPCo%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40664 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753810AbcCAVgt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Mar 2016 16:36:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, linux.mdb@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: exclude asm volatile from complex macro check
has been added to the -mm tree.  Its filename is
     checkpatch-exclude-asm-volatile-from-complex-macro-check.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/checkpatch-exclude-asm-volatile-from-complex-macro-check.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-exclude-asm-volatile-from-complex-macro-check.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: checkpatch: exclude asm volatile from complex macro check

asm volatile and all its variants like __asm__ __volatile__ ("<foo>") are
reported as errors with "Macros with with complex values should be
enclosed in parentheses".

Make an exception for these asm volatile macro definitions by converting
the "asm volatile" to "asm_volatile" so it appears as a single function
call and the error isn't reported.

Signed-off-by: Joe Perches <joe@perches.com>
Reported-by: Jeff Merkey <linux.mdb@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    3 +++
 1 file changed, 3 insertions(+)

diff -puN scripts/checkpatch.pl~checkpatch-exclude-asm-volatile-from-complex-macro-check scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-exclude-asm-volatile-from-complex-macro-check
+++ a/scripts/checkpatch.pl
@@ -4563,6 +4563,9 @@ sub process {
 			{
 			}
 
+			# Make asm volatile uses seem like a generic function
+			$dstat =~ s/\b_*asm_*\s+_*volatile_*\b/asm_volatile/g;
+
 			my $exceptions = qr{
 				$Declare|
 				module_param_named|
_

Patches currently in -mm which might be from joe@perches.com are

checkpatch-exclude-asm-volatile-from-complex-macro-check.patch

