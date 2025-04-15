Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 879951FECA5
	for <mm-commits@vger.kernel.org>; Tue, 15 Apr 2025 01:23:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744680204; cv=none; b=SFLksrhGUUN2Az5k1xfbihxFDDjYcYeTAQFEwDZxBkxex2OhwIu86hpuB6xEb6VzCxFGPPNJ4S7PSReMNHX620K7ijuY+IlFNW5BlgUtIgVLc9ZkjV14l0M5Hx2m/wtI1bnapbwpu6XFbM3v/3KS7voHLVIJ60NUElUO8rwj038=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744680204; c=relaxed/simple;
	bh=d5R1uk0gk8zvoUkUgptSL/JNp4I6mO0I7rBG4I7DKyg=;
	h=Date:To:From:Subject:Message-Id; b=sQieIYAWzirZkeoluZlXc2jGZBPgdvR9fZpndpOnmZlFyvMFy3XZpcIvL0pzldZVOFMZh9t/MoiaNvbHt2VCHo+vRa0X0joiHSEpAQGhazS/PSqix91GUqgpQ6eDqvx7eBZFZ56c+2Awi0cO221YEKZWbbGUSZ/DgM+CsgEcnWw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=AbiJDYua; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="AbiJDYua"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB3E1C4CEE2;
	Tue, 15 Apr 2025 01:23:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1744680204;
	bh=d5R1uk0gk8zvoUkUgptSL/JNp4I6mO0I7rBG4I7DKyg=;
	h=Date:To:From:Subject:From;
	b=AbiJDYuaSjvcabQzprmxdVGlRUCvWo20OKK76nD2fjDFF3MounqeVqti6DQdljNmK
	 25SSQzc5gPX7GzQBQ03W1gevcA1zh6m8G5lEdp/H3ecLQcZjOAMiU/7mbOQj4yZoUO
	 Cv36ozDN4+TWqCqFJOB3szgQw74Rxd/bV4vz9KAg=
Date: Mon, 14 Apr 2025 18:23:23 -0700
To: mm-commits@vger.kernel.org,tglx@linutronix.de,samitolvanen@google.com,pmenzel@molgen.mpg.de,mingo@kernel.org,masahiroy@kernel.org,bp@alien8.de,ubizjak@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + compilerh-avoid-the-usage-of-__typeof_unqual__-when-__genksyms__-is-defined.patch added to mm-hotfixes-unstable branch
Message-Id: <20250415012323.DB3E1C4CEE2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: compiler.h: avoid the usage of __typeof_unqual__() when __GENKSYMS__ is defined
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     compilerh-avoid-the-usage-of-__typeof_unqual__-when-__genksyms__-is-defined.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/compilerh-avoid-the-usage-of-__typeof_unqual__-when-__genksyms__-is-defined.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Uros Bizjak <ubizjak@gmail.com>
Subject: compiler.h: avoid the usage of __typeof_unqual__() when __GENKSYMS__ is defined
Date: Fri, 4 Apr 2025 12:24:37 +0200

Current version of genksyms doesn't know anything about
__typeof_unqual__() operator.  Avoid the usage of __typeof_unqual__() with
genksyms to prevent errors when symbols are versioned.

There were no problems with gendwarfksyms.

Link: https://lkml.kernel.org/r/20250404102535.705090-1-ubizjak@gmail.com
Fixes: ac053946f5c40 ("compiler.h: introduce TYPEOF_UNQUAL() macro")
Signed-off-by: Uros Bizjak <ubizjak@gmail.com>
Reported-by: Paul Menzel <pmenzel@molgen.mpg.de>
Closes: https://lore.kernel.org/lkml/81a25a60-de78-43fb-b56a-131151e1c035@molgen.mpg.de/
Cc: Sami Tolvanen <samitolvanen@google.com>
Cc: Borislav Betkov <bp@alien8.de>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Cc: Paul Menzel <pmenzel@molgen.mpg.de>
Cc: Sami Tolvanen <samitolvanen@google.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Paul Menzel <pmenzel@molgen.mpg.de>
Cc: Thomas Gleinxer <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/compiler.h |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/include/linux/compiler.h~compilerh-avoid-the-usage-of-__typeof_unqual__-when-__genksyms__-is-defined
+++ a/include/linux/compiler.h
@@ -229,10 +229,10 @@ void ftrace_likely_update(struct ftrace_
 /*
  * Use __typeof_unqual__() when available.
  *
- * XXX: Remove test for __CHECKER__ once
- * sparse learns about __typeof_unqual__().
+ * XXX: Remove test for __GENKSYMS__ once "genksyms" handles
+ * __typeof_unqual__(), and test for __CHECKER__ once "sparse" handles it.
  */
-#if CC_HAS_TYPEOF_UNQUAL && !defined(__CHECKER__)
+#if CC_HAS_TYPEOF_UNQUAL && !defined(__GENKSYMS__) && !defined(__CHECKER__)
 # define USE_TYPEOF_UNQUAL 1
 #endif
 
_

Patches currently in -mm which might be from ubizjak@gmail.com are

compilerh-avoid-the-usage-of-__typeof_unqual__-when-__genksyms__-is-defined.patch

