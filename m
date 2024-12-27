Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F9C957C93;
	Fri, 27 Dec 2024 18:17:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735323429; cv=none; b=pCxfGy4sNmRGmTOH1FImLa674shybabNTbL+mTQpAw7EXTOgEbbZtzUFpIlxfrDfcUer351enFTRB0QHKHonQFZ8Cehvt2YKsqCtKKS16xz0JVDoKeBzfVA6rm3fGexkFVifP6rqKP3vBaSV7HTqGMIIMP7X5jhC/Lr9P1X0UZ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735323429; c=relaxed/simple;
	bh=hgLTG9x/Hkq9O+DHS9knFWeoeVLM47KiC6OVSbSuvgk=;
	h=Date:To:From:Subject:Message-Id; b=R1hkmAnOrf39fDOiedU/RkWU14OvgzP1ByVnpa/NoM13zJrjO7OAZa+uzbDTxuTYKhSyBcUl+/QdOQ1bH4NupQDgs+SlBNtNIZw0VZOJOFCMLWInG4diw862igBMZO1mb9Sfv8I/TYWw8oYaLuLa4eZ862YNrWX3sdMYE76ez+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZkyUf7md; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZkyUf7md"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFEC6C4CED0;
	Fri, 27 Dec 2024 18:17:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1735323428;
	bh=hgLTG9x/Hkq9O+DHS9knFWeoeVLM47KiC6OVSbSuvgk=;
	h=Date:To:From:Subject:From;
	b=ZkyUf7mdq+8KxNJ5I+92hTalpzksEHDoLtueg00IaA4CEC2NSyN4S0x0c/dbfp242
	 JhqsSZr104QzbAmgck9R/fyYGLeTXdmMmguKAO6uND45+7up7+y2zg6uL67bRt4HGB
	 fWSvmqR5OA+sWv77ArQ8ZK40eaTZBV/yJfdBDdAo=
Date: Fri, 27 Dec 2024 10:17:08 -0800
To: mm-commits@vger.kernel.org,ubizjak@gmail.com,stable@vger.kernel.org,catalin.marinas@arm.com,guoweikang.kernel@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-kmemleak-fix-percpu-memory-leak-detection-failure.patch added to mm-hotfixes-unstable branch
Message-Id: <20241227181708.AFEC6C4CED0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/kmemleak: fix percpu memory leak detection failure
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-kmemleak-fix-percpu-memory-leak-detection-failure.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-kmemleak-fix-percpu-memory-leak-detection-failure.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Guo Weikang <guoweikang.kernel@gmail.com>
Subject: mm/kmemleak: fix percpu memory leak detection failure
Date: Fri, 27 Dec 2024 17:23:10 +0800

kmemleak_alloc_percpu gives an incorrect min_count parameter, causing
percpu memory to be considered a gray object.

Link: https://lkml.kernel.org/r/20241227092311.3572500-1-guoweikang.kernel@gmail.com
Fixes: 8c8685928910 ("mm/kmemleak: use IS_ERR_PCPU() for pointer in the percpu address space")
Signed-off-by: Guo Weikang <guoweikang.kernel@gmail.com>
Acked-by: Uros Bizjak <ubizjak@gmail.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Guo Weikang <guoweikang.kernel@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kmemleak.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/kmemleak.c~mm-kmemleak-fix-percpu-memory-leak-detection-failure
+++ a/mm/kmemleak.c
@@ -1093,7 +1093,7 @@ void __ref kmemleak_alloc_percpu(const v
 	pr_debug("%s(0x%px, %zu)\n", __func__, ptr, size);
 
 	if (kmemleak_enabled && ptr && !IS_ERR_PCPU(ptr))
-		create_object_percpu((__force unsigned long)ptr, size, 0, gfp);
+		create_object_percpu((__force unsigned long)ptr, size, 1, gfp);
 }
 EXPORT_SYMBOL_GPL(kmemleak_alloc_percpu);
 
_

Patches currently in -mm which might be from guoweikang.kernel@gmail.com are

mm-kmemleak-fix-percpu-memory-leak-detection-failure.patch
mm-shmem-refactor-to-reuse-vfs_parse_monolithic_sep-for-option-parsing.patch
mm-early_ioremap-add-null-pointer-checks-to-prevent-null-pointer-dereference.patch

