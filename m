From: akpm@linux-foundation.org
Subject: +
 checkpatch-allow-define_per_cpu-definitions-to-exceed-line-length.patch
 added to -mm tree
Date: Mon, 16 Oct 2017 14:52:39 -0700
Message-ID: <59e52a27.X9ErKSTVEq5xdNSv%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37526 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752107AbdJPVwl (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 16 Oct 2017 17:52:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, ard.biesheuvel@linaro.org, daniel.lezcano@linaro.org, marc.zyngier@arm.com, mark.rutland@arm.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: allow DEFINE_PER_CPU definitions to exceed line length
has been added to the -mm tree.  Its filename is
     checkpatch-allow-define_per_cpu-definitions-to-exceed-line-length.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/checkpatch-allow-define_per_cpu-definitions-to-exceed-line-length.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-allow-define_per_cpu-definitions-to-exceed-line-length.patch

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

spellingtxt-add-unnecessary-typo-variants.patch
parse-maintainers-add-ability-to-specify-filenames.patch
checkpatch-printks-always-need-a-kern_level.patch
checkpatch-allow-define_per_cpu-definitions-to-exceed-line-length.patch

