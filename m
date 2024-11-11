Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4716115D5B6
	for <mm-commits@vger.kernel.org>; Mon, 11 Nov 2024 08:28:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731313693; cv=none; b=eDNq7hg6wOoS7W6ap3Y60l/x4B7h3JpMhqjTMbsK6wr4nSAJfpG83M2uFDKZsn0Grh5xqEWQiD/MAvbIy9jjlkfp/Wf68IMYqfHuA40bdDvcDoWSXISELMIE01EVTdcfpXhrfJ6pCs/leEPvb1dRGUuFl03bKWEdMNrvdvxDI8c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731313693; c=relaxed/simple;
	bh=Q9YzuRDP7IadUv0wXmCSKAs44UG0Cba0UrVtRZ/hun4=;
	h=Date:To:From:Subject:Message-Id; b=urGD3Kgylzr3FQ08p57+VoG35hwQjzowBtEva5IBE0/Ld9zh97bWcLyjiuWGre7Ufl05mMeeW2UASqV3kTLE1XCJeIawxF9Px09EE4/D5rZPHnGjVikSCTAnjV04CLKPnBpZqY5K7pQfW5n3COIOUGqO+1zEW+ZAoZg7/KoPC6Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=duDeA7Vt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="duDeA7Vt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C75CBC4CED0;
	Mon, 11 Nov 2024 08:28:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1731313692;
	bh=Q9YzuRDP7IadUv0wXmCSKAs44UG0Cba0UrVtRZ/hun4=;
	h=Date:To:From:Subject:From;
	b=duDeA7VtZ/taF1d6Cfp+UL2fyzPWl0bChokNmuk8yQ7K7ypQw2PRr3vQj+JYfhf60
	 3E37p7GIJpha24jzUanznZRKqquklEjqLXQTExKJytl+diIHRLqUx2z9kz21uOOsLq
	 dQ9h7y9c2GtPG3KsM0VYaj5XIuy6OUwFmzXjxKdw=
Date: Mon, 11 Nov 2024 00:28:12 -0800
To: mm-commits@vger.kernel.org,vincenzo.frascino@arm.com,siyanteng@loongson.cn,ryabinin.a.a@gmail.com,glider@google.com,elver@google.com,dvyukov@google.com,corbet@lwn.net,andreyknvl@gmail.com,alexs@kernel.org,2023002089@link.tyut.edu.cn,snovitoll@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] kasan-move-checks-to-do_strncpy_from_user.patch removed from -mm tree
Message-Id: <20241111082812.C75CBC4CED0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kasan: move checks to do_strncpy_from_user
has been removed from the -mm tree.  Its filename was
     kasan-move-checks-to-do_strncpy_from_user.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Sabyrzhan Tasbolatov <snovitoll@gmail.com>
Subject: kasan: move checks to do_strncpy_from_user
Date: Wed, 16 Oct 2024 18:18:00 +0500

Patch series "kasan: migrate the last module test to kunit", v4.

copy_user_test() is the last KUnit-incompatible test with
CONFIG_KASAN_MODULE_TEST requirement, which we are going to migrate to
KUnit framework and delete the former test and Kconfig as well.

In this patch series:

	- [1/3] move kasan_check_write() and check_object_size() to
		do_strncpy_from_user() to cover with KASAN checks with
		multiple conditions	in strncpy_from_user().

	- [2/3] migrated copy_user_test() to KUnit, where we can also test
		strncpy_from_user() due to [1/4].

		KUnits have been tested on:
		- x86_64 with CONFIG_KASAN_GENERIC. Passed
		- arm64 with CONFIG_KASAN_SW_TAGS. 1 fail. See [1]
		- arm64 with CONFIG_KASAN_HW_TAGS. 1 fail. See [1]
		[1] https://lore.kernel.org/linux-mm/CACzwLxj21h7nCcS2-KA_q7ybe+5pxH0uCDwu64q_9pPsydneWQ@mail.gmail.com/

	- [3/3] delete CONFIG_KASAN_MODULE_TEST and documentation occurrences.


This patch (of 3):

Since in the commit 2865baf54077("x86: support user address masking
instead of non-speculative conditional") do_strncpy_from_user() is called
from multiple places, we should sanitize the kernel *dst memory and size
which were done in strncpy_from_user() previously.

Link: https://lkml.kernel.org/r/20241016131802.3115788-1-snovitoll@gmail.com
Link: https://lkml.kernel.org/r/20241016131802.3115788-2-snovitoll@gmail.com
Fixes: 2865baf54077 ("x86: support user address masking instead of non-speculative conditional")
Signed-off-by: Sabyrzhan Tasbolatov <snovitoll@gmail.com>
Reviewed-by: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Alex Shi <alexs@kernel.org>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Hu Haowen <2023002089@link.tyut.edu.cn>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Marco Elver <elver@google.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc: Yanteng Si <siyanteng@loongson.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/strncpy_from_user.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/lib/strncpy_from_user.c~kasan-move-checks-to-do_strncpy_from_user
+++ a/lib/strncpy_from_user.c
@@ -120,6 +120,9 @@ long strncpy_from_user(char *dst, const
 	if (unlikely(count <= 0))
 		return 0;
 
+	kasan_check_write(dst, count);
+	check_object_size(dst, count, false);
+
 	if (can_do_masked_user_access()) {
 		long retval;
 
@@ -142,8 +145,6 @@ long strncpy_from_user(char *dst, const
 		if (max > count)
 			max = count;
 
-		kasan_check_write(dst, count);
-		check_object_size(dst, count, false);
 		if (user_read_access_begin(src, max)) {
 			retval = do_strncpy_from_user(dst, src, count, max);
 			user_read_access_end();
_

Patches currently in -mm which might be from snovitoll@gmail.com are


