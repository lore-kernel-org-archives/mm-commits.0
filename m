From: akpm@linux-foundation.org
Subject: [merged]
 checkpatch-allow-define_per_cpu-definitions-to-exceed-line-length.patch
 removed from -mm tree
Date: Mon, 20 Nov 2017 13:24:42 -0800
Message-ID: <20171120212442.uUaMdByh1%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40590 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752856AbdKTVYn (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 20 Nov 2017 16:24:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ard.biesheuvel@linaro.org, daniel.lezcano@linaro.org, joe@perches.com, marc.zyngier@arm.com, mark.rutland@arm.com, mm-commits@vger.kernel.org, tglx@linutronix.de


The patch titled
     Subject: checkpatch: allow DEFINE_PER_CPU definitions to exceed line length
has been removed from the -mm tree.  Its filename was
     checkpatch-allow-define_per_cpu-definitions-to-exceed-line-length.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: checkpatch: allow DEFINE_PER_CPU definitions to exceed line length

Some of the definitions are very long and can't be split into multiple
lines because ctags is limited.

Exempt these lines from the line length checks.

See 25528213fe9f75f4 ("tags: Fix DEFINE_PER_CPU expansions") for more
details.

Link: http://lkml.kernel.org/r/1508170320.6530.15.camel@perches.com
Signed-off-by: Joe Perches <joe@perches.com>
Acked-by: Mark Rutland <mark.rutland@arm.com>
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: Marc Zyngier <marc.zyngier@arm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN scripts/checkpatch.pl~checkpatch-allow-define_per_cpu-definitions-to-exceed-line-length scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-allow-define_per_cpu-definitions-to-exceed-line-length
+++ a/scripts/checkpatch.pl
@@ -2900,8 +2900,9 @@ sub process {
 				 $line =~ /^\+\s*#\s*define\s+\w+\s+$String$/) {
 				$msg_type = "";
 
-			# EFI_GUID is another special case
-			} elsif ($line =~ /^\+.*\bEFI_GUID\s*\(/) {
+			# More special cases
+			} elsif ($line =~ /^\+.*\bEFI_GUID\s*\(/ ||
+				 $line =~ /^\+\s*(?:\w+)?\s*DEFINE_PER_CPU/) {
 				$msg_type = "";
 
 			# Otherwise set the alternate message types
_

Patches currently in -mm which might be from joe@perches.com are


