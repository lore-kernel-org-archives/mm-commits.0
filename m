Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE74515687D
	for <mm-commits@vger.kernel.org>; Sun, 20 Jul 2025 02:09:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752977358; cv=none; b=ty3QKbgt6uhWLl3NkrTat3IXP6ALt+Fv2zWfCumFZ68RZZNtZ1m/7pD9/UhvZ00NXO/k6gA99kf8m2TCnskpZM/8oablbnDv58zKZB3NnakuzfocInC1ReZU6ZaqiNjWNV2S6jNHaEvvNAsRUfH/VUSzWgHkMNGgD1V5J/poUig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752977358; c=relaxed/simple;
	bh=DuARjVkvK1qM9t6V2KVaydtM1xwnhOnQllCAcxwM1jo=;
	h=Date:To:From:Subject:Message-Id; b=SDEud+b69M9ZDnssJ1TyVqXsxJdSKefoa6+gQ7QLsJHavDivPGEd+rLigw/1ybNz8BSgVz6mZTn8mMY2PnYL2gdhoQhMTfVnbRf5IsrjbcwhYgyEq/1XBYWLlnECYAN4h2TZjJqH1fhZrW8b69QcnLwO6FljoxD54AOmbusj7ck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=C+tyGTWh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="C+tyGTWh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CBF4C4CEF4;
	Sun, 20 Jul 2025 02:09:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752977358;
	bh=DuARjVkvK1qM9t6V2KVaydtM1xwnhOnQllCAcxwM1jo=;
	h=Date:To:From:Subject:From;
	b=C+tyGTWhzvT6p/1/WWCyopvuMTdmzUEcgerUdg+Zw8s8IE1UBng8Zh1Vtsb+s6BrX
	 CsP+FzjjpQ5/MBYrjhkRyjjwXhTf0bRipMGz4FFuoNKg3Bha1nuO5Ox8APW/BUi+kv
	 pE1eZI3L5vd/7UxIFCyR7y6ICSQ/FQ4r7HgcBi4k=
Date: Sat, 19 Jul 2025 19:09:17 -0700
To: mm-commits@vger.kernel.org,ribalda@chromium.org,nicolas.palix@imag.fr,kuba@kernel.org,julia.lawall@inria.fr,eahariha@linux.microsoft.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] coccinelle-misc-secs_to_jiffies-implement-context-and-report-modes.patch removed from -mm tree
Message-Id: <20250720020918.6CBF4C4CEF4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: coccinelle: misc: secs_to_jiffies: implement context and report modes
has been removed from the -mm tree.  Its filename was
     coccinelle-misc-secs_to_jiffies-implement-context-and-report-modes.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


