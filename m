Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB2CA3AC0FB
	for <mm-commits@vger.kernel.org>; Mon, 18 May 2026 22:27:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779143272; cv=none; b=NNCpRzOz3qiq114dxP7Za2my59BJ/tiCBT2nstajjOLShKtV1Xb03WnEX0d98ptrDUnsARfZqG7Tjw3dsWIlxDV3PSgj01S9Pekv4PdNTkEsbSzoWYV1cDtTny1qtiAzfMY4OoPZCf93OKOg66ErKIxIyM22pgSts219D+tUUck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779143272; c=relaxed/simple;
	bh=SsPTgllf+YZYFJfaQMrcA8yyV4XpLJWFVNKrMoFSgn0=;
	h=Date:To:From:Subject:Message-Id; b=f6w2a3dJjbFFvbpF15LAZrxKXsG6IayA5VGOXZI44nOQRBrVe5nW7TlTn1YMwTLjJhexpnq27APZ9fBwWH01qON0OlJvYEKA1JqYPbZ3duIHyCga2QokWwblFPst8JQw0I81S6rBzPggqEcxyxCMtGcXXCNw5zGnONx4JZ2RrvA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=FX9/gQef; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FX9/gQef"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77743C2BCB7;
	Mon, 18 May 2026 22:27:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1779143272;
	bh=SsPTgllf+YZYFJfaQMrcA8yyV4XpLJWFVNKrMoFSgn0=;
	h=Date:To:From:Subject:From;
	b=FX9/gQefkwnm6QdiVvTrv0xI+Tb8Gzb5CpVmANiyv72dNdVFu/0YhKmVyoPy2gtcc
	 Bp/wkyUX3eZQdXFu/BEC8kTVI3m5nNy4pvkejhkU+5jKI8ZYPlZEF3+bdcTuaScIcj
	 zUqN6YXLh/x+74ORqnRtlFU7YLjI5PtBbSRxk2es=
Date: Mon, 18 May 2026 15:27:51 -0700
To: mm-commits@vger.kernel.org,vincenzo.frascino@arm.com,ryabinin.a.a@gmail.com,glider@google.com,dvyukov@google.com,andreyknvl@gmail.com,wsw9603@163.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kasan-test-only-do-kmalloc_double_kzfree-for-generic-mode.patch added to mm-new branch
Message-Id: <20260518222752.77743C2BCB7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kasan/test: only do kmalloc_double_kzfree for generic mode
has been added to the -mm mm-new branch.  Its filename is
     kasan-test-only-do-kmalloc_double_kzfree-for-generic-mode.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kasan-test-only-do-kmalloc_double_kzfree-for-generic-mode.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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
From: Wang Wensheng <wsw9603@163.com>
Subject: kasan/test: only do kmalloc_double_kzfree for generic mode
Date: Sun, 17 May 2026 15:17:13 +0800

kmalloc_double_kzfree() would corrupt kernel memory when the just freed
memory were allocated by another thread before the second call to
kfree_sensitive().

This could not happen in GENERIC mode as it uses quarantine.

Link: https://lore.kernel.org/20260517071713.353579-1-wsw9603@163.com
Signed-off-by: Wang Wensheng <wsw9603@163.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/kasan_test_c.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/mm/kasan/kasan_test_c.c~kasan-test-only-do-kmalloc_double_kzfree-for-generic-mode
+++ a/mm/kasan/kasan_test_c.c
@@ -874,6 +874,12 @@ static void kmalloc_double_kzfree(struct
 	char *ptr;
 	size_t size = 16;
 
+	/*
+	 * Only generic KASAN uses quarantine, which could prevent the just freed
+	 * memory from being allocated soon.
+	 */
+	KASAN_TEST_NEEDS_CONFIG_ON(test, CONFIG_KASAN_GENERIC);
+
 	ptr = kmalloc(size, GFP_KERNEL);
 	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, ptr);
 
_

Patches currently in -mm which might be from wsw9603@163.com are

kasan-test-only-do-kmalloc_double_kzfree-for-generic-mode.patch

