Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81C054A7CBF;
	Thu, 17 Sep 2026 22:22:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789683772; cv=none; b=SYAdkQmKSvoKM/M/yvuZnSp9DuoZA4Jkw64zbzrUvW/9luZFrX//6AkAPHkpQx8T6lny98ayVa8gQdlAEvm1gOPRuaU0OqViF/panYWs26wF/XWpeZCBp/zAuxFhz7ln+HNGqyuTcNJe5PKz5faTIlYPefxMhUBQ3+daZwIFirg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789683772; c=relaxed/simple;
	bh=yl3bEdZWBwGjPVi4lZ537ug+Tkpi0akx5iqNL1iryGY=;
	h=Date:To:From:Subject:Message-Id; b=LqLd/4V9KUQTMMw4QQDbvS0g4k6NjOw0P0g+RonQ8GRieGKYF8do+G95I6Bfl4sLfdo10TS8j+qANbV0MiMKgjppWPHb9H//9oquJl/1mK+UyNY1PiqAy3LhLmt7o50i44/kaHmVgVvH+RPPR9fHzpw2efST5x0TvNMb9nn74P8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Psah268b; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Psah268b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5A981F000FF;
	Thu, 17 Sep 2026 22:22:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789683770;
	bh=O08KkwWLSId7tdgI2XXwZypsTpY8W7M6m8WT5KIfN1o=;
	h=Date:To:From:Subject;
	b=Psah268bbu1W0ejEpDCamdq3efgzee8nlilS/QmEJ0FXNlUeLDCQkw8VgcEhhsuDf
	 BrqgMriFXSN0EJxzhL2FOubrJi4v0eRpp4qxSVdvjgy3y6IKHre6PwXVqCDSDQbaNF
	 3S/aPiuMfBXI5pzfSe9Nc4j7by4OiWyfrx1Zl61k=
Date: Thu, 17 Sep 2026 15:22:50 -0700
To: mm-commits@vger.kernel.org,tchibo@google.com,stable@vger.kernel.org,glider@google.com,elver@google.com,dvyukov@google.com,andreyknvl@gmail.com,fangxy@xiaopeng.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kcov-ignore-an-out-of-range-comparison-count-in-write_comp_data.patch added to mm-nonmm-unstable branch
Message-Id: <20260917222250.D5A981F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kcov: ignore an out-of-range comparison count in write_comp_data()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     kcov-ignore-an-out-of-range-comparison-count-in-write_comp_data.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kcov-ignore-an-out-of-range-comparison-count-in-write_comp_data.patch

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
From: Fang Xieyan <fangxy@xiaopeng.com>
Subject: kcov: ignore an out-of-range comparison count in write_comp_data()
Date: Thu, 17 Sep 2026 18:43:06 +0800

write_comp_data() reads the comparison record count from area[0] and uses
it to index the coverage buffer:

	area = (u64 *)t->kcov_area;
	max_pos = t->kcov_size * sizeof(unsigned long);

	count = READ_ONCE(area[0]);

	/* Every record is KCOV_WORDS_PER_CMP 64-bit words. */
	start_index = 1 + count * KCOV_WORDS_PER_CMP;
	end_pos = (start_index + KCOV_WORDS_PER_CMP) * sizeof(u64);
	if (likely(end_pos <= max_pos)) {

The buffer is mmap'd writable into the collecting process, so count is
under its control and end_pos <= max_pos is its only bound.  A count that
wraps the u64 multiply leaves end_pos below max_pos, so the check passes
while the record store lands 24 bytes before the buffer, in the unmapped
vmalloc guard page, and faults:

  BUG: unable to handle page fault for address: ffa0000000b60fe8
  #PF: supervisor write access in kernel mode
  #PF: error_code(0x0002) - not-present page
  Oops: 0002 [#1] SMP KASAN NOPTI
  RIP: 0010:write_comp_data+0x7e/0xa0
  ...
  Kernel panic - not syncing: Fatal exception

Bound count first: only max_pos / (sizeof(u64) * KCOV_WORDS_PER_CMP)
records fit, so a larger count is not a valid index and is dropped. 
kcov_move_area() bounds the same untrusted count this way, and no count
the end_pos <= max_pos check accepts reaches that limit, so no valid
record is lost.

kcov is a root-only debugfs file (debugfs_create_file_unsafe("kcov", 0600,
...)) and write_comp_data() exists only under
CONFIG_KCOV_ENABLE_COMPARISONS, so this is a local, debug-kernel
robustness fix: the process corrupts its own buffer and the kernel oopses.
It crosses no privilege boundary.  Additonal details at [1]

Link: https://lore.kernel.org/20260917104306.22145-1-fangxy@xiaopeng.com [1]
Fixes: ded97d2c2b2c ("kcov: support comparison operands collection")
Signed-off-by: Fang Xieyan <fangxy@xiaopeng.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Assisted-by: Hawkeye:GLM-5.3-flash
Assisted-by: Qoder:Qwen3.8-Max
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Marco Elver <elver@google.com>
Cc: Victor Chibotaru <tchibo@google.com>
Cc: <stable@vger.kernel.org>
---

 kernel/kcov.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/kernel/kcov.c~kcov-ignore-an-out-of-range-comparison-count-in-write_comp_data
+++ a/kernel/kcov.c
@@ -253,6 +253,14 @@ static void notrace write_comp_data(u64
 
 	count = READ_ONCE(area[0]);
 
+	/*
+	 * area[0] is writable by the collecting process, so count cannot be
+	 * trusted. Bound it to the records that fit, as kcov_move_area()
+	 * does, so the end_pos multiply below cannot wrap past its check.
+	 */
+	if (count >= max_pos / (sizeof(u64) * KCOV_WORDS_PER_CMP))
+		return;
+
 	/* Every record is KCOV_WORDS_PER_CMP 64-bit words. */
 	start_index = 1 + count * KCOV_WORDS_PER_CMP;
 	end_pos = (start_index + KCOV_WORDS_PER_CMP) * sizeof(u64);
_

Patches currently in -mm which might be from fangxy@xiaopeng.com are

kcov-ignore-an-out-of-range-comparison-count-in-write_comp_data.patch

