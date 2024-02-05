Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF459482F7
	for <mm-commits@vger.kernel.org>; Mon,  5 Feb 2024 23:19:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707175141; cv=none; b=Hr84RMNj3x+3/wjBiMIClK5Wq6JyvhVDqpi0EdgYza+T94puDblid9aIAIO/+sEf7iOL5uO9TisM2rFmhgdA0It9qiZzhSqGnUUFLvTtapGetDmi+S/qJK0jGFA5LzbHE1nIYKDPqZ827V3ZvyA+x0e7n3+LBZ0l7rJ+m4MvZO0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707175141; c=relaxed/simple;
	bh=FvmJqBJAtcimqY0RRo3qMkn4iOePts8102UUV+ZCT6E=;
	h=Date:To:From:Subject:Message-Id; b=USB+fpqjq1ztr6A3gy9upTJndZRmiY3vNfc9HXI4O9krOynuTMIjj6F+cM/yxmxu822/UjVeFfUZwvvamr863v5zLusxaU8psGqJ2LowRTEdxlxskF8JD4u3nik+iJ/tsmM0ETqRT2f9IveCD35zECUXJJXV9mtBYuH0rI8DSnw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=TIuH/MME; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="TIuH/MME"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CD2BC43390;
	Mon,  5 Feb 2024 23:19:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1707175141;
	bh=FvmJqBJAtcimqY0RRo3qMkn4iOePts8102UUV+ZCT6E=;
	h=Date:To:From:Subject:From;
	b=TIuH/MME4pgdjR040ok8KfKGBTFqK9rnn8jX87ADcAFKU+MadxUuNGGk1zK0SNU/Z
	 A9RZmDoRt451QSoUnL3uv6KjcKzR4deFDUppk8IsTJSH1GwymHkOqcW7fOyEaXU1/I
	 tfZ2GE2pP8vdrhDhpYxxFW+nONbAjGG+sdm+7oFI=
Date: Mon, 05 Feb 2024 15:19:00 -0800
To: mm-commits@vger.kernel.org,elver@google.com,corbet@lwn.net,andreyknvl@gmail.com,yangtiezhu@loongson.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kasan-rename-test_kasan_module_init-to-kasan_test_module_init.patch added to mm-unstable branch
Message-Id: <20240205231901.2CD2BC43390@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kasan: rename test_kasan_module_init to kasan_test_module_init
has been added to the -mm mm-unstable branch.  Its filename is
     kasan-rename-test_kasan_module_init-to-kasan_test_module_init.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kasan-rename-test_kasan_module_init-to-kasan_test_module_init.patch

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
From: Tiezhu Yang <yangtiezhu@loongson.cn>
Subject: kasan: rename test_kasan_module_init to kasan_test_module_init
Date: Mon, 5 Feb 2024 14:09:22 +0800

After commit f7e01ab828fd ("kasan: move tests to mm/kasan/"), the test
module file is renamed from lib/test_kasan_module.c to
mm/kasan/kasan_test_module.c, in order to keep consistent, rename
test_kasan_module_init to kasan_test_module_init.

Link: https://lkml.kernel.org/r/20240205060925.15594-3-yangtiezhu@loongson.cn
Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
Acked-by: Marco Elver <elver@google.com>
Reviewed-by: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/kasan_test_module.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/kasan/kasan_test_module.c~kasan-rename-test_kasan_module_init-to-kasan_test_module_init
+++ a/mm/kasan/kasan_test_module.c
@@ -62,7 +62,7 @@ static noinline void __init copy_user_te
 	kfree(kmem);
 }
 
-static int __init test_kasan_module_init(void)
+static int __init kasan_test_module_init(void)
 {
 	/*
 	 * Temporarily enable multi-shot mode. Otherwise, KASAN would only
@@ -77,5 +77,5 @@ static int __init test_kasan_module_init
 	return -EAGAIN;
 }
 
-module_init(test_kasan_module_init);
+module_init(kasan_test_module_init);
 MODULE_LICENSE("GPL");
_

Patches currently in -mm which might be from yangtiezhu@loongson.cn are

kasan-docs-update-descriptions-about-test-file-and-module.patch
kasan-rename-test_kasan_module_init-to-kasan_test_module_init.patch

