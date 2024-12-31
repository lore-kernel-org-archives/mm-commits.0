Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 128B413C9DE;
	Tue, 31 Dec 2024 02:00:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735610403; cv=none; b=ifExVAYvMwyzKmZgiXPoGpOFsv+aHrLVLLgylpdR87hy63pCkCDJdnYR6ANf1MitRyLWQ7Nh/FJ9/zFvhhuUr9ICCmIjrKPdkFBl/tDokX3g7+nxalRxQpRHRJxE0O79rIeEGmtH2kcelGEifUiqKMlyDFE8I5AeuOw2M403J00=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735610403; c=relaxed/simple;
	bh=8QEcNhdnOvz8ra6ZNf4/GAow6KKFT1LyPZef7h+f8/Q=;
	h=Date:To:From:Subject:Message-Id; b=ucCloZjB0mK52v8Z4qhRGCXFjPbsXqjSiRBbfwfqbcdmuhBeRJ+V8pHGhIG06lqCZsEm/xSeLrshkQdISZGKookT8DE/fMZenS5kVHEHlXlPVi9ELR0LjE0RmD2JPKoQDAVFNi3E8XG18G20p4PqQHj2M7RTuD9FblTGCXBFhNg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=hGkASxmM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="hGkASxmM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A58CFC4CED0;
	Tue, 31 Dec 2024 02:00:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1735610402;
	bh=8QEcNhdnOvz8ra6ZNf4/GAow6KKFT1LyPZef7h+f8/Q=;
	h=Date:To:From:Subject:From;
	b=hGkASxmMPb5FdE9CtIru07Uo+G/ztcuifYwzd8vczAZ6yCFypyrEPIord6Kfeb2U5
	 2oRd4J1w1oE44E1pyLfdrYrZgwSL6Pj5psSBds3+LlCLa4dJleVNhyUotplvEDvo6R
	 aHt6dTK16s+ZKvBIeJrYqgVu3V8yi/BAJheyehoA=
Date: Mon, 30 Dec 2024 18:00:02 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,peterz@infradead.org,nogikh@google.com,jpoimboe@kernel.org,elver@google.com,dvyukov@google.com,andreyknvl@gmail.com,arnd@arndb.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] kcov-mark-in_softirq_really-as-__always_inline.patch removed from -mm tree
Message-Id: <20241231020002.A58CFC4CED0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kcov: mark in_softirq_really() as __always_inline
has been removed from the -mm tree.  Its filename was
     kcov-mark-in_softirq_really-as-__always_inline.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


