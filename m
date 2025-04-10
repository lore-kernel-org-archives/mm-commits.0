Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10FBA25634
	for <mm-commits@vger.kernel.org>; Thu, 10 Apr 2025 23:49:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744328994; cv=none; b=AWhvv4vdIXDfXk5o9DaKw3S8+nnoR7AcxBxvtAPYv0KdpbSyREiyytQ7D4xrI/JpCgK9EiBXat3Dmr+4QRBI9QPQjYln77VgoIKRZWHekOmbrcP/RtZfWsua4wx4ezyI8GJQLT4228mCgvBm4uBMOuqeKbsRohZi/zhPyXj9xpM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744328994; c=relaxed/simple;
	bh=807ZA+UU8Uf4qE96jk4CizVhN5A8rz/48Di4RGCoduM=;
	h=Date:To:From:Subject:Message-Id; b=MUB7dzJnC0CY/2W+9I9sooo95QoWuPnXyxuBJzQtVv440aPwAGLWE+ngQDqMcpoYmLOou2GofUpApx0NqKWW3VVXo+41PH90h4qUxyFi+IHNnPXhrSMjvxrq8Bx8r2AOt/pG45wGgT8sXoKlPdTC7vnfWZS/87MXl3fjUFSXX3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=O2O3xRpP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="O2O3xRpP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA43BC4CEE7;
	Thu, 10 Apr 2025 23:49:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1744328993;
	bh=807ZA+UU8Uf4qE96jk4CizVhN5A8rz/48Di4RGCoduM=;
	h=Date:To:From:Subject:From;
	b=O2O3xRpPrz5rqxEeAyEH9H4k5W/czHqv6VXJEJBgzRhvKn1p9+YXv2j9MyQuBHWfZ
	 7v4CZ4PDAlu1RQ9bH9g/3STq/qnIy/I+PFvStHZf1ZA/SZJG0nn5j2kXsthvz8Vtri
	 EQknC2s9poo93QSXc3w323ocg4HfLYzb0MhyQlE4=
Date: Thu, 10 Apr 2025 16:49:53 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,surenb@google.com,roman.gushchin@linux.dev,rientjes@google.com,penberg@kernel.org,mhocko@suse.com,jackmanb@google.com,iamjoonsoo.kim@lge.com,harry.yoo@oracle.com,hannes@cmpxchg.org,cl@linux.com,vbabka@suse.cz,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maintainers-update-slab-allocator-maintainers.patch added to mm-hotfixes-unstable branch
Message-Id: <20250410234953.CA43BC4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: MAINTAINERS: update SLAB ALLOCATOR maintainers
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     maintainers-update-slab-allocator-maintainers.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maintainers-update-slab-allocator-maintainers.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Vlastimil Babka <vbabka@suse.cz>
Subject: MAINTAINERS: update SLAB ALLOCATOR maintainers
Date: Thu, 10 Apr 2025 11:00:22 +0200

With permission, reduce the number of maintainers.  Create a CREDITS entry
for Joonsoo (Pekka already has one).  Thanks for all the work!

Link: https://lkml.kernel.org/r/20250410090021.72296-3-vbabka@suse.cz
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Harry Yoo <harry.yoo@oracle.com>
Acked-by: Christoph Lameter (Ampere) <cl@linux.com>
Acked-by: David Rientjes <rientjes@google.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 CREDITS     |    4 ++++
 MAINTAINERS |    2 --
 2 files changed, 4 insertions(+), 2 deletions(-)

--- a/CREDITS~maintainers-update-slab-allocator-maintainers
+++ a/CREDITS
@@ -2071,6 +2071,10 @@ S: 660 Harvard Ave. #7
 S: Santa Clara, CA 95051
 S: USA
 
+N: Joonsoo Kim
+E: iamjoonsoo.kim@lge.com
+D: Slab allocators
+
 N: Kukjin Kim
 E: kgene@kernel.org
 D: Samsung S3C, S5P and Exynos ARM architectures
--- a/MAINTAINERS~maintainers-update-slab-allocator-maintainers
+++ a/MAINTAINERS
@@ -22240,9 +22240,7 @@ F:	drivers/nvmem/layouts/sl28vpd.c
 
 SLAB ALLOCATOR
 M:	Christoph Lameter <cl@linux.com>
-M:	Pekka Enberg <penberg@kernel.org>
 M:	David Rientjes <rientjes@google.com>
-M:	Joonsoo Kim <iamjoonsoo.kim@lge.com>
 M:	Andrew Morton <akpm@linux-foundation.org>
 M:	Vlastimil Babka <vbabka@suse.cz>
 R:	Roman Gushchin <roman.gushchin@linux.dev>
_

Patches currently in -mm which might be from vbabka@suse.cz are

maintainers-update-slab-allocator-maintainers.patch
maintainers-add-mm-subsection-for-the-page-allocator.patch
memcg-combine-slab-obj-stock-charging-and-accounting.patch

