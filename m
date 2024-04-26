Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9CA1811F7
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 04:07:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714104458; cv=none; b=XKWQ3/0fLFI+3XDJfmppvTdDYzCqC3ltqmkrNPJR0iHTukwy9h578PSMHFOomR5ooePUOs7immqpimHGpM75jCuWwlO3oa89WYKmNn88hyMBOZo1QNWH48P384NGr0Qti/dZCUIGFJqcE2KBha7Pcu5rMjo74pHui+w+uAeFftY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714104458; c=relaxed/simple;
	bh=KJMBqjzQwOL4MsQLnr8syW6TcSH5QtXef9ffXL9Yai0=;
	h=Date:To:From:Subject:Message-Id; b=ebGx2eT4LV4xqxl0DtLpRa0G0fJ5SJFR6n+3d28lRgx9Plfz3TvN3KqOGMJIMw4Xu/ENAGqMux8aOpbhFQgUW89ZCYcSq8HLtwx0C0OPs3ofsZIt8kSPmiMzxw+qPW//LUy9QAj6EE536SXv9WGcFUmjJiW5j4MPjBnI1w7gkJE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=T3hnMCZk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="T3hnMCZk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA64CC113CD;
	Fri, 26 Apr 2024 04:07:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714104457;
	bh=KJMBqjzQwOL4MsQLnr8syW6TcSH5QtXef9ffXL9Yai0=;
	h=Date:To:From:Subject:From;
	b=T3hnMCZkDafW53fZx8R5mm42odOyJCVqB8J8sAc0c1yen/eLL8p/7dV86vHHjj8tJ
	 pZ4O168gfJFFfes5RozgIdJwIrjM5FMJL56yPiJOIcqdRD1sy+QTtsrbLTvGELedl8
	 Zbt67/YLez3uoFrLzUT9JFxSR52oaP0sWkgjXEkI=
Date: Thu, 25 Apr 2024 21:07:37 -0700
To: mm-commits@vger.kernel.org,torvalds@linux-foundation.org,tglx@linutronix.de,penguin-kernel@I-love.SAKURA.ne.jp,elver@google.com,dvyukov@google.com,glider@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] instrumentedh-add-instrument_memcpy_before-instrument_memcpy_after.patch removed from -mm tree
Message-Id: <20240426040737.BA64CC113CD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: instrumented.h: add instrument_memcpy_before, instrument_memcpy_after
has been removed from the -mm tree.  Its filename was
     instrumentedh-add-instrument_memcpy_before-instrument_memcpy_after.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Alexander Potapenko <glider@google.com>
Subject: instrumented.h: add instrument_memcpy_before, instrument_memcpy_after
Date: Wed, 20 Mar 2024 11:18:50 +0100

Bug detection tools based on compiler instrumentation may miss memory
accesses in custom memcpy implementations (such as copy_mc_to_kernel). 
Provide instrumentation hooks that tell KASAN, KCSAN, and KMSAN about such
accesses.

Link: https://lore.kernel.org/all/3b7dbd88-0861-4638-b2d2-911c97a4cadf@I-love.SAKURA.ne.jp/
Link: https://lkml.kernel.org/r/20240320101851.2589698-2-glider@google.com
Signed-off-by: Alexander Potapenko <glider@google.com>
Reviewed-by: Marco Elver <elver@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/instrumented.h |   35 +++++++++++++++++++++++++++++++++
 1 file changed, 35 insertions(+)

--- a/include/linux/instrumented.h~instrumentedh-add-instrument_memcpy_before-instrument_memcpy_after
+++ a/include/linux/instrumented.h
@@ -148,6 +148,41 @@ instrument_copy_from_user_after(const vo
 }
 
 /**
+ * instrument_memcpy_before - add instrumentation before non-instrumented memcpy
+ * @to: destination address
+ * @from: source address
+ * @n: number of bytes to copy
+ *
+ * Instrument memory accesses that happen in custom memcpy implementations. The
+ * instrumentation should be inserted before the memcpy call.
+ */
+static __always_inline void instrument_memcpy_before(void *to, const void *from,
+						     unsigned long n)
+{
+	kasan_check_write(to, n);
+	kasan_check_read(from, n);
+	kcsan_check_write(to, n);
+	kcsan_check_read(from, n);
+}
+
+/**
+ * instrument_memcpy_after - add instrumentation after non-instrumented memcpy
+ * @to: destination address
+ * @from: source address
+ * @n: number of bytes to copy
+ * @left: number of bytes not copied (if known)
+ *
+ * Instrument memory accesses that happen in custom memcpy implementations. The
+ * instrumentation should be inserted after the memcpy call.
+ */
+static __always_inline void instrument_memcpy_after(void *to, const void *from,
+						    unsigned long n,
+						    unsigned long left)
+{
+	kmsan_memmove(to, from, n - left);
+}
+
+/**
  * instrument_get_user() - add instrumentation to get_user()-like macros
  * @to: destination variable, may not be address-taken
  *
_

Patches currently in -mm which might be from glider@google.com are

kmsan-compiler_types-declare-__no_sanitize_or_inline.patch

