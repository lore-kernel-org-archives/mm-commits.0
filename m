Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39F821850B2
	for <mm-commits@vger.kernel.org>; Wed,  3 Jul 2024 18:33:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720031637; cv=none; b=Ymzdte7eIjl1QwiyP+Rb+O0IBq3XC9PjvzK9mZ/ArTQtDJTi2GhCfJJuZ1XdWCSwiaqXMuZkcj0CS5qntiDcY69ZVnJQj6VFiqOl7AdhsSnXXNqiAROiALTqOGswZCpM1Hy9FbXnngjjm253sIZmEe/Oc1y+DvVW+mHhuKIEHIU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720031637; c=relaxed/simple;
	bh=pYSnoxRS4Z1s9+GwMJOLf87FWOiC9SFuv9vQxPACQG0=;
	h=Date:To:From:Subject:Message-Id; b=baYAgvUOX3upAa0qyVEEayW6JFFJb202cqv2NbxTa2VwyB9innpBxiU1MfSQl+uwH/bxIqGRvvYjN1IRGdCm1c25tBjmOwSFhOu+U72xsZiaoN4Df9TnBe0JZvMSDh34aSTQlq3oBT8oHQPjoACx48QYvspiU7dmuzTf5c7OYiA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1ZYr1dqq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1ZYr1dqq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03AD0C2BD10;
	Wed,  3 Jul 2024 18:33:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1720031637;
	bh=pYSnoxRS4Z1s9+GwMJOLf87FWOiC9SFuv9vQxPACQG0=;
	h=Date:To:From:Subject:From;
	b=1ZYr1dqqbnjoJOQl4uFmXKZrnQEJG/Se3WfuSif++AD1afEMpjkq5mdZeUX1TVIsy
	 UW45XaBM5v77PqzEqdn+9OYMlOHv1/b2wxNicPhsCiydn7MyEpO5sQno1k9CdRCIic
	 DytrgpWpGKBeUR4hoYAMbXQAZcRfjXxmQqHHjf2U=
Date: Wed, 03 Jul 2024 11:33:56 -0700
To: mm-commits@vger.kernel.org,rppt@kernel.org,nicolas@fjasle.eu,nathan@kernel.org,masahiroy@kernel.org,richard.weiyang@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [nacked] mm-page_alloc-put-__free_pages_core-in-__meminit-section.patch removed from -mm tree
Message-Id: <20240703183357.03AD0C2BD10@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/page_alloc: put __free_pages_core() in __meminit section
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-put-__free_pages_core-in-__meminit-section.patch

This patch was dropped because it was nacked

------------------------------------------------------
From: Wei Yang <richard.weiyang@gmail.com>
Subject: mm/page_alloc: put __free_pages_core() in __meminit section
Date: Tue, 2 Jul 2024 23:40:08 +0000

Function __free_pages_core() is only used in bootmem init and hot-add
memory init path. Let's put it in __meminit section.

Link: https://lkml.kernel.org/r/20240702234008.19101-3-richard.weiyang@gmail.com
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Cc: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Nicolas Schier <nicolas@fjasle.eu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/page_alloc.c~mm-page_alloc-put-__free_pages_core-in-__meminit-section
+++ a/mm/page_alloc.c
@@ -1219,7 +1219,7 @@ static void __free_pages_ok(struct page
 	__count_vm_events(PGFREE, 1 << order);
 }
 
-void __free_pages_core(struct page *page, unsigned int order,
+void __meminit __free_pages_core(struct page *page, unsigned int order,
 		enum meminit_context context)
 {
 	unsigned int nr_pages = 1 << order;
_

Patches currently in -mm which might be from richard.weiyang@gmail.com are

kernel-forkc-get-totalram_pages-from-memblock-to-calculate-max_threads.patch
kernel-forkc-put-set_max_threads-task_struct_whitelist-in-__init-section.patch
mm-page_alloc-remove-prefetchw-on-freeing-page-to-buddy-system.patch

