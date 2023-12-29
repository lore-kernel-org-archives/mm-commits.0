Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33EEF13AF8
	for <mm-commits@vger.kernel.org>; Fri, 29 Dec 2023 20:01:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="m3BjIs6n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 005DDC433C8;
	Fri, 29 Dec 2023 20:01:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703880079;
	bh=cM/r0Dv4S4C+MURG/t7e/afJ5GxnZKNuIvx4BQABKBY=;
	h=Date:To:From:Subject:From;
	b=m3BjIs6nqhD/F2SooF1qTbeOHql7zLhEMtBDIsKaZLy8AZaA0kHKvaAoAn308SmDy
	 xhueWVCcT5aulRH8WkHop6XTl01u8dKBjzsp4sF053czCrRlW3VeVLZRvsHlhEta0k
	 Ao5ZxFv/Ihw1ZVAwEe8F7Hhl81/YjNT9CpNg0HA8=
Date: Fri, 29 Dec 2023 12:01:18 -0800
To: mm-commits@vger.kernel.org,ryabinin.a.a@gmail.com,glider@google.com,elver@google.com,dvyukov@google.com,andreyknvl@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] kasan-speed-up-match_all_mem_tag-test-for-sw_tags.patch removed from -mm tree
Message-Id: <20231229200119.005DDC433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kasan: speed up match_all_mem_tag test for SW_TAGS
has been removed from the -mm tree.  Its filename was
     kasan-speed-up-match_all_mem_tag-test-for-sw_tags.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Andrey Konovalov <andreyknvl@google.com>
Subject: kasan: speed up match_all_mem_tag test for SW_TAGS
Date: Thu, 21 Dec 2023 21:04:53 +0100

Checking all 256 possible tag values in the match_all_mem_tag KASAN test
is slow and produces 256 reports.  Instead, just check the first 8 and the
last 8.

Link: https://lkml.kernel.org/r/6fe51262defd80cdc1150c42404977aafd1b6167.1703188911.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Marco Elver <elver@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/kasan_test.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/mm/kasan/kasan_test.c~kasan-speed-up-match_all_mem_tag-test-for-sw_tags
+++ a/mm/kasan/kasan_test.c
@@ -1797,6 +1797,14 @@ static void match_all_mem_tag(struct kun
 
 	/* For each possible tag value not matching the pointer tag. */
 	for (tag = KASAN_TAG_MIN; tag <= KASAN_TAG_KERNEL; tag++) {
+		/*
+		 * For Software Tag-Based KASAN, skip the majority of tag
+		 * values to avoid the test printing too many reports.
+		 */
+		if (IS_ENABLED(CONFIG_KASAN_SW_TAGS) &&
+		    tag >= KASAN_TAG_MIN + 8 && tag <= KASAN_TAG_KERNEL - 8)
+			continue;
+
 		if (tag == get_tag(ptr))
 			continue;
 
_

Patches currently in -mm which might be from andreyknvl@google.com are

kasan-stop-leaking-stack-trace-handles.patch

