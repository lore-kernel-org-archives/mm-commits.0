Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E66D5424D47;
	Tue,  4 Aug 2026 04:05:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785816356; cv=none; b=iGxuSzD2q16reWyWD1hNECeNW+huiU8i/RpZW+vQJJNyucUvOnaj+b40tJFU5+G8aikukfgwmm6RyHcSaAhVwbBK7Vl24dxyTplwn1cckCJfsziVkSHNDx5X12igQzb3M1Jp9ShSbvHzQO4GUw+ETGqNV/FqDaNCroUiJkE3D54=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785816356; c=relaxed/simple;
	bh=2p+NvFHg1CDQ3vu37GwJ1IOAnhCCJjXCg4lUcEhhsw0=;
	h=Date:To:From:Subject:Message-Id; b=Wj+3LLCi14pWTLcwAZGkHfMoGj8IS6wAEfWJNYvDGRFd5eX3U1IGk0K9VKQLBy08Wtokl2VaiixEjcgvLTkStzORPQvmZHTmjPPW70yd7pqqkDa66M5DGSx7jNADy8SaG8Q0MKoC5iqYCU7Hnk4/lc3lNJuQS9xcbfu6CIEdNL8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0FFrWNnH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0FFrWNnH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC7561F00A3A;
	Tue,  4 Aug 2026 04:05:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785816354;
	bh=a1L8Njc2KWO24Kktu0wQgBt+5zk4QyTqDpkl29Nt5g8=;
	h=Date:To:From:Subject;
	b=0FFrWNnH8WeA2T4d2PEtQHL/aJinRI7GXX+klJtQ9fNUsmnYCwC/2SWq6zy9TJvk4
	 jF0RnkrYEePUj7xtt1F+MW35U9HB7OL8+xkHqP0xY9YORVzAkkEipTQHXoigCVLGWd
	 KnxQqgN9BKT/r3Tc7sv33hFG2B6mtXhJnmOR5jFw=
Date: Mon, 03 Aug 2026 21:05:54 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,kees@kernel.org,mailhol@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] lib-ucs2_stringc-fix-out-of-bounds-read-in-ucs2_strnlen.patch removed from -mm tree
Message-Id: <20260804040554.BC7561F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: lib/ucs2_string.c: fix out-of-bounds read in ucs2_strnlen()
has been removed from the -mm tree.  Its filename was
     lib-ucs2_stringc-fix-out-of-bounds-read-in-ucs2_strnlen.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Vincent Mailhol <mailhol@kernel.org>
Subject: lib/ucs2_string.c: fix out-of-bounds read in ucs2_strnlen()
Date: Thu, 23 Jul 2026 21:40:31 +0200

Patch series "lib/ucs2_string.c: fix out-of-bounds read in
ucs2_strnlen()", v2.

This series fixes an off-by-one out-of-bounds read in ucs2_strnlen().

The first patch is the real fix, the second patch comes as a bonus and
fixes the code indentation.


This patch (of 2):

ucs2_strnlen() checks the current character before checking whether the
caller-provided maximum length has been reached.  If the input is not
NUL-terminated within that bound, the loop can read one ucs2_char_t past
the limit.

Test the length before dereferencing to prevent an off-by-one
out-of-bounds read.

Link: https://lore.kernel.org/20260723-fix-ucs2_strnlen-v2-0-9ea94e32a358@kernel.org
Link: https://lore.kernel.org/20260723-fix-ucs2_strnlen-v2-1-9ea94e32a358@kernel.org
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Vincent Mailhol <mailhol@kernel.org>
Cc: Kees Cook <kees@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/ucs2_string.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/ucs2_string.c~lib-ucs2_stringc-fix-out-of-bounds-read-in-ucs2_strnlen
+++ a/lib/ucs2_string.c
@@ -8,7 +8,7 @@ ucs2_strnlen(const ucs2_char_t *s, size_
 {
         unsigned long length = 0;
 
-        while (*s++ != 0 && length < maxlength)
+	while (length < maxlength && *s++ != 0)
                 length++;
         return length;
 }
_

Patches currently in -mm which might be from mailhol@kernel.org are


