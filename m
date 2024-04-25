Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86AD7152DE6;
	Thu, 25 Apr 2024 20:31:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714077108; cv=none; b=pdILbiftXsXdbPtg0p23hYnV9tBm3lw+BP4fLDli20ViZKs1biTPMwQKciXsTZh9TJnn3vpZYJP+FneoJWFpvAAssSBbY8dNU+PZEDuLBLKiT8zUjCYDwc+DrrzApCSljDKNreniOJTh2KuXS27+Mj4OB6inOfnxjGhGAScka8U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714077108; c=relaxed/simple;
	bh=Wt8IgxHYFqfRDRLjtQroy9iMu2/HAuvcxeZhMKnrdC4=;
	h=Date:To:From:Subject:Message-Id; b=LlmWjlDsCsT6pDoHLYFdQHGnR9zfx2/TYwUT9mK3efGKAnDfBB/Yz2ZW8gKdsc+KVrvQxBXpBhU+TZKpAXekp2OQ+pB1P5jHbJQcCFIP0UNtVaH6xcdaoTbBERv83EL/mC/bzoCe08FNM7PeVv7OUscVN4ehHkCU9OyZI2aWiQE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=wUKz8+xD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wUKz8+xD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E03D8C113CE;
	Thu, 25 Apr 2024 20:31:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714077108;
	bh=Wt8IgxHYFqfRDRLjtQroy9iMu2/HAuvcxeZhMKnrdC4=;
	h=Date:To:From:Subject:From;
	b=wUKz8+xDIwy6oVqAr6WsqfBsNPcIxZxfKTnDh0bR0KfaNwJdicYY7wmJHOt4loFmz
	 drrNBOS+UXd/TFrDy6W7Gc6xUntEF0emHapEZRj4/3kRrbMsmfoXAjW1GufXZSYQ0S
	 Ub92+1qqdT+InT+ZuiNC5B81ji7l9xlhtuuDXm1c=
Date: Thu, 25 Apr 2024 13:31:47 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,ojeda@kernel.org,elver@google.com,dvyukov@google.com,glider@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kmsan-compiler_types-declare-__no_sanitize_or_inline.patch added to mm-hotfixes-unstable branch
Message-Id: <20240425203147.E03D8C113CE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kmsan: compiler_types: declare __no_sanitize_or_inline
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     kmsan-compiler_types-declare-__no_sanitize_or_inline.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kmsan-compiler_types-declare-__no_sanitize_or_inline.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
Subject: kmsan: compiler_types: declare __no_sanitize_or_inline
Date: Thu, 25 Apr 2024 11:28:59 +0200

It turned out that KMSAN instruments READ_ONCE_NOCHECK(), resulting in
false positive reports, because __no_sanitize_or_inline enforced inlining.

Properly declare __no_sanitize_or_inline under __SANITIZE_MEMORY__,
so that it does not inline the annotated function.

Link: https://lkml.kernel.org/r/20240425092859.3370297-1-glider@google.com
Reported-by: syzbot+355c5bb8c1445c871ee8@syzkaller.appspotmail.com
Link: https://lkml.kernel.org/r/000000000000826ac1061675b0e3@google.com
Signed-off-by: Alexander Potapenko <glider@google.com>
Reviewed-by: Marco Elver <elver@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Miguel Ojeda <ojeda@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/compiler_types.h |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/include/linux/compiler_types.h~kmsan-compiler_types-declare-__no_sanitize_or_inline
+++ a/include/linux/compiler_types.h
@@ -278,6 +278,17 @@ struct ftrace_likely_data {
 # define __no_kcsan
 #endif
 
+#ifdef __SANITIZE_MEMORY__
+/*
+ * Similarly to KASAN and KCSAN, KMSAN loses function attributes of inlined
+ * functions, therefore disabling KMSAN checks also requires disabling inlining.
+ *
+ * __no_sanitize_or_inline effectively prevents KMSAN from reporting errors
+ * within the function and marks all its outputs as initialized.
+ */
+# define __no_sanitize_or_inline __no_kmsan_checks notrace __maybe_unused
+#endif
+
 #ifndef __no_sanitize_or_inline
 #define __no_sanitize_or_inline __always_inline
 #endif
_

Patches currently in -mm which might be from glider@google.com are

kmsan-compiler_types-declare-__no_sanitize_or_inline.patch
mm-kmsan-implement-kmsan_memmove.patch
instrumentedh-add-instrument_memcpy_before-instrument_memcpy_after.patch
x86-call-instrumentation-hooks-from-copy_mcc.patch

