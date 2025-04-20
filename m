Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DF8C158218
	for <mm-commits@vger.kernel.org>; Sun, 20 Apr 2025 21:24:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745184296; cv=none; b=AsRMXIah+R70sQ4xxQxtcwooeqUvVqT6lIyTy68d8k3Kq4tBBjnAJy1CiGsEhldd4QJXMYDal6JdM3SgeW2Wv4uuQssIjKHyVKp0UnRLiPp1+Fi/IS/7C5YI/RHno+5OzQ2ScKBU25f14kXXz/bWKT810pP0n8LMQXLBZ0KqNlw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745184296; c=relaxed/simple;
	bh=6mppyxW707ZiLjFZHqmZbT1dVccc0HdlivEG2bhvksU=;
	h=Date:To:From:Subject:Message-Id; b=uxGMl+dDFg4eYscd0vpRfCxPeoAEtFkHmVcZnYO5+XGqdgyN6ymVwrK+ADV0W1X9CRpelkMFcSANwwMUHaLpelMTEjqnIajXCF+WMOvGNWG69+TChP3PUsHVBE7PX52P7bnCanBTyC2gqKgqhK1pseerE/Rr3zaMzI+muNH3A0Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=YrVmLijb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="YrVmLijb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFF60C4CEE2;
	Sun, 20 Apr 2025 21:24:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1745184295;
	bh=6mppyxW707ZiLjFZHqmZbT1dVccc0HdlivEG2bhvksU=;
	h=Date:To:From:Subject:From;
	b=YrVmLijbMxGe90VCmiLnGeNrwWO7zvdqSkH9eNbgGj7kC7DVc1X4ShfdqEoaWgFS2
	 hrN8N1F6aM4itMSCZbZbv9JkIDBUnohXmMRTw6l+K6RLJhcWopCVv9+ykUm2FAWXZk
	 94kU2P9p5tFxGPLWNgh7v3tUTcH8iDDaRXVBKT5A=
Date: Sun, 20 Apr 2025 14:24:55 -0700
To: mm-commits@vger.kernel.org,vishal.moola@gmail.com,urezki@gmail.com,shivankg@amd.com,bhe@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmallocc-change-purge_ndoes-as-local-static-variable.patch added to mm-new branch
Message-Id: <20250420212455.DFF60C4CEE2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/vmalloc.c: change purge_ndoes as local static variable
has been added to the -mm mm-new branch.  Its filename is
     mm-vmallocc-change-purge_ndoes-as-local-static-variable.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmallocc-change-purge_ndoes-as-local-static-variable.patch

This patch will later appear in the mm-new branch at
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
From: Baoquan He <bhe@redhat.com>
Subject: mm/vmalloc.c: change purge_ndoes as local static variable
Date: Sat, 19 Apr 2025 06:36:49 +0800

Patch series "mm/vmalloc.c: code cleanup and improvements", v2.

These changes were made from code inspection in mm/vmalloc.c.


This patch (of 5):

Static variable 'purge_ndoes' is defined in global scope, while it's only
used in function __purge_vmap_area_lazy().  It mainly serves to avoid
memory allocation repeatedly, especially when NR_CPUS is big.

While a local static variable can also satisfy the demand, and can improve
code readibility.  Hence move its definition into
__purge_vmap_area_lazy().

Link: https://lkml.kernel.org/r/20250418223653.243436-1-bhe@redhat.com
Link: https://lkml.kernel.org/r/20250418223653.243436-2-bhe@redhat.com
Signed-off-by: Baoquan He <bhe@redhat.com>
Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Reviewed-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Reviewed-by: Shivank Garg <shivankg@amd.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/vmalloc.c~mm-vmallocc-change-purge_ndoes-as-local-static-variable
+++ a/mm/vmalloc.c
@@ -2127,7 +2127,6 @@ static DEFINE_MUTEX(vmap_purge_lock);
 
 /* for per-CPU blocks */
 static void purge_fragmented_blocks_allcpus(void);
-static cpumask_t purge_nodes;
 
 static void
 reclaim_list_global(struct list_head *head)
@@ -2260,6 +2259,7 @@ static bool __purge_vmap_area_lazy(unsig
 {
 	unsigned long nr_purged_areas = 0;
 	unsigned int nr_purge_helpers;
+	static cpumask_t purge_nodes;
 	unsigned int nr_purge_nodes;
 	struct vmap_node *vn;
 	int i;
_

Patches currently in -mm which might be from bhe@redhat.com are

mm-gup-remove-unneeded-checking-in-follow_page_pte.patch
mm-gup-remove-gup_fast_pgd_leaf-and-clean-up-the-relevant-codes.patch
mm-gup-clean-up-codes-in-fault_in_xxx-functions.patch
mm-gup-clean-up-codes-in-fault_in_xxx-functions-v5.patch
mm-vmallocc-change-purge_ndoes-as-local-static-variable.patch
mm-vmallocc-find-the-vmap-of-vmap_nodes-in-reverse-order.patch
mm-vmallocc-optimize-code-in-decay_va_pool_node-a-little-bit.patch
mm-vmalloc-optimize-function-vm_unmap_aliases.patch
mm-vmallocc-return-explicit-error-value-in-alloc_vmap_area.patch

