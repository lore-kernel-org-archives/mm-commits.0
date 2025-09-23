Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D8161DFDE
	for <mm-commits@vger.kernel.org>; Tue, 23 Sep 2025 03:18:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758597508; cv=none; b=r7nse6OsY4HTASWJ2t8HAA8Jp5vehkqysZhOBuzvu/XyibbrIalItWjVwhHql7wLXW5yofGQbyswn2N+Q+3R3VmNon++6ZiLFz+Lx3uMBM2tK4GQMRO0rTHMPeCzp7+B3oItCLWspLit2522V9fQTcize16qmb2OWvCT6a2mV3Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758597508; c=relaxed/simple;
	bh=vyzPMmxcmkjPhpj4ipn6jcr7QZQDzOPcbvebOvyC50E=;
	h=Date:To:From:Subject:Message-Id; b=C0D+pZVck2PJaE/H4hNH2CEmQHn23Up0nH64WGP1UkwXcEFK1s5EtlOlqfR/AY5FraPVyFezQY5TsaZCGyd8MisYQjDVE3NJB3z1z92FiJTG7qAUWMXhPF5Xjxx1MrVzq8LYph553Oohqwn4HcxbvfKwP26YGfARHV5UaYM5FM0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=WNN7/qYK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="WNN7/qYK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5CD7C4CEF0;
	Tue, 23 Sep 2025 03:18:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758597507;
	bh=vyzPMmxcmkjPhpj4ipn6jcr7QZQDzOPcbvebOvyC50E=;
	h=Date:To:From:Subject:From;
	b=WNN7/qYKYQl+n8wnzEUfTLqECqaGCV2c29pTDSsG8h9hziCQLUUCpZn1H9pBWjm92
	 ZowlHQhyYQw4+ebmqyFLCGXQOS7UDL0+yVWRPJrRFKfzcBpYxK1DZPmUgmztF8PLRc
	 da4A3Td41VX3Y4V6zht+VcrqmJ8JTuushT3Am+7A=
Date: Mon, 22 Sep 2025 20:18:27 -0700
To: mm-commits@vger.kernel.org,mhocko@kernel.org,bhe@redhat.com,urezki@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-vmalloc-move-resched-point-into-alloc_vmap_area.patch removed from -mm tree
Message-Id: <20250923031827.D5CD7C4CEF0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/vmalloc: move resched point into alloc_vmap_area()
has been removed from the -mm tree.  Its filename was
     mm-vmalloc-move-resched-point-into-alloc_vmap_area.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Subject: mm/vmalloc: move resched point into alloc_vmap_area()
Date: Wed, 17 Sep 2025 20:59:06 +0200

Currently vm_area_alloc_pages() contains two cond_resched() points. 
However, the page allocator already has its own in slow path so an extra
resched is not optimal because it delays the loops.

The place where CPU time can be consumed is in the VA-space search in
alloc_vmap_area(), especially if the space is really fragmented using
synthetic stress tests, after a fast path falls back to a slow one.

Move a single cond_resched() there, after dropping free_vmap_area_lock in
a slow path.  This keeps fairness where it matters while removing
redundant yields from the page-allocation path.

[akpm@linux-foundation.org: tweak comment grammar]
Link: https://lkml.kernel.org/r/20250917185906.1595454-1-urezki@gmail.com
Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Michal Hocko <mhocko@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/mm/vmalloc.c~mm-vmalloc-move-resched-point-into-alloc_vmap_area
+++ a/mm/vmalloc.c
@@ -2057,6 +2057,12 @@ retry:
 		addr = __alloc_vmap_area(&free_vmap_area_root, &free_vmap_area_list,
 			size, align, vstart, vend);
 		spin_unlock(&free_vmap_area_lock);
+
+		/*
+		 * This is not a fast path.  Check if yielding is needed. This
+		 * is the only reschedule point in the vmalloc() path.
+		 */
+		cond_resched();
 	}
 
 	trace_alloc_vmap_area(addr, size, align, vstart, vend, IS_ERR_VALUE(addr));
@@ -3622,7 +3628,6 @@ vm_area_alloc_pages(gfp_t gfp, int nid,
 							pages + nr_allocated);
 
 			nr_allocated += nr;
-			cond_resched();
 
 			/*
 			 * If zero or pages were obtained partly,
@@ -3664,7 +3669,6 @@ vm_area_alloc_pages(gfp_t gfp, int nid,
 		for (i = 0; i < (1U << order); i++)
 			pages[nr_allocated + i] = page + i;
 
-		cond_resched();
 		nr_allocated += 1U << order;
 	}
 
_

Patches currently in -mm which might be from urezki@gmail.com are


