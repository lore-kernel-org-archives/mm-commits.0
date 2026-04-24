Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FF431C861D
	for <mm-commits@vger.kernel.org>; Fri, 24 Apr 2026 19:42:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777059732; cv=none; b=NxuCqZxirbzUUS4x5trBTMD81vZBSYrsHzRNDoaYpJX9xKdXm4Y4DQfZ5WcJi6sBcOpYEUGYktBJD+h8uqBnqIO2mRPr6/tLTrVEsNarDgXL6nF6kC5acvROH8kZcyWIWkk97t+go6Tbkm7j6/8kM+5izuhYrKEl3GHJJzxP8LA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777059732; c=relaxed/simple;
	bh=Yohmi+UQvTOvQOzgSUlcRUIv2AhYb+NeJ1OcQ95Yeow=;
	h=Date:To:From:Subject:Message-Id; b=kef1O2P862HPy2CMLgytVLRFOCwK7pn+2c3xExe313MttEClFfT46ZcVgIie56QjMRGe66ZL/E2Gbw1+HjgI1652/fc1bVZM2c13goxBZ0G/4WzFKaf75tdqYvGyDDGE2ESDIJESRCJdQIXcL8JOWo8fo/zicumvH4pi41DbtVw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=OmU5TscG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="OmU5TscG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C62A6C19425;
	Fri, 24 Apr 2026 19:42:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777059731;
	bh=Yohmi+UQvTOvQOzgSUlcRUIv2AhYb+NeJ1OcQ95Yeow=;
	h=Date:To:From:Subject:From;
	b=OmU5TscGIGuUoabbAIXzE1Nvb8+ZfTs0p88Gp7FROF0c0Q4NguC2MGLwJZHwjhy3t
	 KCOIePw78leWI5yTq66/0kvVvGtBMKqTdOPedM9Em/rN3InSnPxkhCNGbeXcfYi1s4
	 LTHXSWLjTqtS/qbJBQmO8gOi8ON3i3qIOB1/H324=
Date: Fri, 24 Apr 2026 12:42:11 -0700
To: mm-commits@vger.kernel.org,pmladek@suse.com,peterz@infradead.org,nsc@kernel.org,nathan@kernel.org,kees@kernel.org,jpoimboe@kernel.org,elver@google.com,dmitry.torokhov@gmail.com,andriy.shevchenko@linux.intel.com,arnd@arndb.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + inith-discard-exitcall-symbols-early.patch added to mm-nonmm-unstable branch
Message-Id: <20260424194211.C62A6C19425@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: init.h: discard exitcall symbols early
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     inith-discard-exitcall-symbols-early.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/inith-discard-exitcall-symbols-early.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Arnd Bergmann <arnd@arndb.de>
Subject: init.h: discard exitcall symbols early
Date: Tue, 31 Mar 2026 16:28:38 +0200

Any __exitcall() and built-in module_exit() handler is marked as __used,
which leads to the code being included in the object file and later
discarded at link time.

As far as I can tell, this was originally added at the same time as
initcalls were marked the same way, to prevent them from getting dropped
with gcc-3.4, but it was never actaully necessary to keep exit functions
around.

Mark them as __maybe_unused instead, which lets the compiler treat the
exitcalls as entirely unused, and make better decisions about dropping
specializing static functions called from these.

Link: https://lore.kernel.org/all/acruxMNdnUlyRHiy@google.com/
Link: https://lore.kernel.org/20260331142846.3187706-1-arnd@kernel.org
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Nicolas Schier <nsc@kernel.org>
Cc: Andriy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: Kees Cook <kees@kernel.org>
Cc: Marco Elver <elver@google.com>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Petr Mladek <pmladek@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/init.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/init.h~inith-discard-exitcall-symbols-early
+++ a/include/linux/init.h
@@ -47,7 +47,7 @@
 #define __initdata	__section(".init.data")
 #define __initconst	__section(".init.rodata")
 #define __exitdata	__section(".exit.data")
-#define __exit_call	__used __section(".exitcall.exit")
+#define __exit_call	__maybe_unused __section(".exitcall.exit")
 
 /*
  * modpost check for section mismatches during the kernel build.
_

Patches currently in -mm which might be from arnd@arndb.de are

inith-discard-exitcall-symbols-early.patch

