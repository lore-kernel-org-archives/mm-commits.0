Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3DBABA2E
	for <mm-commits@vger.kernel.org>; Fri, 15 Nov 2024 00:00:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731628815; cv=none; b=O4OB0vgfDyug12T9A3SBn8eIzC8v5RvEzgw2lekkh4ESm79oDPNXsO7GpRv6P7NSBNV2pLM6BHu/z8DGXIWXiZo1bCTTZaOjuOY0+I9sN7jIrKYYEkZosDuJmHRtnpoONgWVLAvOG9X1F+iHiz3V+teRsBgSUpd616lEQvlJj2U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731628815; c=relaxed/simple;
	bh=PIX2VIKCkI4mE6cS3a76cFVt0pBXv5onAZZbQsyD5II=;
	h=Date:To:From:Subject:Message-Id; b=qAjeDk9GHwqKutu2KVkMDUjXQfuNhRcQ7YZfniinS/ks4DHInI/1qKUF1BxCpiXDXB59DmBsUGh5n4pY8P98vKj8JDHlTb7gMTqBvVIdIXePnqHEfzJUjxw2vluX1uSZb99elcGsnnaf7h9S84K1jhUY3Sa/Xyznqm8ZhEQwXQ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Fenipzeh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Fenipzeh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3590C4CED4;
	Fri, 15 Nov 2024 00:00:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1731628815;
	bh=PIX2VIKCkI4mE6cS3a76cFVt0pBXv5onAZZbQsyD5II=;
	h=Date:To:From:Subject:From;
	b=Fenipzeh5rkok8VBWeActYmYpZHu0dkfEVFR+n8S3NWauhakygYadV7emkPxKUgTc
	 S7s/lwf5wYRAC3bW98l8cq6wmwtxHboLZIIO5vMwvbxPZodvKVdLdfNzqGpiZXC094
	 1AigCvkrCNHu0L8YxKcQGBhPKpscKbUcrAsP73GI=
Date: Thu, 14 Nov 2024 16:00:12 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,david@redhat.com,anshuman.khandual@arm.com,ritesh.list@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + cma-enforce-non-zero-pageblock_order-during-cma_init_reserved_mem.patch added to mm-unstable branch
Message-Id: <20241115000014.D3590C4CED4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: cma: enforce non-zero pageblock_order during cma_init_reserved_mem()
has been added to the -mm mm-unstable branch.  Its filename is
     cma-enforce-non-zero-pageblock_order-during-cma_init_reserved_mem.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/cma-enforce-non-zero-pageblock_order-during-cma_init_reserved_mem.patch

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
From: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
Subject: cma: enforce non-zero pageblock_order during cma_init_reserved_mem()
Date: Wed, 13 Nov 2024 19:49:54 +0530

cma_init_reserved_mem() checks base and size alignment with
CMA_MIN_ALIGNMENT_BYTES.  However, some users might call this during early
boot when pageblock_order is 0.  That means if base and size does not have
pageblock_order alignment, it can cause functional failures during cma
activate area.

So let's enforce pageblock_order to be non-zero during
cma_init_reserved_mem() to catch such wrong usages.

1. This was seen with fadump on PowerPC which was calling
   cma_init_reserved_mem() before the pageblock_order was initialized. 
   This is now fixed in the fadump on PowerPC itself.  The details of that
   can be found in the patch including the userspace-visible effect of the
   issue [1].

2. However it was also decided that we should add a stronger
   enforcement check within cma_init_reserved_mem() to catch such wrong
   usages [2].  Hence this patch.  This is ok to be in -next and there is
   no "Fixes" tag required for this patch.

[1]: https://lore.kernel.org/all/3ae208e48c0d9cefe53d2dc4f593388067405b7d.1729146153.git.ritesh.list@gmail.com/
[2]: https://lore.kernel.org/all/83eb128e-4f06-4725-a843-a4563f246a44@redhat.com/

Link: https://lkml.kernel.org/r/e274344b44d5f80fa54c52f530387257fe99ec65.1731505681.git.ritesh.list@gmail.com
Signed-off-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/cma.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/mm/cma.c~cma-enforce-non-zero-pageblock_order-during-cma_init_reserved_mem
+++ a/mm/cma.c
@@ -181,6 +181,15 @@ int __init cma_init_reserved_mem(phys_ad
 	if (!size || !memblock_is_region_reserved(base, size))
 		return -EINVAL;
 
+	/*
+	 * CMA uses CMA_MIN_ALIGNMENT_BYTES as alignment requirement which
+	 * needs pageblock_order to be initialized. Let's enforce it.
+	 */
+	if (!pageblock_order) {
+		pr_err("pageblock_order not yet initialized. Called during early boot?\n");
+		return -EINVAL;
+	}
+
 	/* ensure minimal alignment required by mm core */
 	if (!IS_ALIGNED(base | size, CMA_MIN_ALIGNMENT_BYTES))
 		return -EINVAL;
_

Patches currently in -mm which might be from ritesh.list@gmail.com are

cma-enforce-non-zero-pageblock_order-during-cma_init_reserved_mem.patch

