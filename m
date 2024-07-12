Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2993127E0F
	for <mm-commits@vger.kernel.org>; Fri, 12 Jul 2024 22:54:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720824896; cv=none; b=NrF9oUXQbX1cL5g1ta2JSoZN5z+62eQ4UdOoGuW/k0pZoSapEnvUnhQ3mGRqAm72uN2z/6F1D1RZ/clJrWP9F0R2aoUyvr07vDm2pJsrAhDve8M7Jrj0k39mRwpA0zGIV4dOaQvfD/n01nHmNc6lipHAPOyGveTNV6xunbfKAe8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720824896; c=relaxed/simple;
	bh=lzpZBX0BOXIFtMaXddqMj6lf7Yi0OBo1X1DPHmUc1+M=;
	h=Date:To:From:Subject:Message-Id; b=hGe7H0IUF6yAhpy3184RMIISk0ARlNUSnm1cEOHcRgVW7YcNLPo1SD31MZswgp/IVjq9pu6YxjWww0XMww5wOMwVUeYyfy2PLW8cXluubo9z+ZBLVKSN+lMUqcdcLu9WWAzy34+MQ3Ocgl7D3XlX8+1uIbh/fmW3EMNlvKsHOzk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=EhX3q1kT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="EhX3q1kT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BA9BC32782;
	Fri, 12 Jul 2024 22:54:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1720824896;
	bh=lzpZBX0BOXIFtMaXddqMj6lf7Yi0OBo1X1DPHmUc1+M=;
	h=Date:To:From:Subject:From;
	b=EhX3q1kTCyDlFHHjcuu1cdvYudhO41fL1MmVEoGYgmMtMqeRnDCuKSCJ4XL4uFhda
	 L9tHUPkSoMnacPmlJPAlLqu3il9hrtwx7yK/MzV2KTOMMUDmpy+Nfcfa3lJjPYFjmA
	 ezoS91K2HMTKcNWL3TGY8101vcpMVZ2OQsvjhyBI=
Date: Fri, 12 Jul 2024 15:54:56 -0700
To: mm-commits@vger.kernel.org,osalvador@suse.de,david@redhat.com,richard.weiyang@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_alloc-put-__free_pages_core-in-__meminit-section.patch removed from -mm tree
Message-Id: <20240712225456.7BA9BC32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/page_alloc: put __free_pages_core() in __meminit section
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-put-__free_pages_core-in-__meminit-section.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Wei Yang <richard.weiyang@gmail.com>
Subject: mm/page_alloc: put __free_pages_core() in __meminit section
Date: Sat, 6 Jul 2024 06:16:15 +0000

__free_pages_core() is only used in bootmem init and hot-add memory init
path.  Let's put it in __meminit section.

Link: https://lkml.kernel.org/r/20240706061615.30322-1-richard.weiyang@gmail.com
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Oscar Salvador <osalvador@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |    3 ++-
 mm/page_alloc.c     |    2 +-
 2 files changed, 3 insertions(+), 2 deletions(-)

--- a/mm/memory_hotplug.c~mm-page_alloc-put-__free_pages_core-in-__meminit-section
+++ a/mm/memory_hotplug.c
@@ -628,7 +628,8 @@ int restore_online_page_callback(online_
 }
 EXPORT_SYMBOL_GPL(restore_online_page_callback);
 
-void generic_online_page(struct page *page, unsigned int order)
+/* we are OK calling __meminit stuff here - we have CONFIG_MEMORY_HOTPLUG */
+void __ref generic_online_page(struct page *page, unsigned int order)
 {
 	__free_pages_core(page, order, MEMINIT_HOTPLUG);
 }
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


