Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAFF4D51C
	for <mm-commits@vger.kernel.org>; Sun, 28 Jan 2024 08:27:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706430478; cv=none; b=AMUavIuiKTIQj703SmAB3oiyRjtdAqT8F7xdJl/bh5oMuETqGM5Xe7IXyLUlTbQ0CyBb3xfs0azNfGyl3ikuMoKLIKa5PENDcMQRr6/sIVQk/2Db/GGu/MG6HMbSKoGIEUJ+a8tGPdAWWYxdGQ/vZCN3VxRJy4+1W3yOE7HTknM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706430478; c=relaxed/simple;
	bh=qOn66axFIP9w0wYYov8PtJ0CEypxPxxz2yDoiDyIYs0=;
	h=Date:To:From:Subject:Message-Id; b=KKIfGD6pGi5rOJKWOxTRCxA/MP/g3IuBt5XNT6VQEsvhOnQHIb6cWcrTtPb6SosKo8kfWWqb0RDU9gHePVPH9VbjkVMtdVuvlh3bbMYhFr2UnQTtiSCyoZKWux418nX+hpxz6A4ZqPrDiwfzttBg4cHdrzyF4/FWazm65Xngi4s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=yGNPlllH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="yGNPlllH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1185EC433F1;
	Sun, 28 Jan 2024 08:27:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1706430478;
	bh=qOn66axFIP9w0wYYov8PtJ0CEypxPxxz2yDoiDyIYs0=;
	h=Date:To:From:Subject:From;
	b=yGNPlllHnzPGimI/MyXvtGNroPOcfy3+u5DMkw+KQEJtZYEFqdmWBRw1L6qadEmxV
	 zBG2AjbDsbnMjbMk+pukgsuYhbjdzCrV0ST7dTrFB++FDe78WMqe2j8M71baFXczvv
	 mX1i4SjCqoLPXyhnrSoSAc1Drl7G7kISITxuK0ng=
Date: Sun, 28 Jan 2024 00:27:55 -0800
To: mm-commits@vger.kernel.org,tim.c.chen@linux.intel.com,rientjes@google.com,muchun.song@linux.dev,mike.kravetz@oracle.com,ligang.bdlg@bytedance.com,david@redhat.com,gang.li@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + hugetlb-code-clean-for-hugetlb_hstate_alloc_pages.patch added to mm-unstable branch
Message-Id: <20240128082758.1185EC433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: hugetlb: code clean for hugetlb_hstate_alloc_pages
has been added to the -mm mm-unstable branch.  Its filename is
     hugetlb-code-clean-for-hugetlb_hstate_alloc_pages.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/hugetlb-code-clean-for-hugetlb_hstate_alloc_pages.patch

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
From: Gang Li <gang.li@linux.dev>
Subject: hugetlb: code clean for hugetlb_hstate_alloc_pages
Date: Fri, 26 Jan 2024 23:24:05 +0800

Patch series "hugetlb: parallelize hugetlb page init on boot", v5.

# Introduction
Hugetlb initialization during boot takes up a considerable amount of time.
For instance, on a 2TB system, initializing 1,800 1GB huge pages takes
1-2 seconds out of 10 seconds.  Initializing 11,776 1GB pages on a 12TB
Intel host takes more than 1 minute[1].  This is a noteworthy figure.

Inspired by [2] and [3], hugetlb initialization can also be accelerated
through parallelization.  Kernel already has infrastructure like
padata_do_multithreaded, this patch uses it to achieve effective results
by minimal modifications.

[1] https://lore.kernel.org/all/783f8bac-55b8-5b95-eb6a-11a583675000@google.com/
[2] https://lore.kernel.org/all/20200527173608.2885243-1-daniel.m.jordan@oracle.com/
[3] https://lore.kernel.org/all/20230906112605.2286994-1-usama.arif@bytedance.com/
[4] https://lore.kernel.org/all/76becfc1-e609-e3e8-2966-4053143170b6@google.com/

# max_threads
This patch use `padata_do_multithreaded` like this:

```
job.max_threads	= num_node_state(N_MEMORY) * multiplier;
padata_do_multithreaded(&job);
```

To fully utilize the CPU, the number of parallel threads needs to be
carefully considered.  `max_threads = num_node_state(N_MEMORY)` does not
fully utilize the CPU, so we need to multiply it by a multiplier.

Tests below indicate that a multiplier of 2 significantly improves
performance, and although larger values also provide improvements, the
gains are marginal.

  multiplier     1       2       3       4       5
 ------------ ------- ------- ------- ------- -------
  256G 2node   358ms   215ms   157ms   134ms   126ms
  2T   4node   979ms   679ms   543ms   489ms   481ms
  50G  2node   71ms    44ms    37ms    30ms    31ms

Therefore, choosing 2 as the multiplier strikes a good balance between
enhancing parallel processing capabilities and maintaining efficient
resource management.

