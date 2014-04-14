From: akpm@linux-foundation.org
Subject: + lib-stringc-use-the-name-c-string-in-comments.patch added to
 -mm tree
Date: Mon, 14 Apr 2014 14:47:02 -0700
Message-ID: <534c5756.Yt3Z8/sd4Aw7p/SY%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52122 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754300AbaDNVrD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 14 Apr 2014 17:47:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, dan.carpenter@oracle.com

Subject: + lib-stringc-use-the-name-c-string-in-comments.patch added to -mm tree
To: dan.carpenter@oracle.com
From: akpm@linux-foundation.org
Date: Mon, 14 Apr 2014 14:47:02 -0700


The patch titled
     Subject: lib/string.c: use the name "C-string" in comments
has been added to the -mm tree.  Its filename is
     lib-stringc-use-the-name-c-string-in-comments.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lib-stringc-use-the-name-c-string-in-comments.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lib-stringc-use-the-name-c-string-in-comments.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

lib-stringc-use-the-name-c-string-in-comments.patch
lib-stringc-strlcpy-might-read-too-far.patch
linux-next.patch

