Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D09368296
	for <mm-commits@vger.kernel.org>; Wed, 13 Dec 2023 20:16:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="TjW9Qnkf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07681C433C7;
	Wed, 13 Dec 2023 20:16:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702498565;
	bh=MTBP5rwxih/0xaWgaEQtnh3yWf8uNDVevAQ1xOGWMrs=;
	h=Date:To:From:Subject:From;
	b=TjW9QnkfXEam7zoqofR2FdepTuUAhFQqjVFEfno6Xx1OfwjuisMi7L6gptrNjyC6D
	 E2tivvEVwW4BojviBptYWuudxjlqRtRf3LuCISjEcZKvzNPHxp/b0T2neDtec1ymX7
	 5GAgxkfmGpos/mE4t37YZOSWAYsNKU6rBhP4Xe/Y=
Date: Wed, 13 Dec 2023 12:16:04 -0800
To: mm-commits@vger.kernel.org,rdunlap@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + gfp-gfp_typesh-fix-typos-punctuation.patch added to mm-unstable branch
Message-Id: <20231213201605.07681C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: gfp: gfp_types.h: fix typos & punctuation
has been added to the -mm mm-unstable branch.  Its filename is
     gfp-gfp_typesh-fix-typos-punctuation.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/gfp-gfp_typesh-fix-typos-punctuation.patch

This patch will later appear in the mm-unstable branch at
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
From: Randy Dunlap <rdunlap@infradead.org>
Subject: gfp: gfp_types.h: fix typos & punctuation
Date: Tue, 12 Dec 2023 20:33:16 -0800

Correct typos/spellos and punctutation.

Link: https://lkml.kernel.org/r/20231213043316.10128-1-rdunlap@infradead.org
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/gfp_types.h |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/include/linux/gfp_types.h~gfp-gfp_typesh-fix-typos-punctuation
+++ a/include/linux/gfp_types.h
@@ -162,25 +162,25 @@ typedef unsigned int __bitwise gfp_t;
  * %__GFP_RECLAIM is shorthand to allow/forbid both direct and kswapd reclaim.
  *
  * The default allocator behavior depends on the request size. We have a concept
- * of so called costly allocations (with order > %PAGE_ALLOC_COSTLY_ORDER).
+ * of so-called costly allocations (with order > %PAGE_ALLOC_COSTLY_ORDER).
  * !costly allocations are too essential to fail so they are implicitly
  * non-failing by default (with some exceptions like OOM victims might fail so
  * the caller still has to check for failures) while costly requests try to be
  * not disruptive and back off even without invoking the OOM killer.
  * The following three modifiers might be used to override some of these
- * implicit rules
+ * implicit rules.
  *
  * %__GFP_NORETRY: The VM implementation will try only very lightweight
  * memory direct reclaim to get some memory under memory pressure (thus
  * it can sleep). It will avoid disruptive actions like OOM killer. The
  * caller must handle the failure which is quite likely to happen under
  * heavy memory pressure. The flag is suitable when failure can easily be
- * handled at small cost, such as reduced throughput
+ * handled at small cost, such as reduced throughput.
  *
  * %__GFP_RETRY_MAYFAIL: The VM implementation will retry memory reclaim
  * procedures that have previously failed if there is some indication
- * that progress has been made else where.  It can wait for other
- * tasks to attempt high level approaches to freeing memory such as
+ * that progress has been made elsewhere.  It can wait for other
+ * tasks to attempt high-level approaches to freeing memory such as
  * compaction (which removes fragmentation) and page-out.
  * There is still a definite limit to the number of retries, but it is
  * a larger limit than with %__GFP_NORETRY.
@@ -230,7 +230,7 @@ typedef unsigned int __bitwise gfp_t;
  * is being zeroed (either via __GFP_ZERO or via init_on_alloc, provided that
  * __GFP_SKIP_ZERO is not set). This flag is intended for optimization: setting
  * memory tags at the same time as zeroing memory has minimal additional
- * performace impact.
+ * performance impact.
  *
  * %__GFP_SKIP_KASAN makes KASAN skip unpoisoning on page allocation.
  * Used for userspace and vmalloc pages; the latter are unpoisoned by
_

Patches currently in -mm which might be from rdunlap@infradead.org are

maple_tree-fix-typos-spellos-etc.patch
gfp-gfp_typesh-fix-typos-punctuation.patch
rapidio-tsi721-fix-kernel-doc-warnings.patch
freevxfs-bmap-fix-kernel-doc-warnings.patch
freevxfs-immed-fix-kernel-doc-param-name.patch
freevxfs-lookup-fix-function-params-kernel-doc.patch
init-kconfig-move-more-items-into-the-expert-menu.patch
usr-kconfig-fix-typos-of-its.patch

