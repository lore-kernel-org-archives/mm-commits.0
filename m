From: akpm@linux-foundation.org
Subject: + lib-stringc-strlcpy-might-read-too-far.patch added to -mm tree
Date: Mon, 14 Apr 2014 14:47:03 -0700
Message-ID: <534c5757.VydWMxxcqkXGiwNa%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52124 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754345AbaDNVrE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 14 Apr 2014 17:47:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, vegard.nossum@gmail.com, dan.carpenter@oracle.com

Subject: + lib-stringc-strlcpy-might-read-too-far.patch added to -mm tree
To: dan.carpenter@oracle.com,vegard.nossum@gmail.com
From: akpm@linux-foundation.org
Date: Mon, 14 Apr 2014 14:47:03 -0700


The patch titled
     Subject: lib/string.c: strlcpy() might read too far
has been added to the -mm tree.  Its filename is
     lib-stringc-strlcpy-might-read-too-far.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lib-stringc-strlcpy-might-read-too-far.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lib-stringc-strlcpy-might-read-too-far.patch

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
lib-stringc-strlcpy-might-read-too-far.patch
linux-next.patch

