Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B90E9823A6
	for <mm-commits@vger.kernel.org>; Thu, 23 May 2024 20:15:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716495307; cv=none; b=pyIbiGZjSLedCusVrPjOIb1o3PYTRtfb5Wo6uPb/15XGNCBWMwS/0F9qPviR0/K8/Q9ZIbqHmYrOJb5xeTwensNUVXW1mqAcSi+1CAXld1rKe+CAFOV08SRDadNhPCL8sm7OyV4ck2XoDd2/pqKdRboVQWRcvSJNu6KXyAppHqI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716495307; c=relaxed/simple;
	bh=omHKU3t6iTYnWkKHN1jjTEXK2a+HynCiDC3xFqmVPbg=;
	h=Date:To:From:Subject:Message-Id; b=j3BOFbMlWgbcxjo3Yj75kIIszp4osdUH6otqSKtIvFbhiVwPnS9w/i7n7bGBoVCpHSt9zJtBkJ5GGKRU4Z2HNptnjXnkwpilfcWkPrd1htfy6iHP3RIFl+yhTpSZKwYv9c3GogBw9cGtByY2zz7X+aJpzswNONPQAvh3QAC/Mqc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ISzbX3+d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ISzbX3+d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73644C2BD10;
	Thu, 23 May 2024 20:15:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1716495307;
	bh=omHKU3t6iTYnWkKHN1jjTEXK2a+HynCiDC3xFqmVPbg=;
	h=Date:To:From:Subject:From;
	b=ISzbX3+dFALAlUPi0rfXwli/fKOPoCTSr2a1xgz+suECHcFx5phj81vDILvm7Pkcd
	 6xRICx+5wbdW5N36f+/M9zToBxpKdkbaHoVB2TJkpapR5bcInsE54M5VsfAlIrYmBa
	 i3XsEj4lSEovK2T4jKcgHt43TfOjJpoFih8Gn6Mo=
Date: Thu, 23 May 2024 13:15:06 -0700
To: mm-commits@vger.kernel.org,weihsinyeh168@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + tools-fix-typo.patch added to mm-nonmm-unstable branch
Message-Id: <20240523201507.73644C2BD10@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: include/linux/jhash.h: fix typos
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     tools-fix-typo.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/tools-fix-typo.patch

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
From: Wei-Hsin Yeh <weihsinyeh168@gmail.com>
Subject: include/linux/jhash.h: fix typos
Date: Sun, 12 May 2024 13:42:11 +0800

Drop one '-' to adhere to coding style.
Replace 'arbitray' with 'arbitrary'.

Link: https://lkml.kernel.org/r/20240512054211.24726-1-weihsinyeh168@gmail.com
Signed-off-by: Wei-Hsin Yeh <weihsinyeh168@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/jhash.h |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/include/linux/jhash.h~tools-fix-typo
+++ a/include/linux/jhash.h
@@ -31,7 +31,7 @@
 /* Mask the hash value, i.e (value & jhash_mask(n)) instead of (value % n) */
 #define jhash_mask(n)   (jhash_size(n)-1)
 
-/* __jhash_mix -- mix 3 32-bit values reversibly. */
+/* __jhash_mix - mix 3 32-bit values reversibly. */
 #define __jhash_mix(a, b, c)			\
 {						\
 	a -= c;  a ^= rol32(c, 4);  c += b;	\
@@ -60,7 +60,7 @@
 /* jhash - hash an arbitrary key
  * @k: sequence of bytes as key
  * @length: the length of the key
- * @initval: the previous hash, or an arbitray value
+ * @initval: the previous hash, or an arbitrary value
  *
  * The generic version, hashes an arbitrary sequence of bytes.
  * No alignment or length assumptions are made about the input key.
@@ -110,7 +110,7 @@ static inline u32 jhash(const void *key,
 /* jhash2 - hash an array of u32's
  * @k: the key which must be an array of u32's
  * @length: the number of u32's in the key
- * @initval: the previous hash, or an arbitray value
+ * @initval: the previous hash, or an arbitrary value
  *
  * Returns the hash value of the key.
  */
_

Patches currently in -mm which might be from weihsinyeh168@gmail.com are

tools-fix-typo.patch

