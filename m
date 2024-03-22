Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F66510F2
	for <mm-commits@vger.kernel.org>; Fri, 22 Mar 2024 00:30:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711067405; cv=none; b=ZaommM/xcdD4sF1XMNTZ6EajudQ6KQ7v4xmUjIHjARaVFBC7j91G+DhuVBiYV9CCsVbCzu7M2RueZ5Z9KczQM4ukF3Nv7oPlzehLfG6eppZyMHNO0ZxKmswoYEqFofSWIlzUojO2CP8Jv5XTQkn8kVebdV9144YXRRQBLWrlVQI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711067405; c=relaxed/simple;
	bh=lUMCeZdv5T5tfBxThAeOCdQvV23iN8YbLsAPyXZ6PQI=;
	h=Date:To:From:Subject:Message-Id; b=oQxnEzuHU4FMGru1jcV15q/p8tnMIL5XEZuxSen+ZLs2U7ANY6dao9RfYesxhobQBggLGrFvK270mudQaayIj0u0+rje4VfM5hVpCbIiYkix8i6hCdUwZRhWvDfWzWHOSLmHgyb1XZF/nL1eAmS9sW2ejhl4sZLbbpFDq91iMUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=iNNORPLh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="iNNORPLh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBC57C433C7;
	Fri, 22 Mar 2024 00:30:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1711067405;
	bh=lUMCeZdv5T5tfBxThAeOCdQvV23iN8YbLsAPyXZ6PQI=;
	h=Date:To:From:Subject:From;
	b=iNNORPLhiJb0yyt8cp1GenaqXG56KqSeOBlRLKbHvxqvL9L7yUW6GMPuRooqnBtvx
	 qCGvIi47vN6BBcd+v465sfDIJJepW5uInHm51PqUFfxAibC1m7R3XAfMA7s/x3OZQy
	 uqYI25Yp8XSpgFzKuFpgdtlH/v1KsIrilOdXjPOk=
Date: Thu, 21 Mar 2024 17:30:04 -0700
To: mm-commits@vger.kernel.org,torvalds@linux-foundation.org,tglx@linutronix.de,penguin-kernel@I-love.SAKURA.ne.jp,elver@google.com,dvyukov@google.com,glider@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + x86-call-instrumentation-hooks-from-copy_mcc.patch added to mm-nonmm-unstable branch
Message-Id: <20240322003004.EBC57C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: x86: call instrumentation hooks from copy_mc.c
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     x86-call-instrumentation-hooks-from-copy_mcc.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/x86-call-instrumentation-hooks-from-copy_mcc.patch

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
Subject: x86: call instrumentation hooks from copy_mc.c
Date: Wed, 20 Mar 2024 11:18:51 +0100

Memory accesses in copy_mc_to_kernel() and copy_mc_to_user() are performed
by assembly routines and are invisible to KASAN, KCSAN, and KMSAN.  Add
hooks from instrumentation.h to tell the tools these functions have
memcpy/copy_from_user semantics.

The call to copy_mc_fragile() in copy_mc_fragile_handle_tail() is left
intact, because the latter is only called from the assembly implementation
of copy_mc_fragile(), so the memory accesses in it are covered by the
instrumentation in copy_mc_to_kernel() and copy_mc_to_user().

Link: https://lore.kernel.org/all/3b7dbd88-0861-4638-b2d2-911c97a4cadf@I-love.SAKURA.ne.jp/
Link: https://lkml.kernel.org/r/20240320101851.2589698-3-glider@google.com
Signed-off-by: Alexander Potapenko <glider@google.com>
Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Marco Elver <elver@google.com>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/lib/copy_mc.c |   21 +++++++++++++++++----
 1 file changed, 17 insertions(+), 4 deletions(-)

--- a/arch/x86/lib/copy_mc.c~x86-call-instrumentation-hooks-from-copy_mcc
+++ a/arch/x86/lib/copy_mc.c
@@ -4,6 +4,7 @@
 #include <linux/jump_label.h>
 #include <linux/uaccess.h>
 #include <linux/export.h>
+#include <linux/instrumented.h>
 #include <linux/string.h>
 #include <linux/types.h>
 
@@ -61,10 +62,20 @@ unsigned long copy_mc_enhanced_fast_stri
  */
 unsigned long __must_check copy_mc_to_kernel(void *dst, const void *src, unsigned len)
 {
-	if (copy_mc_fragile_enabled)
-		return copy_mc_fragile(dst, src, len);
-	if (static_cpu_has(X86_FEATURE_ERMS))
-		return copy_mc_enhanced_fast_string(dst, src, len);
+	unsigned long ret;
+
+	if (copy_mc_fragile_enabled) {
+		instrument_memcpy_before(dst, src, len);
+		ret = copy_mc_fragile(dst, src, len);
+		instrument_memcpy_after(dst, src, len, ret);
+		return ret;
+	}
+	if (static_cpu_has(X86_FEATURE_ERMS)) {
+		instrument_memcpy_before(dst, src, len);
+		ret = copy_mc_enhanced_fast_string(dst, src, len);
+		instrument_memcpy_after(dst, src, len, ret);
+		return ret;
+	}
 	memcpy(dst, src, len);
 	return 0;
 }
@@ -75,6 +86,7 @@ unsigned long __must_check copy_mc_to_us
 	unsigned long ret;
 
 	if (copy_mc_fragile_enabled) {
+		instrument_copy_to_user(dst, src, len);
 		__uaccess_begin();
 		ret = copy_mc_fragile((__force void *)dst, src, len);
 		__uaccess_end();
@@ -82,6 +94,7 @@ unsigned long __must_check copy_mc_to_us
 	}
 
 	if (static_cpu_has(X86_FEATURE_ERMS)) {
+		instrument_copy_to_user(dst, src, len);
 		__uaccess_begin();
 		ret = copy_mc_enhanced_fast_string((__force void *)dst, src, len);
 		__uaccess_end();
_

Patches currently in -mm which might be from glider@google.com are

mm-kmsan-implement-kmsan_memmove.patch
instrumentedh-add-instrument_memcpy_before-instrument_memcpy_after.patch
x86-call-instrumentation-hooks-from-copy_mcc.patch

