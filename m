Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74F011FBEA2
	for <mm-commits@vger.kernel.org>; Thu, 27 Nov 2025 22:27:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764282448; cv=none; b=oXwHKMb0IZeST9Dm7Azl+Vl/ddGMC2FOpjXhlJxqn/t3u8LlKiAWpwg/6+3FiyoP6wC60jIiUDV+yupM+FjZItLjnaNoE9zzxNjWMf8wKS500MopNfTPIwXYG2wijfqIw+Tj59LzM0gOhvS+H+NfzjafEw/K4Kj5a5OePJrXues=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764282448; c=relaxed/simple;
	bh=gpqfhmxubkKIUBM6WXPrkEbpbj2jgBZay/kpwaJEwcM=;
	h=Date:To:From:Subject:Message-Id; b=tz7YTORRstuUvSIYAAOqnALpUwKezI612JYPx/eJXS2FtK6oTM+7OX95GF0mN/0LUl97TtCKLV3dIZX4XqEfL0kq7zlW++jN5RU0N8B6j9a06WanaekLM7s5fxWYLfo6sGlHsFdTSsGPTHOXOcULEL0R8/vKsZSg1EGq+63U5BA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=kU1OM/ME; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="kU1OM/ME"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49EAAC4CEF8;
	Thu, 27 Nov 2025 22:27:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1764282448;
	bh=gpqfhmxubkKIUBM6WXPrkEbpbj2jgBZay/kpwaJEwcM=;
	h=Date:To:From:Subject:From;
	b=kU1OM/MED9CqLqB0l+ebXBuOMYxupw2K1o6Pv0/Y4h0rAA4YMzzS8gEB7fZWYyCwX
	 bf2soH1WF5/1rNU75MKIFHE1XsdEobqSZ05gRiYAylY92+Y0IDCV1OpNKpsEEF/ckm
	 Fgj34BL+ZRV0qP6FaN8nw/Uk79Nj//zXro9ISsJs=
Date: Thu, 27 Nov 2025 14:27:27 -0800
To: mm-commits@vger.kernel.org,nadav.amit@gmail.com,huang.ying.caritas@gmail.com,david@kernel.org,bhe@redhat.com,andriy.shevchenko@linux.intel.com,ilstam@amazon.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] reinstate-resource-avoid-unnecessary-lookups-in-find_next_iomem_res.patch removed from -mm tree
Message-Id: <20251127222728.49EAAC4CEF8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: Reinstate "resource: avoid unnecessary lookups in find_next_iomem_res()"
has been removed from the -mm tree.  Its filename was
     reinstate-resource-avoid-unnecessary-lookups-in-find_next_iomem_res.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ilias Stamatis <ilstam@amazon.com>
Subject: Reinstate "resource: avoid unnecessary lookups in find_next_iomem_res()"
Date: Mon, 24 Nov 2025 16:53:49 +0000

Commit 97523a4edb7b ("kernel/resource: remove first_lvl / siblings_only
logic") removed an optimization introduced by commit 756398750e11
("resource: avoid unnecessary lookups in find_next_iomem_res()").  That
was not called out in the message of the first commit explicitly so it's
not entirely clear whether removing the optimization happened
inadvertently or not.

As the original commit message of the optimization explains there is no
point considering the children of a subtree in find_next_iomem_res() if
the top level range does not match.

Reinstating the optimization results in performance improvements in
systems where /proc/iomem is ~5k lines long.  Calling mmap() on /dev/mem
in such platforms takes 700-1500μs without the optimisation and 10-50μs
with the optimisation.

Note that even though commit 97523a4edb7b removed the 'sibling_only'
parameter from next_resource(), newer kernels have basically reinstated it
under the name 'skip_children'.

Link: https://lore.kernel.org/all/20251124165349.3377826-1-ilstam@amazon.com/T/#u
Fixes: 97523a4edb7b ("kernel/resource: remove first_lvl / siblings_only logic")
Signed-off-by: Ilias Stamatis <ilstam@amazon.com>
Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
Cc: Andriy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: "Huang, Ying" <huang.ying.caritas@gmail.com>
Cc: Nadav Amit <nadav.amit@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/resource.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- a/kernel/resource.c~reinstate-resource-avoid-unnecessary-lookups-in-find_next_iomem_res
+++ a/kernel/resource.c
@@ -341,6 +341,8 @@ static int find_next_iomem_res(resource_
 			       unsigned long flags, unsigned long desc,
 			       struct resource *res)
 {
+	/* Skip children until we find a top level range that matches */
+	bool skip_children = true;
 	struct resource *p;
 
 	if (!res)
@@ -351,7 +353,7 @@ static int find_next_iomem_res(resource_
 
 	read_lock(&resource_lock);
 
-	for_each_resource(&iomem_resource, p, false) {
+	for_each_resource(&iomem_resource, p, skip_children) {
 		/* If we passed the resource we are looking for, stop */
 		if (p->start > end) {
 			p = NULL;
@@ -362,6 +364,12 @@ static int find_next_iomem_res(resource_
 		if (p->end < start)
 			continue;
 
+		/*
+		 * We found a top level range that matches what we are looking
+		 * for. Time to start checking children too.
+		 */
+		skip_children = false;
+
 		/* Found a match, break */
 		if (is_type_match(p, flags, desc))
 			break;
_

Patches currently in -mm which might be from ilstam@amazon.com are


