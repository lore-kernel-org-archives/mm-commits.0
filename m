Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6877321CC51
	for <mm-commits@vger.kernel.org>; Mon, 17 Nov 2025 01:31:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763343112; cv=none; b=IT4/TP9iMcqJcqGvTamsbU5x2w10w3GW2dT+Usoqw51v3lpbgFPdtLCNb4ouwWQ91IOLxEhqh7neOkRQdDDm+X7W5jDy8w2g+MBvQgMDrBYmHfD6pHLtWCaIhpDY1l8weib/vx/M7owZDzZzeMBmNL9CEDZO66VvhsWz4nncE3c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763343112; c=relaxed/simple;
	bh=3YUm7nkbITNuaC3P6H6XWkGUIECVsgq/xa81+UfNU2Y=;
	h=Date:To:From:Subject:Message-Id; b=Alb1SSTECb5doSQflJumf1XT/bveHvGZEO5/YsjR2vVyU4y7uDDgkUA7SZbK3OHDv5UiAvRdVBEGevk86oki3/51tBzIwB1DbVkfTarCaiw/J1bj4Y8rpaWZ+gbWlbUscY9DHqNhc+qZhWZcqxI2HlYDGigzE2w4aR7uWygb/sI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=TGTUOTfp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="TGTUOTfp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DC93C4CEF1;
	Mon, 17 Nov 2025 01:31:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763343112;
	bh=3YUm7nkbITNuaC3P6H6XWkGUIECVsgq/xa81+UfNU2Y=;
	h=Date:To:From:Subject:From;
	b=TGTUOTfpg1RwNfxWBcT00ZleBSssQbJNrBPbfAxf7z9MV9exMMW2ogLyGAN/zVZ5z
	 vd1unFO20SM7c0RZ3ekZK2Bk9IUnius/J6Vt/KCeY8Sgj84kox693fQs7GrhM+ZKcv
	 xblgSZLAZ3S4ayFC2kDwH/M7vh8DsyUPgtJD7VVU=
Date: Sun, 16 Nov 2025 17:31:51 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@suse.cz,surenb@google.com,osalvador@suse.de,mhocko@suse.com,jackmanb@google.com,hannes@cmpxchg.org,mfo@igalia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_owner-update-documentation-with-show_handles-and-show_stacks_handles.patch removed from -mm tree
Message-Id: <20251117013152.3DC93C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/page_owner: update Documentation with 'show_handles' and 'show_stacks_handles'
has been removed from the -mm tree.  Its filename was
     mm-page_owner-update-documentation-with-show_handles-and-show_stacks_handles.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Mauricio Faria de Oliveira <mfo@igalia.com>
Subject: mm/page_owner: update Documentation with 'show_handles' and 'show_stacks_handles'
Date: Wed, 1 Oct 2025 14:56:11 -0300

Describe and provide examples for 'show_handles' and 'show_stacks_handles'.

Link: https://lkml.kernel.org/r/20251001175611.575861-6-mfo@igalia.com
Signed-off-by: Mauricio Faria de Oliveira <mfo@igalia.com>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/mm/page_owner.rst |   32 +++++++++++++++++++++++++++++-
 1 file changed, 31 insertions(+), 1 deletion(-)

--- a/Documentation/mm/page_owner.rst~mm-page_owner-update-documentation-with-show_handles-and-show_stacks_handles
+++ a/Documentation/mm/page_owner.rst
@@ -27,7 +27,10 @@ enabled. Other usages are more than welc
 It can also be used to show all the stacks and their current number of
 allocated base pages, which gives us a quick overview of where the memory
 is going without the need to screen through all the pages and match the
-allocation and free operation.
+allocation and free operation. It's also possible to show only a numeric
+identifier of all the stacks (without stack traces) and their number of
+allocated base pages (faster to read and parse, eg, for monitoring) that
+can be matched with stacks later (show_handles and show_stacks_handles).
 
 page owner is disabled by default. So, if you'd like to use it, you need
 to add "page_owner=on" to your boot cmdline. If the kernel is built
@@ -116,6 +119,33 @@ Usage
 	nr_base_pages: 20824
 	...
 
+	cat /sys/kernel/debug/page_owner_stacks/show_handles > handles_7000.txt
+	cat handles_7000.txt
+	handle: 42
+	nr_base_pages: 20824
+	...
+
+	cat /sys/kernel/debug/page_owner_stacks/show_stacks_handles > stacks_handles.txt
+	cat stacks_handles.txt
+	 post_alloc_hook+0x177/0x1a0
+	 get_page_from_freelist+0xd01/0xd80
+	 __alloc_pages+0x39e/0x7e0
+	 alloc_pages_mpol+0x22e/0x490
+	 folio_alloc+0xd5/0x110
+	 filemap_alloc_folio+0x78/0x230
+	 page_cache_ra_order+0x287/0x6f0
+	 filemap_get_pages+0x517/0x1160
+	 filemap_read+0x304/0x9f0
+	 xfs_file_buffered_read+0xe6/0x1d0 [xfs]
+	 xfs_file_read_iter+0x1f0/0x380 [xfs]
+	 __kernel_read+0x3b9/0x730
+	 kernel_read_file+0x309/0x4d0
+	 __do_sys_finit_module+0x381/0x730
+	 do_syscall_64+0x8d/0x150
+	 entry_SYSCALL_64_after_hwframe+0x62/0x6a
+	handle: 42
+	...
+
 	cat /sys/kernel/debug/page_owner > page_owner_full.txt
 	./page_owner_sort page_owner_full.txt sorted_page_owner.txt
 
_

Patches currently in -mm which might be from mfo@igalia.com are


