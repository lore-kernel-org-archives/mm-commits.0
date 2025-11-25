Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3D4B15ECD7
	for <mm-commits@vger.kernel.org>; Tue, 25 Nov 2025 17:52:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764093135; cv=none; b=qmjPhpjun+4+J3RfoUiKMhJxjOiiys1tdnVVbLeFtZj+zrCzpHYyXTkMqV7a/EGKQ4Q4+0JtceDcZgUyu46kePJTPjFRNcnJbbJ+4gahz69IyAj8AhPOmXpElofHdNMVJK5E6kMUw4RlhdrEMQMp0pAgx2d12ff3d/oyj9ji5Xk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764093135; c=relaxed/simple;
	bh=8GY9YkKsljvkoprsO63aJVWAOTseHQUJqHnVedBX9Hw=;
	h=Date:To:From:Subject:Message-Id; b=KzbpVsulezqtRw3UvL82PL/SJeGA5+55XetxNThXWO1FgF2pj162+opKFSIDLSy/nDXWvgpu3fa3Qnc1R6c8aV5asCqLuQebqDjy+uDqO/6wXljHJwJx42WUeTSxK5jh2EmM0OjNiJXWjYm9Bxmn1ldHzwnHNQrCuUpVPlA0VFc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=YUrIzuKV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="YUrIzuKV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 310F4C4CEF1;
	Tue, 25 Nov 2025 17:52:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1764093135;
	bh=8GY9YkKsljvkoprsO63aJVWAOTseHQUJqHnVedBX9Hw=;
	h=Date:To:From:Subject:From;
	b=YUrIzuKVaBhqOeKJk5AMVSntnBvozpCnw3swRk/gpp4hWnT8zYr/k7wbUm13ifj2H
	 JPtTBOyqVCmzxRqT4qJCqM1POSprH2ZK1rf7KhWzrKImWSDbiwh4HxZCXf2haAUo33
	 A4OHRcIEUe2PS2nSLEV4ZjcHiEiSGhmmywnsq0Is=
Date: Tue, 25 Nov 2025 09:52:14 -0800
To: mm-commits@vger.kernel.org,nadav.amit@gmail.com,huang.ying.caritas@gmail.com,david@kernel.org,bhe@redhat.com,andriy.shevchenko@linux.intel.com,ilstam@amazon.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + reinstate-resource-avoid-unnecessary-lookups-in-find_next_iomem_res.patch added to mm-nonmm-unstable branch
Message-Id: <20251125175215.310F4C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: Reinstate "resource: avoid unnecessary lookups in find_next_iomem_res()"
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     reinstate-resource-avoid-unnecessary-lookups-in-find_next_iomem_res.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/reinstate-resource-avoid-unnecessary-lookups-in-find_next_iomem_res.patch

This patch will later appear in the mm-nonmm-unstable branch at
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

reinstate-resource-avoid-unnecessary-lookups-in-find_next_iomem_res.patch

