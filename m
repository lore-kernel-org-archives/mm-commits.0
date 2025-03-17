Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD229140E30
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 05:31:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742189504; cv=none; b=SFKGDLhorpOZjwQRUD8EICNmNjs9sOfS5KWbEzuYlCOTFvAKvm//LQprDXbeYMlwulLbppYpS8VwEpAmoen7hLtYtNOXtI6q5+6RZUDhs7Gp+NItWzk19Js+w95w5wBlLBgBTL06p8EDiZY5wuEpBegN4M7ONQmECi0/45pegzU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742189504; c=relaxed/simple;
	bh=boJi9wPOulldeieitF0lDeRFjIWK/+q8nmBYI8xeaks=;
	h=Date:To:From:Subject:Message-Id; b=OfpbM4/+fHr4NF91Q/T5UMKKVYOF2pn5qxw3yqpbG112lha38+qezHO77Tt/SEWKTWwz11jre1Hmx5+4lP1NEl5TwzlI7/xA2O3wA/aRWf1a8hBzyFXJiQprIiKcN8EgtxMuq/tCwuXoaRoOeyEjIgzx6OeUVKLPPuGQQKk2Tbs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ukfcMA/D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ukfcMA/D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33FD7C4CEEC;
	Mon, 17 Mar 2025 05:31:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742189504;
	bh=boJi9wPOulldeieitF0lDeRFjIWK/+q8nmBYI8xeaks=;
	h=Date:To:From:Subject:From;
	b=ukfcMA/DFHCbs0Yd9GTXe9Jkesb9sDtXe56MBHeVWnuZkXAytzePHENdJKwrM5czZ
	 ts/MXgKp4yDUWDFTcWGe3sOsMTzvbv/KNnQuDAWgBUnBHqoJOFBqP81heGwKc4NtMz
	 4fIUYiw/xC60cc7Y/8jIHrdZ731KwQqkC/K98U3Y=
Date: Sun, 16 Mar 2025 22:31:43 -0700
To: mm-commits@vger.kernel.org,zaslonko@linux.ibm.com,senozhatsky@chromium.org,joe@perches.com,iii@linux.ibm.com,heiko.carstens@de.ibm.com,yury.norov@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] lib-zlib-drop-equal-macro.patch removed from -mm tree
Message-Id: <20250317053144.33FD7C4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: lib/zlib: drop EQUAL macro
has been removed from the -mm tree.  Its filename was
     lib-zlib-drop-equal-macro.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Reviewed-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Reviewed-by: Mikhail Zaslonko <zaslonko@linux.ibm.com>
Cc: Heiko Carsten <heiko.carstens@de.ibm.com>
Cc: Ilya Leoshkevich <iii@linux.ibm.com>
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


