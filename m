Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B634423D7
	for <mm-commits@vger.kernel.org>; Mon,  6 May 2024 00:28:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714955323; cv=none; b=hzP+I70a+8EJZfOCoXg5ZCXhymzs7XkAtTPmV+2xGXRm7MiIWtp7EcpLMfRBFNMEGj8VVob73LZc2Pb1Qy5JEzG0aQhnfFzbYyYJofU1D1iVkH7bL8I41+FF2PyaPyHf+7j5/WZMtER6h0APlC5s5AAEmTfKJqL+hFJD6gVS3vs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714955323; c=relaxed/simple;
	bh=4WGFOnPfGvCwvz/uBdFSr2dAT35n+w6hbHGV3sHW0Ns=;
	h=Date:To:From:Subject:Message-Id; b=k26MTwsmYX2PhP4mpNuttq2GXYVGz9XdRPZWhwIUe5U2/BVuS1tmhhwqRJc6z24B2cobFUPy6WNKA6S6Ljdokg7CQnxFfkjJpl/sIdhklUlzwhyRopoUFlnulaIRwapmsM4dVK26DXT2KXeyU+09yG8mnauN0HQdoXE0ChllwoI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=IVkTFp4J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="IVkTFp4J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35826C116B1;
	Mon,  6 May 2024 00:28:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714955323;
	bh=4WGFOnPfGvCwvz/uBdFSr2dAT35n+w6hbHGV3sHW0Ns=;
	h=Date:To:From:Subject:From;
	b=IVkTFp4Jbcl3MuL5R4hchXR2IDMPyn+z8wCfROxEODbbKShSGdXpEiYGkNvccxnOz
	 WuaW/7auGwh3afnbyhNYqaB5+/hP7DRxd0JhqZTfeziZr5CxHv2s5apxOrh0SJG3JR
	 CpnoChwTyrAXZk60hGCH0zD2J6ypuheW+v1RBdLE=
Date: Sun, 05 May 2024 17:28:42 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,urezki@gmail.com,r.thapliyal@samsung.com,osalvador@suse.de,lstoakes@gmail.com,hch@infradead.org,hariom1.p@samsung.com,maninder1.s@samsung.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-page_owner-fixing-wrong-information-in-dump_page_owner.patch removed from -mm tree
Message-Id: <20240506002843.35826C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: page_owner: fix wrong information in dump_page_owner
has been removed from the -mm tree.  Its filename was
     mm-page_owner-fixing-wrong-information-in-dump_page_owner.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Maninder Singh <maninder1.s@samsung.com>
Subject: mm: page_owner: fix wrong information in dump_page_owner
Date: Wed, 24 Apr 2024 16:48:37 +0530

With commit ea4b5b33bf8a ("mm,page_owner: update metadata for tail
pages"), new API __update_page_owner_handle was introduced and arguemnt
was passed in wrong order from __set_page_owner and thus page_owner is
giving wrong data.

[   15.982420] page last allocated via order 0, migratetype Unmovable, gfp_mask 0xcc0(GFP_KERNEL), pid 80, tgid -1210279584 (insmod), ts 80, free_ts 0

Fixing the same.
Correct output:
[   14.556482] page last allocated via order 0, migratetype Unmovable, gfp_mask 0xcc0(GFP_KERNEL), pid 80, tgid 80 (insmod), ts 14552004992, free_ts 0

Link: https://lkml.kernel.org/r/20240424111838.3782931-1-hariom1.p@samsung.com
Fixes: ea4b5b33bf8a ("mm,page_owner: update metadata for tail pages")
Signed-off-by: Maninder Singh <maninder1.s@samsung.com>
Signed-off-by: Hariom Panthi <hariom1.p@samsung.com>
Acked-by: Oscar Salvador <osalvador@suse.de>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: Rohit Thapliyal <r.thapliyal@samsung.com>
Cc: Uladzislau Rezki (Sony) <urezki@gmail.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_owner.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/page_owner.c~mm-page_owner-fixing-wrong-information-in-dump_page_owner
+++ a/mm/page_owner.c
@@ -328,7 +328,7 @@ noinline void __set_page_owner(struct pa
 	if (unlikely(!page_ext))
 		return;
 	__update_page_owner_handle(page_ext, handle, order, gfp_mask, -1,
-				   current->pid, current->tgid, ts_nsec,
+				   ts_nsec, current->pid, current->tgid,
 				   current->comm);
 	page_ext_put(page_ext);
 	inc_stack_record_count(handle, gfp_mask, 1 << order);
_

Patches currently in -mm which might be from maninder1.s@samsung.com are


