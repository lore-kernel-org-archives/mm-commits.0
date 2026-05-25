Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0AEE3438B5
	for <mm-commits@vger.kernel.org>; Mon, 25 May 2026 22:06:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779746786; cv=none; b=PZCTdmQ+vIPVYeDf8U1/A4d8+xusg3zrYh4CrT2AuDgs8QiWTWQPEiANLJPU3MZ+FaTNc2da9EIuXF4CPaDSplteaHu/zFMTJHpPWjydL+JJWlxymseK9qwzzIBNwVfopOD84oMfjr82lEQZdKHlRGztq/hndj7M29EHli3Pw3I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779746786; c=relaxed/simple;
	bh=Hv/Z3ipR4682Y94B3vlDWcl2t3a3o3QsYUJRh5VGuHc=;
	h=Date:To:From:Subject:Message-Id; b=CeVcymaQHucODEI5fo3JrhtDF4iNTcEZpQwb6FLo4Ttr1fL59QlN3NA9jZaEgAGQuAxL8mtzicvOrkAdvO/eG8CBzLTBHGq2S0jvduNOXvg3HZT2xK//3do/bSwbMcAEfmcH/P4r/twJvsfuFAxWl0ySetJR5wYM/7Fhk6P0qQs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=LBanQNFz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="LBanQNFz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F4CA1F000E9;
	Mon, 25 May 2026 22:06:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1779746785;
	bh=yXmwysPGdl5RjO4QbAoV89VAwc6442OSUZSojxYP4J8=;
	h=Date:To:From:Subject;
	b=LBanQNFzuiT9Ty5CZg19LMQAiOmbq8gOLEeOmkxPniNztdakhiz5Xin5OeyYr+0b8
	 jIjtP5cvPRZ5jLkKusZCP0IxWj0DPCyxXejw+P+PDDQkOzFWjIa/zW7UR4QI6VOLBl
	 ZtfiRHtmrplWGBJ5x1JXW53e1j9kYyBtVs5P7878=
Date: Mon, 25 May 2026 15:06:24 -0700
To: mm-commits@vger.kernel.org,vincenzo.frascino@arm.com,ryabinin.a.a@gmail.com,glider@google.com,dvyukov@google.com,andreyknvl@gmail.com,wsw9603@163.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kasan-test-only-do-kmalloc_double_kzfree-for-generic-mode.patch added to mm-unstable branch
Message-Id: <20260525220625.2F4CA1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kasan/test: only do kmalloc_double_kzfree for generic mode
has been added to the -mm mm-unstable branch.  Its filename is
     kasan-test-only-do-kmalloc_double_kzfree-for-generic-mode.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kasan-test-only-do-kmalloc_double_kzfree-for-generic-mode.patch

This patch will later appear in the mm-unstable branch at
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
From: Wang Wensheng <wsw9603@163.com>
Subject: kasan/test: only do kmalloc_double_kzfree for generic mode
Date: Sun, 24 May 2026 11:10:53 +0800

kmalloc_double_kzfree() would corrupt kernel memory when the just freed
memory were allocated by another thread before the second call to
kfree_sensitive() and the new allocation tag happened to match the old
one.

This could not happen in GENERIC mode as it uses quarantine.

Link: https://lore.kernel.org/20260524031053.381776-1-wsw9603@163.com
Signed-off-by: Wang Wensheng <wsw9603@163.com>
Reviewed-by: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/kasan_test_c.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/mm/kasan/kasan_test_c.c~kasan-test-only-do-kmalloc_double_kzfree-for-generic-mode
+++ a/mm/kasan/kasan_test_c.c
@@ -874,6 +874,16 @@ static void kmalloc_double_kzfree(struct
 	char *ptr;
 	size_t size = 16;
 
+	/*
+	 * With the tag-based KASAN modes, if the memory happens to be
+	 * reallocated between the two frees and the new allocation tag happens
+	 * to match the old one, the second free will cause a memory corruption.
+	 * Resolving https://bugzilla.kernel.org/show_bug.cgi?id=212177 would
+	 * help to deal with this. With Generic KASAN, it's effectively
+	 * impossible for the memory to get reallocated due to the quarantine.
+	 */
+	KASAN_TEST_NEEDS_CONFIG_ON(test, CONFIG_KASAN_GENERIC);
+
 	ptr = kmalloc(size, GFP_KERNEL);
 	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, ptr);
 
_

Patches currently in -mm which might be from wsw9603@163.com are

kasan-test-only-do-kmalloc_double_kzfree-for-generic-mode.patch

