From: akpm@linux-foundation.org
Subject: [merged]
 mm-maccessc-actually-return-efault-from-strncpy_from_unsafe.patch removed
 from -mm tree
Date: Fri, 06 Nov 2015 12:17:03 -0800
Message-ID: <563d0abf.b4iO7IQu8mnztXpB%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49052 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161895AbbKFURD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Nov 2015 15:17:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@rasmusvillemoes.dk, ast@kernel.org, masami.hiramatsu.pt@hitachi.com, namhyung@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/maccess.c: actually return -EFAULT from strncpy_from_unsafe
has been removed from the -mm tree.  Its filename was
     mm-maccessc-actually-return-efault-from-strncpy_from_unsafe.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: mm/maccess.c: actually return -EFAULT from strncpy_from_unsafe

As far as I can tell, strncpy_from_unsafe never returns -EFAULT.  ret is
the result of a __copy_from_user_inatomic(), which is 0 for success and
positive (in this case necessarily 1) for access error - it is never
negative.  So we were always returning the length of the, possibly
truncated, destination string.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Acked-by: Alexei Starovoitov <ast@kernel.org>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/maccess.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/maccess.c~mm-maccessc-actually-return-efault-from-strncpy_from_unsafe mm/maccess.c
--- a/mm/maccess.c~mm-maccessc-actually-return-efault-from-strncpy_from_unsafe
+++ a/mm/maccess.c
@@ -104,5 +104,5 @@ long strncpy_from_unsafe(char *dst, cons
 	pagefault_enable();
 	set_fs(old_fs);
 
-	return ret < 0 ? ret : src - unsafe_addr;
+	return ret ? -EFAULT : src - unsafe_addr;
 }
_

Patches currently in -mm which might be from linux@rasmusvillemoes.dk are

slabh-sprinkle-__assume_aligned-attributes.patch
lib-dynamic_debugc-use-kstrdup_const.patch
lib-vsprintfc-handle-invalid-format-specifiers-more-robustly.patch
lib-vsprintfc-also-improve-sanity-check-in-bstr_printf.patch
lib-vsprintfc-remove-special-handling-in-pointer.patch
test_printf-test-printf-family-at-runtime.patch
lib-vsprintfc-update-documentation.patch
lib-introduce-kvasprintf_const.patch
kobject-use-kvasprintf_const-for-formatting-name.patch

