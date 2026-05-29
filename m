Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7002436A351
	for <mm-commits@vger.kernel.org>; Fri, 29 May 2026 04:25:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780028752; cv=none; b=W+WanWY+2KpaZGr1FX2U3PqyIAKkjfiszohf/MYyyhPvYsHfuw1luLJJXq5p0bPrH+Argowm5fo2GQ+guPh9R3zMjYJrPRMw2fpljN4XQczfCZhT1UO+uzjxrJALwX+LBZ1z7pJi7sPtaGUVPBgOEVoLx/2gPHRAmeZ5HgPNQC0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780028752; c=relaxed/simple;
	bh=9oKXsJPsfzW7SjdXr+WiRF8BGMQVErx99TR8a4X+hmE=;
	h=Date:To:From:Subject:Message-Id; b=lRM+3KVIEJdg83NifcRQ7onD5cQ/JP23XcvcLfLZChTih15tieWJTDCzmFdsvvC/wo5214rGEcdmG0U7B4gOSGNilHI8ukYAKguPiDcGj6bZ4CfkKI5EWKfFUIpjY1UlREvgLV1AnWKdOBam/SBctW3FFVvC6BQyKQTl83IdVnI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Eg60C2iZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Eg60C2iZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4420C1F00898;
	Fri, 29 May 2026 04:25:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780028751;
	bh=17a7vRZaLjzxZv6apzIGL5BwnK2SJIprPHQBM+cxFrc=;
	h=Date:To:From:Subject;
	b=Eg60C2iZ2VGY37okoKOKInjW2pMJJA/k5vzcPnC3sKZkITAvK6yAkvdEt4Oh6PDJp
	 pUQLJcaGKB112EovJJx7GCwr7rOHeziyWXKKDUT0nQ7zxf9DQcgXQVx0hu7qDLh3qE
	 UfcUtFZdAmwbQU+f1saoHYUzIJu40QGd6gxwNR/Y=
Date: Thu, 28 May 2026 21:25:50 -0700
To: mm-commits@vger.kernel.org,akpm@linux-foundation.org,objecting@objecting.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] lib-base64-validate-before-writing-in-decode-tail-path.patch removed from -mm tree
Message-Id: <20260529042551.4420C1F00898@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: lib/base64: validate before writing in decode tail path
has been removed from the -mm tree.  Its filename was
     lib-base64-validate-before-writing-in-decode-tail-path.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

lib-idr-fix-ida_find_first_range-missing-ids-across-chunk-boundaries.patch

