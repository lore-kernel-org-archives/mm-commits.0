From: akpm@linux-foundation.org
Subject: [merged] lib-stringc-use-the-name-c-string-in-comments.patch
 removed from -mm tree
Date: Thu, 05 Jun 2014 13:05:05 -0700
Message-ID: <5390cd71.3JRVoqBfG25VMAnT%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56793 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751660AbaFEUFG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jun 2014 16:05:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, dan.carpenter@oracle.com

Subject: [merged] lib-stringc-use-the-name-c-string-in-comments.patch removed from -mm tree
To: dan.carpenter@oracle.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 05 Jun 2014 13:05:05 -0700


The patch titled
     Subject: lib/string.c: use the name "C-string" in comments
has been removed from the -mm tree.  Its filename was
     lib-stringc-use-the-name-c-string-in-comments.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: lib/string.c: use the name "C-string" in comments

For strncpy() and friends the source string may or may not have an actual
NUL character at the end.  The documentation is confusing in this because
it specifically mentions that you are passing a "NUL-terminated" string. 
Wikipedia says that "C-string" is an alternative name we can use instead.

http://en.wikipedia.org/wiki/Null-terminated_string

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/string.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN lib/string.c~lib-stringc-use-the-name-c-string-in-comments lib/string.c
--- a/lib/string.c~lib-stringc-use-the-name-c-string-in-comments
+++ a/lib/string.c
@@ -107,7 +107,7 @@ EXPORT_SYMBOL(strcpy);
 
 #ifndef __HAVE_ARCH_STRNCPY
 /**
- * strncpy - Copy a length-limited, %NUL-terminated string
+ * strncpy - Copy a length-limited, C-string
  * @dest: Where to copy the string to
  * @src: Where to copy the string from
  * @count: The maximum number of bytes to copy
@@ -136,7 +136,7 @@ EXPORT_SYMBOL(strncpy);
 
 #ifndef __HAVE_ARCH_STRLCPY
 /**
- * strlcpy - Copy a %NUL terminated string into a sized buffer
+ * strlcpy - Copy a C-string into a sized buffer
  * @dest: Where to copy the string to
  * @src: Where to copy the string from
  * @size: size of destination buffer
@@ -182,7 +182,7 @@ EXPORT_SYMBOL(strcat);
 
 #ifndef __HAVE_ARCH_STRNCAT
 /**
- * strncat - Append a length-limited, %NUL-terminated string to another
+ * strncat - Append a length-limited, C-string to another
  * @dest: The string to be appended to
  * @src: The string to append to it
  * @count: The maximum numbers of bytes to copy
@@ -211,7 +211,7 @@ EXPORT_SYMBOL(strncat);
 
 #ifndef __HAVE_ARCH_STRLCAT
 /**
- * strlcat - Append a length-limited, %NUL-terminated string to another
+ * strlcat - Append a length-limited, C-string to another
  * @dest: The string to be appended to
  * @src: The string to append to it
  * @count: The size of the destination buffer.
_

Patches currently in -mm which might be from dan.carpenter@oracle.com are

origin.patch
linux-next.patch

