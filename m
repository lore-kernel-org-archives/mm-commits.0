Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F52223AD
	for <mm-commits@vger.kernel.org>; Fri, 22 Mar 2024 00:30:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711067403; cv=none; b=hZu/C2DWJKcZ3JHcpTAMDuS/RjOcLQzBIKmK8WoA6kFEHNd9QmN1eLWQWWXnvFvJc40kmeDp9vE+pP2bUEtSk/Eg6DysSUJfhp8GKi3NcZdPXdf7VMc7v9/3xmkTfotCk/kzPAhJWSbCGxRTovKnXWqHqM/zkFCT8GVc6+Xib2c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711067403; c=relaxed/simple;
	bh=TuNk+nxTw77aY1/MIT8naoaMsrrh4q1aPLCgzcuPOuk=;
	h=Date:To:From:Subject:Message-Id; b=Ss3MfjSG7lsevWjaDbfFXsJGs5fLZyURjXjte5jnMJk6MJ6l3vxdfgDKWTiCjXLEA/Cgc1bKFwq+h0vqi7FGLnoUCWxypFUEBAsxwntQ46KhHW3aF6QU1PonEmCtoti3PM5Ep/Pus/7winieaBVXdB2rJluuOLvc7RjasqSSfWQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=CPkvPIdS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="CPkvPIdS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E9A8C433F1;
	Fri, 22 Mar 2024 00:30:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1711067403;
	bh=TuNk+nxTw77aY1/MIT8naoaMsrrh4q1aPLCgzcuPOuk=;
	h=Date:To:From:Subject:From;
	b=CPkvPIdSXnoHtKsRwAVz0ZeWTst9F35McVzXhziQi0Yo+HcZ0h4e/37gjzq3UI/XI
	 GIx8yfa6vBQUCNvardAIeJhn5gVkJXTbwOsvL5SBbaBis0GgJfhlo4QBo3pHeGoUKW
	 ufMoP19ypJSlLVmiNiq4NYcoGhvr2XTdRlf6X7Go=
Date: Thu, 21 Mar 2024 17:30:02 -0700
To: mm-commits@vger.kernel.org,torvalds@linux-foundation.org,tglx@linutronix.de,penguin-kernel@I-love.SAKURA.ne.jp,elver@google.com,dvyukov@google.com,glider@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + instrumentedh-add-instrument_memcpy_before-instrument_memcpy_after.patch added to mm-nonmm-unstable branch
Message-Id: <20240322003003.0E9A8C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: instrumented.h: add instrument_memcpy_before, instrument_memcpy_after
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     instrumentedh-add-instrument_memcpy_before-instrument_memcpy_after.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/instrumentedh-add-instrument_memcpy_before-instrument_memcpy_after.patch

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

mm-kmsan-implement-kmsan_memmove.patch
instrumentedh-add-instrument_memcpy_before-instrument_memcpy_after.patch
x86-call-instrumentation-hooks-from-copy_mcc.patch

