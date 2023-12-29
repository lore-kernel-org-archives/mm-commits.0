Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B8DC13AEA
	for <mm-commits@vger.kernel.org>; Fri, 29 Dec 2023 20:01:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="du6BKX/3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1727AC433C7;
	Fri, 29 Dec 2023 20:01:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703880072;
	bh=0lZVzmMAPR3IKuaMeMcxl6H1oTEZRJB6OSZ5xcLiOxQ=;
	h=Date:To:From:Subject:From;
	b=du6BKX/3+ARJOdLdUu4/8mLK1G/5OdWtLB0LmR2szbkQf1JQm580n0Zy76YvBJGO5
	 wVS+MLeJWcqVrD8vxX3/3j493ftSNVM+eg8JztnZ81+8ge78KKImQgIX7kMCudEugf
	 7Xuor3vwXo5iMXCURrKu1ZGJ41ez1ZrtThfHsWoI=
Date: Fri, 29 Dec 2023 12:01:11 -0800
To: mm-commits@vger.kernel.org,ryabinin.a.a@gmail.com,glider@google.com,elver@google.com,dvyukov@google.com,andreyknvl@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] kasan-clean-up-kasan_requires_meta.patch removed from -mm tree
Message-Id: <20231229200112.1727AC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kasan: clean up kasan_requires_meta
has been removed from the -mm tree.  Its filename was
     kasan-clean-up-kasan_requires_meta.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Andrey Konovalov <andreyknvl@google.com>
Subject: kasan: clean up kasan_requires_meta
Date: Thu, 21 Dec 2023 21:04:46 +0100

Currently, for Generic KASAN mode, kasan_requires_meta is defined to
return kasan_stack_collection_enabled.

Even though the Generic mode does not support disabling stack trace
collection, kasan_requires_meta was implemented in this way to make it
easier to implement the disabling for the Generic mode in the future.

However, for the Generic mode, the per-object metadata also stores the
quarantine link.  So even if disabling stack collection is implemented,
the per-object metadata will still be required.

Fix kasan_requires_meta to return true for the Generic mode and update the
related comments.

This change does not fix any observable bugs but rather just brings the
code to a cleaner state.

Link: https://lkml.kernel.org/r/8086623407095ac1c82377a2107dcc5845f99cfa.1703188911.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Marco Elver <elver@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/kasan.h |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

--- a/mm/kasan/kasan.h~kasan-clean-up-kasan_requires_meta
+++ a/mm/kasan/kasan.h
@@ -101,21 +101,21 @@ static inline bool kasan_sample_page_all
 
 #ifdef CONFIG_KASAN_GENERIC
 
-/* Generic KASAN uses per-object metadata to store stack traces. */
+/*
+ * Generic KASAN uses per-object metadata to store alloc and free stack traces
+ * and the quarantine link.
+ */
 static inline bool kasan_requires_meta(void)
 {
-	/*
-	 * Technically, Generic KASAN always collects stack traces right now.
-	 * However, let's use kasan_stack_collection_enabled() in case the
-	 * kasan.stacktrace command-line argument is changed to affect
-	 * Generic KASAN.
-	 */
-	return kasan_stack_collection_enabled();
+	return true;
 }
 
 #else /* CONFIG_KASAN_GENERIC */
 
-/* Tag-based KASAN modes do not use per-object metadata. */
+/*
+ * Tag-based KASAN modes do not use per-object metadata: they use the stack
+ * ring to store alloc and free stack traces and do not use qurantine.
+ */
 static inline bool kasan_requires_meta(void)
 {
 	return false;
_

Patches currently in -mm which might be from andreyknvl@google.com are

kasan-stop-leaking-stack-trace-handles.patch

