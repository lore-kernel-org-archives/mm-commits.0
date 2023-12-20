Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8D1B4F5F2
	for <mm-commits@vger.kernel.org>; Wed, 20 Dec 2023 23:03:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="v8AX6OPc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DE82C433C7;
	Wed, 20 Dec 2023 23:03:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703113416;
	bh=diGnImF/a+iaJvbWIPUf6MFxEl+YgzkXOOfkfPrxvaU=;
	h=Date:To:From:Subject:From;
	b=v8AX6OPcPtPqikjtNTDiqUECuFqxuS9iKKPkrjeMRB1bWSVezZxAfriAq546f+lt3
	 cviPRT6vnAH490+cAia9Qmb3p5qezYt7OQpfG5nKjieIVGk5Wdt0YWfhQI8A6B3fjg
	 xgBmw1kDqXnLHQAfxh/GdzuZoegFigDggzxxiMxM=
Date: Wed, 20 Dec 2023 15:03:35 -0800
To: mm-commits@vger.kernel.org,dvyukov@google.com,bp@alien8.de,andreyknvl@gmail.com,alex.popov@linux.com,mark.rutland@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] kcov-remove-stale-randomize_base-text.patch removed from -mm tree
Message-Id: <20231220230336.6DE82C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kcov: remove stale RANDOMIZE_BASE text
has been removed from the -mm tree.  Its filename was
     kcov-remove-stale-randomize_base-text.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Mark Rutland <mark.rutland@arm.com>
Subject: kcov: remove stale RANDOMIZE_BASE text
Date: Mon, 4 Dec 2023 17:18:07 +0000

The Kconfig help text for CONFIG_KCOV describes that recorded PC values
will not be stable across machines or reboots when RANDOMIZE_BASE is
selected.  This was the case when KCOV was introduced in commit:

  5c9a8750a6409c63 ("kernel: add kcov code coverage")

However, this changed in commit:

  4983f0ab7ffaad1e ("kcov: make kcov work properly with KASLR enabled")

Since that commit KCOV always subtracts the KASLR offset from PC values,
which ensures that these are stable across machines and across reboots
even when RANDOMIZE_BASE is selected.

Unfortunately, that commit failed to update the Kconfig help text, which
still suggests disabling RANDOMIZE_BASE even though this is no longer
necessary.

Remove the stale Kconfig text.

Link: https://lkml.kernel.org/r/20231204171807.3313022-1-mark.rutland@arm.com
Reported-by: Borislav Petkov <bp@alien8.de>
Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Reviewed-by: Dmitry Vyukov <dvyukov@google.com>
Cc: Alexander Popov <alex.popov@linux.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Kconfig.debug |    4 ----
 1 file changed, 4 deletions(-)

--- a/lib/Kconfig.debug~kcov-remove-stale-randomize_base-text
+++ a/lib/Kconfig.debug
@@ -2103,10 +2103,6 @@ config KCOV
 	  KCOV exposes kernel code coverage information in a form suitable
 	  for coverage-guided fuzzing (randomized testing).
 
-	  If RANDOMIZE_BASE is enabled, PC values will not be stable across
-	  different machines and across reboots. If you need stable PC values,
-	  disable RANDOMIZE_BASE.
-
 	  For more details, see Documentation/dev-tools/kcov.rst.
 
 config KCOV_ENABLE_COMPARISONS
_

Patches currently in -mm which might be from mark.rutland@arm.com are


