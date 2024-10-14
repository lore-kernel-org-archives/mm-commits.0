Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C58E9148826
	for <mm-commits@vger.kernel.org>; Mon, 14 Oct 2024 23:11:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728947468; cv=none; b=J5Yl1GQk+BE1J2lubgamCGMHqr11tZ5rbaFtU1upK0klwievblHXavNFh+RsFFhVbDAtAUwWZZydDc7Gj1ZVd+/BPxsXXHhxfo+120M+YIAHm9l+6Xi/5LQcyjhk4MN2vx3yixSsdsHKIB7bxdaC5Su9KK7bPiDnWALQeu24ctg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728947468; c=relaxed/simple;
	bh=1WmbePC/tMnF7KyGBJrxPspm8hgDnIoVxQTzzGnl1wU=;
	h=Date:To:From:Subject:Message-Id; b=rhf3o/GRbfguoKhJr9Zfc0v7YS1Z/hvbT9ttSA8vcycjll6Abae1oOetA0vOC8wvxtqDkxT+ef0DIT/jwfB89HKFGo0NxTK3nCBfmKjrtAQrs868woS0L82rrpnvqDYHvpngg3jHa/CKm/v823kSooHNSddKu2ipyB/t0z5JV8s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=CxbYzRBq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="CxbYzRBq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49539C4CEC3;
	Mon, 14 Oct 2024 23:11:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1728947468;
	bh=1WmbePC/tMnF7KyGBJrxPspm8hgDnIoVxQTzzGnl1wU=;
	h=Date:To:From:Subject:From;
	b=CxbYzRBqPrCHhGg/ytMJy5TsPu8d+KG9jV1awhGfZUYPeOw/ijfA4sJKaD9QSiuCS
	 J49AzSJaaMmkPqmv4IRveD/Yv0ee4Uu0agmI2easf015hgl3LhWiNTE2FdVzQiFvrR
	 zCe41bL8tkKHskDVwEAx0J0OajnoAi56aH6+6yQo=
Date: Mon, 14 Oct 2024 16:11:07 -0700
To: mm-commits@vger.kernel.org,vincenzo.frascino@arm.com,siyanteng@loongson.cn,ryabinin.a.a@gmail.com,glider@google.com,elver@google.com,dvyukov@google.com,corbet@lwn.net,andreyknvl@gmail.com,alexs@kernel.org,2023002089@link.tyut.edu.cn,snovitoll@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [failures] kasan-move-checks-to-do_strncpy_from_user.patch removed from -mm tree
Message-Id: <20241014231108.49539C4CEC3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kasan: move checks to do_strncpy_from_user
has been removed from the -mm tree.  Its filename was
     kasan-move-checks-to-do_strncpy_from_user.patch

This patch was dropped because it had testing failures

------------------------------------------------------
From: Sabyrzhan Tasbolatov <snovitoll@gmail.com>
Subject: kasan: move checks to do_strncpy_from_user
Date: Mon, 14 Oct 2024 07:56:59 +0500

Patch series "kasan: migrate the last module test to kunit", v3.

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

Link: https://lkml.kernel.org/r/20241014025701.3096253-1-snovitoll@gmail.com
Link: https://lkml.kernel.org/r/20241014025701.3096253-2-snovitoll@gmail.com
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
@@ -31,6 +31,9 @@ static __always_inline long do_strncpy_f
 	const struct word_at_a_time constants = WORD_AT_A_TIME_CONSTANTS;
 	unsigned long res = 0;
 
+	kasan_check_write(dst, count);
+	check_object_size(dst, count, false);
+
 	if (IS_UNALIGNED(src, dst))
 		goto byte_at_a_time;
 
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

kasan-migrate-copy_user_test-to-kunit.patch
kasan-delete-config_kasan_module_test.patch

