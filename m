Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C5702EB10
	for <mm-commits@vger.kernel.org>; Mon, 12 May 2025 00:55:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747011350; cv=none; b=lwiW1nNQvDfO16XCsKxbqFbrmmutOAIS50U2b0bn4bKKj4taLuoziuEqXzwkfa196t0UPOhACE4VlNQp8ldgQcCWY5CYbja81KHC0KoUDZQBNspdSF5nAo/lAX2hKLrRoOXO0S6FRV9QSIRV8yWjVisQKjSGSkpZRlsjTmYpi/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747011350; c=relaxed/simple;
	bh=3uY/Okg+xhaSJOc+IHylrZVnx9jDNQIXDDNl6IVTikE=;
	h=Date:To:From:Subject:Message-Id; b=sdHIcItwnMlbgzLc1rkVGcbYhBsoR9esVNYsmrcG36lrXxfZQWI75uaaifhrXhOjs/Q1JM6kT4TqPSDB/IeyEzq21W4rpGd+3GCcC6L8xk6u42CtJQjQk4XeBMNYWh/Eq11qGEtXp85zW+Dx/DaW2Xu8Ppwbu2ZYhj22yS6abJY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=sON6o06D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="sON6o06D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E4A9C4CEE4;
	Mon, 12 May 2025 00:55:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747011350;
	bh=3uY/Okg+xhaSJOc+IHylrZVnx9jDNQIXDDNl6IVTikE=;
	h=Date:To:From:Subject:From;
	b=sON6o06DM2KlFpiStAe6LuBZ2M+8YnymVDm1SoFlgE/vbINyIIapiJfac1/v9C7j3
	 5xgAVJPO/msEVIaqR29qoSDBqrrzYWTGe2H3AX8eSr7iz8bePQyhWUvNYRBfINS0OW
	 nsazwXCqFwEq6WveFKzhdOLKADlZrEvTiJU07STY=
Date: Sun, 11 May 2025 17:55:49 -0700
To: mm-commits@vger.kernel.org,mingo@kernel.org,aardelean@baylibre.com,andriy.shevchenko@linux.intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] kernelh-move-ptr_if-and-u64_to_user_ptr-to-util_macrosh.patch removed from -mm tree
Message-Id: <20250512005550.5E4A9C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kernel.h: move PTR_IF() and u64_to_user_ptr() to util_macros.h
has been removed from the -mm tree.  Its filename was
     kernelh-move-ptr_if-and-u64_to_user_ptr-to-util_macrosh.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: kernel.h: move PTR_IF() and u64_to_user_ptr() to util_macros.h
Date: Mon, 24 Mar 2025 12:50:25 +0200

While the natural choice of PTR_IF() is kconfig.h, the latter is too broad
to include C code and actually the macro was moved out from there in the
past.  But kernel.h is neither a good choice for that.  Move it to
util_macros.h.  Do the same for u64_to_user_ptr().

While moving, add necessary documentation.

Link: https://lkml.kernel.org/r/20250324105228.775784-3-andriy.shevchenko@linux.intel.com
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Alexandru Ardelean <aardelean@baylibre.com>
Cc: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kernel.h      |   10 -----
 include/linux/util_macros.h |   66 ++++++++++++++++++++++++++++++++++
 2 files changed, 67 insertions(+), 9 deletions(-)

--- a/include/linux/kernel.h~kernelh-move-ptr_if-and-u64_to_user_ptr-to-util_macrosh
+++ a/include/linux/kernel.h
@@ -33,6 +33,7 @@
 #include <linux/sprintf.h>
 #include <linux/static_call_types.h>
 #include <linux/instruction_pointer.h>
+#include <linux/util_macros.h>
 #include <linux/wordpart.h>
 
 #include <asm/byteorder.h>
@@ -41,15 +42,6 @@
 
 #define STACK_MAGIC	0xdeadbeef
 
-#define PTR_IF(cond, ptr)	((cond) ? (ptr) : NULL)
-
-#define u64_to_user_ptr(x) (		\
-{					\
-	typecheck(u64, (x));		\
-	(void __user *)(uintptr_t)(x);	\
-}					\
-)
-
 struct completion;
 struct user;
 
--- a/include/linux/util_macros.h~kernelh-move-ptr_if-and-u64_to_user_ptr-to-util_macrosh
+++ a/include/linux/util_macros.h
@@ -80,6 +80,72 @@
 })
 
 /**
+ * PTR_IF - evaluate to @ptr if @cond is true, or to NULL otherwise.
+ * @cond: A conditional, usually in a form of IS_ENABLED(CONFIG_FOO)
+ * @ptr: A pointer to assign if @cond is true.
+ *
+ * PTR_IF(IS_ENABLED(CONFIG_FOO), ptr) evaluates to @ptr if CONFIG_FOO is set
+ * to 'y' or 'm', or to NULL otherwise. The (ptr) argument must be a pointer.
+ *
+ * The macro can be very useful to help compiler dropping dead code.
+ *
+ * For instance, consider the following::
+ *
+ *     #ifdef CONFIG_FOO_SUSPEND
+ *     static int foo_suspend(struct device *dev)
+ *     {
+ *        ...
+ *     }
+ *     #endif
+ *
+ *     static struct pm_ops foo_ops = {
+ *     #ifdef CONFIG_FOO_SUSPEND
+ *         .suspend = foo_suspend,
+ *     #endif
+ *     };
+ *
+ * While this works, the foo_suspend() macro is compiled conditionally,
+ * only when CONFIG_FOO_SUSPEND is set. This is problematic, as there could
+ * be a build bug in this function, we wouldn't have a way to know unless
+ * the configuration option is set.
+ *
+ * An alternative is to declare foo_suspend() always, but mark it
+ * as __maybe_unused. This works, but the __maybe_unused attribute
+ * is required to instruct the compiler that the function may not
+ * be referenced anywhere, and is safe to remove without making
+ * a fuss about it. This makes the programmer responsible for tagging
+ * the functions that can be garbage-collected.
+ *
+ * With the macro it is possible to write the following:
+ *
+ *     static int foo_suspend(struct device *dev)
+ *     {
+ *        ...
+ *     }
+ *
+ *     static struct pm_ops foo_ops = {
+ *         .suspend = PTR_IF(IS_ENABLED(CONFIG_FOO_SUSPEND), foo_suspend),
+ *     };
+ *
+ * The foo_suspend() function will now be automatically dropped by the
+ * compiler, and it does not require any specific attribute.
+ */
+#define PTR_IF(cond, ptr)	((cond) ? (ptr) : NULL)
+
+/**
+ * to_user_ptr - cast a pointer passed as u64 from user space to void __user *
+ * @x: The u64 value from user space, usually via IOCTL
+ *
+ * to_user_ptr() simply casts a pointer passed as u64 from user space to void
+ * __user * correctly. Using this lets us get rid of all the tiresome casts.
+ */
+#define u64_to_user_ptr(x)		\
+({					\
+	typecheck(u64, (x));		\
+	(void __user *)(uintptr_t)(x);	\
+})
+
+/**
  * is_insidevar - check if the @ptr points inside the @var memory range.
  * @ptr:	the pointer to a memory address.
  * @var:	the variable which address and size identify the memory range.
_

Patches currently in -mm which might be from andriy.shevchenko@linux.intel.com are

util_macrosh-make-the-header-more-resilient.patch

