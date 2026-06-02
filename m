Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 185C33C1F52
	for <mm-commits@vger.kernel.org>; Tue,  2 Jun 2026 22:26:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780439167; cv=none; b=qzXdSqG4YJbcXNYHu2k8R8UOC2elIJCai85Lhu40iRkHqx8XQv9o0r16cFP/X5r6BwO6zuz8tjDaMeUAhrvwuWDJfisF5B54FezG3zD9UyPuAu2u2GdIjlAf83PCYuq46s/EWMO34rq2X4ch74SBV2CNpyCsge56w/iz3fjFSGs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780439167; c=relaxed/simple;
	bh=tM8sFZeK7wQc8AntrXJw8ioXXklCkgllLTMGYiLWtMw=;
	h=Date:To:From:Subject:Message-Id; b=Xhrni/+0pkNF06DgRcC3bWuxJB1lgNEtyHd/IwKA3DzP053TAclMstwY+6VyuGg3hscEwQxcrOewqtgPA3TLIOYmvJgt2T8m+hL/BpQAtIv4sP3HimzU/KTxnn55+KFtD2+Vp4kGuw7F+cAYhGZAEVId3bTYwHuTadPMmfH6lqA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=z7G4qtfb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="z7G4qtfb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF2D31F00893;
	Tue,  2 Jun 2026 22:26:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780439166;
	bh=ixKeTttiXY/YDjeCFkBcV4XVg2Q9WCvFpyfUk+ozAbg=;
	h=Date:To:From:Subject;
	b=z7G4qtfbxpdaOudTxEbAtSZRgBkBcHd/fCsDqrL3wYNmiMkulMN5hDfO6MpFr5jwK
	 9ukXWTlB55vyJswxnjqcNErf1cd61vF3hCHMEOvS3Uo8ZqlSA0/rCEARWmYXHhK4cb
	 WvCrCqdUItEwv6S2CdJjAJjB3I7Dq3btxwFsR8jM=
Date: Tue, 02 Jun 2026 15:26:05 -0700
To: mm-commits@vger.kernel.org,vincenzo.frascino@arm.com,ryabinin.a.a@gmail.com,glider@google.com,dvyukov@google.com,andreyknvl@gmail.com,wsw9603@163.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] kasan-test-only-do-kmalloc_double_kzfree-for-generic-mode.patch removed from -mm tree
Message-Id: <20260602222605.DF2D31F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kasan/test: only do kmalloc_double_kzfree for generic mode
has been removed from the -mm tree.  Its filename was
     kasan-test-only-do-kmalloc_double_kzfree-for-generic-mode.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


