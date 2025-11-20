Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 882BB23A9B3
	for <mm-commits@vger.kernel.org>; Thu, 20 Nov 2025 22:04:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763676259; cv=none; b=q2nVRg1nqYvDh+b9Ei7cMyjYCFDAOz9FTn5/BNo0I6/Vx4CNx0AiSGXHJFp4tdPfDS6N+c3tT9+scOtPCNgzJg2hS9YKA8OlZT5b6zkCfstvhwb8nKTZzmKMKtIZwOe6ZRocuaWjRROiC2D7rx6yo1kSbrSCDpPF43XA1zYhfIQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763676259; c=relaxed/simple;
	bh=mEU6zD179XAr6HL3qjAHiepxhQRS2TpkIsGeH6F+KNQ=;
	h=Date:To:From:Subject:Message-Id; b=av55FmCN+7BOclPYUJm58toGjio0t3mRlSZQC65PCI1HqvFgi6ahXdmmV7tGaXEc4CCpuopHjWHOwwN5vf5/KZcJ2YGuOg0uFNOF9cQ6a1hjcGUG7riwDDIUd5OVsT54J2s1VyEB1mvDqJJ9d5qVNxPBVJUxo3+V/Znsi8RQRAA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=uL4A7UhJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="uL4A7UhJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08DACC4CEF1;
	Thu, 20 Nov 2025 22:04:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763676259;
	bh=mEU6zD179XAr6HL3qjAHiepxhQRS2TpkIsGeH6F+KNQ=;
	h=Date:To:From:Subject:From;
	b=uL4A7UhJPErlMNL4wXp38/7QhyM8gXdB58MFJw24ZhZXcdfingXz/0oxOVakKQOqF
	 CBUipQi7U6g1NpP4Bc/cGHtTrkBcxdEOIgr38r7bvFiimtXEIHDws17LXWwzZrWobV
	 8PxlFEeYbAWeZ5Ffyzpy89ehlarC6Zc9Zb/t3IUE=
Date: Thu, 20 Nov 2025 14:04:18 -0800
To: mm-commits@vger.kernel.org,bp@alien8.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] lib-kconfigdebug-cleanup-config_debug_section_mismatch-help-text.patch removed from -mm tree
Message-Id: <20251120220419.08DACC4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: lib/Kconfig.debug: cleanup CONFIG_DEBUG_SECTION_MISMATCH help text
has been removed from the -mm tree.  Its filename was
     lib-kconfigdebug-cleanup-config_debug_section_mismatch-help-text.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


