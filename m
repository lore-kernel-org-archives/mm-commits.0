From: akpm@linux-foundation.org
Subject: [merged]
 lib-make-bitmap_parse_user-a-wrapper-on-bitmap_parse.patch removed from -mm
 tree
Date: Tue, 04 Feb 2020 10:42:29 -0800
Message-ID: <20200204184229.f72pckRpV%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:59370 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727559AbgBDSma (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 4 Feb 2020 13:42:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: acme@redhat.com, amritha.nambiar@intel.com, andriy.shevchenko@linux.intel.com, chris@chris-wilson.co.uk, keescook@chromium.org, linux@rasmusvillemoes.dk, mm-commits@vger.kernel.org, mszeredi@redhat.com, steffen.klassert@secunet.com, tobin@kernel.org, vineet.gupta1@synopsys.com, will.deacon@arm.com, willemb@google.com, willy@infradead.org, yury.norov@gmail.com


The patch titled
     Subject: lib: make bitmap_parse_user a wrapper on bitmap_parse
has been removed from the -mm tree.  Its filename was
     lib-make-bitmap_parse_user-a-wrapper-on-bitmap_parse.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Yury Norov <yury.norov@gmail.com>
Subject: lib: make bitmap_parse_user a wrapper on bitmap_parse

Currently we parse user data byte after byte which leads to
overcomplicating of parsing algorithm.  There are no performance critical
users of bitmap_parse_user(), and so we can duplicate user data to kernel
buffer and simply call bitmap_parselist().  This rework lets us unify and
simplify bitmap_parse() and bitmap_parse_user(), which is done in the
following patch.

Link: http://lkml.kernel.org/r/20200102043031.30357-5-yury.norov@gmail.com
Signed-off-by: Yury Norov <yury.norov@gmail.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Amritha Nambiar <amritha.nambiar@intel.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Kees Cook <keescook@chromium.org>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Miklos Szeredi <mszeredi@redhat.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Steffen Klassert <steffen.klassert@secunet.com>
Cc: "Tobin C . Harding" <tobin@kernel.org>
Cc: Vineet Gupta <vineet.gupta1@synopsys.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Willem de Bruijn <willemb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/bitmap.c |   20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

--- a/lib/bitmap.c~lib-make-bitmap_parse_user-a-wrapper-on-bitmap_parse
+++ a/lib/bitmap.c
@@ -530,22 +530,22 @@ EXPORT_SYMBOL(__bitmap_parse);
  *    then it must be terminated with a \0.
  * @maskp: pointer to bitmap array that will contain result.
  * @nmaskbits: size of bitmap, in bits.
- *
- * Wrapper for __bitmap_parse(), providing it with user buffer.
- *
- * We cannot have this as an inline function in bitmap.h because it needs
- * linux/uaccess.h to get the access_ok() declaration and this causes
- * cyclic dependencies.
  */
 int bitmap_parse_user(const char __user *ubuf,
 			unsigned int ulen, unsigned long *maskp,
 			int nmaskbits)
 {
-	if (!access_ok(ubuf, ulen))
-		return -EFAULT;
-	return __bitmap_parse((const char __force *)ubuf,
-				ulen, 1, maskp, nmaskbits);
+	char *buf;
+	int ret;
 
+	buf = memdup_user_nul(ubuf, ulen);
+	if (IS_ERR(buf))
+		return PTR_ERR(buf);
+
+	ret = bitmap_parse(buf, ulen, maskp, nmaskbits);
+
+	kfree(buf);
+	return ret;
 }
 EXPORT_SYMBOL(bitmap_parse_user);
 
_

Patches currently in -mm which might be from yury.norov@gmail.com are
