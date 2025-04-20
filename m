Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64985158218
	for <mm-commits@vger.kernel.org>; Sun, 20 Apr 2025 21:24:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745184298; cv=none; b=L9W+OAAqJv+ceu9jbvfGsKMK1q/r6vUbv7hQka/gL7/eEEpAn0pnRTnMrzqgAi7ujlp0AXzOVkKMF6sqw7ZxQHuk5iumtK2HYDsFaK8HqYSr13OOk7t+JoH2vQlOicSigetmRKfPKEi1ly3aZEICfs2W55vL1SgMngKzb7SBK2w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745184298; c=relaxed/simple;
	bh=RYwrP6Zth6ZTXVaZEVAsxuntWrGJ7wChaGbvBcoxQec=;
	h=Date:To:From:Subject:Message-Id; b=rUexTUXZPXIX+Ugc4Qch1GKZ1qZswmYSaGfbF3Br/+QWlLfx8nHrkX9v4BbJ56VH8Os5uOd1eqy8uGF+m6DCmT3t+DNB20mL5m+e2P97pPnRSNkC2+iMGG+n01uGgHqsgGPSAmAjSWodkSO45O/2VkiLDOLedZcrU/iHR/ruphM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=04IqTcjv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="04IqTcjv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2E5EC4CEE2;
	Sun, 20 Apr 2025 21:24:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1745184297;
	bh=RYwrP6Zth6ZTXVaZEVAsxuntWrGJ7wChaGbvBcoxQec=;
	h=Date:To:From:Subject:From;
	b=04IqTcjvcSto45RflZIZyV4V59G1r5sWmDv3yA9bjT0UrtKDImrR5CqS2LYvYjuiv
	 +k6YA1IRtOno4OsgXItrR4S56aSvKUA4RIfbqGFAD7w0iQ9yOpea08SkhZUBl+KojP
	 Udu3Z7GS4qOHo3MpGso/XCjUn/I6G6MduQkxJXG4=
Date: Sun, 20 Apr 2025 14:24:57 -0700
To: mm-commits@vger.kernel.org,vishal.moola@gmail.com,urezki@gmail.com,shivankg@amd.com,bhe@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmallocc-find-the-vmap-of-vmap_nodes-in-reverse-order.patch added to mm-new branch
Message-Id: <20250420212457.C2E5EC4CEE2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/vmalloc.c: find the vmap of vmap_nodes in reverse order
has been added to the -mm mm-new branch.  Its filename is
     mm-vmallocc-find-the-vmap-of-vmap_nodes-in-reverse-order.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmallocc-find-the-vmap-of-vmap_nodes-in-reverse-order.patch

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
Subject: mm/vmalloc.c: find the vmap of vmap_nodes in reverse order
Date: Sat, 19 Apr 2025 06:36:50 +0800

When finding VA in vn->busy, if VA spans several zones and the passed addr
is not the same as va->va_start, we should scan the vn in reverse odrdr
because the starting address of VA must be smaller than the passed addr if
it really resides in the VA.

E.g on a system nr_vmap_nodes=100,

     <----va---->
 -|-----|-----|-----|-----|-----|-----|-----|-----|-----|-
    ...   n-1   n    n+1   n+2   ...   100     0     1

VA resides in node 'n' whereas it spans 'n', 'n+1' and 'n+2'.  If passed
addr is within 'n+2', we should try nodes backwards on 'n+1' and 'n', then
succeed very soon.

Meanwhile we still need loop around because VA could spans node from 'n'
to node 100, node 0, node 1.

Anyway, changing to find in reverse order can improve efficiency on many
CPUs system.

Link: https://lkml.kernel.org/r/20250418223653.243436-3-bhe@redhat.com
Signed-off-by: Baoquan He <bhe@redhat.com>
Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Reviewed-by: Shivank Garg <shivankg@amd.com>
Cc: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/vmalloc.c~mm-vmallocc-find-the-vmap-of-vmap_nodes-in-reverse-order
+++ a/mm/vmalloc.c
@@ -2435,7 +2435,7 @@ struct vmap_area *find_vmap_area(unsigne
 
 		if (va)
 			return va;
-	} while ((i = (i + 1) % nr_vmap_nodes) != j);
+	} while ((i = (i + nr_vmap_nodes - 1) % nr_vmap_nodes) != j);
 
 	return NULL;
 }
@@ -2461,7 +2461,7 @@ static struct vmap_area *find_unlink_vma
 
 		if (va)
 			return va;
-	} while ((i = (i + 1) % nr_vmap_nodes) != j);
+	} while ((i = (i + nr_vmap_nodes - 1) % nr_vmap_nodes) != j);
 
 	return NULL;
 }
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

