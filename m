Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1A95811F7
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 04:07:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714104457; cv=none; b=gXjxDshwyCMu1hypVvG7NqM3MYGITkOIJ3SH6zdpJ4WH7Qbwl1cW9fcY0YmVUozbzAxnwJ9fkhQ2M4soJw1+I6HE0aqq5xvTyw9Km3mzSTaXf45RkhNCLfb5sw7a0PsQMMbkW6MxASmkAqV+zf9rDWE28Do5xM58jefMtkKQF64=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714104457; c=relaxed/simple;
	bh=rIJizTlxsDT+tI6DAik3h28iw+4PCLhpdahJGCHeNiM=;
	h=Date:To:From:Subject:Message-Id; b=j/TaLrVZyfbXfvFk/tigH4tQWsGGFcMQg0drY9pMYTfh61Llg1GI+aT5g8piNqZY/GUtMU9/h9JS87sAO+rPGMEYmxNGhT/gHoJgxveP+33ln55Iri+uIUe4Mw+gzKikKY3O4s9Jgi3lykbFYEqDg72TM1LCUG/cM9xON8vPGic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0eGZmKPZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0eGZmKPZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3B01C2BD11;
	Fri, 26 Apr 2024 04:07:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714104456;
	bh=rIJizTlxsDT+tI6DAik3h28iw+4PCLhpdahJGCHeNiM=;
	h=Date:To:From:Subject:From;
	b=0eGZmKPZaeVN50fl4o0YSi0Eil2LYo8G1ysRdAu69ik/ii7i2HNEr/kTB+Uiro2Ol
	 RDPc327/PUYSAI7bl1mynV3PLfHQsiY25nFitbYP39KfmNVI+4McT2T2tFaRUD+XhL
	 0FgV91z2HPw/qbOLAA2bxQTP77sdv0gj7AApG3PM=
Date: Thu, 25 Apr 2024 21:07:36 -0700
To: mm-commits@vger.kernel.org,torvalds@linux-foundation.org,tglx@linutronix.de,penguin-kernel@I-love.SAKURA.ne.jp,elver@google.com,dvyukov@google.com,glider@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] mm-kmsan-implement-kmsan_memmove.patch removed from -mm tree
Message-Id: <20240426040736.A3B01C2BD11@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: kmsan: implement kmsan_memmove()
has been removed from the -mm tree.  Its filename was
     mm-kmsan-implement-kmsan_memmove.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

kmsan-compiler_types-declare-__no_sanitize_or_inline.patch

