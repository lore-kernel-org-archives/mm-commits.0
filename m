Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A572E27F195;
	Tue,  2 Sep 2025 23:35:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756856152; cv=none; b=GqOZelIa06D+Pt4QSrdy85ezu5pitraTwVAna0B6ozZQQKkH/Sr2YwRmYq0W4P4BI5xrs8wmtv6dLd4B8Z8M0IkwnZ5Sau2DEfe8Qt7L5Ku4xtDGqaONZeQgYjkUaP8gvb+BdTm8sLwR7tuIcPbcuM33IbFgUgJ2CRUOQNRxNtI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756856152; c=relaxed/simple;
	bh=x6LpFluFjx6CMdPJhcdJXxc+ZmKyyp+mg5K9yCMKoXw=;
	h=Date:To:From:Subject:Message-Id; b=riS0/bejN3UgUEXu58BqayPKnYv532xQykAj05NZkzAYYWKmTyBh9n9I5RKSoXIVvvX137V3fgDhC8sHm2p9ZaT8VIg7Hj5y7p4hat07A9Yu4KKSv1tTcNjRnvAXiu2TiLz/QwlSSIlKAmBEMbfGSbLD/eSr16Hjb/mE91les8U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=KuhVkv/d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="KuhVkv/d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A5FBC4CEED;
	Tue,  2 Sep 2025 23:35:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1756856151;
	bh=x6LpFluFjx6CMdPJhcdJXxc+ZmKyyp+mg5K9yCMKoXw=;
	h=Date:To:From:Subject:From;
	b=KuhVkv/dMsehG2G9RndMZhC5kPhaLSbMQxSp8bg7cG2voVcPcXJxYEgToEqtELJp8
	 TCIIp3xzjkr5RdWHbp11ZI3kL8Gn2x+nQW/RFycVPK8ehKSDhO2+gzDg0cK6ffFfa1
	 8I3GWHnLFAfmAwHTNXvJf7Up9lHZP+YCfuyUXI7Q=
Date: Tue, 02 Sep 2025 16:35:50 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,ryabinin.a.a@gmail.com,morbo@google.com,justinstitt@google.com,glider@google.com,elver@google.com,dvyukov@google.com,andreyknvl@gmail.com,nathan@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + compiler-clangh-define-__sanitize___-macros-only-when-undefined.patch added to mm-hotfixes-unstable branch
Message-Id: <20250902233551.1A5FBC4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: compiler-clang.h: define __SANITIZE_*__ macros only when undefined
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     compiler-clangh-define-__sanitize___-macros-only-when-undefined.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/compiler-clangh-define-__sanitize___-macros-only-when-undefined.patch

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
From: Nathan Chancellor <nathan@kernel.org>
Subject: compiler-clang.h: define __SANITIZE_*__ macros only when undefined
Date: Tue, 02 Sep 2025 15:49:26 -0700

Clang 22 recently added support for defining __SANITIZE__ macros similar
to GCC [1], which causes warnings (or errors with CONFIG_WERROR=y or W=e)
with the existing defines that the kernel creates to emulate this behavior
with existing clang versions.

  In file included from <built-in>:3:
  In file included from include/linux/compiler_types.h:171:
  include/linux/compiler-clang.h:37:9: error: '__SANITIZE_THREAD__' macro redefined [-Werror,-Wmacro-redefined]
     37 | #define __SANITIZE_THREAD__
        |         ^
  <built-in>:352:9: note: previous definition is here
    352 | #define __SANITIZE_THREAD__ 1
        |         ^

Refactor compiler-clang.h to only define the sanitizer macros when they
are undefined and adjust the rest of the code to use these macros for
checking if the sanitizers are enabled, clearing up the warnings and
allowing the kernel to easily drop these defines when the minimum
supported version of LLVM for building the kernel becomes 22.0.0 or newer.

Link: https://lkml.kernel.org/r/20250902-clang-update-sanitize-defines-v1-1-cf3702ca3d92@kernel.org
Link: https://github.com/llvm/llvm-project/commit/568c23bbd3303518c5056d7f03444dae4fdc8a9c [1]
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Reviewed-by: Justin Stitt <justinstitt@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Bill Wendling <morbo@google.com>
Cc: Dmitriy Vyukov <dvyukov@google.com>
Cc: Marco Elver <elver@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/compiler-clang.h |   29 ++++++++++++++++++++++++-----
 1 file changed, 24 insertions(+), 5 deletions(-)

--- a/include/linux/compiler-clang.h~compiler-clangh-define-__sanitize___-macros-only-when-undefined
+++ a/include/linux/compiler-clang.h
@@ -18,23 +18,42 @@
 #define KASAN_ABI_VERSION 5
 
 /*
+ * Clang 22 added preprocessor macros to match GCC, in hopes of eventually
+ * dropping __has_feature support for sanitizers:
+ * https://github.com/llvm/llvm-project/commit/568c23bbd3303518c5056d7f03444dae4fdc8a9c
+ * Create these macros for older versions of clang so that it is easy to clean
+ * up once the minimum supported version of LLVM for building the kernel always
+ * creates these macros.
+ *
  * Note: Checking __has_feature(*_sanitizer) is only true if the feature is
  * enabled. Therefore it is not required to additionally check defined(CONFIG_*)
  * to avoid adding redundant attributes in other configurations.
  */
+#if __has_feature(address_sanitizer) && !defined(__SANITIZE_ADDRESS__)
+#define __SANITIZE_ADDRESS__
+#endif
+#if __has_feature(hwaddress_sanitizer) && !defined(__SANITIZE_HWADDRESS__)
+#define __SANITIZE_HWADDRESS__
+#endif
+#if __has_feature(thread_sanitizer) && !defined(__SANITIZE_THREAD__)
+#define __SANITIZE_THREAD__
+#endif
 
-#if __has_feature(address_sanitizer) || __has_feature(hwaddress_sanitizer)
-/* Emulate GCC's __SANITIZE_ADDRESS__ flag */
+/*
+ * Treat __SANITIZE_HWADDRESS__ the same as __SANITIZE_ADDRESS__ in the kernel.
+ */
+#ifdef __SANITIZE_HWADDRESS__
 #define __SANITIZE_ADDRESS__
+#endif
+
+#ifdef __SANITIZE_ADDRESS__
 #define __no_sanitize_address \
 		__attribute__((no_sanitize("address", "hwaddress")))
 #else
 #define __no_sanitize_address
 #endif
 
-#if __has_feature(thread_sanitizer)
-/* emulate gcc's __SANITIZE_THREAD__ flag */
-#define __SANITIZE_THREAD__
+#ifdef __SANITIZE_THREAD__
 #define __no_sanitize_thread \
 		__attribute__((no_sanitize("thread")))
 #else
_

Patches currently in -mm which might be from nathan@kernel.org are

compiler-clangh-define-__sanitize___-macros-only-when-undefined.patch
mm-rmap-convert-enum-rmap_level-to-enum-pgtable_level-fix.patch

