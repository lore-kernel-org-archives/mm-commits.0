Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A43119A288
	for <mm-commits@vger.kernel.org>; Sat,  1 Nov 2025 03:22:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761967357; cv=none; b=BZjM2rihYShFZGiWEZdhuFlBiV8AfK7TIBZmPtHLJ99JQfJtLaSV2Uux541RhC/QZ+w01EIoqgCQ3KGISK0nUNUvfR3wof0ZabSHvQEz8JvP9xyMWo//lWw/Ey3f2zEOrAaers9rg6zbqXldVdkglmZ+pL8uZ3qj532UtnkUI6c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761967357; c=relaxed/simple;
	bh=D0A2svReRKKOoqd1KF548KwuIboqjswb+3l9glB62RA=;
	h=Date:To:From:Subject:Message-Id; b=XfJAHTOM3vl/cqur7m070mpNmh/BWdpV41m+ymV8yvUWSJi0VJfJ7pJWGo1dx18wmkWRl9sMR4v5Ovj626Sznxc+anEfLqA0g9/c+A29dBSO5DQPqN71bWNqnbnc7uTXr8Fxc0qmjLBtWg7XwlE5xlzWvnCXpScIl8YSK3LujAY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=VuCcKeHr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="VuCcKeHr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A952C4CEF7;
	Sat,  1 Nov 2025 03:22:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1761967356;
	bh=D0A2svReRKKOoqd1KF548KwuIboqjswb+3l9glB62RA=;
	h=Date:To:From:Subject:From;
	b=VuCcKeHrpW/UbY6lzpKQnIScDZFJJdQrpM6ZlKgKTseOWYgb6U352n4QMRDPoblMA
	 VchEX1hQ7jSa25DvF7v4mO8TEgnTeDmtppjL+nxSUkCPhh8b1/yBNmLv5lRLvdy1Px
	 DUjP7QcQq/noBTexT3qckBUDEJ3VDgfpRwAeKw7A=
Date: Fri, 31 Oct 2025 20:22:36 -0700
To: mm-commits@vger.kernel.org,bp@alien8.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-kconfigdebug-cleanup-config_debug_section_mismatch-help-text.patch added to mm-nonmm-unstable branch
Message-Id: <20251101032236.9A952C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib/Kconfig.debug: cleanup CONFIG_DEBUG_SECTION_MISMATCH help text
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-kconfigdebug-cleanup-config_debug_section_mismatch-help-text.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-kconfigdebug-cleanup-config_debug_section_mismatch-help-text.patch

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
From: "Borislav Petkov (AMD)" <bp@alien8.de>
Subject: lib/Kconfig.debug: cleanup CONFIG_DEBUG_SECTION_MISMATCH help text
Date: Wed, 29 Oct 2025 13:27:43 +0100

Simplify formulations, correct flow, split it into proper paragraphs and
update structure.

No functional changes.

Link: https://lkml.kernel.org/r/20251029122743.1110-1-bp@kernel.org
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Kconfig.debug |   32 ++++++++++++++++----------------
 1 file changed, 16 insertions(+), 16 deletions(-)

--- a/lib/Kconfig.debug~lib-kconfigdebug-cleanup-config_debug_section_mismatch-help-text
+++ a/lib/Kconfig.debug
@@ -483,23 +483,23 @@ config DEBUG_SECTION_MISMATCH
 	bool "Enable full Section mismatch analysis"
 	depends on CC_IS_GCC
 	help
-	  The section mismatch analysis checks if there are illegal
-	  references from one section to another section.
-	  During linktime or runtime, some sections are dropped;
-	  any use of code/data previously in these sections would
-	  most likely result in an oops.
-	  In the code, functions and variables are annotated with
-	  __init,, etc. (see the full list in include/linux/init.h),
-	  which results in the code/data being placed in specific sections.
+	  The section mismatch analysis checks if there are illegal references
+	  from one section to another. During linktime or runtime, some
+	  sections are dropped; any use of code/data previously in these
+	  sections would most likely result in an oops.
+
+	  In the code, functions and variables are annotated with __init,
+	  __initdata, and so on (see the full list in include/linux/init.h).
+	  This directs the toolchain to place code/data in specific sections.
+
 	  The section mismatch analysis is always performed after a full
-	  kernel build, and enabling this option causes the following
-	  additional step to occur:
-	  - Add the option -fno-inline-functions-called-once to gcc commands.
-	    When inlining a function annotated with __init in a non-init
-	    function, we would lose the section information and thus
-	    the analysis would not catch the illegal reference.
-	    This option tells gcc to inline less (but it does result in
-	    a larger kernel).
+	  kernel build, and enabling this option causes the option
+	  -fno-inline-functions-called-once to be added to gcc commands.
+
+	  However, when inlining a function annotated with __init in
+	  a non-init function, we would lose the section information and thus
+	  the analysis would not catch the illegal reference.  This option
+	  tells gcc to inline less (but it does result in a larger kernel).
 
 config SECTION_MISMATCH_WARN_ONLY
 	bool "Make section mismatch errors non-fatal"
_

Patches currently in -mm which might be from bp@alien8.de are

lib-kconfigdebug-cleanup-config_debug_section_mismatch-help-text.patch

