Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D8A4372066
	for <mm-commits@vger.kernel.org>; Fri, 29 May 2026 04:25:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780028753; cv=none; b=fb1zyKOyn5qP5Wm0Wmag8X1ePoI+je84PU3ScppLSegEoeIxXE/DzCCMtqgScL89SCZLt5dlQAjBpktQNH/jIldPS7pwSGHxUjKAPFuiOhs+x/WASyzjgP/AeABi+SfrPQllXIRfDmGaNxmXkME9jPOV1NJYg7tUUKah7B7ryTI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780028753; c=relaxed/simple;
	bh=G3Kcncq/BV2beyRph6EbkgPvd+oR2Wu2s3ChT/apdqY=;
	h=Date:To:From:Subject:Message-Id; b=I6SdBnTDGX/L8U0ZikacEpZZ1UqGd+aW3xndCzwpaK3E1s2P+cs1zpuzfCiNA063lD3urwfreJVGzUwT/vA9ZajCwWB59JHVrtCw16vsTHG2GN4cVCZAI5XovCsIeP0O1HMKxYnJe/aY8z6Wga14chHyrbHVwALpClaRrEr7/ZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xl571ctJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xl571ctJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51EC01F00893;
	Fri, 29 May 2026 04:25:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780028752;
	bh=0BzlSnlqqisP+WwYJNYutrbLcrMFg2cSFwbIsjReasU=;
	h=Date:To:From:Subject;
	b=xl571ctJSVB5pIcfKfeRy2Im9L4NJw0tJ5+riG5VcjBoLajh8CV7bVE7dtHnqD/wI
	 PMb1vuTeXkkjxGMVmD32H7yDsJ/DWY4ubaZiUard+hKrd3gY+vOv7IjBnBwWK367Yt
	 oiSpG/UypALwM20+hPPtYSMEORMsSdR4ZRx8tPA8=
Date: Thu, 28 May 2026 21:25:51 -0700
To: mm-commits@vger.kernel.org,akpm@linux-foundation.org,objecting@objecting.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] lib-base64-fix-copy-pasted-padding-doc-in-base64_decode.patch removed from -mm tree
Message-Id: <20260529042552.51EC01F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: lib/base64: fix copy-pasted @padding doc in base64_decode()
has been removed from the -mm tree.  Its filename was
     lib-base64-fix-copy-pasted-padding-doc-in-base64_decode.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Josh Law <objecting@objecting.org>
Subject: lib/base64: fix copy-pasted @padding doc in base64_decode()
Date: Tue, 24 Mar 2026 22:32:10 +0000

The @padding kernel-doc for base64_decode() says "whether to append '='
padding characters", which was copy-pasted from base64_encode().  In the
decode context, it controls whether the input is expected to include
padding, not whether to append it.

Link: https://lore.kernel.org/20260324223210.47676-3-objecting@objecting.org
Signed-off-by: Josh Law <objecting@objecting.org>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/base64.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/base64.c~lib-base64-fix-copy-pasted-padding-doc-in-base64_decode
+++ a/lib/base64.c
@@ -122,7 +122,7 @@ EXPORT_SYMBOL_GPL(base64_encode);
  * @src: the string to decode.  Doesn't need to be NUL-terminated.
  * @srclen: the length of @src in bytes
  * @dst: (output) the decoded binary data
- * @padding: whether to append '=' padding characters
+ * @padding: whether the input is expected to include '=' padding characters
  * @variant: which base64 variant to use
  *
  * Decodes a string using the selected Base64 variant.
_

Patches currently in -mm which might be from objecting@objecting.org are

lib-idr-fix-ida_find_first_range-missing-ids-across-chunk-boundaries.patch

