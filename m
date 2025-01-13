Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A345525761
	for <mm-commits@vger.kernel.org>; Mon, 13 Jan 2025 04:23:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736742233; cv=none; b=TA/Bk7TKXCHPQdKTMIoOL91JcERvsCIkNXGv4p+x/xPo4az7eU0uboSTOQVgmnCWPSzg9t2NksufdRGYtitnGXchQpDxXXXhhmXAjwGI99WdJWObYf5bMPl0D2K0Dval9T2zBAfVqLj87Mg0oBwF+qcLouh1TN8xa+W8E07mVaM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736742233; c=relaxed/simple;
	bh=ZCQRCANfK88gnHo31U54AmW+FaxSqlm7RpxYg5y3OI0=;
	h=Date:To:From:Subject:Message-Id; b=stXY/k3y8isDH/BUvcE+FfezcevfqKo3l5YMiRau5k4xcOap0uR7xm4y+uW0B8G0kvxRVc0pDfwkdZQPtZT8/FJjJ7CDl4FauH65Sk1AB86HFvpn7PyzjNATkLCrPZ2Avr6/oSV1kOoowXBWAXjcYEjGkJ8B6atQcDlT3kf3h/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ybW+d6Nn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ybW+d6Nn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78669C4CED6;
	Mon, 13 Jan 2025 04:23:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736742233;
	bh=ZCQRCANfK88gnHo31U54AmW+FaxSqlm7RpxYg5y3OI0=;
	h=Date:To:From:Subject:From;
	b=ybW+d6NnunWygkpZHyP2jNm3S2lYDathgvL16T3DDHIoL1Ze/nvywmpHHJvfJ8wk9
	 fMiXqJZPGfI2Rv3v/5/4P0IbCkjtDUer6W55axUlS2+gMZwwMiOgeGLWRKWQ7Te4Tl
	 Lown5H+w1sro9oykSqAjzpgCdwehDzppqL4EBSdk=
Date: Sun, 12 Jan 2025 20:23:52 -0800
To: mm-commits@vger.kernel.org,glider@google.com,andreyknvl@gmail.com,dominik.karol.piatkowski@protonmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] kasan-fix-typo-in-kasan_poison_new_object-documentation.patch removed from -mm tree
Message-Id: <20250113042353.78669C4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kasan: fix typo in kasan_poison_new_object documentation
has been removed from the -mm tree.  Its filename was
     kasan-fix-typo-in-kasan_poison_new_object-documentation.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Reviewed-by: Alexander Potapenko <glider@google.com>
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


