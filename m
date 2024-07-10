Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6A0819347B
	for <mm-commits@vger.kernel.org>; Wed, 10 Jul 2024 19:04:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720638274; cv=none; b=B9Koaz7U8RmbYIWO51JmW7T3T3JZkHt9xmumPR6X/wGdpKINxWD8QS2YOx4jB4uePZF6fPfLAxjgVwF/YjY4NrWi0VgpxQo3kjwOXf3aEIPslKLqh5E78QLBfZlMKomy3rGcGLD4BSW1hCUH4xcDGT75WQLGOSnW6N/D4GmJJz8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720638274; c=relaxed/simple;
	bh=i4jwMO2TrUixwU8mCIAi0xEOeqF00GUVNFHTbkDNMdg=;
	h=Date:To:From:Subject:Message-Id; b=mMtZ0x0RDgkSRLzKkvkNdFYyNZIpDeM0ey3Eug3oY7q+pfjNsQMkS6lKa9rYjEqxAH5hjB46DjDmawtiZROTljmE1843I247WopkLzJobDOTYtXz1Xf9V8tA7uPx+uUrO3OrR0LynKurpPkTxKZ0ifdcu88/7uRQuB3Omk1JspI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=OpYFVVDW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="OpYFVVDW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CDF6C32781;
	Wed, 10 Jul 2024 19:04:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1720638274;
	bh=i4jwMO2TrUixwU8mCIAi0xEOeqF00GUVNFHTbkDNMdg=;
	h=Date:To:From:Subject:From;
	b=OpYFVVDWOLyx4ToeaaLDCIO7kzyCjkGF5WV/U79wVx6RK04M6Xt6a2k4fInx6C85X
	 5DEEPXm0BSPRGWE9byqalWMko6d6YEdi3PBVDXhmsT6jYCUMqvVWYQMHQog2/Q/zNy
	 grQUWtoENdOtjxyNUjdvJBS2/iqGyDas6+bZjgGc=
Date: Wed, 10 Jul 2024 12:04:33 -0700
To: mm-commits@vger.kernel.org,yosryahmed@google.com,ying.huang@intel.com,willy@infradead.org,shakeel.butt@linux.dev,oliver.sang@intel.com,nphamcs@gmail.com,hughd@google.com,hannes@cmpxchg.org,david@redhat.com,chengming.zhou@linux.dev,ak@linux.intel.com,usamaarif642@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-set-p-zeromap-to-null-after-freeing-it.patch added to mm-unstable branch
Message-Id: <20240710190434.6CDF6C32781@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: set p->zeromap to NULL after freeing it
has been added to the -mm mm-unstable branch.  Its filename is
     mm-set-p-zeromap-to-null-after-freeing-it.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-set-p-zeromap-to-null-after-freeing-it.patch

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
From: Usama Arif <usamaarif642@gmail.com>
Subject: mm: set p->zeromap to NULL after freeing it
Date: Wed Jul 10 18:37:57 2024 +0100

alloc_swap_info can reuse swap_info_struct from previously used swap. 
Reset p->zeromap to NULL so that its not set to a corrupted pointer from
previous swap.

Signed-off-by: Usama Arif <usamaarif642@gmail.com>
Reported-by: kernel test robot <oliver.sang@intel.com>
Closes: https://lore.kernel.org/oe-lkp/202407101031.c6c3c651-lkp@intel.com
Cc: Hugh Dickins <hughd@google.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: David Hildenbrand <david@redhat.com>
Cc: Huang Ying <ying.huang@intel.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/swapfile.c~mm-set-p-zeromap-to-null-after-freeing-it
+++ a/mm/swapfile.c
@@ -2654,6 +2654,7 @@ SYSCALL_DEFINE1(swapoff, const char __us
 	p->cluster_next_cpu = NULL;
 	vfree(swap_map);
 	kvfree(p->zeromap);
+	p->zeromap = NULL;
 	kvfree(cluster_info);
 	/* Destroy swap account information */
 	swap_cgroup_swapoff(p->type);
@@ -3346,6 +3347,7 @@ bad_swap:
 	spin_unlock(&swap_lock);
 	vfree(swap_map);
 	kvfree(p->zeromap);
+	p->zeromap = NULL;
 	kvfree(cluster_info);
 	if (inced_nr_rotate_swap)
 		atomic_dec(&nr_rotate_swap);
_

Patches currently in -mm which might be from usamaarif642@gmail.com are

mm-set-p-zeromap-to-null-after-freeing-it.patch

