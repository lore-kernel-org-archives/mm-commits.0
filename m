Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CF6C29CF0;
	Thu,  6 Mar 2025 05:37:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741239436; cv=none; b=X9mnz45CgTboWRPA21YeHdhsUMyTzgFysGh7302xJVJYw0S1FYcq/u4hLX29yogB3gjh9XAr/AmchwEF4micD+tp4n52l4hjrtIga0orVQ1vFG95ubDyksGHyqpNjCTu0QHCN0OoqGFLghzJFSOBzr4yttEpUUCnkwANZXbaeK4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741239436; c=relaxed/simple;
	bh=1d9bTkc2TiVZAwFfQ5yYcAd24/v6/9sWLx3bRm2LaNY=;
	h=Date:To:From:Subject:Message-Id; b=mqEmNneXx9apyuhqr6JHVG9GxRObF4qKxQ+ZwJ77M1VahyQYa/48cMMUfaBwv9zB3RyomDi2fxe/cYntQ+l3siIQntCTbqZxhPQ7hV8BJLDvGIX5hKoaK2zVYGU2RRyYzNp9FlEX1omaTPY6G+yN4gY1//qDSXJHnAlmO/eY0bk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=waWkRyGC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="waWkRyGC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3298C4CEE5;
	Thu,  6 Mar 2025 05:37:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1741239436;
	bh=1d9bTkc2TiVZAwFfQ5yYcAd24/v6/9sWLx3bRm2LaNY=;
	h=Date:To:From:Subject:From;
	b=waWkRyGCHaiOZvDAfO4TWIdZhdTpE0gx0e1Blm9DB1Y9rzqbeGjMLDYW4Akn1zXW0
	 R2gtbfgJbUw8mo/qjQ5okJTF5V6Q++cGPKfxW5zg0wVNKHps6PuvBLcNum8G2dgzTa
	 t3tz+VgVkmfsX/NZ0TPA9jgrsw48sATD67PJ5u0A=
Date: Wed, 05 Mar 2025 21:37:15 -0800
To: mm-commits@vger.kernel.org,zhengqi.arch@bytedance.com,stable@vger.kernel.org,sammy@sammy.net,kevin.brodsky@arm.com,geert@linux-m68k.org,dave.hansen@linux.intel.com,haoxiang_li2024@163.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] m68k-sun3-add-check-for-__pgd_alloc.patch removed from -mm tree
Message-Id: <20250306053715.E3298C4CEE5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: m68k: sun3: add check for __pgd_alloc()
has been removed from the -mm tree.  Its filename was
     m68k-sun3-add-check-for-__pgd_alloc.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Haoxiang Li <haoxiang_li2024@163.com>
Subject: m68k: sun3: add check for __pgd_alloc()
Date: Tue, 18 Feb 2025 00:00:17 +0800

Add check for the return value of __pgd_alloc() in pgd_alloc() to prevent
null pointer dereference.

Link: https://lkml.kernel.org/r/20250217160017.2375536-1-haoxiang_li2024@163.com
Fixes: a9b3c355c2e6 ("asm-generic: pgalloc: provide generic __pgd_{alloc,free}")
Signed-off-by: Haoxiang Li <haoxiang_li2024@163.com>
Reviewed-by: Geert Uytterhoeven <geert@linux-m68k.org>
Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Kevin Brodsky <kevin.brodsky@arm.com>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Sam Creasey <sammy@sammy.net>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/m68k/include/asm/sun3_pgalloc.h |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/arch/m68k/include/asm/sun3_pgalloc.h~m68k-sun3-add-check-for-__pgd_alloc
+++ a/arch/m68k/include/asm/sun3_pgalloc.h
@@ -44,8 +44,10 @@ static inline pgd_t * pgd_alloc(struct m
 	pgd_t *new_pgd;
 
 	new_pgd = __pgd_alloc(mm, 0);
-	memcpy(new_pgd, swapper_pg_dir, PAGE_SIZE);
-	memset(new_pgd, 0, (PAGE_OFFSET >> PGDIR_SHIFT));
+	if (likely(new_pgd != NULL)) {
+		memcpy(new_pgd, swapper_pg_dir, PAGE_SIZE);
+		memset(new_pgd, 0, (PAGE_OFFSET >> PGDIR_SHIFT));
+	}
 	return new_pgd;
 }
 
_

Patches currently in -mm which might be from haoxiang_li2024@163.com are


