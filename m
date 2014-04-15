From: akpm@linux-foundation.org
Subject: [withdrawn] lib-stringc-strlcpy-might-read-too-far.patch removed
 from -mm tree
Date: Tue, 15 Apr 2014 13:46:01 -0700
Message-ID: <534d9a89.V8wlAvqA+FFzrFYw%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34166 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751198AbaDOUqD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 15 Apr 2014 16:46:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, vegard.nossum@gmail.com, dan.carpenter@oracle.com

Subject: [withdrawn] lib-stringc-strlcpy-might-read-too-far.patch removed from -mm tree
To: dan.carpenter@oracle.com,vegard.nossum@gmail.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 15 Apr 2014 13:46:01 -0700


The patch titled
     Subject: lib/string.c: strlcpy() might read too far
has been removed from the -mm tree.  Its filename was
     lib-stringc-strlcpy-might-read-too-far.patch

This patch was dropped because it was withdrawn

------------------------------------------------------
From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: lib/string.c: strlcpy() might read too far

Imagine you have a user controlled variable at the end of a struct which
is allocated at the end of a page.  The strlen() could read beyond the
mapped memory and cause an oops.

Probably there are two reasons why we have never hit this condition in
real life.  First you would have to be really unlucky for all the
variables to line up so the oops can happen.  Second we don't do a lot of
fuzzing with invalid strings.

The strnlen() call is obviously a little bit slower than strlen() but I
have tested it and I think it's probably ok.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Reported-by: Vegard Nossum <vegard.nossum@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/string.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN lib/string.c~lib-stringc-strlcpy-might-read-too-far lib/string.c
--- a/lib/string.c~lib-stringc-strlcpy-might-read-too-far
+++ a/lib/string.c
@@ -148,10 +148,10 @@ EXPORT_SYMBOL(strncpy);
  */
 size_t strlcpy(char *dest, const char *src, size_t size)
 {
-	size_t ret = strlen(src);
+	size_t ret = strnlen(src, size);
 
 	if (size) {
-		size_t len = (ret >= size) ? size - 1 : ret;
+		size_t len = (ret < size) ? ret : ret - 1;
 		memcpy(dest, src, len);
 		dest[len] = '\0';
 	}
_

Patches currently in -mm which might be from dan.carpenter@oracle.com are

lib-stringc-use-the-name-c-string-in-comments.patch
linux-next.patch

