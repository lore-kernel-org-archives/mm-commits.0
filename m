Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53AD822538F
	for <mm-commits@vger.kernel.org>; Sat, 25 Apr 2026 15:27:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777130821; cv=none; b=sFQxYFLkreS3ExE1fq0UeWw1QGmOyQBwJtvFsdYC0AlI767TqMj9Wr9rLFwzcfpk+RkZpmRb1j2os1LnP57ixjJNgdnZ8Z2Gv2bYqeF8ek2JzFBANByG7+XtU53MtLs1OKi6kLcw7qN29W/EXGVT1Fw85LwbtidCDL27PSvMz2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777130821; c=relaxed/simple;
	bh=lFY9yt3fGJ7X+Ot0JXpdZJZgb+8pvAgBaxjczfgN/VI=;
	h=Date:To:From:Subject:Message-Id; b=EOR/mfmkAKbBUWyC7wo3ABw48A3adTt8S0jDWkSu2vPp4ZFi+TAAR6bQ/fHIc3H3uNGk3N+If+OIAaNzl4L+q5Gz00OwI7FzpKXiYGG+TLC2SjOMdQghBwM5+Sx4U3cPQJL7OVL3AO5C0/GU7mErMfu6NFeZPYRq0AdNAudxg7c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=swdEeX/K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="swdEeX/K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8DE7C2BCB0;
	Sat, 25 Apr 2026 15:27:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777130820;
	bh=lFY9yt3fGJ7X+Ot0JXpdZJZgb+8pvAgBaxjczfgN/VI=;
	h=Date:To:From:Subject:From;
	b=swdEeX/KdmcXcJcqiwbR77xi7dkmy7+hUKinurQU8oQDrSVpl8qpGw0najlbe+gvg
	 zYsEE9nMtpBWyYlFMGN5TvM3OHPsPE32w7i6whqNPfcJvQVp9c9pX7IpuDUOxBl/dy
	 etddUhpBJGa79nQInU7UnNkweNvrlMmV6ACKq7so=
Date: Sat, 25 Apr 2026 08:27:00 -0700
To: mm-commits@vger.kernel.org,akpm@linux-foundation.org,objecting@objecting.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-base64-fix-copy-pasted-padding-doc-in-base64_decode.patch added to mm-nonmm-unstable branch
Message-Id: <20260425152700.D8DE7C2BCB0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib/base64: fix copy-pasted @padding doc in base64_decode()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-base64-fix-copy-pasted-padding-doc-in-base64_decode.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-base64-fix-copy-pasted-padding-doc-in-base64_decode.patch

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

lib-base64-validate-before-writing-in-decode-tail-path.patch
lib-base64-fix-copy-pasted-padding-doc-in-base64_decode.patch
lib-idr-fix-ida_find_first_range-missing-ids-across-chunk-boundaries.patch

