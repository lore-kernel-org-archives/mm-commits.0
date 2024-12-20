Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBAEC155342
	for <mm-commits@vger.kernel.org>; Fri, 20 Dec 2024 22:21:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734733286; cv=none; b=IEkmimaAg+BnqckuEDN4yJ1UXcCqgXupK1fs9xJXp1Lkjd2PlP6UeJrtSMaBmPmkb5EcQ/M6ACKlqytCF2kcF/uLS7OTPZpky3hNPPhDUZey5p4L2L+AIh85WwaG/cB8lhcufLBjEmGAb7kwIuKhbhvq78kQ7alMBi43Efr6Smo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734733286; c=relaxed/simple;
	bh=DxtiKelzHZH/wCy7kCC+ZWK4/2OXiRi7oCaXNCvyhDE=;
	h=Date:To:From:Subject:Message-Id; b=R5wRNceTyoGpa/zSCVK98t2sNFEZvcJyGYgLfIEb6XtpT2ecEe8rjzRq0DK9P4HzcU4Qw3NQMdbOyChcwqiRZqYiLL93KwIzVKNI702avG8h3/cWlq7i+KbzqF0Vl3yo2poMbWc+MRLI6gDLxZUCqbM+gGEfYCsR9DLWMhlfLTk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=FZZvIJiu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FZZvIJiu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5709CC4CECD;
	Fri, 20 Dec 2024 22:21:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1734733286;
	bh=DxtiKelzHZH/wCy7kCC+ZWK4/2OXiRi7oCaXNCvyhDE=;
	h=Date:To:From:Subject:From;
	b=FZZvIJiuU/XAdsRGiewUE/YQ5zzD43K/4aG792gDvnkcPK7IQ8tGd/sW+CXvHDYvf
	 oyRzoGElnrhpAoZrVwD74cdd/cXq4gDMiNqZ3rObkMpDp/7Wz9QJcNVNjw7fYXQ1yY
	 lXqRGNObdzoulp37LOEP9NgkO4u7y61tnpjC1I4o=
Date: Fri, 20 Dec 2024 14:21:25 -0800
To: mm-commits@vger.kernel.org,andreyknvl@gmail.com,dominik.karol.piatkowski@protonmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kasan-fix-typo-in-kasan_poison_new_object-documentation.patch added to mm-nonmm-unstable branch
Message-Id: <20241220222126.5709CC4CECD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kasan: fix typo in kasan_poison_new_object documentation
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     kasan-fix-typo-in-kasan_poison_new_object-documentation.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kasan-fix-typo-in-kasan_poison_new_object-documentation.patch

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
From: Dominik Karol Piątkowski <dominik.karol.piatkowski@protonmail.com>
Subject: kasan: fix typo in kasan_poison_new_object documentation
Date: Fri, 20 Dec 2024 18:12:12 +0000

Fix presumed copy-paste typo of kasan_poison_new_object documentation
referring to kasan_unpoison_new_object.

No functional changes.

Link: https://lkml.kernel.org/r/20241220181205.9663-1-dominik.karol.piatkowski@protonmail.com
Fixes: 1ce9a0523938 ("kasan: rename and document kasan_(un)poison_object_data")
ta")
Signed-off-by: Dominik Karol Piątkowski <dominik.karol.piatkowski@protonmail.com>
Reviewed-by: Andrey Konovalov <andreyknvl@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kasan.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/kasan.h~kasan-fix-typo-in-kasan_poison_new_object-documentation
+++ a/include/linux/kasan.h
@@ -153,7 +153,7 @@ static __always_inline void kasan_unpois
 
 void __kasan_poison_new_object(struct kmem_cache *cache, void *object);
 /**
- * kasan_unpoison_new_object - Repoison a new slab object.
+ * kasan_poison_new_object - Repoison a new slab object.
  * @cache: Cache the object belong to.
  * @object: Pointer to the object.
  *
_

Patches currently in -mm which might be from dominik.karol.piatkowski@protonmail.com are

kasan-fix-typo-in-kasan_poison_new_object-documentation.patch

