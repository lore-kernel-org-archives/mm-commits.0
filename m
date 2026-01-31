Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4854A20CCDC
	for <mm-commits@vger.kernel.org>; Sat, 31 Jan 2026 22:24:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769898241; cv=none; b=L8v4C+jmjELZjAsxJ3L2z0i+Us7SIy9dGkkiqc7psqazI4X7vC/ismwjRHKX+6tFaSVdNSAbaq+yTF70uTZem1YlrGvMP69DDfNwqh6ZrAXHKjAt86aSNyhSDLouna81/Azkan16FcCrhpLQjmG9rWF9aBOTG17TO/FBzMbm0bA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769898241; c=relaxed/simple;
	bh=RuXpQ5Obwy89HCYfNUjCUSc6g1hw8JkLwmSYPZduCb4=;
	h=Date:To:From:Subject:Message-Id; b=uWPYj2chTIMqqmJpLu1PfbTHSgmZp8xF3tVDdsnMbx1sVzqdHccoag5JGDZvtx+DzBWhFkZ7blcSFTPM+REv2tzWOzJzcyLoHutAtFY+Ml/1vlqsUWUuGsaY5GMZVpjdPSqXwF5tX7Itnfx4ackihIVfvcUfGPd1Ejxjv0KT2jk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=WisQQtOd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="WisQQtOd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03E95C116D0;
	Sat, 31 Jan 2026 22:24:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769898241;
	bh=RuXpQ5Obwy89HCYfNUjCUSc6g1hw8JkLwmSYPZduCb4=;
	h=Date:To:From:Subject:From;
	b=WisQQtOdhUdomLO15TIy6eaXZuU+TSVwVg5BB3iLz+qFW48B9RUfndZvzcz2ulMk5
	 PiCwGOBEUN51H6JNU9K4HxXCd09d6T6lufXxh7Au9rsHzL5vXsNYcUqld7qr710I12
	 98NUoAKKbLJjRc3Az8PM8eFLPGaRe7/Lg/+OJWwg=
Date: Sat, 31 Jan 2026 14:24:00 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,xuanzhuo@linux.alibaba.com,vbabka@suse.cz,surenb@google.com,sj@kernel.org,rppt@kernel.org,osalvador@suse.de,npiggin@gmail.com,mst@redhat.com,mpe@ellerman.id.au,mhocko@suse.com,maddy@linux.ibm.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,jerrin.shaji-george@broadcom.com,jasowang@redhat.com,gregkh@linuxfoundation.org,eperezma@redhat.com,corbet@lwn.net,christophe.leroy@csgroup.eu,arnd@arndb.de,david@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] vmw_balloon-adjust-balloon_deflate-when-deflating-while-migrating.patch removed from -mm tree
Message-Id: <20260131222401.03E95C116D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: vmw_balloon: adjust BALLOON_DEFLATE when deflating while migrating
has been removed from the -mm tree.  Its filename was
     vmw_balloon-adjust-balloon_deflate-when-deflating-while-migrating.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Subject: vmw_balloon: adjust BALLOON_DEFLATE when deflating while migrating
Date: Tue, 20 Jan 2026 00:01:09 +0100

Patch series "mm: balloon infrastructure cleanups", v3.

I started with wanting to remove the dependency of the balloon
infrastructure on the page lock, but ended up performing various other
cleanups, some of which I had on my todo list for years.

This series heavily cleans up and simplifies our balloon infrastructure,
including our balloon page migration functionality.

With this series, we no longer make use of the page lock for PageOffline
pages as part of the balloon infrastructure (preparing for memdescs where
PageOffline pages won't have any such lock), and simplifies migration
handling such that refcounting can more easily be adjusted later
(long-term focus is for PageOffline pages to not have a refcount either).

Plenty of related cleanups.


This patch (of 24):

When we're effectively deflating the balloon while migrating a page
because inflating the new page failed, we're not adjusting
BALLOON_DEFLATE.

Let's do that.  This is a preparation for factoring out this handling to
the core code, making it work in a similar way first.

As this (deflating while migrating because of inflation error) is a corner
case that I don't really expect to happen in practice and the stats are
not that crucial, this likely doesn't classify as a fix.

Link: https://lkml.kernel.org/r/20260119230133.3551867-1-david@kernel.org
Link: https://lkml.kernel.org/r/20260119230133.3551867-2-david@kernel.org
Signed-off-by: David Hildenbrand (Red Hat) <david@kernel.org>
Reviewed-by: SeongJae Park <sj@kernel.org>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Acked-by: Michael S. Tsirkin <mst@redhat.com
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Eugenio Pérez <eperezma@redhat.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jason Wang <jasowang@redhat.com>
Cc: Jerrin Shaji George <jerrin.shaji-george@broadcom.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/vmw_balloon.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/misc/vmw_balloon.c~vmw_balloon-adjust-balloon_deflate-when-deflating-while-migrating
+++ a/drivers/misc/vmw_balloon.c
@@ -1818,6 +1818,8 @@ static int vmballoon_migratepage(struct
 	if (status == VMW_BALLOON_SUCCESS) {
 		balloon_page_insert(&b->b_dev_info, newpage);
 		__count_vm_event(BALLOON_MIGRATE);
+	} else {
+		__count_vm_event(BALLOON_DEFLATE);
 	}
 
 	/*
_

Patches currently in -mm which might be from david@kernel.org are

mm-move-pte-table-reclaim-code-to-memoryc.patch
mm-memory-handle-non-split-locks-correctly-in-zap_empty_pte_table.patch

