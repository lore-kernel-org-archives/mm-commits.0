From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 59/67] lib/string: add strnchrnul()
Date: Mon, 03 Feb 2020 17:37:20 -0800
Message-ID: <20200204013720.6WLKyLh5o%akpm@linux-foundation.org>
References: <20200203173311.6269a8be06a05e5a4aa08a93@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:39130 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726872AbgBDBhX (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 3 Feb 2020 20:37:23 -0500
In-Reply-To: <20200203173311.6269a8be06a05e5a4aa08a93@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: acme@redhat.com, akpm@linux-foundation.org, amritha.nambiar@intel.com, andriy.shevchenko@linux.intel.com, chris@chris-wilson.co.uk, keescook@chromium.org, linux-mm@kvack.org, linux@rasmusvillemoes.dk, mm-commits@vger.kernel.org, mszeredi@redhat.com, steffen.klassert@secunet.com, tobin@kernel.org, torvalds@linux-foundation.org, vineet.gupta1@synopsys.com, will.deacon@arm.com, willemb@google.com, willy@infradead.org, yury.norov@gmail.com

From: Yury Norov <yury.norov@gmail.com>
Subject: lib/string: add strnchrnul()

Patch series "lib: rework bitmap_parse", v5.

Similarl to the recently revisited bitmap_parselist(), bitmap_parse() is
ineffective and overcomplicated.  This series reworks it, aligns its
interface with bitmap_parselist() and makes it simpler to use.

The series also adds a test for the function and fixes usage of it in
cpumask_parse() according to the new design - drops the calculating of
length of an input string.

bitmap_parse() takes the array of numbers to be put into the map in the BE
order which is reversed to the natural LE order for bitmaps.  For example,
to construct bitmap containing a bit on the position 42, we have to put a
line '400,0'.  Current implementation reads chunk one by one from the
beginning ('400' before '0') and makes bitmap shift after each successful
parse.  It makes the complexity of the whole process as O(n^2).  We can do
it in reverse direction ('0' before '400') and avoid shifting, but it
requires reverse parsing helpers.


This patch (of 7):

New function works like strchrnul() with a length limited string.

Link: http://lkml.kernel.org/r/20200102043031.30357-2-yury.norov@gmail.com
Signed-off-by: Yury Norov <yury.norov@gmail.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Amritha Nambiar <amritha.nambiar@intel.com>
Cc: Willem de Bruijn <willemb@google.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: "Tobin C . Harding" <tobin@kernel.org>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Miklos Szeredi <mszeredi@redhat.com>
Cc: Vineet Gupta <vineet.gupta1@synopsys.com>
Cc: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/string.h |    1 +
 lib/string.c           |   17 +++++++++++++++++
 2 files changed, 18 insertions(+)

--- a/include/linux/string.h~lib-string-add-strnchrnul
+++ a/include/linux/string.h
@@ -62,6 +62,7 @@ extern char * strchr(const char *,int);
 #ifndef __HAVE_ARCH_STRCHRNUL
 extern char * strchrnul(const char *,int);
 #endif
+extern char * strnchrnul(const char *, size_t, int);
 #ifndef __HAVE_ARCH_STRNCHR
 extern char * strnchr(const char *, size_t, int);
 #endif
--- a/lib/string.c~lib-string-add-strnchrnul
+++ a/lib/string.c
@@ -434,6 +434,23 @@ char *strchrnul(const char *s, int c)
 EXPORT_SYMBOL(strchrnul);
 #endif
 
+/**
+ * strnchrnul - Find and return a character in a length limited string,
+ * or end of string
+ * @s: The string to be searched
+ * @count: The number of characters to be searched
+ * @c: The character to search for
+ *
+ * Returns pointer to the first occurrence of 'c' in s. If c is not found,
+ * then return a pointer to the last character of the string.
+ */
+char *strnchrnul(const char *s, size_t count, int c)
+{
+	while (count-- && *s && *s != (char)c)
+		s++;
+	return (char *)s;
+}
+
 #ifndef __HAVE_ARCH_STRRCHR
 /**
  * strrchr - Find the last occurrence of a character in a string
_
