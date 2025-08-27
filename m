Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73392238D52
	for <mm-commits@vger.kernel.org>; Wed, 27 Aug 2025 03:25:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756265108; cv=none; b=DQ4QF5MISXsBmYT6PKUTdxy/QiewapjNNhc1oW/QERg/Vx9jUGija0B3nXkz204xO/XPpiysbXsE+633Z9m4tmOIJtogTQrsn58hFnjOqApp9KzynRfg66rXo0RgL6UD6ZX+RxrGKjm1nPF6XoOLlV7fm8B782oQWpvgLbgIRT4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756265108; c=relaxed/simple;
	bh=JcxMz0FMdDoChwbeKDzlYEpVF3ucTOoV5knqBnfzXnw=;
	h=Date:To:From:Subject:Message-Id; b=g9IWoTMEOzwfpRfq/LRzxYbkjVZ5Hki2/pV4cGm6qH0v4nOBrgCOS3owTO89qSjSEqSg0Y/+cSQBfeGnLKaYiwp7PBn4dPjNmgEDjWWLZqopq8BD7oEmKThdK73rbMm4wE27O/825b1F3K1h2GFLcXLaym4nXkg1qxcvgNcbrHc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=j6HHQJ0H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="j6HHQJ0H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1989C4CEEB;
	Wed, 27 Aug 2025 03:25:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1756265107;
	bh=JcxMz0FMdDoChwbeKDzlYEpVF3ucTOoV5knqBnfzXnw=;
	h=Date:To:From:Subject:From;
	b=j6HHQJ0HmPecNI3rvy02ZwvF/bqGx1Zx8rzZM1mGLfda0LLi+0/2J0ifqd9uNHy1P
	 6QnmqXptOtm+s3BnmYIETpqzl5Cb+7JYUWykzurTIPNN0vwb8DvUewOYhsVZP5QcMu
	 yQNaLn8Ut82iF/igtS/XaitDP9LR2Gnzzu95JgXo=
Date: Tue, 26 Aug 2025 20:25:07 -0700
To: mm-commits@vger.kernel.org,david@redhat.com,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + memblock-fix-kernel-doc-for-memblock_rsrv_noinit.patch added to mm-unstable branch
Message-Id: <20250827032507.C1989C4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: memblock: fix kernel-doc for MEMBLOCK_RSRV_NOINIT
has been added to the -mm mm-unstable branch.  Its filename is
     memblock-fix-kernel-doc-for-memblock_rsrv_noinit.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/memblock-fix-kernel-doc-for-memblock_rsrv_noinit.patch

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
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: memblock: fix kernel-doc for MEMBLOCK_RSRV_NOINIT
Date: Tue, 26 Aug 2025 10:19:46 +0300

The kernel-doc description of MEMBLOCK_RSRV_NOINIT and
memblock_reserved_mark_noinit() do not accurately describe their
functionality.

Expand their kernel doc to make it clear that the user of
MEMBLOCK_RSRV_NOINIT is responsible to properly initialize the struct
pages for such regions and add more details about effects of using this
flag.

Link: https://lkml.kernel.org/r/20250826071947.1949725-1-rppt@kernel.org
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memblock.h |    5 +++--
 mm/memblock.c            |   15 +++++++++++----
 2 files changed, 14 insertions(+), 6 deletions(-)

--- a/include/linux/memblock.h~memblock-fix-kernel-doc-for-memblock_rsrv_noinit
+++ a/include/linux/memblock.h
@@ -40,8 +40,9 @@ extern unsigned long long max_possible_p
  * via a driver, and never indicated in the firmware-provided memory map as
  * system RAM. This corresponds to IORESOURCE_SYSRAM_DRIVER_MANAGED in the
  * kernel resource tree.
- * @MEMBLOCK_RSRV_NOINIT: memory region for which struct pages are
- * not initialized (only for reserved regions).
+ * @MEMBLOCK_RSRV_NOINIT: reserved memory region for which struct pages are not
+ * fully initialized. Users of this flag are responsible to properly initialize
+ * struct pages of this region
  * @MEMBLOCK_RSRV_KERN: memory region that is reserved for kernel use,
  * either explictitly with memblock_reserve_kern() or via memblock
  * allocation APIs. All memblock allocations set this flag.
--- a/mm/memblock.c~memblock-fix-kernel-doc-for-memblock_rsrv_noinit
+++ a/mm/memblock.c
@@ -1091,13 +1091,20 @@ int __init_memblock memblock_clear_nomap
 
 /**
  * memblock_reserved_mark_noinit - Mark a reserved memory region with flag
- * MEMBLOCK_RSRV_NOINIT which results in the struct pages not being initialized
- * for this region.
+ * MEMBLOCK_RSRV_NOINIT
+ *
  * @base: the base phys addr of the region
  * @size: the size of the region
  *
- * struct pages will not be initialized for reserved memory regions marked with
- * %MEMBLOCK_RSRV_NOINIT.
+ * The struct pages for the reserved regions marked %MEMBLOCK_RSRV_NOINIT will
+ * not be fully initialized to allow the caller optimize their initialization.
+ *
+ * When %CONFIG_DEFERRED_STRUCT_PAGE_INIT is enabled, setting this flag
+ * completely bypasses the initialization of struct pages for such region.
+ *
+ * When %CONFIG_DEFERRED_STRUCT_PAGE_INIT is disabled, struct pages in this
+ * region will be initialized with default values but won't be marked as
+ * reserved.
  *
  * Return: 0 on success, -errno on failure.
  */
_

Patches currently in -mm which might be from rppt@kernel.org are

init-mainc-fix-boot-time-tracing-crash.patch
kho-allow-scratch-areas-with-zero-size.patch
lib-test_kho-fixes-for-error-handling.patch
selftest-kho-update-generation-of-initrd.patch
memblock-fix-kernel-doc-for-memblock_rsrv_noinit.patch

