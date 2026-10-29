Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793297128;
	b=ThuX69kXerDKG/qxY6ZIgif4fehGeA/jcfqtDNdcZNpksGCffg6ahZuM3JPW3CkuW4mz
	 a43AYd6/UfnKZWxJoFc7IFcSysVMt8crhOWJp3TwgvHgHWadnA1qcNVD05+U54ZCPiZ1w
	 90khrdpiIXHijJhAwlS6OfDzQpEHYO1ptfkk6+rLs9oNZJ39sjgBSNaeUcjszz55u57oa
	 ZaxVeZ2sBbjj9/Z9PEwqMW0e/qP4ppS2k3PptbluNgybktXsZYXPW4rWG340a8i9cM9ln
	 lFFw2HXZ7QH0zGQoSzKpZPdHwIfP+R1zUFHOsAZQxxqhMoyfEIeh8Ixl3uzxWVCW63w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793297128;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=tSlas1zGLSvCDaIbabZF/yRlIAAcytnvfSufUmOKktU=;
	b=bMbLZGQVB4hhk3UOHxxW9k5vAd/+FYA5Evakow2VawxggdjCFn0t9Csv96ijpK30glsY
	 OVw2ASLetY3P7b2OJnG2NVD8M4+SuaoSOTDbg4JaCrRVj5bqn/FZKdILs7g8Lp1N0XLwD
	 c55rgnupNwucyLKgBBmWUWgxyQxnRNogzdYbklhEja6tZdu4JhNvX743KDcr6IvZnPqHc
	 io0KrrCdRI5EuiplSFz/aMWLNZwy8HciAb607zFvgdEA00NIq5UnXQAdkK6+Mg2pffh+n
	 hObA41a7JrweGtF7FncXDWkNg2SyAO6IpOxJI4uv30bbqkbHZYS/Q1S6lEAb/1aYL+w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=Oh4eStM6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AACE4606A31A;
	Thu, 29 Oct 2026 18:05:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=Oh4eStM6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CEB01F01816;
	Thu, 29 Oct 2026 18:05:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793297127;
	bh=tSlas1zGLSvCDaIbabZF/yRlIAAcytnvfSufUmOKktU=;
	h=Date:To:From:Subject;
	b=Oh4eStM6aoVd55oEqgqIWvJDfjU/kiSBOy3eJEKhke5sEp7gz/zT5KRA3GrYUDlI1
	 HFKiuJIFtp4Wr4B0jBpBMhW/a91L1z977ndkjgJfCwPdUt9FhUR7XFLTOwbUINmX0N
	 4VWGH8d3eO2t0CjVsmu0sft5PwelKx1tC+O4HBQA=
Date: Thu, 29 Oct 2026 11:05:26 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,
	stable@vger.kernel.org,pankaj.gupta@amd.com,mhocko@suse.com,ljs@kernel.org,
	liam@infradead.org,kas@kernel.org,david@kernel.org,rppt@kernel.org,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-cma-accept-memory-of-multi-range-cma-areas.patch added to mm-hotfixes-unstable branch
Message-Id: <20261029180527.2CEB01F01816@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm/cma: accept memory of multi-range CMA areas
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-cma-accept-memory-of-multi-range-cma-areas.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-cma-accept-memory-of-multi-range-cma-areas.patch

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
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: mm/cma: accept memory of multi-range CMA areas
Date: Thu, 29 Oct 2026 12:18:37 +0200

Patch series "mm/cma: accept memory of CMA areas reserved with
memblock_reserve()", v1.

Pages of allocated CMA areas are released to the buddy allocator with
__free_pages(), which does not check for unaccepted memory.

This usually works because memblock accepts the memory it allocates.

However, multi-range CMA areas, used by hugetlb_cma, and fixed CMA areas
requested with cma=<size>@<base> are reserved with memblock_reserve() and
their memory is never accepted.

On TDX and SEV-SNP guests the first access to such a page is fatal.

To ease the backporting, each case is addressed by a separate patch:
- patch 1 accepts the memory of multi-range CMA areas
- patch 2 does the same for the fixed CMA areas

The second patch won't apply cleanly to 6.6 and 6.12, but I believe the
stable team LLMs will take care of that :)


This patch (of 2):

On systems with unaccepted memory, memblock allocations accept the
allocated range, but when cma_declare_contiguous_multi() uses open coded
allocation of multiple ranges, it reserves them with memblock_reserve()
and they are never accepted.

These pages are released to the buddy allocator by cma_activate_area()
with __free_pages() that does not check for unaccepted memory, so the
first access to such a page in a TDX or SEV-SNP guest is fatal.

Accept the memory of each range when it is reserved.

Link: https://lore.kernel.org/20261029-cma-multi-v1-0-2cbced8b5cb7@kernel.org
Link: https://lore.kernel.org/20261029-cma-multi-v1-1-2cbced8b5cb7@kernel.org
Fixes: c009da4258f9 ("mm, cma: support multiple contiguous ranges, if requested")
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: "Gupta, Pankaj" <pankaj.gupta@amd.com>
Cc: <stable@vger.kernel.org>
---

 mm/cma.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/cma.c~mm-cma-accept-memory-of-multi-range-cma-areas
+++ a/mm/cma.c
@@ -678,6 +678,8 @@ int __init cma_declare_contiguous_multi(
 			break;
 		}
 
+		accept_memory(mlp->base, size);
+
 		pr_debug("created region %d: %016llx - %016llx\n",
 		    nr, (u64)mlp->base, (u64)mlp->base + size);
 		cmrp = &cma->ranges[nr++];
_

Patches currently in -mm which might be from rppt@kernel.org are

mm-cma-accept-memory-of-multi-range-cma-areas.patch
mm-cma-accept-memory-of-cma-areas-reserved-at-a-fixed-address.patch

