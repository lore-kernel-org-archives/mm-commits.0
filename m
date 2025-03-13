Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E777C1F03E5
	for <mm-commits@vger.kernel.org>; Thu, 13 Mar 2025 21:12:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741900324; cv=none; b=nu8bSMqV7cLOYJ6AaiWa6eRs49XzUwNHYwEfAcEcpaW5r2XxZRCYyoa1N8ey03H7k7cAJigB2HIB2SThb/6NJCIE06IV9xV6bIVsyTy0yXwibIR4E1Nag+FNu/Ms/uvKE9SxPwl/2hjXn3DCXPEglnHI1zcXAi39WOu9KRbEFGk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741900324; c=relaxed/simple;
	bh=GYjQmFCeRfaXGbxilzPhhVmFXiFP9xf1U9bkUrTNYeM=;
	h=Date:To:From:Subject:Message-Id; b=rIwmDgKS1C9ByII8FxIXLAA8pa073XFrkWgK5r3DbmvT3Uk4dHH32FtPplSa87i7WTEC8GTo5NBm/yDFTt1gmQEJc2CS1aSRTTTv9SGjJJguzC/4G7PiGHBJlLjk6e0bZP0TfNP2TZR8bmQ0CNSE4Q8hi0/mvG1od+IyCP7AFTE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=lvNCiq4D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="lvNCiq4D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56782C4CEDD;
	Thu, 13 Mar 2025 21:12:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1741900323;
	bh=GYjQmFCeRfaXGbxilzPhhVmFXiFP9xf1U9bkUrTNYeM=;
	h=Date:To:From:Subject:From;
	b=lvNCiq4DtjDsR/G1Mjs9+SVBW6uZHjPfzBbiMuYwUwmU4ScqtzvkmxjoJ+EBqaxk2
	 nlAYXa0dgMyyn1ktvnY7uRE7Q4WNf16NPnzzIvmRrZBgVSyMugQ8CypAOXzI8DZCcF
	 IeQ6BUYVtkB2etut6zELnu1ykxJoyIldb9y1Ta5I=
Date: Thu, 13 Mar 2025 14:12:02 -0700
To: mm-commits@vger.kernel.org,tglx@linutronix.de,song@kernel.org,thorsten.blum@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + watchdog-perf-optimize-bytes-copied-and-remove-manual-nul-termination.patch added to mm-nonmm-unstable branch
Message-Id: <20250313211203.56782C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: watchdog/perf: optimize bytes copied and remove manual NUL-termination
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     watchdog-perf-optimize-bytes-copied-and-remove-manual-nul-termination.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/watchdog-perf-optimize-bytes-copied-and-remove-manual-nul-termination.patch

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
From: Thorsten Blum <thorsten.blum@linux.dev>
Subject: watchdog/perf: optimize bytes copied and remove manual NUL-termination
Date: Thu, 13 Mar 2025 14:30:02 +0100

Currently, up to 23 bytes of the source string are copied to the
destination buffer (including the comma and anything after it), only to
then manually NUL-terminate the destination buffer again at index 'len'
(where the comma was found).

Fix this by calling strscpy() with 'len' instead of the destination buffer
size to copy only as many bytes from the source string as needed.

Change the length check to allow 'len' to be less than or equal to the
destination buffer size to fill the whole buffer if needed.

Remove the if-check for the return value of strscpy(), because calling
strscpy() with 'len' always truncates the source string at the comma as
expected and NUL-terminates the destination buffer at the corresponding
index instead.  Remove the manual NUL-termination.

No functional changes intended.

Link: https://lkml.kernel.org/r/20250313133004.36406-2-thorsten.blum@linux.dev
Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
Cc: Song Liu <song@kernel.org>
Cc: Thomas Gleinxer <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/watchdog_perf.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/kernel/watchdog_perf.c~watchdog-perf-optimize-bytes-copied-and-remove-manual-nul-termination
+++ a/kernel/watchdog_perf.c
@@ -294,12 +294,10 @@ void __init hardlockup_config_perf_event
 	} else {
 		unsigned int len = comma - str;
 
-		if (len >= sizeof(buf))
+		if (len > sizeof(buf))
 			return;
 
-		if (strscpy(buf, str, sizeof(buf)) < 0)
-			return;
-		buf[len] = 0;
+		strscpy(buf, str, len);
 		if (kstrtoull(buf, 16, &config))
 			return;
 	}
_

Patches currently in -mm which might be from thorsten.blum@linux.dev are

arm-pgtable-remove-duplicate-included-header-file.patch
watchdog-perf-optimize-bytes-copied-and-remove-manual-nul-termination.patch

