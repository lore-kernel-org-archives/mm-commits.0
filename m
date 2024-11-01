Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85B781D9A50
	for <mm-commits@vger.kernel.org>; Fri,  1 Nov 2024 20:28:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730492897; cv=none; b=sGdrdvt4C1sUnrjiQZLZvRHzJd8keZP+7BZyzze0Styu1sPFBXTpWu1QQXKo/v7DMoPQ9N/0OKL72ZTkKUTzKsEkd1veNdPn+FHdTEbGH+WkE//ypaecGiZDa0HwOui4dsOPNPvI0hQhE0Xo1lw7PD52+2eskeh6MUDs/QZfFL4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730492897; c=relaxed/simple;
	bh=q0NuelhbffZsmM4LtMbT3Vd1Y0ccRFv7+wgJESKqbIg=;
	h=Date:To:From:Subject:Message-Id; b=GciSq6d6HWQQnHemJnk9jExwECZtQa+OjjB7FqqZzMQU/paKxZniAa7G6qWX9eXUpVorcM3QlV3cCmfDkFhk86XTGuYmen8h7ba53MekCKlHSJwoSo0WKD+/K5vx0A4NmQ52pOvWxD7GCjiRP5ZXC+4zukZpTLTaLwwo7E+qSWk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0t8BbACV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0t8BbACV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBA09C4CECD;
	Fri,  1 Nov 2024 20:28:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730492897;
	bh=q0NuelhbffZsmM4LtMbT3Vd1Y0ccRFv7+wgJESKqbIg=;
	h=Date:To:From:Subject:From;
	b=0t8BbACV8y5vVok9ii8+RFT0nMVlIpdk12HVpkFL6zP82bEKsOLHsIsIQs1kg9vJW
	 ywgY5VNk+Bu1EdPz942sQX03wCDihZ3zF9e7iqgSEbl0pMgtuQP41CqGGgySF3sqrz
	 bmii8SNojszCVi5lgVnhfXeVsgF87pK5o89YcNHk=
Date: Fri, 01 Nov 2024 13:28:16 -0700
To: mm-commits@vger.kernel.org,skhan@linuxfoundation.org,ryabinin.a.a@gmail.com,dvyukov@google.com,andreyknvl@gmail.com,niharchaithanya@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kasan-add-kunit-tests-for-kmalloc_track_caller-kmalloc_node_track_caller.patch added to mm-unstable branch
Message-Id: <20241101202816.EBA09C4CECD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kasan: add kunit tests for kmalloc_track_caller, kmalloc_node_track_caller
has been added to the -mm mm-unstable branch.  Its filename is
     kasan-add-kunit-tests-for-kmalloc_track_caller-kmalloc_node_track_caller.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kasan-add-kunit-tests-for-kmalloc_track_caller-kmalloc_node_track_caller.patch

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
From: Nihar Chaithanya <niharchaithanya@gmail.com>
Subject: kasan: add kunit tests for kmalloc_track_caller, kmalloc_node_track_caller
Date: Tue, 15 Oct 2024 00:31:30 +0530

The Kunit tests for kmalloc_track_caller and kmalloc_node_track_caller
were missing in kasan_test_c.c, which check that these functions poison
the memory properly.

Add a Kunit test:
-> kmalloc_tracker_caller_oob_right(): This includes out-of-bounds
   access test for kmalloc_track_caller and kmalloc_node_track_caller.

Link: https://lkml.kernel.org/r/20241014190128.442059-1-niharchaithanya@gmail.com
Fixes: https://bugzilla.kernel.org/show_bug.cgi?id=216509
Signed-off-by: Nihar Chaithanya <niharchaithanya@gmail.com>
Reviewed-by: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/kasan_test_c.c |   31 +++++++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

--- a/mm/kasan/kasan_test_c.c~kasan-add-kunit-tests-for-kmalloc_track_caller-kmalloc_node_track_caller
+++ a/mm/kasan/kasan_test_c.c
@@ -215,6 +215,36 @@ static void kmalloc_node_oob_right(struc
 	kfree(ptr);
 }
 
+static void kmalloc_track_caller_oob_right(struct kunit *test)
+{
+	char *ptr;
+	size_t size = 128 - KASAN_GRANULE_SIZE;
+
+	/*
+	 * Check that KASAN detects out-of-bounds access for object allocated via
+	 * kmalloc_track_caller().
+	 */
+	ptr = kmalloc_track_caller(size, GFP_KERNEL);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, ptr);
+
+	OPTIMIZER_HIDE_VAR(ptr);
+	KUNIT_EXPECT_KASAN_FAIL(test, ptr[size] = 'y');
+
+	kfree(ptr);
+
+	/*
+	 * Check that KASAN detects out-of-bounds access for object allocated via
+	 * kmalloc_node_track_caller().
+	 */
+	ptr = kmalloc_node_track_caller(size, GFP_KERNEL, 0);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, ptr);
+
+	OPTIMIZER_HIDE_VAR(ptr);
+	KUNIT_EXPECT_KASAN_FAIL(test, ptr[size] = 'y');
+
+	kfree(ptr);
+}
+
 /*
  * Check that KASAN detects an out-of-bounds access for a big object allocated
  * via kmalloc(). But not as big as to trigger the page_alloc fallback.
@@ -2015,6 +2045,7 @@ static struct kunit_case kasan_kunit_tes
 	KUNIT_CASE(kmalloc_oob_right),
 	KUNIT_CASE(kmalloc_oob_left),
 	KUNIT_CASE(kmalloc_node_oob_right),
+	KUNIT_CASE(kmalloc_track_caller_oob_right),
 	KUNIT_CASE(kmalloc_big_oob_right),
 	KUNIT_CASE(kmalloc_large_oob_right),
 	KUNIT_CASE(kmalloc_large_uaf),
_

Patches currently in -mm which might be from niharchaithanya@gmail.com are

kasan-add-kunit-tests-for-kmalloc_track_caller-kmalloc_node_track_caller.patch

