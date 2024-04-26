Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4338480C14
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 04:07:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714104459; cv=none; b=dy1BYQ36IqTRs4qVMjiBX4mzsq8jJA064sj7m5u4MFKRnTR4zPncEhQoIXaudKz7/SblK5j4l/eG3XM3UtPEO2L9VlrOLCHqlFmttG2O9xovWaEub1Pf12L3LP0HJLhkU+Brt8wGXIX6U0RovADEKQHwBcVttuBdBeOcDtC3LyI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714104459; c=relaxed/simple;
	bh=dzRLxg1nnFIzcpuWKzRj948O5dtFhgEz32oD6eAPkjY=;
	h=Date:To:From:Subject:Message-Id; b=Ojqz25qLUKdY0hAsokJrbvHc3j/f5Dv7MrYApWNduFTAyGRgwR+MQCmswEczr4I7ouRHC9MJ8z2gfcrx99O0zxJtRpLVkoQJySUdtN00swr4thKttRWEQ+c9opvAAdRkb+70Hivt6B2AYAaClMHRZQyt0D0+ayBBmMVxm5FKxA4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=cY0s43tZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="cY0s43tZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D39FCC113CD;
	Fri, 26 Apr 2024 04:07:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714104458;
	bh=dzRLxg1nnFIzcpuWKzRj948O5dtFhgEz32oD6eAPkjY=;
	h=Date:To:From:Subject:From;
	b=cY0s43tZkQp5yK79rq33KwfoEu+Izeee0PqTmU8TQMnW6XaGBE62F91X1MI11QMdB
	 pim9AZEVjBf4Zb0D7VKj0H9kwuqV64/FQL25CyEHL3k3R32eEVvtv98md0ASmc08Mi
	 DQVq9q+VhFjMyEmAUuCV85iyUa98boW5+VaN7OBg=
Date: Thu, 25 Apr 2024 21:07:38 -0700
To: mm-commits@vger.kernel.org,torvalds@linux-foundation.org,tglx@linutronix.de,penguin-kernel@I-love.SAKURA.ne.jp,elver@google.com,dvyukov@google.com,glider@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] x86-call-instrumentation-hooks-from-copy_mcc.patch removed from -mm tree
Message-Id: <20240426040738.D39FCC113CD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: x86: call instrumentation hooks from copy_mc.c
has been removed from the -mm tree.  Its filename was
     x86-call-instrumentation-hooks-from-copy_mcc.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

kmsan-compiler_types-declare-__no_sanitize_or_inline.patch

