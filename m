Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8C8B78C84
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 03:57:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714103874; cv=none; b=PX21OTdrz1XXvisRCWsjUB9JMQclPxAvZNAEdLYMQR67RDVbdJuMjPMYE8FTQsWRd0DmwYhsfjqQPH/Fo0DcZw+5crCOr20vRwvagFdEVXukvFjGgLQp7YoB8BKK15A4VzMM8ZuH4rmobnRmVTOEEVxILIpZTGi8f5qGOPlWkbA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714103874; c=relaxed/simple;
	bh=2JDfrMkV4wcahrvqYS+6rwZsMiXcC4uZj9LpL9eEk8k=;
	h=Date:To:From:Subject:Message-Id; b=HWZKlk1qtAYGSpRqhJlDhmIRalXvr0OgfDglPV36PcJ3NChWwFeUka5m5f5NZ9Jk7EUgVCj9dQM7yUzVHUHGBNLKNGuKTNuwWARXqWli+muUW1Qnrd061Qm99zuFSDUZv72SUjw666DLKUMUozjjpALZIds/7jvr+4isSnf1RdM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vxTA2moT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vxTA2moT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B85FC113CD;
	Fri, 26 Apr 2024 03:57:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714103874;
	bh=2JDfrMkV4wcahrvqYS+6rwZsMiXcC4uZj9LpL9eEk8k=;
	h=Date:To:From:Subject:From;
	b=vxTA2moTsufVxwiruwtAzgiFW+97qdSoAyorbxC3eZ7mgdtlHN/I8HqBFaTxI2ezF
	 e648deQjb9swZxdXC3Hx60ag8MYmm6aL4uZqUMYDWdbD/fMc1HpSzcf1oJmjD2oH6L
	 k87nl4uB3BDTS/FHN3ReRkMHCgvVYpBCSEbES3bo=
Date: Thu, 25 Apr 2024 20:57:53 -0700
To: mm-commits@vger.kernel.org,tj@kernel.org,dennis@kernel.org,cl@linux.com,yosryahmed@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] percpu-clean-up-all-mappings-when-pcpu_map_pages-fails.patch removed from -mm tree
Message-Id: <20240426035754.7B85FC113CD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: percpu: clean up all mappings when pcpu_map_pages() fails
has been removed from the -mm tree.  Its filename was
     percpu-clean-up-all-mappings-when-pcpu_map_pages-fails.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Yosry Ahmed <yosryahmed@google.com>
Subject: percpu: clean up all mappings when pcpu_map_pages() fails
Date: Mon, 11 Mar 2024 19:43:46 +0000

In pcpu_map_pages(), if __pcpu_map_pages() fails on a CPU, we call
__pcpu_unmap_pages() to clean up mappings on all CPUs where mappings were
created, but not on the CPU where __pcpu_map_pages() fails.

__pcpu_map_pages() and __pcpu_unmap_pages() are wrappers around
vmap_pages_range_noflush() and vunmap_range_noflush().  All other callers
of vmap_pages_range_noflush() call vunmap_range_noflush() when mapping
fails, except pcpu_map_pages().  The reason could be that partial mappings
may be left behind from a failed mapping attempt.

Call __pcpu_unmap_pages() for the failed CPU as well in pcpu_map_pages().

This was found by code inspection, no failures or bugs were observed.

Link: https://lkml.kernel.org/r/20240311194346.2291333-1-yosryahmed@google.com
Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
Acked-by: Dennis Zhou <dennis@kernel.org>
Cc: Christoph Lameter (Ampere) <cl@linux.com>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/percpu-vm.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/percpu-vm.c~percpu-clean-up-all-mappings-when-pcpu_map_pages-fails
+++ a/mm/percpu-vm.c
@@ -231,10 +231,10 @@ static int pcpu_map_pages(struct pcpu_ch
 	return 0;
 err:
 	for_each_possible_cpu(tcpu) {
-		if (tcpu == cpu)
-			break;
 		__pcpu_unmap_pages(pcpu_chunk_addr(chunk, tcpu, page_start),
 				   page_end - page_start);
+		if (tcpu == cpu)
+			break;
 	}
 	pcpu_post_unmap_tlb_flush(chunk, page_start, page_end);
 	return err;
_

Patches currently in -mm which might be from yosryahmed@google.com are

mm-zswap-always-shrink-in-zswap_store-if-zswap_pool_reached_full.patch
mm-zswap-refactor-limit-checking-from-zswap_store.patch
mm-zswap-move-more-same-filled-pages-checks-outside-of-zswap_store.patch
mm-zswap-remove-same_filled-module-params.patch
mm-zswap-remove-same_filled-module-params-fix.patch

