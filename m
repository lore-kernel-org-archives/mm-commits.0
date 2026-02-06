Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 172633126D4
	for <mm-commits@vger.kernel.org>; Fri,  6 Feb 2026 23:48:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770421691; cv=none; b=QX8uUtQXMlQQ+qdvpGpkav8gqFqO4dCousYHh3SKI1UdT0qVqDnMQuZeVRgGq6NiTNeyq7Mn0DR2w2uUKkmT0mpCTUxYNDHZe5xMW7QH7OtV6hx94ZshLIPaFbfavBxBgjOAZ0taJN8VQoHv3OQGzNpFEeql/J1qwfARaMW5Ykk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770421691; c=relaxed/simple;
	bh=5tuWyY1AF6xo9qlb+OHphP8KBUqc5aznQRmGKmAnWbE=;
	h=Date:To:From:Subject:Message-Id; b=rfE9N5I0AhFQJZ2opNaFDiPPs26LdvxszCO0ARHyjchw79ShImxqgYIjxfCuVRvh/GagF5SJyxjaHtGa/CqsX6RsJfjxV5Zh33NzIuIZYkomqolxvOlDrtQliqvVI1qzZuMcnvyehHX7W7ehMcAEGPvkBKtzWP0sJSINAL4pjNI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=byohby9Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="byohby9Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAD30C116C6;
	Fri,  6 Feb 2026 23:48:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1770421690;
	bh=5tuWyY1AF6xo9qlb+OHphP8KBUqc5aznQRmGKmAnWbE=;
	h=Date:To:From:Subject:From;
	b=byohby9Ysa3xtvryt4VAvIaaoAaLpXekvvB/SuTwkwHllYJMRyax+iiUt/i4niRjM
	 d/peZBwRKoPEDjrEC5VZ4BBWUUDg5yOaByu/SYWHllywZWRSKf8V3uucqJJgerR8bk
	 SavKGr0xyqtthCFqfvILz12/WSNVLeafB2tVHaGM=
Date: Fri, 06 Feb 2026 15:48:10 -0800
To: mm-commits@vger.kernel.org,yosry.ahmed@linux.dev,sj@kernel.org,nphamcs@gmail.com,david@kernel.org,chandna.sahil@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-vmscan-use-%pe-to-print-error-pointers.patch removed from -mm tree
Message-Id: <20260206234810.BAD30C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/vmscan: use %pe to print error pointers
has been removed from the -mm tree.  Its filename was
     mm-vmscan-use-%pe-to-print-error-pointers.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Sahil Chandna <chandna.sahil@gmail.com>
Subject: mm/vmscan: use %pe to print error pointers
Date: Thu, 5 Feb 2026 00:24:07 +0530

Use the %pe printk format specifier to report error pointers directly
instead of printing PTR_ERR() as a long value.  This improves clarity,
produces more readable error messages.

This instance was flagged by the Coccinelle script
(misc/ptr_err_to_pe.cocci) as an opportunity to adopt %pe.

Found by: make coccicheck MODE=report M=mm/
No functional change intended

Link: https://lkml.kernel.org/r/80a6643657a60e75ddf48b4869b3e7fdc101f855.1770230135.git.chandna.sahil@gmail.com
Signed-off-by: Sahil Chandna <chandna.sahil@gmail.com>
Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
Reviewed-by: SeongJae Park <sj@kernel.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Yosry Ahmed <yosry.ahmed@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/vmscan.c~mm-vmscan-use-%pe-to-print-error-pointers
+++ a/mm/vmscan.c
@@ -7470,8 +7470,8 @@ void __meminit kswapd_run(int nid)
 		pgdat->kswapd = kthread_create_on_node(kswapd, pgdat, nid, "kswapd%d", nid);
 		if (IS_ERR(pgdat->kswapd)) {
 			/* failure at boot is fatal */
-			pr_err("Failed to start kswapd on node %d，ret=%ld\n",
-				   nid, PTR_ERR(pgdat->kswapd));
+			pr_err("Failed to start kswapd on node %d, ret=%pe\n",
+				   nid, pgdat->kswapd);
 			BUG_ON(system_state < SYSTEM_RUNNING);
 			pgdat->kswapd = NULL;
 		} else {
_

Patches currently in -mm which might be from chandna.sahil@gmail.com are


