Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DA6E13ADC
	for <mm-commits@vger.kernel.org>; Fri, 29 Dec 2023 20:01:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="opZAZZq/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 070E1C433C9;
	Fri, 29 Dec 2023 20:01:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703880071;
	bh=b5Tqz06vS6RBrpsFIxIrGwINCsyeZ6ZV0/UcUileAX8=;
	h=Date:To:From:Subject:From;
	b=opZAZZq/RYme8PlJjxczwQLRZzYTAt5EJQZvVYqEpryh2fwbezTKRdPI0i/q/aJNp
	 leI7WreOWT/h6aT6UVmHed0Y3VYnzjqXhEigEs9qXN3OM2/6xNHKrq7loZFRitDvev
	 RWzvYhsVPy+5SWIamNaIwCX722SmAZczoiHqM7Yc=
Date: Fri, 29 Dec 2023 12:01:10 -0800
To: mm-commits@vger.kernel.org,ryabinin.a.a@gmail.com,glider@google.com,elver@google.com,dvyukov@google.com,andreyknvl@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] kasan-improve-kasan_non_canonical_hook.patch removed from -mm tree
Message-Id: <20231229200111.070E1C433C9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kasan: improve kasan_non_canonical_hook
has been removed from the -mm tree.  Its filename was
     kasan-improve-kasan_non_canonical_hook.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Andrey Konovalov <andreyknvl@google.com>
Subject: kasan: improve kasan_non_canonical_hook
Date: Thu, 21 Dec 2023 21:04:45 +0100

Make kasan_non_canonical_hook to be more sure in its report (i.e.  say
"probably" instead of "maybe") if the address belongs to the shadow memory
region for kernel addresses.

Also use the kasan_shadow_to_mem helper to calculate the original address.

Also improve the comments in kasan_non_canonical_hook.

Link: https://lkml.kernel.org/r/af94ef3cb26f8c065048b3158d9f20f6102bfaaa.1703188911.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Marco Elver <elver@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/kasan.h  |    6 ++++++
 mm/kasan/report.c |   34 ++++++++++++++++++++--------------
 2 files changed, 26 insertions(+), 14 deletions(-)

--- a/mm/kasan/kasan.h~kasan-improve-kasan_non_canonical_hook
+++ a/mm/kasan/kasan.h
@@ -307,6 +307,12 @@ struct kasan_stack_ring {
 
 #if defined(CONFIG_KASAN_GENERIC) || defined(CONFIG_KASAN_SW_TAGS)
 
+static __always_inline bool addr_in_shadow(const void *addr)
+{
+	return addr >= (void *)KASAN_SHADOW_START &&
+		addr < (void *)KASAN_SHADOW_END;
+}
+
 #ifndef kasan_shadow_to_mem
 static inline const void *kasan_shadow_to_mem(const void *shadow_addr)
 {
--- a/mm/kasan/report.c~kasan-improve-kasan_non_canonical_hook
+++ a/mm/kasan/report.c
@@ -635,37 +635,43 @@ void kasan_report_async(void)
 
 #if defined(CONFIG_KASAN_GENERIC) || defined(CONFIG_KASAN_SW_TAGS)
 /*
- * With CONFIG_KASAN_INLINE, accesses to bogus pointers (outside the high
- * canonical half of the address space) cause out-of-bounds shadow memory reads
- * before the actual access. For addresses in the low canonical half of the
- * address space, as well as most non-canonical addresses, that out-of-bounds
- * shadow memory access lands in the non-canonical part of the address space.
- * Help the user figure out what the original bogus pointer was.
+ * With compiler-based KASAN modes, accesses to bogus pointers (outside of the
+ * mapped kernel address space regions) cause faults when KASAN tries to check
+ * the shadow memory before the actual memory access. This results in cryptic
+ * GPF reports, which are hard for users to interpret. This hook helps users to
+ * figure out what the original bogus pointer was.
  */
 void kasan_non_canonical_hook(unsigned long addr)
 {
 	unsigned long orig_addr;
 	const char *bug_type;
 
+	/*
+	 * All addresses that came as a result of the memory-to-shadow mapping
+	 * (even for bogus pointers) must be >= KASAN_SHADOW_OFFSET.
+	 */
 	if (addr < KASAN_SHADOW_OFFSET)
 		return;
 
-	orig_addr = (addr - KASAN_SHADOW_OFFSET) << KASAN_SHADOW_SCALE_SHIFT;
+	orig_addr = (unsigned long)kasan_shadow_to_mem((void *)addr);
+
 	/*
 	 * For faults near the shadow address for NULL, we can be fairly certain
 	 * that this is a KASAN shadow memory access.
-	 * For faults that correspond to shadow for low canonical addresses, we
-	 * can still be pretty sure - that shadow region is a fairly narrow
-	 * chunk of the non-canonical address space.
-	 * But faults that look like shadow for non-canonical addresses are a
-	 * really large chunk of the address space. In that case, we still
-	 * print the decoded address, but make it clear that this is not
-	 * necessarily what's actually going on.
+	 * For faults that correspond to the shadow for low or high canonical
+	 * addresses, we can still be pretty sure: these shadow regions are a
+	 * fairly narrow chunk of the address space.
+	 * But the shadow for non-canonical addresses is a really large chunk
+	 * of the address space. For this case, we still print the decoded
+	 * address, but make it clear that this is not necessarily what's
+	 * actually going on.
 	 */
 	if (orig_addr < PAGE_SIZE)
 		bug_type = "null-ptr-deref";
 	else if (orig_addr < TASK_SIZE)
 		bug_type = "probably user-memory-access";
+	else if (addr_in_shadow((void *)addr))
+		bug_type = "probably wild-memory-access";
 	else
 		bug_type = "maybe wild-memory-access";
 	pr_alert("KASAN: %s in range [0x%016lx-0x%016lx]\n", bug_type,
_

Patches currently in -mm which might be from andreyknvl@google.com are

kasan-stop-leaking-stack-trace-handles.patch

