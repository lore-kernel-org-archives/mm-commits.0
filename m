Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62F822F3B
	for <mm-commits@vger.kernel.org>; Fri, 22 Mar 2024 00:30:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711067401; cv=none; b=mC6GZOB0oJiOI2fasfiY4k9KRRbt7UWUf1ZNOWGhkb6OTaJtD4+lqucqdqSOhMWkJCfZbhvwHMesxZIE419yIF64MM2ngpEapqTrJ362FcFlIB1F/MUKoShB/kI7fsDve4iduxcYo4fV1cB1y9ap8olzwB1p+uaprYxcNXbw2Q0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711067401; c=relaxed/simple;
	bh=zepDyGf2PEc+/FgE3n/a2l3MOQHlJ8cCxNuWJC68c7c=;
	h=Date:To:From:Subject:Message-Id; b=Ry1nedeSVhJLb+0Us6CsmzEFWHcfOdPT5URyVqsDrsMozOqDXF+WiGjm9+HKl9DyHFYTQelvZ0UeA1b02HwchFypwrf2pb31mX5f+JaQRt1zqvIowGDm70MSQRHL858fyHHbVueQJeNjdKy+R0hS/eODCbQl4K5TqDv5nrJx7rM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZpkGZovW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZpkGZovW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD95FC433F1;
	Fri, 22 Mar 2024 00:30:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1711067401;
	bh=zepDyGf2PEc+/FgE3n/a2l3MOQHlJ8cCxNuWJC68c7c=;
	h=Date:To:From:Subject:From;
	b=ZpkGZovWya3vmVdRu49srr98DV26uwPzJ247YWfu+58sB5RN9BDQ7VSEQyTMKfNhC
	 38y4xBdo8TuMOj7S/C+e3323oeACgzOHJ/ejqYQI/oG9YcF3YYn4ye3pURTng4bWvL
	 1WEr5ygLM/B0k/+f3rXuuwran+/XUa39w/LA/Vbs=
Date: Thu, 21 Mar 2024 17:30:00 -0700
To: mm-commits@vger.kernel.org,torvalds@linux-foundation.org,tglx@linutronix.de,penguin-kernel@I-love.SAKURA.ne.jp,elver@google.com,dvyukov@google.com,glider@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-kmsan-implement-kmsan_memmove.patch added to mm-nonmm-unstable branch
Message-Id: <20240322003000.DD95FC433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: kmsan: implement kmsan_memmove()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     mm-kmsan-implement-kmsan_memmove.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-kmsan-implement-kmsan_memmove.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: Alexander Potapenko <glider@google.com>
Subject: mm: kmsan: implement kmsan_memmove()
Date: Wed, 20 Mar 2024 11:18:49 +0100

Provide a hook that can be used by custom memcpy implementations to tell
KMSAN that the metadata needs to be copied.  Without that, false positive
reports are possible in the cases where KMSAN fails to intercept memory
initialization.

Link: https://lore.kernel.org/all/3b7dbd88-0861-4638-b2d2-911c97a4cadf@I-love.SAKURA.ne.jp/
Link: https://lkml.kernel.org/r/20240320101851.2589698-1-glider@google.com
Signed-off-by: Alexander Potapenko <glider@google.com>
Suggested-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Reviewed-by: Marco Elver <elver@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kmsan-checks.h |   15 +++++++++++++++
 mm/kmsan/hooks.c             |   11 +++++++++++
 2 files changed, 26 insertions(+)

--- a/include/linux/kmsan-checks.h~mm-kmsan-implement-kmsan_memmove
+++ a/include/linux/kmsan-checks.h
@@ -61,6 +61,17 @@ void kmsan_check_memory(const void *addr
 void kmsan_copy_to_user(void __user *to, const void *from, size_t to_copy,
 			size_t left);
 
+/**
+ * kmsan_memmove() - Notify KMSAN about a data copy within kernel.
+ * @to:   destination address in the kernel.
+ * @from: source address in the kernel.
+ * @size: number of bytes to copy.
+ *
+ * Invoked after non-instrumented version (e.g. implemented using assembly
+ * code) of memmove()/memcpy() is called, in order to copy KMSAN's metadata.
+ */
+void kmsan_memmove(void *to, const void *from, size_t to_copy);
+
 #else
 
 static inline void kmsan_poison_memory(const void *address, size_t size,
@@ -78,6 +89,10 @@ static inline void kmsan_copy_to_user(vo
 {
 }
 
+static inline void kmsan_memmove(void *to, const void *from, size_t to_copy)
+{
+}
+
 #endif
 
 #endif /* _LINUX_KMSAN_CHECKS_H */
--- a/mm/kmsan/hooks.c~mm-kmsan-implement-kmsan_memmove
+++ a/mm/kmsan/hooks.c
@@ -285,6 +285,17 @@ void kmsan_copy_to_user(void __user *to,
 }
 EXPORT_SYMBOL(kmsan_copy_to_user);
 
+void kmsan_memmove(void *to, const void *from, size_t size)
+{
+	if (!kmsan_enabled || kmsan_in_runtime())
+		return;
+
+	kmsan_enter_runtime();
+	kmsan_internal_memmove_metadata(to, (void *)from, size);
+	kmsan_leave_runtime();
+}
+EXPORT_SYMBOL(kmsan_memmove);
+
 /* Helper function to check an URB. */
 void kmsan_handle_urb(const struct urb *urb, bool is_out)
 {
_

Patches currently in -mm which might be from glider@google.com are

mm-kmsan-implement-kmsan_memmove.patch
instrumentedh-add-instrument_memcpy_before-instrument_memcpy_after.patch
x86-call-instrumentation-hooks-from-copy_mcc.patch

