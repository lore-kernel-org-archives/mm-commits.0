Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D2F7322E;
	Fri, 20 Jun 2025 03:49:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750391360; cv=none; b=oALPawz4S7v7cOmLrxFPezo/XZGp5cMHyLeSVu9G2J5SQgK6TJuW2skRNjxCM0zL4tXjCGB5F3YPHRHsLBt7YENQ8aW/xg1hh94nR+zgzZfUIUWQok/P3BgLZAKb2Xtr4FrMDqHiqjqZTTKfJf9SMVPXL464CI+CfVjqzv9dfdQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750391360; c=relaxed/simple;
	bh=cQwiK5YRxUn49pAudKT7SfdsPcLaNfgsMufCkQZUnak=;
	h=Date:To:From:Subject:Message-Id; b=GDgtP2ljqDCPZC99aSAInCdSqt/hss9qXxc8Ye8nBi3oU2mKbPfW6rU+opJJuN7aH6SOZvsMDDrcBq8IJGuq4H7SAhZwo38Fv5VEokH1N8W1n1biLe9vPDiseQ1OWM2vPo3OGfzExmIXmvr6kIE1UdZw1kUHBXEDXcn5FKlNMrI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=VkgWFSqz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="VkgWFSqz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2332FC4CEE3;
	Fri, 20 Jun 2025 03:49:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1750391360;
	bh=cQwiK5YRxUn49pAudKT7SfdsPcLaNfgsMufCkQZUnak=;
	h=Date:To:From:Subject:From;
	b=VkgWFSqz+Be0U1G8kHipYgRUEkC8ow9diJo3l8N6nLKgzmdrlCHIqTJ0pHcTCLXxS
	 UPI/lGYNAwPZDRxY9rQqewEX/8+2OWDwUcXye5r+ap2hzq0ubt7BDkdib07WitgCu+
	 iaAhzmjmVBZUAqnmKw8p4J6nt4lTxR9DSYH76vmM=
Date: Thu, 19 Jun 2025 20:49:19 -0700
To: mm-commits@vger.kernel.org,zhaoyang.huang@unisoc.com,zhangpeng.00@bytedance.com,willy@infradead.org,surenb@google.com,Steve.Kang@unisoc.com,stable@vger.kernel.org,sidhartha.kumar@oracle.com,lorenzo.stoakes@oracle.com,hailong.liu@oppo.com,Liam.Howlett@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] maple_tree-fix-ma_state_prealloc-flag-in-mas_preallocate.patch removed from -mm tree
Message-Id: <20250620034920.2332FC4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: maple_tree: fix MA_STATE_PREALLOC flag in mas_preallocate()
has been removed from the -mm tree.  Its filename was
     maple_tree-fix-ma_state_prealloc-flag-in-mas_preallocate.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: maple_tree: fix MA_STATE_PREALLOC flag in mas_preallocate()
Date: Mon, 16 Jun 2025 14:45:20 -0400

Temporarily clear the preallocation flag when explicitly requesting
allocations.  Pre-existing allocations are already counted against the
request through mas_node_count_gfp(), but the allocations will not happen
if the MA_STATE_PREALLOC flag is set.  This flag is meant to avoid
re-allocating in bulk allocation mode, and to detect issues with
preallocation calculations.

The MA_STATE_PREALLOC flag should also always be set on zero allocations
so that detection of underflow allocations will print a WARN_ON() during
consumption.

User visible effect of this flaw is a WARN_ON() followed by a null pointer
dereference when subsequent requests for larger number of nodes is
ignored, such as the vma merge retry in mmap_region() caused by drivers
altering the vma flags (which happens in v6.6, at least)

Link: https://lkml.kernel.org/r/20250616184521.3382795-3-Liam.Howlett@oracle.com
Fixes: 54a611b60590 ("Maple Tree: add new data structure")
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Reported-by: Zhaoyang Huang <zhaoyang.huang@unisoc.com>
Reported-by: Hailong Liu <hailong.liu@oppo.com>
Link: https://lore.kernel.org/all/1652f7eb-a51b-4fee-8058-c73af63bacd1@oppo.com/
Link: https://lore.kernel.org/all/20250428184058.1416274-1-Liam.Howlett@oracle.com/
Link: https://lore.kernel.org/all/20250429014754.1479118-1-Liam.Howlett@oracle.com/
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Hailong Liu <hailong.liu@oppo.com>
Cc: zhangpeng.00@bytedance.com <zhangpeng.00@bytedance.com>
Cc: Steve Kang <Steve.Kang@unisoc.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/lib/maple_tree.c~maple_tree-fix-ma_state_prealloc-flag-in-mas_preallocate
+++ a/lib/maple_tree.c
@@ -5527,8 +5527,9 @@ int mas_preallocate(struct ma_state *mas
 	mas->store_type = mas_wr_store_type(&wr_mas);
 	request = mas_prealloc_calc(&wr_mas, entry);
 	if (!request)
-		return ret;
+		goto set_flag;
 
+	mas->mas_flags &= ~MA_STATE_PREALLOC;
 	mas_node_count_gfp(mas, request, gfp);
 	if (mas_is_err(mas)) {
 		mas_set_alloc_req(mas, 0);
@@ -5538,6 +5539,7 @@ int mas_preallocate(struct ma_state *mas
 		return ret;
 	}
 
+set_flag:
 	mas->mas_flags |= MA_STATE_PREALLOC;
 	return ret;
 }
_

Patches currently in -mm which might be from Liam.Howlett@oracle.com are

tools-testing-radix-tree-test-maple-tree-chaining-mas_preallocate-calls.patch

