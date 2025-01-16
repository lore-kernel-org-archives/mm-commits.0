Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 732FB189F43
	for <mm-commits@vger.kernel.org>; Thu, 16 Jan 2025 05:45:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737006303; cv=none; b=tdgTgNT1PU8SXb3kA22EloLM99oO11G40Djvr9oovbbjnqpfg5fvbqhBDdSo2qupjaQEdIFeGXgPgpMoBa/a0AbjtKB5g/Svz3xJVYyYi9EqEto0D1ocU+XBZFqT67DhNlLk5d7Vtp6Hz9WPqAq0fZ3etLhMOJAkIfAn9AQDX1Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737006303; c=relaxed/simple;
	bh=ihY/RXprxmAovTJB0bvc3owralY1VLQ7zUzK1V817SU=;
	h=Date:To:From:Subject:Message-Id; b=gDU8vnrtlHJ/oyZk0kcbI2YhmYmM61kY1A/1d6WpJhCKoKfc7zKLzEo953JCETQkq1/U9N6qTu3uKuiHUR/W8qR2TOi6mQF+E2Bq16F/5IQ2ThjRkvSo9Luxx/FDppaCcwc3IWWFIwSseYcgkZs6awhbYFuEMhJkl4QW50ccaWI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=VDbUsVgQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="VDbUsVgQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46EA0C4CED6;
	Thu, 16 Jan 2025 05:45:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1737006303;
	bh=ihY/RXprxmAovTJB0bvc3owralY1VLQ7zUzK1V817SU=;
	h=Date:To:From:Subject:From;
	b=VDbUsVgQFOI2R7q/x28Nq8mSSyCq691ZLnvrgAPkO8A/yiHvpeWON48fFHPM/ck8c
	 XrpWBfz4PV4U7URxNudaFczcjW4SqQnKIq+TmGqPUjkXeBLvIPqITer+8jPwK6NP9h
	 MkMh2hRDG/nYC5VGo/UXYCjau1ch/yG+ONgt3jJU=
Date: Wed, 15 Jan 2025 21:45:02 -0800
To: mm-commits@vger.kernel.org,vincenzo.frascino@arm.com,ryabinin.a.a@gmail.com,glider@google.com,dvyukov@google.com,andreyknvl@gmail.com,rdunlap@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] kasan-use-correct-kernel-doc-format.patch removed from -mm tree
Message-Id: <20250116054503.46EA0C4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kasan: use correct kernel-doc format
has been removed from the -mm tree.  Its filename was
     kasan-use-correct-kernel-doc-format.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Reviewed-by: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Alexander Potapenko <glider@google.com>
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

latencytop-use-correct-kernel-doc-format-for-func-params.patch
gcov-clang-use-correct-function-param-names.patch
ipc-utilc-complete-the-kernel-doc-function-descriptions.patch

