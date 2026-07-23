Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B646D3F3267;
	Thu, 23 Jul 2026 21:11:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784841110; cv=none; b=FeeiRjDWZymQm03Wu+EXJDedE08Evi/fQn066SsdqHTVQ6P0AvBA9qVTj6dQAbiTqY72I+Qdk2+2X6GbmYwa5R9vTPY4gs7J+VbCmVNDerfGjd2TZasIoHXRoCwbJ0G4NGl1JZ/foDWq0HgLoiypynAcJsQvyXU3W5lyE9OhIIU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784841110; c=relaxed/simple;
	bh=pXRUQb0/G/790E2j+0MB/p7raT39ryAUpn4Bkmsad+U=;
	h=Date:To:From:Subject:Message-Id; b=dNrh06hYc3iuhw5nb+rjb7Yeyb5ZjFxWEZnCEYA0ws24ml69te96NqGj5SRUqIfQcR4FpxI6hCLKPlP9wO9JxBGmW700kW4izFmnwZtBq5g5CzcXunk7OR1y8I/uNNT/7F76U6pHDjQMx3Lq1Uf2dKQTNl58e5XpBiNP54THxKE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=AKxzQZ1H; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="AKxzQZ1H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54BF71F000E9;
	Thu, 23 Jul 2026 21:11:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1784841105;
	bh=HxCS1V2Iv0Z3gwqQcJIx0vL9k45FIhoP+lf4PkSyjQM=;
	h=Date:To:From:Subject;
	b=AKxzQZ1HWl3YTSauLDmmA4qpCD4DwOdgGdpSGaJ4sweaaPnXFT7RM0cM83va8EAoi
	 ht8sQHOvaeljBRJ6Y0CRUzw7/LFGB7XySKgj5Gt8cmU2xmBRXF/8X+ZKV8Re+NVdoU
	 5SLZ/AFmNLN1jb8MHVe145SkJJzubuoLKkcG7Ymg=
Date: Thu, 23 Jul 2026 14:11:44 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,kees@kernel.org,mailhol@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-ucs2_stringc-fix-out-of-bounds-read-in-ucs2_strnlen.patch added to mm-nonmm-unstable branch
Message-Id: <20260723211145.54BF71F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib/ucs2_string.c: fix out-of-bounds read in ucs2_strnlen()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-ucs2_stringc-fix-out-of-bounds-read-in-ucs2_strnlen.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-ucs2_stringc-fix-out-of-bounds-read-in-ucs2_strnlen.patch

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

lib-ucs2_stringc-fix-out-of-bounds-read-in-ucs2_strnlen.patch
lib-ucs2_stringc-fix-indentation.patch

