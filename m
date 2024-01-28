Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92473D518
	for <mm-commits@vger.kernel.org>; Sun, 28 Jan 2024 08:35:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706430932; cv=none; b=HbPzPgsJPwoztS/4mAcYlRUPxCTRZ4E7UA9rgZeLk5PgpH1NBDGJkIPFOf7h71/m4QGde9G+f6cIUB4VREuWheqj8Dw7byxIib10sHOvlsKVUcgR+C2r5D/HstIUczs+YLuEsQfdahfL2lz0Eg+ALKUkQtXOXPErpqYS+lyWzwc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706430932; c=relaxed/simple;
	bh=Fhgzfo0WRw1eNrxkjFx/mqXknsQz9hYm9qM8yMSX41U=;
	h=Date:To:From:Subject:Message-Id; b=U2lZ6KBPuGZvxJuDO6Klk9o/6egWlYjoWRzi5ir0PxpgLLx3Da0ZpaEasUUuFoGrmuy58QUx6aoCnHWxzgq2IVUkjEUu/2c0HAW2tpkxeZhtuNo4nJT7WeE+oQk7e4ZI0vdBSYd8SxEqRiZ4BjG7g/q7wCVg2QopBiRk3pcZgEA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=sfS7zHAH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="sfS7zHAH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A320C433F1;
	Sun, 28 Jan 2024 08:35:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1706430932;
	bh=Fhgzfo0WRw1eNrxkjFx/mqXknsQz9hYm9qM8yMSX41U=;
	h=Date:To:From:Subject:From;
	b=sfS7zHAHVGx2lMMU98T5/idsYuBpMI+Q6otu8/ZIeYgdTNOf+BIiFXHf9+gi7Xkvt
	 LN8SPI/sXOfC0J1sOPpjJXNp9H/+zv24M+7mVFqiQkF2qdqYRFjCnZAxwbhtc/CKbv
	 gSAtbq1M1wb27vKDUcdBVw+bA9fFVe4oMpPZ7aVY=
Date: Sun, 28 Jan 2024 00:35:28 -0800
To: mm-commits@vger.kernel.org,yajun.deng@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mmap-use-sz_8m-128m-helper-macro.patch added to mm-unstable branch
Message-Id: <20240128083531.9A320C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/mmap: use SZ_{8M, 128M} helper macro
has been added to the -mm mm-unstable branch.  Its filename is
     mm-mmap-use-sz_8m-128m-helper-macro.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mmap-use-sz_8m-128m-helper-macro.patch

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
From: Yajun Deng <yajun.deng@linux.dev>
Subject: mm/mmap: use SZ_{8M, 128M} helper macro
Date: Fri, 26 Jan 2024 16:59:05 +0800

Use SZ_{8M, 128M} macro intead of the number in init_user_reserve and
reserve_mem_notifier.

Link: https://lkml.kernel.org/r/20240126085905.2835513-1-yajun.deng@linux.dev
Signed-off-by: Yajun Deng <yajun.deng@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/mm/mmap.c~mm-mmap-use-sz_8m-128m-helper-macro
+++ a/mm/mmap.c
@@ -3847,7 +3847,7 @@ static int init_user_reserve(void)
 
 	free_kbytes = K(global_zone_page_state(NR_FREE_PAGES));
 
-	sysctl_user_reserve_kbytes = min(free_kbytes / 32, 1UL << 17);
+	sysctl_user_reserve_kbytes = min(free_kbytes / 32, SZ_128M);
 	return 0;
 }
 subsys_initcall(init_user_reserve);
@@ -3868,7 +3868,7 @@ static int init_admin_reserve(void)
 
 	free_kbytes = K(global_zone_page_state(NR_FREE_PAGES));
 
-	sysctl_admin_reserve_kbytes = min(free_kbytes / 32, 1UL << 13);
+	sysctl_admin_reserve_kbytes = min(free_kbytes / 32, SZ_8M);
 	return 0;
 }
 subsys_initcall(init_admin_reserve);
@@ -3900,12 +3900,12 @@ static int reserve_mem_notifier(struct n
 	case MEM_ONLINE:
 		/* Default max is 128MB. Leave alone if modified by operator. */
 		tmp = sysctl_user_reserve_kbytes;
-		if (0 < tmp && tmp < (1UL << 17))
+		if (tmp > 0 && tmp < SZ_128M)
 			init_user_reserve();
 
 		/* Default max is 8MB.  Leave alone if modified by operator. */
 		tmp = sysctl_admin_reserve_kbytes;
-		if (0 < tmp && tmp < (1UL << 13))
+		if (tmp > 0 && tmp < SZ_8M)
 			init_admin_reserve();
 
 		break;
_

Patches currently in -mm which might be from yajun.deng@linux.dev are

mm-mmap-simplify-vma-link-and-unlink.patch
mm-mmap-introduce-vma_set_range.patch
mm-mmap-pass-vma-to-vma_merge.patch
mm-mmap-remove-find_vma_intersection-in-vma_merge.patch
mm-mmap-use-sz_8m-128m-helper-macro.patch

