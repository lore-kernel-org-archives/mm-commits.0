Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8D7B2253F1
	for <mm-commits@vger.kernel.org>; Thu,  6 Feb 2025 07:45:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738827916; cv=none; b=tHa1Xt6GyH4xcrGaLE9vDPUP+Pt3Xs1j6BCZ/97xHqZ1GAU6unxwXJPitsllnJUTIIBdpraKOCP+t3TJBXwDd43xvgVuzPjZ6T5WaN/jOyESVJLXD+2yFyG6FAOwNSHnXsmGYyBJMXwZJ12YQ0cNzIms2IbUavzIkntlRp2qaaI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738827916; c=relaxed/simple;
	bh=JWKnpFRL8QbXghQg3hYpxoNVJKRbawf2oJq7c8JCo4U=;
	h=Date:To:From:Subject:Message-Id; b=Ko3uUUQWsFsb/YGoK9Nu1/Zal55NL31gZxJcauN9KxXdflf0yTm/Cd7m5wNoKIKHYYXdZfvB4AwE7urQqzfuhjnSIusDXwQwQ8Yb42XcBBnZNjOgF1yQOoIUThwM8Xa3OjdtR0g48vLgQ/2/lNMkxGvMxMPkw42mm7wY4QXCAUQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=QPnlaNLS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="QPnlaNLS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0516AC4CEDD;
	Thu,  6 Feb 2025 07:45:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1738827916;
	bh=JWKnpFRL8QbXghQg3hYpxoNVJKRbawf2oJq7c8JCo4U=;
	h=Date:To:From:Subject:From;
	b=QPnlaNLS45mwsXvIez8XBIq5o7AIaGdcnKYDXHMYiHZicJqm88zsZPTnGql2f9Yj8
	 Pa2TymJCMbh3LeARIlzKW31BplKy0Uwvf3VYgTwd4tXh4B36VxTWzfe8yWErmGTJXS
	 qYxDGgviHmvLlGZV82uIMPqgKVBlThm5HAguJUU4=
Date: Wed, 05 Feb 2025 23:45:15 -0800
To: mm-commits@vger.kernel.org,zaslonko@linux.ibm.com,sergey.senozhatsky@gmail.com,joe@perches.com,iii@linux.ibm.com,heiko.carstens@de.ibm.com,yury.norov@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-zlib-drop-equal-macro.patch added to mm-nonmm-unstable branch
Message-Id: <20250206074516.0516AC4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib/zlib: drop EQUAL macro
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-zlib-drop-equal-macro.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-zlib-drop-equal-macro.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: Yury Norov <yury.norov@gmail.com>
Subject: lib/zlib: drop EQUAL macro
Date: Wed, 5 Feb 2025 16:29:32 -0500

The macro is prehistoric, and only exists to help those readers who don't
know what memcmp() returns if memory areas differ.  This is pretty well
documented, so the macro looks excessive.

Now that the only user of the macro depends on DEBUG_ZLIB config, GCC
warns about unused macro if the library is built with W=2 against
defconfig.  So drop it for good.

Link: https://lkml.kernel.org/r/20250205212933.68695-1-yury.norov@gmail.com
Signed-off-by: Yury Norov <yury.norov@gmail.com>
Cc: Heiko Carsten <heiko.carstens@de.ibm.com>
Cc: Ilya Leoshkevich <iii@linux.ibm.com>
Cc: Mikhail Zaslonko <zaslonko@linux.ibm.com>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/zlib_deflate/deflate.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

--- a/lib/zlib_deflate/deflate.c~lib-zlib-drop-equal-macro
+++ a/lib/zlib_deflate/deflate.c
@@ -151,9 +151,6 @@ static const config configuration_table[
  * meaning.
  */
 
-#define EQUAL 0
-/* result of memcmp for equal strings */
-
 /* ===========================================================================
  * Update a hash value with the given input byte
  * IN  assertion: all calls to UPDATE_HASH are made with consecutive
@@ -713,8 +710,7 @@ static void check_match(
 )
 {
     /* check that the match is indeed a match */
-    if (memcmp((char *)s->window + match,
-                (char *)s->window + start, length) != EQUAL) {
+    if (memcmp((char *)s->window + match, (char *)s->window + start, length)) {
         fprintf(stderr, " start %u, match %u, length %d\n",
 		start, match, length);
         do {
_

Patches currently in -mm which might be from yury.norov@gmail.com are

lib-zlib-drop-equal-macro.patch

