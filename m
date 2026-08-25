Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6C9C233936
	for <mm-commits@vger.kernel.org>; Tue, 25 Aug 2026 01:54:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787622861; cv=none; b=Yogm5Yl+JVxhGGtfOOP6Z3cnKrxV48l7CzzJ2LkDgizEei6WLKlq3IsK7ROzqVaC5bimgSCDvsnwjk1pjrzvMC/U8AtZ858XHApG8zvLS16Osq1W514Vb68uB6HCKypTzWlEsTdqgc/6Y5VdaB/N+yWYYa928OkhwQtx8VEipqA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787622861; c=relaxed/simple;
	bh=0fKuXeKizhd2oMZNioPM0iJVi+5gUmZ6zxAsDqYEB24=;
	h=Date:To:From:Subject:Message-Id; b=nCJWIPGRpRsD+J7/9jnAUHppkY10KRVXEO8e689NXZpb+qmhyOqDUm9BOT9jOMqyn79KFv6d8SkLbX0FN5DGEkBKDbLYE7842ilO8o0yRL/9RpLtCemj9qeAy8a6Z0EmMYb0QnRWD+iG1ErlHo/fzeuplr31zY1/cDbYZEYPsh8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=LnT7Blts; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="LnT7Blts"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CD2B1F000E9;
	Tue, 25 Aug 2026 01:54:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787622860;
	bh=S288SsZoFA2U5lDDv4ZHrQlUnVuXQIB0rjitx95cArs=;
	h=Date:To:From:Subject;
	b=LnT7Bltsl6BqYvx3kzTFlhDtpc3SWo2SktBU4T32oUECF1GQYfrblN2m3LBh349+V
	 8BJr9LYUnfsYLDw6x0V0+HwatPR8IKxCe5DTNwNrX23iq4VUY85SX8PeqUuqUJiwBz
	 B/8qb5RcyKAQh5xr9KXLitevP1CJjnzytVUdQbsg=
Date: Mon, 24 Aug 2026 18:54:20 -0700
To: mm-commits@vger.kernel.org,rppt@kernel.org,henry.elderman.edu+linux@gmail.com,henry.elderman.edu@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-execmem-fix-fallback_end-description-in-kernel-doc.patch removed from -mm tree
Message-Id: <20260825015420.8CD2B1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/execmem: fix fallback_end description in kernel-doc
has been removed from the -mm tree.  Its filename was
     mm-execmem-fix-fallback_end-description-in-kernel-doc.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Henry Elderman <henry.elderman.edu@gmail.com>
Subject: mm/execmem: fix fallback_end description in kernel-doc
Date: Fri, 7 Aug 2026 11:19:58 +0200

The kernel-doc for struct execmem_range incorrectly describes @fallback_end
as "start". Correct it to "end".

Link: https://lore.kernel.org/20260807091958.4735-1-henry.elderman.edu+linux@gmail.com
Signed-off-by: Henry Elderman <henry.elderman.edu+linux@gmail.com>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/execmem.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/execmem.h~mm-execmem-fix-fallback_end-description-in-kernel-doc
+++ a/include/linux/execmem.h
@@ -89,7 +89,7 @@ static inline int execmem_restore_rox(vo
  * @end:	address space end (inclusive)
  * @fallback_start: start of the secondary address space range for fallback
  *                  allocations on architectures that require it
- * @fallback_end:   start of the secondary address space (inclusive)
+ * @fallback_end:   end of the secondary address space (inclusive)
  * @pgprot:	permissions for memory in this address space
  * @alignment:	alignment required for text allocations
  * @flags:	options for memory allocations for this range
_

Patches currently in -mm which might be from henry.elderman.edu@gmail.com are


