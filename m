Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE005469D
	for <mm-commits@vger.kernel.org>; Thu, 10 Jul 2025 04:36:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752122205; cv=none; b=mTp/FMY+rWO+xLRu1UNip2T+O9JcPS8L1qWAo8urL5JXOSpybUVrYy5xZkeMDr9wHUWxnKNxzh+HYrKe/RxfC01qognU/NG14rXS8yeCOAdcNIVaBF4R9IRLyyUWPehDb9vbrrJ1JcGR1z+luCqRqcDVBvWiM3vJD/b9+Qm+YTk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752122205; c=relaxed/simple;
	bh=z8W/D5MnIrH5mlmxZp6Qxg8pXALyKzJDCEIPj2egjpY=;
	h=Date:To:From:Subject:Message-Id; b=LFV1hNB0FKPzFcBYE65dSa08PXqdwNgFjljIcYpvoQzypqt9uxHYvwKD5EdzlFNDn+1MQF+KfoTKVBml+lnntKALXJyzyj3inN/Nu2TUonOyrpcGUHB9+L4Uo1gsIuSQMuTPiq4kX/Xa62tNiIyNJol9gkVceA5o5qLurkGZbao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=CpQJ/pPz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="CpQJ/pPz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0BB4C4CEE3;
	Thu, 10 Jul 2025 04:36:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752122205;
	bh=z8W/D5MnIrH5mlmxZp6Qxg8pXALyKzJDCEIPj2egjpY=;
	h=Date:To:From:Subject:From;
	b=CpQJ/pPzT4ITRNGD53ZRg4tz3yw7RoE6TkmEqExU901RT8q9zPVqRjQH1520iAjK1
	 YWDHskjrGtpnwB9oBbuxaCK9tR/sG3DiShRg+goaERNl5XA1IqB42foPo8S3CaxiNp
	 1kroOzMQfMomH3XKdJ99lv5BhT2mAds8B4EMTa9o=
Date: Wed, 09 Jul 2025 21:36:45 -0700
To: mm-commits@vger.kernel.org,zhengtangquan@oppo.com,vbabka@suse.cz,surenb@google.com,ryan.roberts@arm.com,osalvador@suse.de,lorenzo.stoakes@oracle.com,lokeshgidra@google.com,Liam.Howlett@oracle.com,jannh@google.com,harry.yoo@oracle.com,dev.jain@arm.com,david@redhat.com,anshuman.khandual@arm.com,v-songbaohua@oppo.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-madvise-use-walk_page_range_vma-instead-of-walk_page_range-fix.patch removed from -mm tree
Message-Id: <20250710043645.B0BB4C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: madvise: revert the walk_page_range_vma change for MADV_GUARD_INSTALL
has been removed from the -mm tree.  Its filename was
     mm-madvise-use-walk_page_range_vma-instead-of-walk_page_range-fix.patch

This patch was dropped because it was folded into mm-madvise-use-walk_page_range_vma-instead-of-walk_page_range.patch

------------------------------------------------------
From: Barry Song <v-songbaohua@oppo.com>
Subject: mm: madvise: revert the walk_page_range_vma change for MADV_GUARD_INSTALL
Date: Mon, 9 Jun 2025 22:42:13 +1200

Fix the broken MADV_GUARD_INSTALL reported by Ryan.
 # guard-regions.c:719:split_merge:Expected madvise(ptr, 10 * page_size,
 MADV_GUARD_INSTALL) (-1) == 0 (0)

Link: https://lkml.kernel.org/r/20250609105513.10901-1-21cnbao@gmail.com
Closes: https://lore.kernel.org/linux-mm/671f8164-a90b-48d7-9446-359eb9493500@arm.com/
Signed-off-by: Barry Song <v-songbaohua@oppo.com>
Reported-by: Ryan Roberts <ryan.roberts@arm.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Harry Yoo <harry.yoo@oracle.com>
Cc: Jann Horn <jannh@google.com>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: Lokesh Gidra <lokeshgidra@google.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Tangquan Zheng <zhengtangquan@oppo.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/madvise.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/madvise.c~mm-madvise-use-walk_page_range_vma-instead-of-walk_page_range-fix
+++ a/mm/madvise.c
@@ -1162,7 +1162,7 @@ static long madvise_guard_install(struct
 		unsigned long nr_pages = 0;
 
 		/* Returns < 0 on error, == 0 if success, > 0 if zap needed. */
-		err = walk_page_range_vma(vma, start, end,
+		err = walk_page_range_mm(vma->vm_mm, start, end,
 					 &guard_install_walk_ops, &nr_pages);
 		if (err < 0)
 			return err;
_

Patches currently in -mm which might be from v-songbaohua@oppo.com are

mm-madvise-use-walk_page_range_vma-instead-of-walk_page_range.patch
mm-use-per_vma-lock-for-madv_dontneed.patch
mm-madvise-use-per_vma-lock-for-madv_free.patch

