Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6E7372624
	for <mm-commits@vger.kernel.org>; Mon, 23 Jun 2025 21:53:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750715600; cv=none; b=RyinrYUBvrunij6/oxheBWqpJfovilbIFQdw8dyb8m8cNDmMM5xmLWjy4kMPpjrt1ekE7anD/tnhEIJwNgE4veGjC3100P6pffPBJg7z3TcFdzMxL2OloNVYPial04BErGXhYhNBiVLpUAPiCg+qrfNt6n+Z0yCTCKNcDj10k+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750715600; c=relaxed/simple;
	bh=Md65WxmIrKw6QMr0RyYLIHQFibx/ADAQ1/pj44Lv57A=;
	h=Date:To:From:Subject:Message-Id; b=ASufOu4zKU4tpeOuZf7sO36v20HE/ywlIijAuKEECW76DfnGR5qNlk4DIQt0Lc06d1XTGBRS7BLL1d6R2QtD2KAD6qHT6uAkBWi4eDz2untYq4jHoqXEKauzpgHm9HMBECGAi5Ks6qY61pYjpwuG5fi1T6p8d3L63z1Qsw3YLZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=N+13AWs/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="N+13AWs/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83F52C4CEEA;
	Mon, 23 Jun 2025 21:53:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1750715600;
	bh=Md65WxmIrKw6QMr0RyYLIHQFibx/ADAQ1/pj44Lv57A=;
	h=Date:To:From:Subject:From;
	b=N+13AWs/xNlw+YAH3DXyk0x9rEDNEj5LbsUa8XjgV+mwLgQU/A2kwlhDlfg8SJ3SW
	 4/keDrAcCAf4B4qJ9xIlbIzewRjtb8I+nkP7Uq2jjb5dYfQnrhuUE32d6HouGRMR+d
	 BvBipyRW0Uytuuo4lVSz1EtGtXuFq1dfGdo3LX8Y=
Date: Mon, 23 Jun 2025 14:53:19 -0700
To: mm-commits@vger.kernel.org,surenb@google.com,harry.yoo@oracle.com,00107082@163.com,urezki@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-test_vmallocc-restrict-default-test-mask-to-avoid-test-warnings.patch added to mm-new branch
Message-Id: <20250623215320.83F52C4CEEA@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib/test_vmalloc.c: restrict default test mask to avoid test warnings
has been added to the -mm mm-new branch.  Its filename is
     lib-test_vmallocc-restrict-default-test-mask-to-avoid-test-warnings.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-test_vmallocc-restrict-default-test-mask-to-avoid-test-warnings.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Subject: lib/test_vmalloc.c: restrict default test mask to avoid test warnings
Date: Mon, 23 Jun 2025 20:40:35 +0200

When the vmalloc test is built into the kernel, it runs automatically
during the boot.  The current-default "run_test_mask" includes all test
cases, including those which are designed to fail and which trigger kernel
warnings.

These kernel splats can be misinterpreted as actual kernel bugs, leading
to false alarms and unnecessary reports.

To address this, limit the default test mask to only the first few tests
which are expected to pass cleanly.  These tests are safe and should not
generate any warnings unless there is a real bug.

Users who wish to explicitly run specific test cases have to pass the
run_test_mask as a boot parameter or at module load time.

Link: https://lkml.kernel.org/r/20250623184035.581229-2-urezki@gmail.com
Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Cc: Harry Yoo <harry.yoo@oracle.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: David Wang <00107082@163.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_vmalloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/test_vmalloc.c~lib-test_vmallocc-restrict-default-test-mask-to-avoid-test-warnings
+++ a/lib/test_vmalloc.c
@@ -41,7 +41,7 @@ __param(int, nr_pages, 0,
 __param(bool, use_huge, false,
 	"Use vmalloc_huge in fix_size_alloc_test");
 
-__param(int, run_test_mask, INT_MAX,
+__param(int, run_test_mask, 7,
 	"Set tests specified in the mask.\n\n"
 		"\t\tid: 1,    name: fix_size_alloc_test\n"
 		"\t\tid: 2,    name: full_fit_alloc_test\n"
_

Patches currently in -mm which might be from urezki@gmail.com are

lib-test_vmallocc-use-late_initcall-if-built-in-for-init-ordering.patch
lib-test_vmallocc-restrict-default-test-mask-to-avoid-test-warnings.patch

