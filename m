Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FC47145A11
	for <mm-commits@vger.kernel.org>; Tue, 30 Jul 2024 22:54:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722380059; cv=none; b=CzCWLdcNxoSLkt4KFVth1NGtzZNqlGx2XxaUiMaEYmZ/KWXnbyUJBWIapuoXt1aErBb1UREaxTCTCqnD4EBg6PGaA1Hm9D5TJyKq2BFHc3IBZNyAGX6O7kULvdeEMt4PdhHO320XkSrqv049vluKvhuAw8Eq1WaFwPNHY24vdao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722380059; c=relaxed/simple;
	bh=iNvt6m/9cJ0lX8iyaTEj8uBTFIa+GeU4oPt2yge4eFQ=;
	h=Date:To:From:Subject:Message-Id; b=CuhEOqRr/ibdqnIXQNKlge7Lij35IvBC6kzrGrZbRQyGsOP7Cg3noqUgLv9sOF/yoD0aX5agB2BwbF7xpNEQG7Wsz2QUDytk2Ao/DmgcHOt+KL+JoozRfRovtxQAxTyM/pytVVj7YEhSx7Bsn2CxRWAJMNMWPDOwkQ1OhN99mrU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=PEpoaMNL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="PEpoaMNL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81CBAC32782;
	Tue, 30 Jul 2024 22:54:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1722380058;
	bh=iNvt6m/9cJ0lX8iyaTEj8uBTFIa+GeU4oPt2yge4eFQ=;
	h=Date:To:From:Subject:From;
	b=PEpoaMNLsEZC5VBhlUVX8nOICNa1vlj6SEQe8h7JcGzr5lYTS0HK6941E5FzwaxqH
	 IqoSzLxGLsKnWbdhE+uXRx0n3LFA57lA1OTHBVsPYv9bNg6wjKhKQgrbueXBm7Fw4Z
	 MngPJAlojIi4T1hhD5UpZ2OVyJgKD7BIXwzpWmAI=
Date: Tue, 30 Jul 2024 15:54:17 -0700
To: mm-commits@vger.kernel.org,dakr@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-kvmalloc-align-kvrealloc-with-krealloc-fix-2.patch added to mm-unstable branch
Message-Id: <20240730225418.81CBAC32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: kvrealloc: disable KASAN when switching to vmalloc
has been added to the -mm mm-unstable branch.  Its filename is
     mm-kvmalloc-align-kvrealloc-with-krealloc-fix-2.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-kvmalloc-align-kvrealloc-with-krealloc-fix-2.patch

This patch will later appear in the mm-unstable branch at
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
From: Danilo Krummrich <dakr@kernel.org>
Subject: mm: kvrealloc: disable KASAN when switching to vmalloc
Date: Tue, 30 Jul 2024 20:49:41 +0200

Disable KASAN accessibility checks when switching from a kmalloc buffer
to a vmalloc buffer.

Link: https://lkml.kernel.org/r/20240730185049.6244-2-dakr@kernel.org
Fixes: 923a26b4c679 ("mm: kvmalloc: align kvrealloc() with krealloc()")
Signed-off-by: Danilo Krummrich <dakr@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/util.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/mm/util.c~mm-kvmalloc-align-kvrealloc-with-krealloc-fix-2
+++ a/mm/util.c
@@ -753,7 +753,10 @@ void *kvrealloc_noprof(const void *p, si
 
 		if (p) {
 			/* We already know that `p` is not a vmalloc address. */
-			memcpy(n, p, ksize(p));
+			kasan_disable_current();
+			memcpy(n, kasan_reset_tag(p), ksize(p));
+			kasan_enable_current();
+
 			kfree(p);
 		}
 	}
_

Patches currently in -mm which might be from dakr@kernel.org are

mm-vmalloc-implement-vrealloc.patch
mm-vmalloc-implement-vrealloc-fix.patch
mm-vmalloc-implement-vrealloc-fix-2.patch
mm-kvmalloc-align-kvrealloc-with-krealloc.patch
mm-kvmalloc-align-kvrealloc-with-krealloc-fix.patch
mm-kvmalloc-align-kvrealloc-with-krealloc-fix-2.patch

