Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3E7333937A
	for <mm-commits@vger.kernel.org>; Fri, 31 Jul 2026 02:43:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785465808; cv=none; b=aUBcTWF9p2gEPN52GAfv4iHgBr4bhnyzd02S6wmZCZy0soVNBkmHjDHgUMcBtJW8aSDlu4Ql/C7+UdzkMmndT8hR7en1cFZVKruFudCy7yYHKTkncy6hF8glQZBi1gbrkLg7rUru/AAJhBCJJd0ZhdUnx3YZ+bC2ZXyt0prUIUw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785465808; c=relaxed/simple;
	bh=Qs1OBB6IoGMXt6TV06QbLXbh7G9xmGNb6oBXcNhaAV0=;
	h=Date:To:From:Subject:Message-Id; b=Fq49cMTZ9Xf1WcmhQusSFfW7mHjuHbYZLpQo2bMF3Rg1wILDU2a26aNh7MlK3HWmw11etF3JobI71IhxqmLPHXeSz8wkk55eubsoyJ8qT/VNsnzCzOKko8tmd0+jpL0aXaR0d6MwVQgL4wrxx1wVAZJnzFm1DwLxAGNtnldcjXQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qMGr6s8M; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qMGr6s8M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 977EA1F000E9;
	Fri, 31 Jul 2026 02:43:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785465807;
	bh=EQwsTwQs8Ew7TrzNRTGa4OVo1sHcBcnDP5oPh+qucxc=;
	h=Date:To:From:Subject;
	b=qMGr6s8MU0iEkOst2bCRmSRHMY3AAaU0l01wXA3PBkkVV77bvval8sVKeMc2Vg83o
	 28a3844+pjXLY9jyshgFJIHLj11klKjocHHO9Qgq9deGUKb0KcBz7gU8CmJFx/WWiV
	 Z6kHsuK4PWEJ5aLaWIDOTt/xKABZskJrrUQiT85c=
Date: Thu, 30 Jul 2026 19:43:27 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,surenb@google.com,steve.wahl@hpe.com,robinmholt@gmail.com,gregkh@linuxfoundation.org,arnd@arndb.de,jackmanb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] sgi-xp-use-higher-level-allocator-api.patch removed from -mm tree
Message-Id: <20260731024327.977EA1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: sgi-xp: use higher-level allocator API
has been removed from the -mm tree.  Its filename was
     sgi-xp-use-higher-level-allocator-api.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Brendan Jackman <jackmanb@google.com>
Subject: sgi-xp: use higher-level allocator API
Date: Fri, 03 Jul 2026 12:31:51 +0000

The difference between __alloc_pages_node() and alloc_pages_node() is
that the latter allows you to pass NUMA_NO_NODE.

The former is going away and the latter works fine here so switch over.

No functional change intended.

Link: https://lore.kernel.org/20260703-alloc-trylock-v5-11-c87b714e19d3@google.com
Signed-off-by: Brendan Jackman <jackmanb@google.com>
Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Acked-by: Steve Wahl <steve.wahl@hpe.com>
Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Cc: Robin Holt <robinmholt@gmail.com>
Cc: Steve Wahl <steve.wahl@hpe.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Assisted-by: Gemini:unknown-model
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/sgi-xp/xpc_uv.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/drivers/misc/sgi-xp/xpc_uv.c~sgi-xp-use-higher-level-allocator-api
+++ a/drivers/misc/sgi-xp/xpc_uv.c
@@ -170,9 +170,8 @@ xpc_create_gru_mq_uv(unsigned int mq_siz
 	mq->mmr_blade = uv_cpu_to_blade_id(cpu);
 
 	nid = cpu_to_node(cpu);
-	page = __alloc_pages_node(nid,
-				      GFP_KERNEL | __GFP_ZERO | __GFP_THISNODE,
-				      pg_order);
+	page = alloc_pages_node(nid, GFP_KERNEL | __GFP_ZERO | __GFP_THISNODE,
+				pg_order);
 	if (page == NULL) {
 		dev_err(xpc_part, "xpc_create_gru_mq_uv() failed to alloc %d "
 			"bytes of memory on nid=%d for GRU mq\n", mq_size, nid);
_

Patches currently in -mm which might be from jackmanb@google.com are

mm-secretmem-dont-allow-highmem-folios.patch
mm-page_alloc-dont-spin_trylock-in-nmi-on-up.patch
mm-page_alloc-dont-spin_trylock-when-disallowed-in-free_one_page.patch
mm-page_alloc-rename-fpi_trylock-fpi_nolock.patch
cgroup-cpuset-update-some-comments-about-the-page-allocator.patch
mm-page_alloc-fixup-alloc_pages_nolock_noprof-comment.patch
mm-page_alloc-remove-a-couple-of-vm_bug_onst.patch

