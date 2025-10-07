Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F68124676C
	for <mm-commits@vger.kernel.org>; Tue,  7 Oct 2025 21:36:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759873003; cv=none; b=XFQ3MvNIPqYj92okQgAhWfBPNf0owWhi5L76XEa5PylUT9cj5X6Glfy7i5fLw5R8+OP2gCLToiiqw60q8kwjXrw/EOO61MM/y3VjchAmGaufMa/oTjJlsKjBCnVct8b3UJ9p/qg5otkB5vohE8KuSv7Brn2cS/NqERbISpOPzEo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759873003; c=relaxed/simple;
	bh=XrQzfYYKAf06E5PjgSWmfiOOP3lUErjPOxbffJnetik=;
	h=Date:To:From:Subject:Message-Id; b=TfoqV2CQczPthp72paBBJVGDFQKjxmcl/UZADrSLD50GnUamWXWoT+B3o/Dzfw4Zup71Mymra6XLYjbRL1molZgvTvvADpbX8WOImNgKbsB8ZoPkN5xZww30+WCa+bou76UftAa6pFPWE1IxKmyjpP8fSL0ANOPbMqtSkyZ/TnI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=AtWlFdTG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="AtWlFdTG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 545A2C4CEF1;
	Tue,  7 Oct 2025 21:36:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1759873003;
	bh=XrQzfYYKAf06E5PjgSWmfiOOP3lUErjPOxbffJnetik=;
	h=Date:To:From:Subject:From;
	b=AtWlFdTGwpiUGFfkJX5MlsmqzPcOKQK8YEp+X5BVJEDd2hC5F8Yi2XTt9WcudUjDq
	 lshnBpWGGsshFjUFOmUjlZGXMP00wISNezmHshG8ZDZ7SQwodw84aEuu14w0VO6AYS
	 ucWvCIMJp8X/CHRxSaPrwurIdjt0s/otkoItJTws=
Date: Tue, 07 Oct 2025 14:36:42 -0700
To: mm-commits@vger.kernel.org,ryabinin.a.a@gmail.com,mhocko@suse.com,mhocko@kernel.org,glider@google.com,elver@google.com,bhe@redhat.com,urezki@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-skip-might_alloc-warnings-when-pf_memalloc-is-set.patch added to mm-new branch
Message-Id: <20251007213643.545A2C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: skip might_alloc() warnings when PF_MEMALLOC is set
has been added to the -mm mm-new branch.  Its filename is
     mm-skip-might_alloc-warnings-when-pf_memalloc-is-set.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-skip-might_alloc-warnings-when-pf_memalloc-is-set.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Subject: mm: skip might_alloc() warnings when PF_MEMALLOC is set
Date: Tue, 7 Oct 2025 14:20:33 +0200

might_alloc() catches invalid blocking allocations in contexts where
sleeping is not allowed.

However when PF_MEMALLOC is set, the page allocator already skips reclaim
and other blocking paths.  In such cases, a blocking gfp_mask does not
actually lead to blocking, so triggering might_alloc() splats is
misleading.

Adjust might_alloc() to skip warnings when the current task has
PF_MEMALLOC set, matching the allocator's actual blocking behaviour.

Link: https://lkml.kernel.org/r/20251007122035.56347-9-urezki@gmail.com
Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Reviewed-by: Baoquan He <bhe@redhat.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Marco Elver <elver@google.com>
Cc: Michal Hocko <mhocko@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sched/mm.h |    3 +++
 1 file changed, 3 insertions(+)

--- a/include/linux/sched/mm.h~mm-skip-might_alloc-warnings-when-pf_memalloc-is-set
+++ a/include/linux/sched/mm.h
@@ -318,6 +318,9 @@ static inline void might_alloc(gfp_t gfp
 	fs_reclaim_acquire(gfp_mask);
 	fs_reclaim_release(gfp_mask);
 
+	if (current->flags & PF_MEMALLOC)
+		return;
+
 	might_sleep_if(gfpflags_allow_blocking(gfp_mask));
 }
 
_

Patches currently in -mm which might be from urezki@gmail.com are

lib-test_vmalloc-add-no_block_alloc_test-case.patch
lib-test_vmalloc-remove-xfail-condition-check.patch
mm-vmalloc-support-non-blocking-gfp-flags-in-alloc_vmap_area.patch
mm-vmalloc-defer-freeing-partly-initialized-vm_struct.patch
mm-vmalloc-handle-non-blocking-gfp-in-__vmalloc_area_node.patch
mm-kasan-support-non-blocking-gfp-in-kasan_populate_vmalloc.patch
kmsan-remove-hard-coded-gfp_kernel-flags.patch
mm-skip-might_alloc-warnings-when-pf_memalloc-is-set.patch
mm-vmalloc-update-__vmalloc_node_range-documentation.patch
mm-kvmalloc-add-non-blocking-support-for-vmalloc.patch

