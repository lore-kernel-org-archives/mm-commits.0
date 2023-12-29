Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88FF713ADC
	for <mm-commits@vger.kernel.org>; Fri, 29 Dec 2023 20:01:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="uTwRFVIU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0541CC433C8;
	Fri, 29 Dec 2023 20:01:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703880073;
	bh=Vc9us3zqknZLIlyGRIX++azuXFnaY8ZHBqykMC8ZTUs=;
	h=Date:To:From:Subject:From;
	b=uTwRFVIU/cZ8vWd6VygswW+K8ALuaHObYauNuuyWEq06FmGeNQa4xYQwQChYJBiqL
	 zOpovxtPkkObJRxlvQEPmJ0M4/v7AfQLgyhLn4vvCBkJdvn1mnKbjChUGRwLwl5bWe
	 JQqrid92WrCfCeoxkb7Z29R6lXNJaFQDKN2ODkGs=
Date: Fri, 29 Dec 2023 12:01:12 -0800
To: mm-commits@vger.kernel.org,ryabinin.a.a@gmail.com,glider@google.com,elver@google.com,dvyukov@google.com,andreyknvl@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] kasan-update-kasan_poison-documentation-comment.patch removed from -mm tree
Message-Id: <20231229200113.0541CC433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kasan: update kasan_poison documentation comment
has been removed from the -mm tree.  Its filename was
     kasan-update-kasan_poison-documentation-comment.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Andrey Konovalov <andreyknvl@google.com>
Subject: kasan: update kasan_poison documentation comment
Date: Thu, 21 Dec 2023 21:04:47 +0100

The comment for kasan_poison says that the size argument gets aligned by
the function to KASAN_GRANULE_SIZE, which is wrong: the argument must be
already aligned when it is passed to the function.

Remove the invalid part of the comment.

Link: https://lkml.kernel.org/r/992a302542059fc40d86ea560eac413ecb31b6a1.1703188911.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Marco Elver <elver@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/kasan.h |    2 --
 1 file changed, 2 deletions(-)

--- a/mm/kasan/kasan.h~kasan-update-kasan_poison-documentation-comment
+++ a/mm/kasan/kasan.h
@@ -513,8 +513,6 @@ static inline bool kasan_byte_accessible
  * @size - range size, must be aligned to KASAN_GRANULE_SIZE
  * @value - value that's written to metadata for the range
  * @init - whether to initialize the memory range (only for hardware tag-based)
- *
- * The size gets aligned to KASAN_GRANULE_SIZE before marking the range.
  */
 void kasan_poison(const void *addr, size_t size, u8 value, bool init);
 
_

Patches currently in -mm which might be from andreyknvl@google.com are

kasan-stop-leaking-stack-trace-handles.patch

