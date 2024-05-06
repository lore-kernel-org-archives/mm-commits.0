Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5381E19BA6
	for <mm-commits@vger.kernel.org>; Mon,  6 May 2024 00:57:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714957039; cv=none; b=r0lri+VOJ4cR9z0uWQZ7lzJpxqNTaFdrbyl5gUSDRk3xASbNgpe75H9U5udw+GP/MTvoO5jLyu3iR3GNVdraAjnurrpYa9fHF5gYKbnF43ai/z2sTV1Low5QsCqGRaQQckTaH7T8TaiBE9QlPWVkhy8m4jyoSplIZbc8TdmE72U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714957039; c=relaxed/simple;
	bh=Xm2mvsd35XHzB5t4DPlSGEcJ3SHBlwQ41Q+63GXTNDE=;
	h=Date:To:From:Subject:Message-Id; b=EKCZAIkt45cA3fs+Tvoa+DstNg5q+rFRZrkxAsj6wk1pNqnBC1V+ipmJxmI9leIz+ILKMMHbmx5iU3oDrj0eJO5+TnkcXATB5ZAIS8oa8G0s1rRcAi79VIAVGS0oN70YPkBb1T7QpURK9+b68iJwm3QPChKVmYqzexSQH6JKPEM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=tgjB+Qpa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="tgjB+Qpa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29F7FC116B1;
	Mon,  6 May 2024 00:57:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714957039;
	bh=Xm2mvsd35XHzB5t4DPlSGEcJ3SHBlwQ41Q+63GXTNDE=;
	h=Date:To:From:Subject:From;
	b=tgjB+Qpay6Q1l6jxDvQL3xw+Mum4DKxXHyL1eDjM4xrSaqPGb/BB5JntuqySuAm9y
	 RKOlw4AQKhtY3CHqyP7+AwsN88h1jl5dVQui33QQk/zktgfpu/3O6W7uRpF5t+T/J/
	 W06OkUEoGFsNSmVStybsBjJIcZMOrkMg0/yE6478=
Date: Sun, 05 May 2024 17:57:18 -0700
To: mm-commits@vger.kernel.org,yuzhao@google.com,yosryahmed@google.com,willy@infradead.org,surenb@google.com,ryan.roberts@arm.com,peterx@redhat.com,kasong@tencent.com,david@redhat.com,corbet@lwn.net,chrisl@kernel.org,cerasuolodomenico@gmail.com,v-songbaohua@oppo.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-add-per-order-mthp-anon_swpout-and-anon_swpout_fallback-counters.patch removed from -mm tree
Message-Id: <20240506005719.29F7FC116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: add per-order mTHP anon_swpout and anon_swpout_fallback counters
has been removed from the -mm tree.  Its filename was
     mm-add-per-order-mthp-anon_swpout-and-anon_swpout_fallback-counters.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Barry Song <v-songbaohua@oppo.com>
Subject: mm: add per-order mTHP anon_swpout and anon_swpout_fallback counters
Date: Fri, 12 Apr 2024 23:48:56 +1200

This helps to display the fragmentation situation of the swapfile, knowing
the proportion of how much we haven't split large folios.  So far, we only
support non-split swapout for anon memory, with the possibility of
expanding to shmem in the future.  So, we add the "anon" prefix to the
counter names.

Link: https://lkml.kernel.org/r/20240412114858.407208-3-21cnbao@gmail.com
Signed-off-by: Barry Song <v-songbaohua@oppo.com>
Reviewed-by: Ryan Roberts <ryan.roberts@arm.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: Domenico Cerasuolo <cerasuolodomenico@gmail.com>
Cc: Kairui Song <kasong@tencent.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Peter Xu <peterx@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Yosry Ahmed <yosryahmed@google.com>
Cc: Yu Zhao <yuzhao@google.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/huge_mm.h |    2 ++
 mm/huge_memory.c        |    4 ++++
 mm/page_io.c            |    1 +
 mm/vmscan.c             |    3 +++
 4 files changed, 10 insertions(+)

--- a/include/linux/huge_mm.h~mm-add-per-order-mthp-anon_swpout-and-anon_swpout_fallback-counters
+++ a/include/linux/huge_mm.h
@@ -268,6 +268,8 @@ enum mthp_stat_item {
 	MTHP_STAT_ANON_FAULT_ALLOC,
 	MTHP_STAT_ANON_FAULT_FALLBACK,
 	MTHP_STAT_ANON_FAULT_FALLBACK_CHARGE,
+	MTHP_STAT_ANON_SWPOUT,
+	MTHP_STAT_ANON_SWPOUT_FALLBACK,
 	__MTHP_STAT_COUNT
 };
 
--- a/mm/huge_memory.c~mm-add-per-order-mthp-anon_swpout-and-anon_swpout_fallback-counters
+++ a/mm/huge_memory.c
@@ -555,11 +555,15 @@ static struct kobj_attribute _name##_att
 DEFINE_MTHP_STAT_ATTR(anon_fault_alloc, MTHP_STAT_ANON_FAULT_ALLOC);
 DEFINE_MTHP_STAT_ATTR(anon_fault_fallback, MTHP_STAT_ANON_FAULT_FALLBACK);
 DEFINE_MTHP_STAT_ATTR(anon_fault_fallback_charge, MTHP_STAT_ANON_FAULT_FALLBACK_CHARGE);
+DEFINE_MTHP_STAT_ATTR(anon_swpout, MTHP_STAT_ANON_SWPOUT);
+DEFINE_MTHP_STAT_ATTR(anon_swpout_fallback, MTHP_STAT_ANON_SWPOUT_FALLBACK);
 
 static struct attribute *stats_attrs[] = {
 	&anon_fault_alloc_attr.attr,
 	&anon_fault_fallback_attr.attr,
 	&anon_fault_fallback_charge_attr.attr,
+	&anon_swpout_attr.attr,
+	&anon_swpout_fallback_attr.attr,
 	NULL,
 };
 
--- a/mm/page_io.c~mm-add-per-order-mthp-anon_swpout-and-anon_swpout_fallback-counters
+++ a/mm/page_io.c
@@ -217,6 +217,7 @@ static inline void count_swpout_vm_event
 		count_memcg_folio_events(folio, THP_SWPOUT, 1);
 		count_vm_event(THP_SWPOUT);
 	}
+	count_mthp_stat(folio_order(folio), MTHP_STAT_ANON_SWPOUT);
 #endif
 	count_vm_events(PSWPOUT, folio_nr_pages(folio));
 }
--- a/mm/vmscan.c~mm-add-per-order-mthp-anon_swpout-and-anon_swpout_fallback-counters
+++ a/mm/vmscan.c
@@ -1214,6 +1214,8 @@ retry:
 						goto activate_locked;
 				}
 				if (!add_to_swap(folio)) {
+					int __maybe_unused order = folio_order(folio);
+
 					if (!folio_test_large(folio))
 						goto activate_locked_split;
 					/* Fallback to swap normal pages */
@@ -1225,6 +1227,7 @@ retry:
 							THP_SWPOUT_FALLBACK, 1);
 						count_vm_event(THP_SWPOUT_FALLBACK);
 					}
+					count_mthp_stat(order, MTHP_STAT_ANON_SWPOUT_FALLBACK);
 #endif
 					if (!add_to_swap(folio))
 						goto activate_locked_split;
_

Patches currently in -mm which might be from v-songbaohua@oppo.com are


