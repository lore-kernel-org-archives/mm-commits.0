Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98EC128EF
	for <mm-commits@vger.kernel.org>; Thu, 22 Feb 2024 00:03:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708560189; cv=none; b=D+4P4HGHhjaJyRcqs3Fuxz+vpg0PK69K+tPWkFBT99DwXhbISqs/skYHZYpwizDfARfZ2QFOGimAtEKm6I5mGLMfEmrBV60vXBOx7I8BZuHE1bmsjzJc5ue2U+a9hc53TIrXHglISkNCQLmdXRO0YyNfgaw3AJiXub4a+3Rzpcc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708560189; c=relaxed/simple;
	bh=elS1Zsa7f63tF2wjyvl6JQCILlq05ahuxGYuM2l2t3k=;
	h=Date:To:From:Subject:Message-Id; b=MpVH18OSv0kpyMNQHFHjVIYY2Vox6kijnfxJIJDI7+23N9KcLWU0/BosQ1DevjHlwnFE4gG84Ccl6u38B76xrvgZ4fwbmcXkcDyvyg36aHPy7MD5Sez+4Iqj4m+wHF/YEOWoNDvM53HFz0WI+hR4LaAQhVZ9gUNDpEKdYrA6S2Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=bwkKuUMw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="bwkKuUMw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 620E5C433F1;
	Thu, 22 Feb 2024 00:03:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708560189;
	bh=elS1Zsa7f63tF2wjyvl6JQCILlq05ahuxGYuM2l2t3k=;
	h=Date:To:From:Subject:From;
	b=bwkKuUMwWdmF3R1V68KTyQjWo1eeR1Be5dJqY40/JhoxNkKRtBuQmksDuTPRDcJbw
	 QTjxrflCbpqFZC4ZtOloxXhZPCqZM7ybRnQdqC+haiM18dpeE2X56cDAPoKu4W1CYf
	 A4RdE0jAKPtt/JZlid4XfNySYzdpoW4pAe+4Vffw=
Date: Wed, 21 Feb 2024 16:03:08 -0800
To: mm-commits@vger.kernel.org,elver@google.com,corbet@lwn.net,andreyknvl@gmail.com,yangtiezhu@loongson.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] kasan-rename-test_kasan_module_init-to-kasan_test_module_init.patch removed from -mm tree
Message-Id: <20240222000309.620E5C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kasan: rename test_kasan_module_init to kasan_test_module_init
has been removed from the -mm tree.  Its filename was
     kasan-rename-test_kasan_module_init-to-kasan_test_module_init.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


