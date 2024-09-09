Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0066E18E375
	for <mm-commits@vger.kernel.org>; Mon,  9 Sep 2024 23:42:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725925325; cv=none; b=tRlXpZbepOea6/b0gom5uuS3RPGnIliEeGl0HBhnHea5wCbl8l1bjQ3EIOnY6pKmFG09/rxBWZzulO1Xy7zyiCT0LnnPhIJUqySpEAGZm237iBk3sLbh/LX+oqSjLUqAs/bXOG0FDdS/m0r+DYFWW+p34LYuVz6y07lpE/NAr9s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725925325; c=relaxed/simple;
	bh=PGIcbQiv+FbsBcOLflFsW83KPSRIdJekuvHL17zroI4=;
	h=Date:To:From:Subject:Message-Id; b=jxWc6vNAcRNSh4RVb7wJY14rGNW4qrEHOU6eI82ybMh7q6ruqGL8EnbOmLjiOpNnMWLE8fQ7mIF0XpPvBoaLFNXLUKvLgfZivMk5bLiCWs25EjcF/TXc6XIx/AWxvre8NExhXCz3RHuaog1d08GkAwJyB8mz8eWrtm1TPUnF9oM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0xtGIJnE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0xtGIJnE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAF26C4CEC5;
	Mon,  9 Sep 2024 23:42:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725925324;
	bh=PGIcbQiv+FbsBcOLflFsW83KPSRIdJekuvHL17zroI4=;
	h=Date:To:From:Subject:From;
	b=0xtGIJnEWWwsuM5gVqahQ1/z9PzgQ7/BxXpy4DQOZXquxkAPR5rw9ZxuS63Nt+2vz
	 SOTPbirKtz84k56768pW46Kk7X4dlTIVKZFUrKe3HwB6sbmmWO8FVclA/xETHAZB98
	 1Cm332DFJM3MZb31lEB/rh5nYX1eKTp63Eh76c0s=
Date: Mon, 09 Sep 2024 16:42:04 -0700
To: mm-commits@vger.kernel.org,oleksiy.avramchenko@sony.com,mhocko@suse.com,hch@infradead.org,bhe@redhat.com,urezki@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-vmallocc-use-high-order-in-description-non-0-order-pages.patch removed from -mm tree
Message-Id: <20240909234204.CAF26C4CEC5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/vmalloc.c: use "high-order" in description non 0-order pages
has been removed from the -mm tree.  Its filename was
     mm-vmallocc-use-high-order-in-description-non-0-order-pages.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Subject: mm/vmalloc.c: use "high-order" in description non 0-order pages
Date: Fri, 6 Sep 2024 11:50:49 +0200

In many places, in the comments, we use both "higher-order" and
"high-order" to describe the non 0-order pages.  That is confusing,
because a "higher-order" statement does not reflect what it is compared
with.

Link: https://lkml.kernel.org/r/20240906095049.3486-1-urezki@gmail.com
Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Suggested-by: Baoquan He <bhe@redhat.com>
Reviewed-by: Baoquan He <bhe@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Oleksiy Avramchenko <oleksiy.avramchenko@sony.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/vmalloc.c~mm-vmallocc-use-high-order-in-description-non-0-order-pages
+++ a/mm/vmalloc.c
@@ -3570,7 +3570,7 @@ vm_area_alloc_pages(gfp_t gfp, int nid,
 			break;
 
 		/*
-		 * Higher order allocations must be able to be treated as
+		 * High-order allocations must be able to be treated as
 		 * independent small pages by callers (as they can with
 		 * small-page vmallocs). Some drivers do their own refcounting
 		 * on vmalloc_to_page() pages, some use page->mapping,
@@ -3633,7 +3633,7 @@ static void *__vmalloc_area_node(struct
 	page_order = vm_area_page_order(area);
 
 	/*
-	 * Higher order nofail allocations are really expensive and
+	 * High-order nofail allocations are really expensive and
 	 * potentially dangerous (pre-mature OOM, disruptive reclaim
 	 * and compaction etc.
 	 *
_

Patches currently in -mm which might be from urezki@gmail.com are


