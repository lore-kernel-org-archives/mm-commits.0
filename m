Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48E0313ADE
	for <mm-commits@vger.kernel.org>; Fri, 29 Dec 2023 20:01:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="LggGtDHI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1383EC433C9;
	Fri, 29 Dec 2023 20:01:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703880070;
	bh=UhtJN4YuhODG/upKEgPfp2AZPf9rBAu3bRcY5+HZF68=;
	h=Date:To:From:Subject:From;
	b=LggGtDHIStvL33+NbKrWv6i3rVmkRHVHWphCAxpIJL0+jrtA4qgpalep6IJRmsXv0
	 IEyuK/ywMlqErle7QHbYsNFwRv1fhjuQIxh26MMPnDOGwtWlJUwgei8GO8Dl//Inr5
	 Z+6GOBdL1qKpgdM+kq2lMCOQ9nx2EtB/zO7RTrjo=
Date: Fri, 29 Dec 2023 12:01:09 -0800
To: mm-commits@vger.kernel.org,ryabinin.a.a@gmail.com,glider@google.com,elver@google.com,dvyukov@google.com,andreyknvl@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-kasan-use-kasan_tag_kernel-instead-of-0xff.patch removed from -mm tree
Message-Id: <20231229200110.1383EC433C9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm, kasan: use KASAN_TAG_KERNEL instead of 0xff
has been removed from the -mm tree.  Its filename was
     mm-kasan-use-kasan_tag_kernel-instead-of-0xff.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Andrey Konovalov <andreyknvl@google.com>
Subject: mm, kasan: use KASAN_TAG_KERNEL instead of 0xff
Date: Thu, 21 Dec 2023 21:04:44 +0100

Use the KASAN_TAG_KERNEL marco instead of open-coding 0xff in the mm code.
This macro is provided by include/linux/kasan-tags.h, which does not
include any other headers, so it's safe to include it into mm.h without
causing circular include dependencies.

Link: https://lkml.kernel.org/r/71db9087b0aebb6c4dccbc609cc0cd50621533c7.1703188911.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Marco Elver <elver@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kasan.h |    1 +
 include/linux/mm.h    |    4 ++--
 mm/page_alloc.c       |    2 +-
 3 files changed, 4 insertions(+), 3 deletions(-)

--- a/include/linux/kasan.h~mm-kasan-use-kasan_tag_kernel-instead-of-0xff
+++ a/include/linux/kasan.h
@@ -4,6 +4,7 @@
 
 #include <linux/bug.h>
 #include <linux/kasan-enabled.h>
+#include <linux/kasan-tags.h>
 #include <linux/kernel.h>
 #include <linux/static_key.h>
 #include <linux/types.h>
--- a/include/linux/mm.h~mm-kasan-use-kasan_tag_kernel-instead-of-0xff
+++ a/include/linux/mm.h
@@ -1815,7 +1815,7 @@ static inline void vma_set_access_pid_bi
 
 static inline u8 page_kasan_tag(const struct page *page)
 {
-	u8 tag = 0xff;
+	u8 tag = KASAN_TAG_KERNEL;
 
 	if (kasan_enabled()) {
 		tag = (page->flags >> KASAN_TAG_PGSHIFT) & KASAN_TAG_MASK;
@@ -1844,7 +1844,7 @@ static inline void page_kasan_tag_set(st
 static inline void page_kasan_tag_reset(struct page *page)
 {
 	if (kasan_enabled())
-		page_kasan_tag_set(page, 0xff);
+		page_kasan_tag_set(page, KASAN_TAG_KERNEL);
 }
 
 #else /* CONFIG_KASAN_SW_TAGS || CONFIG_KASAN_HW_TAGS */
--- a/mm/page_alloc.c~mm-kasan-use-kasan_tag_kernel-instead-of-0xff
+++ a/mm/page_alloc.c
@@ -1059,7 +1059,7 @@ static inline bool should_skip_kasan_poi
 	if (IS_ENABLED(CONFIG_KASAN_GENERIC))
 		return deferred_pages_enabled();
 
-	return page_kasan_tag(page) == 0xff;
+	return page_kasan_tag(page) == KASAN_TAG_KERNEL;
 }
 
 static void kernel_init_pages(struct page *page, int numpages)
_

Patches currently in -mm which might be from andreyknvl@google.com are

kasan-stop-leaking-stack-trace-handles.patch

