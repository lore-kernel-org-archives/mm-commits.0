Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E9C41CF5C6
	for <mm-commits@vger.kernel.org>; Mon, 14 Oct 2024 20:08:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728936537; cv=none; b=Q9QAFxBRxBtXfsigpP0yYjtctXjpm31eHjQr4Lj0lgdGEJc3rnfVG+cv+1NDgAwwQhElCJiDQKkWh6ZAsjy9WePCp8UMqSX31qEPUbWdUIuD9lmy70qnbS1sjbiqVSgfvfGAg/PykxA3qE5CA3gr5kC3rampUE+KsO6N0fZJ3eM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728936537; c=relaxed/simple;
	bh=dPhKWRz/ot3ZH4ZjBvV4mv757DssbF5Oofz073yK57M=;
	h=Date:To:From:Subject:Message-Id; b=XhXwRbhzk1D5sYhH66J5b61L4kqYK1WN+LIYf4FUaBwcgFMNFbP/yBn5NqRABY8Bd4i1zOWgF1leoVhTVevF2a4h9pQA5jgfo9qNHRaLvPeflKQT2NQXZ7WX6bi3VEXYSmsETtD7C2rQuldvMbLtSkI+RwoCSp9ZYdDZvPTatLA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=LDks8QLT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="LDks8QLT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1CC9C4CEC3;
	Mon, 14 Oct 2024 20:08:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1728936537;
	bh=dPhKWRz/ot3ZH4ZjBvV4mv757DssbF5Oofz073yK57M=;
	h=Date:To:From:Subject:From;
	b=LDks8QLTl14YJ7Nqbhxwmp29xGs7uTULK//ZGui0zKFSp92LbddRSuycYMf2ueiiD
	 cDRMEvAZp4W5zqxmPrQrcsjC4APIHllQCetIoX4VP+B9nytEacHv0LsaU7lGjZ8lgt
	 j6zoDcoi9vy7XBRIDB/FNgxl/hoYtbvD0Yyz3w7A=
Date: Mon, 14 Oct 2024 13:08:56 -0700
To: mm-commits@vger.kernel.org,vincenzo.frascino@arm.com,siyanteng@loongson.cn,ryabinin.a.a@gmail.com,glider@google.com,elver@google.com,dvyukov@google.com,corbet@lwn.net,andreyknvl@gmail.com,alexs@kernel.org,2023002089@link.tyut.edu.cn,snovitoll@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kasan-move-checks-to-do_strncpy_from_user.patch added to mm-unstable branch
Message-Id: <20241014200856.F1CC9C4CEC3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kasan: move checks to do_strncpy_from_user
has been added to the -mm mm-unstable branch.  Its filename is
     kasan-move-checks-to-do_strncpy_from_user.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kasan-move-checks-to-do_strncpy_from_user.patch

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

kasan-move-checks-to-do_strncpy_from_user.patch
kasan-migrate-copy_user_test-to-kunit.patch
kasan-delete-config_kasan_module_test.patch

