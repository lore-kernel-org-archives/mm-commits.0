Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71D3422538F
	for <mm-commits@vger.kernel.org>; Sat, 25 Apr 2026 15:26:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777130819; cv=none; b=HEMjiea/s4SlY+B9YX9opuf2E8Ncvf7vUZGuPSvo+ijq+VgdCVta3ciy6b8afsOTab2lzA0hiYPHBHizSf49WRzkRIKZXvNEAcmoVDFNUCtVLoxSZbj/ExRXjYCx/XHB46VpcHtv8oAesF20OJw+XtcrsWZ6lscmvY8/FrgBbK4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777130819; c=relaxed/simple;
	bh=dMVW8pzu4/HSoEQrwe8sAKz2coCab5ZEJJz+x/1enHU=;
	h=Date:To:From:Subject:Message-Id; b=tRpxXEfRiVF0+nDHNcc/WmgXsCZ794ZCFnlBh3JJEmyDS0vgF2BJkj6L0LoCriUqCswEKVw9Ra8tia/nuyW+vmoLBNBt7nYd8emMLAMTywgiw737uTnA3km8Pq1Ew6utLzpau62LU249amJ9h/MCSzQNamj5QxJ4Xx1O+NA36jQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=lz8KClv2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="lz8KClv2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1E62C2BCB0;
	Sat, 25 Apr 2026 15:26:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777130819;
	bh=dMVW8pzu4/HSoEQrwe8sAKz2coCab5ZEJJz+x/1enHU=;
	h=Date:To:From:Subject:From;
	b=lz8KClv2gUUgr250Nk9CbqAcz2+HmpOPETDnOTceVR2qCQw4Nk9gCzUm8y7tKfDGL
	 XSpqHEOOIdsKPuwY0ngTbSt6Dvw5ark3VhqcvI73iLMBvyAqDUG16hNAX2MBBY3pXM
	 bYp6yt3WHGDo+9YvvddsPBlXO8ESi1F3J5yAEb1o=
Date: Sat, 25 Apr 2026 08:26:58 -0700
To: mm-commits@vger.kernel.org,akpm@linux-foundation.org,objecting@objecting.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-base64-validate-before-writing-in-decode-tail-path.patch added to mm-nonmm-unstable branch
Message-Id: <20260425152658.E1E62C2BCB0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib/base64: validate before writing in decode tail path
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-base64-validate-before-writing-in-decode-tail-path.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-base64-validate-before-writing-in-decode-tail-path.patch

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
From: Josh Law <objecting@objecting.org>
Subject: lib/base64: validate before writing in decode tail path
Date: Tue, 24 Mar 2026 22:32:09 +0000

Patch series "lib/base64: decode fixes", v2.

Two small fixes for lib/base64.c:

1. base64_decode() writes a decoded byte to the output buffer before
   validating the input in the trailing-bytes path. Move the validity
   checks before any writes so dst is untouched on invalid input.

2. The @padding kernel-doc for base64_decode() was copy-pasted from
   base64_encode() and describes the wrong direction.


This patch (of 2):

The trailing-bytes path in base64_decode() writes a decoded byte to the
output buffer before checking whether the input characters are valid.  If
the input is malformed, garbage is written to dst before the function
returns -1.

Move the validity checks before any writes so the output buffer is left
untouched on invalid input.

Link: https://lore.kernel.org/20260324223210.47676-1-objecting@objecting.org
Link: https://lore.kernel.org/20260324223210.47676-2-objecting@objecting.org
Fixes: 9c7d3cf94d33 ("lib/base64: rework encode/decode for speed and stricter validation")
Signed-off-by: Josh Law <objecting@objecting.org>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/base64.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/lib/base64.c~lib-base64-validate-before-writing-in-decode-tail-path
+++ a/lib/base64.c
@@ -168,15 +168,16 @@ int base64_decode(const char *src, int s
 		return -1;
 
 	val = (base64_rev_tables[s[0]] << 12) | (base64_rev_tables[s[1]] << 6);
-	*bp++ = val >> 10;
 
 	if (srclen == 2) {
 		if (val & 0x800003ff)
 			return -1;
+		*bp++ = val >> 10;
 	} else {
 		val |= base64_rev_tables[s[2]];
 		if (val & 0x80000003)
 			return -1;
+		*bp++ = val >> 10;
 		*bp++ = val >> 2;
 	}
 	return bp - dst;
_

Patches currently in -mm which might be from objecting@objecting.org are

lib-base64-validate-before-writing-in-decode-tail-path.patch
lib-base64-fix-copy-pasted-padding-doc-in-base64_decode.patch
lib-idr-fix-ida_find_first_range-missing-ids-across-chunk-boundaries.patch

