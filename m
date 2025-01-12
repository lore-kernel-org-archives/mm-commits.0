Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 250BA33F7
	for <mm-commits@vger.kernel.org>; Sun, 12 Jan 2025 05:32:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736659973; cv=none; b=RhJvjTzj06RgPnU6OgaMSDtkDJ4WetVfe4VItK2tUrBIYCC7ZqYI09ouinQIHSRMRu4gsMvXCYmmu/vAlDB5b1EC9L+FjDCx9N2V1dz7FhhPPxE/rSkBxrFYDXYt00OJMm+w78FoTfKTWhKnoTcxyYwnReMnXLMzOCrEKhbv0X0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736659973; c=relaxed/simple;
	bh=RQr76rzyRBVC7TRb/958MB6bF9aAB9N27N+pd3X7t2c=;
	h=Date:To:From:Subject:Message-Id; b=ITY/+lMrnACT46MZOwxK4D+yc1q1syXVqvD9oURhixz+7gQzDJMoYqyzxAGTuzUrvSwcV9+7vINuiYR1sE1rVVu5T3HluvsJPnq1p2FTRO818gcQQhsa/3xnEQIyPoemGUqSbosDBQjCOJyxqHXE9R+VPMnaygMpH43CgJdcHrw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0DZ4nO0K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0DZ4nO0K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A474FC4CEE0;
	Sun, 12 Jan 2025 05:32:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736659972;
	bh=RQr76rzyRBVC7TRb/958MB6bF9aAB9N27N+pd3X7t2c=;
	h=Date:To:From:Subject:From;
	b=0DZ4nO0KRXaCfbKx5P9Fuq9fqzvuzPMLUMENaqBLfdWYKX/21IqsxwsGpL/iBCelz
	 3JXiSFTNfWhL3Ei1G9/hecHXbryW6wUOoNPvDj6z+u4KGNvMADXwOxUvvfDH7aA9a+
	 H+ASMLM2taKDzINvyb6qpjvyNhl2eJhryUPa7lH0=
Date: Sat, 11 Jan 2025 21:32:52 -0800
To: mm-commits@vger.kernel.org,vincenzo.frascino@arm.com,ryabinin.a.a@gmail.com,glider@google.com,dvyukov@google.com,andreyknvl@gmail.com,rdunlap@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kasan-use-correct-kernel-doc-format.patch added to mm-unstable branch
Message-Id: <20250112053252.A474FC4CEE0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kasan: use correct kernel-doc format
has been added to the -mm mm-unstable branch.  Its filename is
     kasan-use-correct-kernel-doc-format.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kasan-use-correct-kernel-doc-format.patch

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
Subject: kasan: use correct kernel-doc format
Date: Fri, 10 Jan 2025 22:32:49 -0800

Use the correct kernel-doc character following function parameters or
struct members (':' instead of '-') to eliminate kernel-doc warnings.

kasan.h:509: warning: Function parameter or struct member 'addr' not described in 'kasan_poison'
kasan.h:509: warning: Function parameter or struct member 'size' not described in 'kasan_poison'
kasan.h:509: warning: Function parameter or struct member 'value' not described in 'kasan_poison'
kasan.h:509: warning: Function parameter or struct member 'init' not described in 'kasan_poison'
kasan.h:522: warning: Function parameter or struct member 'addr' not described in 'kasan_unpoison'
kasan.h:522: warning: Function parameter or struct member 'size' not described in 'kasan_unpoison'
kasan.h:522: warning: Function parameter or struct member 'init' not described in 'kasan_unpoison'
kasan.h:539: warning: Function parameter or struct member 'address' not described in 'kasan_poison_last_granule'
kasan.h:539: warning: Function parameter or struct member 'size' not described in 'kasan_poison_last_granule'

Link: https://lkml.kernel.org/r/20250111063249.910975-1-rdunlap@infradead.org
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/kasan.h |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

--- a/mm/kasan/kasan.h~kasan-use-correct-kernel-doc-format
+++ a/mm/kasan/kasan.h
@@ -501,18 +501,18 @@ static inline bool kasan_byte_accessible
 
 /**
  * kasan_poison - mark the memory range as inaccessible
- * @addr - range start address, must be aligned to KASAN_GRANULE_SIZE
- * @size - range size, must be aligned to KASAN_GRANULE_SIZE
- * @value - value that's written to metadata for the range
- * @init - whether to initialize the memory range (only for hardware tag-based)
+ * @addr: range start address, must be aligned to KASAN_GRANULE_SIZE
+ * @size: range size, must be aligned to KASAN_GRANULE_SIZE
+ * @value: value that's written to metadata for the range
+ * @init: whether to initialize the memory range (only for hardware tag-based)
  */
 void kasan_poison(const void *addr, size_t size, u8 value, bool init);
 
 /**
  * kasan_unpoison - mark the memory range as accessible
- * @addr - range start address, must be aligned to KASAN_GRANULE_SIZE
- * @size - range size, can be unaligned
- * @init - whether to initialize the memory range (only for hardware tag-based)
+ * @addr: range start address, must be aligned to KASAN_GRANULE_SIZE
+ * @size: range size, can be unaligned
+ * @init: whether to initialize the memory range (only for hardware tag-based)
  *
  * For the tag-based modes, the @size gets aligned to KASAN_GRANULE_SIZE before
  * marking the range.
@@ -530,8 +530,8 @@ bool kasan_byte_accessible(const void *a
 /**
  * kasan_poison_last_granule - mark the last granule of the memory range as
  * inaccessible
- * @addr - range start address, must be aligned to KASAN_GRANULE_SIZE
- * @size - range size
+ * @address: range start address, must be aligned to KASAN_GRANULE_SIZE
+ * @size: range size
  *
  * This function is only available for the generic mode, as it's the only mode
  * that has partially poisoned memory granules.
_

Patches currently in -mm which might be from rdunlap@infradead.org are

mm-zsmalloc-fix-function-parameter-kernel-doc-notation.patch
kasan-use-correct-kernel-doc-format.patch

