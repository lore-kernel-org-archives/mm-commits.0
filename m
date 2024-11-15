Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D834188015
	for <mm-commits@vger.kernel.org>; Fri, 15 Nov 2024 06:50:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731653408; cv=none; b=oq+ilz4sages8q4LXu8M4dBDx2duhWouu+BdV8SnKMTWBfaSypFAoPyyjhfXWeJCalLnq8Hk3I5F4glRaOWd0eP8+3RIdIZG7hCJ3m54+urFkOh78ag6nG/ZlIi/9OZ6EMZhF8IcvKaReHbJoY1LksS+vf+WpTcLB/4/ThnH2Rc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731653408; c=relaxed/simple;
	bh=6eG3TJkNtGMIgyrjxjmst4WTw4pwQLyBu10/2QSbMBY=;
	h=Date:To:From:Subject:Message-Id; b=YLDzdo/AoeTAbzb9SuiJ2SdjAGgg7B5NN3bCmMkC/UXN5MJvvg/dnDn1ONF0ZZFVf19fq+CH1GP1rVkorF3OfZo6AEjd53JC/+N9F6IHw2locurIDReZ+rFtbBC4RjUIQ45TytvBbN5snxzQeUWXe9Y/LPujhnu6lRTaY1n2y9Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=DPmjQWq1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DPmjQWq1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CB2AC4CECF;
	Fri, 15 Nov 2024 06:50:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1731653408;
	bh=6eG3TJkNtGMIgyrjxjmst4WTw4pwQLyBu10/2QSbMBY=;
	h=Date:To:From:Subject:From;
	b=DPmjQWq1rPHkuqOljTqmZki/SxlOb20qZ9n+UeGddwUJcSI9sTUbHCvM4HeZ5TFI0
	 V/TcVzI8p1QUBFetSDIVCY3XDd/pgU7hT8jT6KUlr6/EEMupqSOesIFkQnYbKtz/NG
	 iGeIlK9XRBVZCDOHWl77oxKptCwXjOEXO9IQUTKc=
Date: Thu, 14 Nov 2024 22:50:04 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,david@redhat.com,anshuman.khandual@arm.com,ritesh.list@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] cma-enforce-non-zero-pageblock_order-during-cma_init_reserved_mem.patch removed from -mm tree
Message-Id: <20241115065007.4CB2AC4CECF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: cma: enforce non-zero pageblock_order during cma_init_reserved_mem()
has been removed from the -mm tree.  Its filename was
     cma-enforce-non-zero-pageblock_order-during-cma_init_reserved_mem.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


