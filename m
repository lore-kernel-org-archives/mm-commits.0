From: akpm@linux-foundation.org
Subject: [merged]
 checkpatch-exclude-asm-volatile-from-complex-macro-check.patch removed from -mm tree
Date: Wed, 16 Mar 2016 12:57:28 -0700
Message-ID: <56e9baa8.PjKbVeH7D1L5cXP9%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39155 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755335AbcCPT53 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 16 Mar 2016 15:57:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, linux.mdb@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: exclude asm volatile from complex macro check
has been removed from the -mm tree.  Its filename was
     checkpatch-exclude-asm-volatile-from-complex-macro-check.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -4560,6 +4560,9 @@ sub process {
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

mm-convert-pr_warning-to-pr_warn.patch
mm-coalesce-split-strings.patch
mm-convert-printkkern_level-to-pr_level.patch
mm-percpu-use-pr_fmt-to-prefix-output.patch
kernel-convert-pr_warning-to-pr_warn.patch

