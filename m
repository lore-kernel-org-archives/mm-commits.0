Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58ABD1448DC;
	Tue, 17 Dec 2024 18:08:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734458922; cv=none; b=ty7s6yhMNA/T1QwHIYBo+VV6TCyq2SjC8br5PtEqp431PZhj0q6y+wy/RHhm5ULRyk3ZEbaBQomVD+BuIdQdaZw2yrdpvaKmaqnS/+fQHZqwv4TJasPtnkUTTQ1ELB2ayAwFtVvyCu5Pv+Xdzp/zx2oO65birb7+Hk/p1CW5b4I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734458922; c=relaxed/simple;
	bh=5gdAGPUlydPDv2YKuXgrnuzBVCXJJ83iBQDDjmgQI0k=;
	h=Date:To:From:Subject:Message-Id; b=t57qiCUOF+yP7EpBmK11fBtD8WZo7t5/DQIXTuoFaTkGyh15uQjO5Yms9c6pQ3/DQIlsHwQOX/UHHs3zO44w2VGJUO1bCAmckPJgMs/m58lkvas0gwlvUMGVUvpKge47d4OUbNThqHooZCn0dM62jCXWAERcGzQQg1G39QL9CO4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=g1NKti2G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="g1NKti2G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1EEDC4CED3;
	Tue, 17 Dec 2024 18:08:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1734458921;
	bh=5gdAGPUlydPDv2YKuXgrnuzBVCXJJ83iBQDDjmgQI0k=;
	h=Date:To:From:Subject:From;
	b=g1NKti2GaXpsMd00zOzgFU4xZCNp3TlC5WBSh4cVXUNeJLoIU/1q4y0xRZ3iEtzzd
	 5yYqbpm/byuwJrW/irXd1b+AZkb9D4XOIXEkWdlHh2L2lfDbAnx9XYIP6y2n54/JFo
	 zpxbXFuweC7m6vPVm6K5yROjhmTz8fC3q3zT3LV4=
Date: Tue, 17 Dec 2024 10:08:41 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,peterz@infradead.org,nogikh@google.com,jpoimboe@kernel.org,elver@google.com,dvyukov@google.com,andreyknvl@gmail.com,arnd@arndb.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kcov-mark-in_softirq_really-as-__always_inline.patch added to mm-hotfixes-unstable branch
Message-Id: <20241217180841.B1EEDC4CED3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kcov: mark in_softirq_really() as __always_inline
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     kcov-mark-in_softirq_really-as-__always_inline.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kcov-mark-in_softirq_really-as-__always_inline.patch

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
From: Arnd Bergmann <arnd@arndb.de>
Subject: kcov: mark in_softirq_really() as __always_inline
Date: Tue, 17 Dec 2024 08:18:10 +0100

If gcc decides not to inline in_softirq_really(), objtool warns about a
function call with UACCESS enabled:

kernel/kcov.o: warning: objtool: __sanitizer_cov_trace_pc+0x1e: call to in_softirq_really() with UACCESS enabled
kernel/kcov.o: warning: objtool: check_kcov_mode+0x11: call to in_softirq_really() with UACCESS enabled

Mark this as __always_inline to avoid the problem.

Link: https://lkml.kernel.org/r/20241217071814.2261620-1-arnd@kernel.org
Fixes: 7d4df2dad312 ("kcov: properly check for softirq context")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Marco Elver <elver@google.com>
Cc: Aleksandr Nogikh <nogikh@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kcov.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/kcov.c~kcov-mark-in_softirq_really-as-__always_inline
+++ a/kernel/kcov.c
@@ -166,7 +166,7 @@ static void kcov_remote_area_put(struct
  * Unlike in_serving_softirq(), this function returns false when called during
  * a hardirq or an NMI that happened in the softirq context.
  */
-static inline bool in_softirq_really(void)
+static __always_inline bool in_softirq_really(void)
 {
 	return in_serving_softirq() && !in_hardirq() && !in_nmi();
 }
_

Patches currently in -mm which might be from arnd@arndb.de are

kcov-mark-in_softirq_really-as-__always_inline.patch

