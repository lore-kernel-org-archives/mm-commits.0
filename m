Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DE76194A61
	for <mm-commits@vger.kernel.org>; Mon, 30 Sep 2024 16:24:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727713476; cv=none; b=s6PQ20YhRmhnIkG0t9vdknrwe8i44VLKm023zsiNth5tWBW2bwd1Y5wHlJjIcBLzZfflzVZvyCt/XYvAypJ1bc1WmdLb/jgHULZ0mzMymGuV6X7Udp01LnZayI7xI6SI/VZHZS6smT4l8bMam8OVgSgwJastYLh+ubUGsw4iMis=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727713476; c=relaxed/simple;
	bh=vnJhOuGvJyYlh9vYeDV1ssS1UcVJCwvdeXbEAQhTpMU=;
	h=Date:To:From:Subject:Message-Id; b=OlP2zL3fDr10MWXwJScL+2ZuTSbznDrq+sGaNVV2ftvVCqox+NaDxZCtCx18aNiLDrQodHJYvNOlUKvY2MDE5yORhQyJekTCJQxiYsgqgzOhf99RaTW1qhsSZzYFit/TyabFw28ksQIHTBt0+C8Una9RUJr9kqiBlajeZ4wBFc0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=wgOhsjt6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wgOhsjt6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B6CBC4CED0;
	Mon, 30 Sep 2024 16:24:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1727713475;
	bh=vnJhOuGvJyYlh9vYeDV1ssS1UcVJCwvdeXbEAQhTpMU=;
	h=Date:To:From:Subject:From;
	b=wgOhsjt6vt25pCaF4shTs7bqCxme5Qzld5SLB+2I8P1L3tUvcQ+XBSNRNpP2KeA6H
	 KBQVpkojZVVcB+cwMSaUZ+U5fpIpbZRkbL2YyjKne1tCcgkdF1cFy2UfKvF0rx3Bc4
	 iQnIbckE79gdSWRRuZXOzLO0+jS+UXul335s01IU=
Date: Mon, 30 Sep 2024 09:24:35 -0700
To: mm-commits@vger.kernel.org,dvyukov@google.com,andreyknvl@gmail.com,snovitoll@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-instrument-copy_from-to_kernel_nofault-fix.patch added to mm-unstable branch
Message-Id: <20240930162435.9B6CBC4CED0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm, kasan: proper instrument _kernel_nofault
has been added to the -mm mm-unstable branch.  Its filename is
     mm-instrument-copy_from-to_kernel_nofault-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-instrument-copy_from-to_kernel_nofault-fix.patch

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
From: Sabyrzhan Tasbolatov <snovitoll@gmail.com>
Subject: mm, kasan: proper instrument _kernel_nofault
Date: Mon, 30 Sep 2024 15:24:05 +0500

In commit 88ad9dc30bbf("mm, kasan: instrument
copy_from/to_kernel_nofault"), both src and dst were checked which might
lead to the false-positive reports.

Regular instrument_read() for copy_from and instrument_write() for copy_to
triggers KASAN reports in mm/kasan_test_c.c
copy_from_to_kernel_nofault_oob() kunit test.

Tested on x86_64, arm64 with CONFIG_KASAN_SW_TAGS using the latest
linux-next tree, where this commit has been merged today.

Link: https://lkml.kernel.org/r/20240930102405.2227124-1-snovitoll@gmail.com
Signed-off-by: Sabyrzhan Tasbolatov <snovitoll@gmail.com>
Reported-by: Dmitry Vyukov <dvyukov@google.com>
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=210505
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/maccess.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/mm/maccess.c~mm-instrument-copy_from-to_kernel_nofault-fix
+++ a/mm/maccess.c
@@ -32,7 +32,7 @@ long copy_from_kernel_nofault(void *dst,
 		return -ERANGE;
 
 	pagefault_disable();
-	instrument_memcpy_before(dst, src, size);
+	instrument_read(src, size);
 	if (!(align & 7))
 		copy_from_kernel_nofault_loop(dst, src, size, u64, Efault);
 	if (!(align & 3))
@@ -40,7 +40,6 @@ long copy_from_kernel_nofault(void *dst,
 	if (!(align & 1))
 		copy_from_kernel_nofault_loop(dst, src, size, u16, Efault);
 	copy_from_kernel_nofault_loop(dst, src, size, u8, Efault);
-	instrument_memcpy_after(dst, src, size, 0);
 	pagefault_enable();
 	return 0;
 Efault:
@@ -65,7 +64,7 @@ long copy_to_kernel_nofault(void *dst, c
 		align = (unsigned long)dst | (unsigned long)src;
 
 	pagefault_disable();
-	instrument_memcpy_before(dst, src, size);
+	instrument_write(dst, size);
 	if (!(align & 7))
 		copy_to_kernel_nofault_loop(dst, src, size, u64, Efault);
 	if (!(align & 3))
@@ -73,7 +72,6 @@ long copy_to_kernel_nofault(void *dst, c
 	if (!(align & 1))
 		copy_to_kernel_nofault_loop(dst, src, size, u16, Efault);
 	copy_to_kernel_nofault_loop(dst, src, size, u8, Efault);
-	instrument_memcpy_after(dst, src, size, 0);
 	pagefault_enable();
 	return 0;
 Efault:
_

Patches currently in -mm which might be from snovitoll@gmail.com are

mm-instrument-copy_from-to_kernel_nofault.patch
mm-instrument-copy_from-to_kernel_nofault-fix.patch

