Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03FD74252BE
	for <mm-commits@vger.kernel.org>; Tue,  4 Aug 2026 04:05:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785816357; cv=none; b=CM99VM060G24Q7hWNtJgLhHw+NjXVE8TVdP54/FvLKRY3/giS5GiRsvd665sARQZlbzbQRJCBcFx65wMRkDxZoeaqCyNWHz9q0HGbyHGt3REeNxOsXB7MatScb6LHy0SSFasoEAOi4Pk+fnwLIFg4TqguF1Jb+YgcHe3kwlVZj4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785816357; c=relaxed/simple;
	bh=rMepp3ge3eIIHSi+yuzJxlw650ceh/jIiw+2N/0vTN4=;
	h=Date:To:From:Subject:Message-Id; b=NLllqmAOedLOCM59QWYP88NoG5++qjC+LeWmLDB8YXbT72yGgVi7EZCpwr3YxP148S39mmW8o+UexJ+SnmfVEZzDMbfyliaaI23+6Br+J+qLkZpFMPqDHHSr4RohwLTrN4FwdGc/9NTEx0R+ZxEnEOMA68iyfK0A5pbnOuU/TBY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=tyUQbJGo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="tyUQbJGo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE6E41F000E9;
	Tue,  4 Aug 2026 04:05:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785816355;
	bh=4djfVykTEiOLj8PFPe73AWHmEr8N+GIUrGAvfFcjM80=;
	h=Date:To:From:Subject;
	b=tyUQbJGowjIojLc30nzx8r4TZoGXdWuyr96JZShUBgLv/oLsW9MtVIL/ywGW0B76G
	 NtYf8+HtM1ofvmlD1PAz3eR27Zxt6LR0K0HLDLgB7ux04O5/VwAa/ZtZsOsiZ7ke6O
	 tuMdndg3XRc+OGQ1JmSxOe3REsaZaGyIsIq8A+WM=
Date: Mon, 03 Aug 2026 21:05:55 -0700
To: mm-commits@vger.kernel.org,kees@kernel.org,mailhol@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] lib-ucs2_stringc-fix-indentation.patch removed from -mm tree
Message-Id: <20260804040555.CE6E41F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: lib/ucs2_string.c: fix indentation
has been removed from the -mm tree.  Its filename was
     lib-ucs2_stringc-fix-indentation.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


