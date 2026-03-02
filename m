Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31ACB277035
	for <mm-commits@vger.kernel.org>; Mon,  2 Mar 2026 18:34:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772476495; cv=none; b=ML8b9weyDGT3PXsWJ0thcGgALra8ZdYO9BsGT3KdhU6J0gzjPCPxjyYMZ1qwhnIQwxnGIS+CUNp0aSBDIRgrTO6TdE1b2UkbC98tBmFtt8Qqc4Y9iD1Z8fjcOXJ+xvUnUZYVchZAUy2D1DTUaWRfDHvPiCR4s4uA8Z5rVAvMxvc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772476495; c=relaxed/simple;
	bh=aiZX9+GKf5BzpVKi6nyzzD29gZd22udeAIVHQcYrH1U=;
	h=Date:To:From:Subject:Message-Id; b=oTLKCuaeN1j422h6+zNjHEkRktwKwQjCxX1w3wchnEyOxGue9bCI7rina/lf+q8aI0K3ZBSTTSN2tKI3cSrCz1PXBYCsc7Hom+u+HgcwOLS0I+6Yecb17rLqRNvLlOFli59rj1svp7A3p2x1AVdVeRiIsBasLBdpwFvRhelxB8A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=WCmV4Hu8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="WCmV4Hu8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF541C19423;
	Mon,  2 Mar 2026 18:34:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1772476495;
	bh=aiZX9+GKf5BzpVKi6nyzzD29gZd22udeAIVHQcYrH1U=;
	h=Date:To:From:Subject:From;
	b=WCmV4Hu8en4iSB15p2Hk5N+aK5EkjB9uO7BI+axqOtO93r7ZyRfvph/WEqi0Hg0Nt
	 mGRTN1323aA2E7W+wD+If+qQotz1PNhyWh1dao9Wflz0IB9Aznu6ppH/hBnhLWvDQg
	 UUrQysL6dmlfBWq830jauNL1+71vBjePcSINYus0=
Date: Mon, 02 Mar 2026 10:34:54 -0800
To: mm-commits@vger.kernel.org,roman.gushchin@linux.dev,rientjes@google.com,lorenzo.stoakes@oracle.com,harry.yoo@oracle.com,hao.li@linux.dev,cl@linux.com,vbabka@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maintainers-add-co-maintainer-and-reviewer-for-slab-allocator.patch added to mm-hotfixes-unstable branch
Message-Id: <20260302183454.DF541C19423@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: MAINTAINERS: add co-maintainer and reviewer for SLAB ALLOCATOR
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     maintainers-add-co-maintainer-and-reviewer-for-slab-allocator.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maintainers-add-co-maintainer-and-reviewer-for-slab-allocator.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Subject: MAINTAINERS: add co-maintainer and reviewer for SLAB ALLOCATOR
Date: Mon, 2 Mar 2026 11:13:46 +0100

Promote Harry Yoo from reviewer to maintainer.  Harry's been involved in
slab development for multiple years now and doing a great job.

Add Hao Li as a new reviewer.  Hao has been doing very useful reviews for
a while now, so make it official and ensure the Cc's.

Link: https://lkml.kernel.org/r/20260302101345.36713-2-vbabka@kernel.org
Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Acked-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Acked-by: Harry Yoo <harry.yoo@oracle.com>
Acked-by: Hao Li <hao.li@linux.dev>
Cc: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/MAINTAINERS~maintainers-add-co-maintainer-and-reviewer-for-slab-allocator
+++ a/MAINTAINERS
@@ -24361,11 +24361,12 @@ F:	drivers/nvmem/layouts/sl28vpd.c
 
 SLAB ALLOCATOR
 M:	Vlastimil Babka <vbabka@kernel.org>
+M:	Harry Yoo <harry.yoo@oracle.com>
 M:	Andrew Morton <akpm@linux-foundation.org>
+R:	Hao Li <hao.li@linux.dev>
 R:	Christoph Lameter <cl@gentwo.org>
 R:	David Rientjes <rientjes@google.com>
 R:	Roman Gushchin <roman.gushchin@linux.dev>
-R:	Harry Yoo <harry.yoo@oracle.com>
 L:	linux-mm@kvack.org
 S:	Maintained
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/vbabka/slab.git
_

Patches currently in -mm which might be from vbabka@kernel.org are

maintainers-add-co-maintainer-and-reviewer-for-slab-allocator.patch
mm-page_alloc-effectively-disable-pcp-with-config_smp=n.patch
mm-page_alloc-remove-irq-saving-restoring-from-pcp-locking.patch
mm-page_alloc-remove-pcpu_spin_-wrappers.patch