# Test result
      test case       no patch(ms)   patched(ms)   saved
 ------------------- -------------- ------------- --------
  256c2T(4 node) 1G           4745          2024   57.34%
  128c1T(2 node) 1G           3358          1712   49.02%
     12T         1G          77000         18300   76.23%

  256c2T(4 node) 2M           3336          1051   68.52%
  128c1T(2 node) 2M           1943           716   63.15%


This patch (of 7):

The readability of `hugetlb_hstate_alloc_pages` is poor.  By cleaning the
code, its readability can be improved, facilitating future modifications.

This patch extracts two functions to reduce the complexity of
`hugetlb_hstate_alloc_pages` and has no functional changes.

- hugetlb_hstate_alloc_pages_node_specific() to handle iterates through
  each online node and performs allocation if necessary.
- hugetlb_hstate_alloc_pages_report() report error during allocation.
  And the value of h->max_huge_pages is updated accordingly.

Link: https://lkml.kernel.org/r/20240126152411.1238072-1-gang.li@linux.dev
Link: https://lkml.kernel.org/r/20240126152411.1238072-2-gang.li@linux.dev
Signed-off-by: Gang Li <ligang.bdlg@bytedance.com>
Tested-by: David Rientjes <rientjes@google.com>
Reviewed-by: Muchun Song <muchun.song@linux.dev>
Reviewed-by: Tim Chen <tim.c.chen@linux.intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   46 +++++++++++++++++++++++++++++-----------------
 1 file changed, 29 insertions(+), 17 deletions(-)

--- a/mm/hugetlb.c~hugetlb-code-clean-for-hugetlb_hstate_alloc_pages
+++ a/mm/hugetlb.c
@@ -3482,6 +3482,33 @@ static void __init hugetlb_hstate_alloc_
 	h->max_huge_pages_node[nid] = i;
 }
 
+static bool __init hugetlb_hstate_alloc_pages_specific_nodes(struct hstate *h)
+{
+	int i;
+	bool node_specific_alloc = false;
+
+	for_each_online_node(i) {
+		if (h->max_huge_pages_node[i] > 0) {
+			hugetlb_hstate_alloc_pages_onenode(h, i);
+			node_specific_alloc = true;
+		}
+	}
+
+	return node_specific_alloc;
+}
+
+static void __init hugetlb_hstate_alloc_pages_errcheck(unsigned long allocated, struct hstate *h)
+{
+	if (allocated < h->max_huge_pages) {
+		char buf[32];
+
+		string_get_size(huge_page_size(h), 1, STRING_UNITS_2, buf, 32);
+		pr_warn("HugeTLB: allocating %lu of page size %s failed.  Only allocated %lu hugepages.\n",
+			h->max_huge_pages, buf, allocated);
+		h->max_huge_pages = allocated;
+	}
+}
+
 /*
  * NOTE: this routine is called in different contexts for gigantic and
  * non-gigantic pages.
@@ -3499,7 +3526,6 @@ static void __init hugetlb_hstate_alloc_
 	struct folio *folio;
 	LIST_HEAD(folio_list);
 	nodemask_t *node_alloc_noretry;
-	bool node_specific_alloc = false;
 
 	/* skip gigantic hugepages allocation if hugetlb_cma enabled */
 	if (hstate_is_gigantic(h) && hugetlb_cma_size) {
@@ -3508,14 +3534,7 @@ static void __init hugetlb_hstate_alloc_
 	}
 
 	/* do node specific alloc */
-	for_each_online_node(i) {
-		if (h->max_huge_pages_node[i] > 0) {
-			hugetlb_hstate_alloc_pages_onenode(h, i);
-			node_specific_alloc = true;
-		}
-	}
-
-	if (node_specific_alloc)
+	if (hugetlb_hstate_alloc_pages_specific_nodes(h))
 		return;
 
 	/* below will do all node balanced alloc */
@@ -3558,14 +3577,7 @@ static void __init hugetlb_hstate_alloc_
 	/* list will be empty if hstate_is_gigantic */
 	prep_and_add_allocated_folios(h, &folio_list);
 
-	if (i < h->max_huge_pages) {
-		char buf[32];
-
-		string_get_size(huge_page_size(h), 1, STRING_UNITS_2, buf, 32);
-		pr_warn("HugeTLB: allocating %lu of page size %s failed.  Only allocated %lu hugepages.\n",
-			h->max_huge_pages, buf, i);
-		h->max_huge_pages = i;
-	}
+	hugetlb_hstate_alloc_pages_errcheck(i, h);
 	kfree(node_alloc_noretry);
 }
 
_

Patches currently in -mm which might be from gang.li@linux.dev are

hugetlb-code-clean-for-hugetlb_hstate_alloc_pages.patch
hugetlb-split-hugetlb_hstate_alloc_pages.patch
padata-dispatch-works-on-different-nodes.patch
hugetlb-pass-next_nid_to_alloc-directly-to-for_each_node_mask_to_alloc.patch
hugetlb-have-config_hugetlbfs-select-config_padata.patch
hugetlb-parallelize-2m-hugetlb-allocation-and-initialization.patch
hugetlb-parallelize-1g-hugetlb-initialization.patch

