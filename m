Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EBA1B667
	for <mm-commits@vger.kernel.org>; Sat, 15 Mar 2025 01:03:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742000605; cv=none; b=TxJ8N5Ba24MT/9Kx7obKNoTm/DlHiLd0YpU5aalmllS0Lo2nXf/R5//LsP9Ph5ndmUFMWwuG2ci1q0i8LHOagvcW3erGrmWhnN8ie5QmSjvFWwLRfzDOYEBnNdMaNsUjZBoAfbsTTLvoZld6T8253CWi053neMp7OLqTHls67gA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742000605; c=relaxed/simple;
	bh=J6onVrhqR7KeiH0PvjXy3DpnzMqcs2lXQKQwiKO9B24=;
	h=Date:To:From:Subject:Message-Id; b=KM9pwauNe2HXhLWrafcUXMKNcwRjLSf/rNwHuSUhUvg1DnUE5SbbKnVYWJQl3zOMrY+vKGp81IIU0xT44e5f6wgUgiNT1E/lc+HXNnpo5JYCfn/YOtOH8OvSjBMgv+xGfjnsNMxOvdFOVf6uJuhZcFr6kT+pjdKyqqeDtHGaDMc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=pFqh3p6p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="pFqh3p6p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1F7BC4CEE3;
	Sat, 15 Mar 2025 01:03:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742000604;
	bh=J6onVrhqR7KeiH0PvjXy3DpnzMqcs2lXQKQwiKO9B24=;
	h=Date:To:From:Subject:From;
	b=pFqh3p6pFkwlnvQ3Dgz35axCpQl16KkQ5a5TPQjIC3nlY9KaR4Forq/d5d9QRZQVQ
	 VY1xJ4ayGrZkrbM6xjRSsoN5dbpckXYsPRKH//LJRKwboEQv/h+uz/tgRV+04+iKFe
	 hLnKSXr0lRfZm7TA8LniJrdcRmVtcyVwX7PsU0mA=
Date: Fri, 14 Mar 2025 18:03:24 -0700
To: mm-commits@vger.kernel.org,wei.liu@kernel.org,sstabellini@kernel.org,shakeel.butt@linux.dev,roman.gushchin@linux.dev,oleksandr_tyshchenko@epam.com,nphamcs@gmail.com,muchun.song@linux.dev,mst@redhat.com,mhocko@kernel.org,kys@microsoft.com,kanchana.p.sridhar@intel.com,jgross@suse.com,hannes@cmpxchg.org,haiyangz@microsoft.com,decui@microsoft.com,david@redhat.com,chengming.zhou@linux.dev,alexander.atanasov@virtuozzo.com,npache@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + balloon_compaction-update-the-nr_balloon_pages-state.patch added to mm-unstable branch
Message-Id: <20250315010324.B1F7BC4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: balloon_compaction: update the NR_BALLOON_PAGES state
has been added to the -mm mm-unstable branch.  Its filename is
     balloon_compaction-update-the-nr_balloon_pages-state.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/balloon_compaction-update-the-nr_balloon_pages-state.patch

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

meminfo-add-a-per-node-counter-for-balloon-drivers.patch
balloon_compaction-update-the-nr_balloon_pages-state.patch
hv_balloon-update-the-nr_balloon_pages-state.patch
xen-balloon-update-the-nr_balloon_pages-state.patch

