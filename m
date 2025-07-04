Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B19B6D17
	for <mm-commits@vger.kernel.org>; Fri,  4 Jul 2025 00:22:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751588567; cv=none; b=M7vjbEcMDiUap14BRAD5E9wPrZVdHGldCFH/3G5u8YX0J3VcBhI5F7WzD2BTSd251sFoI0/aLRubP0VbUSb/35itVgNaWzrC0vaReQqvy1SIbo9XDyJI7jFjCG3GaH2zD0MsoakntiImTemUgZcG3GgDZeNgqPfs7BosfaKFAks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751588567; c=relaxed/simple;
	bh=K4XOjGKDhbRbt/VDLeckcIJNtlt/EpgMd9eZcMNpReA=;
	h=Date:To:From:Subject:Message-Id; b=Dg7s563XTyKk+kGMikIHzrVSla6A8VDT1sBOUUZjvRlZdH8T3+ALB+FaymLEXOmU4ARzMwPIWWz2s3KNozUX/Qx0MQTAZBl96HTcg6U/QWVVJdTVIoVfkPzwcvv4PffKxka0HGV6L3ahMmEHxQ+qD/a3efKyHWkud+75RDu17CA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=KaMdq7/m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="KaMdq7/m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FAE1C4CEE3;
	Fri,  4 Jul 2025 00:22:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1751588566;
	bh=K4XOjGKDhbRbt/VDLeckcIJNtlt/EpgMd9eZcMNpReA=;
	h=Date:To:From:Subject:From;
	b=KaMdq7/mX9CH3JXQxdV8dVyxgbYzS0uXjJMX/ctEUgEdTgROm2P63pjVtvpe5sTCn
	 YmdruLrBXXXtGF8xfJzy+iay3MwlxEu0r7BhcF028CmjpqOy11eF8WqgzbTxR6YKGG
	 uP54m/ftpWNcpmD9++sXo28mfVMVSYlUi1LMy37U=
Date: Thu, 03 Jul 2025 17:22:45 -0700
To: mm-commits@vger.kernel.org,ribalda@chromium.org,nicolas.palix@imag.fr,kuba@kernel.org,julia.lawall@inria.fr,eahariha@linux.microsoft.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + coccinelle-misc-secs_to_jiffies-implement-context-and-report-modes.patch added to mm-nonmm-unstable branch
Message-Id: <20250704002246.5FAE1C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: coccinelle: misc: secs_to_jiffies: implement context and report modes
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     coccinelle-misc-secs_to_jiffies-implement-context-and-report-modes.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/coccinelle-misc-secs_to_jiffies-implement-context-and-report-modes.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Easwar Hariharan <eahariha@linux.microsoft.com>
Subject: coccinelle: misc: secs_to_jiffies: implement context and report modes
Date: Thu, 3 Jul 2025 15:51:32 -0700

As requested by Ricardo and Jakub, implement report and context modes for
the secs_to_jiffies Coccinelle script.  While here, add the option to look
for opportunities to use secs_to_jiffies() in headers.

Link: https://lkml.kernel.org/r/20250703225145.152288-1-eahariha@linux.microsoft.com
Signed-off-by: Easwar Hariharan <eahariha@linux.microsoft.com>
Closes: https://lore.kernel.org/all/20250129-secs_to_jiffles-v1-1-35a5e16b9f03@chromium.org/
Closes: https://lore.kernel.org/all/20250221162107.409ae333@kernel.org/
Tested-by: Ricardo Ribalda <ribalda@chromium.org>
Cc: Julia Lawall <julia.lawall@inria.fr>
Cc: Nicolas Palix <nicolas.palix@imag.fr>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Ricardo Ribalda <ribalda@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/coccinelle/misc/secs_to_jiffies.cocci |   49 ++++++++++++++--
 1 file changed, 44 insertions(+), 5 deletions(-)

--- a/scripts/coccinelle/misc/secs_to_jiffies.cocci~coccinelle-misc-secs_to_jiffies-implement-context-and-report-modes
+++ a/scripts/coccinelle/misc/secs_to_jiffies.cocci
@@ -7,26 +7,65 @@
 // Confidence: High
 // Copyright: (C) 2024 Easwar Hariharan, Microsoft
 // Keywords: secs, seconds, jiffies
-//
+// Options: --include-headers
 
 virtual patch
+virtual report
+virtual context
 
-@depends on patch@ constant C; @@
+@pconst depends on patch@ constant C; @@
 
 - msecs_to_jiffies(C * 1000)
 + secs_to_jiffies(C)
 
-@depends on patch@ constant C; @@
+@pconstms depends on patch@ constant C; @@
 
 - msecs_to_jiffies(C * MSEC_PER_SEC)
 + secs_to_jiffies(C)
 
-@depends on patch@ expression E; @@
+@pexpr depends on patch@ expression E; @@
 
 - msecs_to_jiffies(E * 1000)
 + secs_to_jiffies(E)
 
-@depends on patch@ expression E; @@
+@pexprms depends on patch@ expression E; @@
 
 - msecs_to_jiffies(E * MSEC_PER_SEC)
 + secs_to_jiffies(E)
+
+@r depends on report && !patch@
+constant C;
+expression E;
+position p;
+@@
+
+(
+  msecs_to_jiffies(C@p * 1000)
+|
+  msecs_to_jiffies(C@p * MSEC_PER_SEC)
+|
+  msecs_to_jiffies(E@p * 1000)
+|
+  msecs_to_jiffies(E@p * MSEC_PER_SEC)
+)
+
+@c depends on context && !patch@
+constant C;
+expression E;
+@@
+
+(
+* msecs_to_jiffies(C * 1000)
+|
+* msecs_to_jiffies(C * MSEC_PER_SEC)
+|
+* msecs_to_jiffies(E * 1000)
+|
+* msecs_to_jiffies(E * MSEC_PER_SEC)
+)
+
+@script:python depends on report@
+p << r.p;
+@@
+
+coccilib.report.print_report(p[0], "WARNING opportunity for secs_to_jiffies()")
_

Patches currently in -mm which might be from eahariha@linux.microsoft.com are

coccinelle-misc-secs_to_jiffies-implement-context-and-report-modes.patch

