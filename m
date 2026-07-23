Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37C2D3F328F
	for <mm-commits@vger.kernel.org>; Thu, 23 Jul 2026 21:11:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784841113; cv=none; b=FgsJJVIqj1krLIIX+xl9BFdodWwahiCqol2EmsWLJnljPJznTiRwJz4IMr0KbwT9alQPtmWf+cP3RrALu602M0100Lic1yvf31vipO4I9I8qKzHcGbix/FV7zklmaHuZph9yl/wWlVor/KZnihdkzbm7IxK1qY+2KyJjJtHwi38=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784841113; c=relaxed/simple;
	bh=BP32tIYP6BZQoT/1ucmATIcGJiKPFOQDJhFXFjghNfA=;
	h=Date:To:From:Subject:Message-Id; b=P03UU4xsvwSg0l6sgZq/NwseJX9qr2UcCr4RhxEtFNo5ZtkvBk0prhfVi6/4W0RhfiFcyRg9sqnftcAvMPOUnSD4Ml6jQms20mgrTpp7IWiA0m+HKUHTx2tuead33A/6TlRSfsBZ5OjxiFfW2kQIBC3+isj4HMildGnmWK7bdvE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=oIl7CELf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="oIl7CELf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D5571F00A3D;
	Thu, 23 Jul 2026 21:11:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1784841107;
	bh=4SXYC9tkc3G69PSyyd+GcW7JC+FZpDRs2avS1iq0oLo=;
	h=Date:To:From:Subject;
	b=oIl7CELfx8thm2L0J0Ydk6YADsGXPxIGOXoj6TdKqSq156yN8HpzWqgNYCFmd2j+8
	 1F7fePcC7UwihAq+MF3igIeJ6vX78xAdEYBLlFdWrI7+4Ek7zh295/3aWYBqEPfUEp
	 Wb88jrEZo/waBCHGbFjWUuDgXYtw5xuxGsm1Ii04=
Date: Thu, 23 Jul 2026 14:11:46 -0700
To: mm-commits@vger.kernel.org,kees@kernel.org,mailhol@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-ucs2_stringc-fix-indentation.patch added to mm-nonmm-unstable branch
Message-Id: <20260723211147.4D5571F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib/ucs2_string.c: fix indentation
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-ucs2_stringc-fix-indentation.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-ucs2_stringc-fix-indentation.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Vincent Mailhol <mailhol@kernel.org>
Subject: lib/ucs2_string.c: fix indentation
Date: Thu, 23 Jul 2026 21:40:32 +0200

checkpatch.pl reports a total of 18 incorrect use of spaces instead of
tabulations in lib/ucs2_string.c.

Apply

  ./scripts/checkpatch.pl --fix-inplace lib/ucs2_string.c

to fix them all.

Link: https://lore.kernel.org/20260723-fix-ucs2_strnlen-v2-2-9ea94e32a358@kernel.org
Signed-off-by: Vincent Mailhol <mailhol@kernel.org>
Cc: Kees Cook <kees@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/ucs2_string.c |   36 ++++++++++++++++++------------------
 1 file changed, 18 insertions(+), 18 deletions(-)

--- a/lib/ucs2_string.c~lib-ucs2_stringc-fix-indentation
+++ a/lib/ucs2_string.c
@@ -6,18 +6,18 @@
 unsigned long
 ucs2_strnlen(const ucs2_char_t *s, size_t maxlength)
 {
-        unsigned long length = 0;
+	unsigned long length = 0;
 
 	while (length < maxlength && *s++ != 0)
-                length++;
-        return length;
+		length++;
+	return length;
 }
 EXPORT_SYMBOL(ucs2_strnlen);
 
 unsigned long
 ucs2_strlen(const ucs2_char_t *s)
 {
-        return ucs2_strnlen(s, ~0UL);
+	return ucs2_strnlen(s, ~0UL);
 }
 EXPORT_SYMBOL(ucs2_strlen);
 
@@ -28,7 +28,7 @@ EXPORT_SYMBOL(ucs2_strlen);
 unsigned long
 ucs2_strsize(const ucs2_char_t *data, unsigned long maxlength)
 {
-        return ucs2_strnlen(data, maxlength/sizeof(ucs2_char_t)) * sizeof(ucs2_char_t);
+	return ucs2_strnlen(data, maxlength/sizeof(ucs2_char_t)) * sizeof(ucs2_char_t);
 }
 EXPORT_SYMBOL(ucs2_strsize);
 
@@ -87,19 +87,19 @@ EXPORT_SYMBOL(ucs2_strscpy);
 int
 ucs2_strncmp(const ucs2_char_t *a, const ucs2_char_t *b, size_t len)
 {
-        while (1) {
-                if (len == 0)
-                        return 0;
-                if (*a < *b)
-                        return -1;
-                if (*a > *b)
-                        return 1;
-                if (*a == 0) /* implies *b == 0 */
-                        return 0;
-                a++;
-                b++;
-                len--;
-        }
+	while (1) {
+		if (len == 0)
+			return 0;
+		if (*a < *b)
+			return -1;
+		if (*a > *b)
+			return 1;
+		if (*a == 0) /* implies *b == 0 */
+			return 0;
+		a++;
+		b++;
+		len--;
+	}
 }
 EXPORT_SYMBOL(ucs2_strncmp);
 
_

Patches currently in -mm which might be from mailhol@kernel.org are

lib-ucs2_stringc-fix-out-of-bounds-read-in-ucs2_strnlen.patch
lib-ucs2_stringc-fix-indentation.patch

