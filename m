Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2D6E12F399
	for <mm-commits@vger.kernel.org>; Sat, 22 Mar 2025 05:03:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742619839; cv=none; b=P0t3DhutKwGaYFa4wE5qYvUmtdvUnkRvUlUDadb5wLChj8YQNZb7i/aNoGJizbkqycjNMwBRf4zF7xIrJVf79K6rT/T4xXkb6c+YMAo+yAk6+Ed9bg8RgAOzkbrUCbg/WK7huJBb5ft2IRLnF3IC6ktrspQZmnWcYFbXqT+AcDQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742619839; c=relaxed/simple;
	bh=2OgTyqYY3DnUYbrdwrg6F8+lBUEG41Ebv2L5t2N2fGM=;
	h=Date:To:From:Subject:Message-Id; b=Vk7rhL9NunLo1HEYNfSRuNFaeIYTn+YOetvDhJh3TjOSzEBj6M3R+KwmTAJYjmsvawthgkqXjzo+b8Wirt48iY5u2QLccUsQ0CofKdQhEKf1qVwqe4+azNiRAO1d7Xv2P4jxRgieYAXnFt/m2sVARUHLRwJCDOF2kt68VSWScos=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=bW24d3Hw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="bW24d3Hw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CB7DC4CEDD;
	Sat, 22 Mar 2025 05:03:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742619839;
	bh=2OgTyqYY3DnUYbrdwrg6F8+lBUEG41Ebv2L5t2N2fGM=;
	h=Date:To:From:Subject:From;
	b=bW24d3HwOqwcsKq+JMJIDzb9ZTpicj5yuIcNpVfwzT1PUA55pBcMXnlzCo6GaWgZy
	 Z0lA90m0oT84MzxkbzQkIujRQsr+urTZDkEDE4rBxrwMj2ftAzYNmcYlN5JaVnMr4X
	 kHG1vaB6UKsJ8QzOkQOo/IZX4QV/hdztyVOJuzDg=
Date: Fri, 21 Mar 2025 22:03:58 -0700
To: mm-commits@vger.kernel.org,wei.liu@kernel.org,sstabellini@kernel.org,shakeel.butt@linux.dev,roman.gushchin@linux.dev,oleksandr_tyshchenko@epam.com,nphamcs@gmail.com,muchun.song@linux.dev,mst@redhat.com,mhocko@kernel.org,mhklinux@outlook.com,kys@microsoft.com,kanchana.p.sridhar@intel.com,jgross@suse.com,hannes@cmpxchg.org,haiyangz@microsoft.com,decui@microsoft.com,david@redhat.com,chengming.zhou@linux.dev,alexander.atanasov@virtuozzo.com,npache@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] balloon_compaction-update-the-nr_balloon_pages-state.patch removed from -mm tree
Message-Id: <20250322050359.1CB7DC4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: balloon_compaction: update the NR_BALLOON_PAGES state
has been removed from the -mm tree.  Its filename was
     balloon_compaction-update-the-nr_balloon_pages-state.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Nico Pache <npache@redhat.com>
Subject: balloon_compaction: update the NR_BALLOON_PAGES state
Date: Fri, 14 Mar 2025 15:37:55 -0600

Update the NR_BALLOON_PAGES counter when pages are added or removed using
the balloon compaction interface.

The virtio, Vmware, and pseries-cmm balloon drivers utilize the
balloon_compaction interface to allocate and free balloon pages.  Other
balloon drivers will have to maintain this counter manually.

Link: https://lkml.kernel.org/r/20250314213757.244258-3-npache@redhat.com
Signed-off-by: Nico Pache <npache@redhat.com>
Cc: Alexander Atanasov <alexander.atanasov@virtuozzo.com>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: David Hildenbrand <david@redhat.com>
Cc: Dexuan Cui <decui@microsoft.com>
Cc: Haiyang Zhang <haiyangz@microsoft.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Juegren Gross <jgross@suse.com>
Cc: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
Cc: K. Y. Srinivasan <kys@microsoft.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Stefano Stabellini <sstabellini@kernel.org>
Cc: Wei Liu <wei.liu@kernel.org>
Cc: Michael Kelley <mhklinux@outlook.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/balloon_compaction.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/balloon_compaction.c~balloon_compaction-update-the-nr_balloon_pages-state
+++ a/mm/balloon_compaction.c
@@ -24,6 +24,7 @@ static void balloon_page_enqueue_one(str
 	balloon_page_insert(b_dev_info, page);
 	unlock_page(page);
 	__count_vm_event(BALLOON_INFLATE);
+	inc_node_page_state(page, NR_BALLOON_PAGES);
 }
 
 /**
@@ -103,6 +104,7 @@ size_t balloon_page_list_dequeue(struct
 		__count_vm_event(BALLOON_DEFLATE);
 		list_add(&page->lru, pages);
 		unlock_page(page);
+		dec_node_page_state(page, NR_BALLOON_PAGES);
 		n_pages++;
 	}
 	spin_unlock_irqrestore(&b_dev_info->pages_lock, flags);
_

Patches currently in -mm which might be from npache@redhat.com are


