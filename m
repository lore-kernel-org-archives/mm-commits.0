Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63CF6165F12
	for <mm-commits@vger.kernel.org>; Fri, 30 Aug 2024 21:45:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725054346; cv=none; b=DLdPRH55vnrEy4z/PzmBYSIb8Ag6HHtoJioHZ7JL+Od9KIR9aHZte1B9UnPnlyVJAP05MEt+A+X/1u/qqb2VfySbCfWg6Tc5rfl4AP0E08fkujPeUT2G8/TeFEbP/9cWncw8gf6LIB32AoCHx2xhq1mh/hwAfZ1CYLBIhh/aMqY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725054346; c=relaxed/simple;
	bh=gQZYClDLYrAxB6vLmvF7InQ2fP2LuhVeO6WF+Lu5hnk=;
	h=Date:To:From:Subject:Message-Id; b=bke2SXssxo8IY0b/nJEkB25jFT/WX1opbVhqU0wWKpBVuWc70mVO7id10kezPbD/AQ6Y5pPoGoSch9E8oMym8IGfb68ob50yw509KZgvpjNbMSW47eaYougUmm03IdaN02kf9qZegMGlRJswRlnz6UNJc9uyp85zFySZZViFJIk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=QCuMFq4d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="QCuMFq4d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D595BC4CEC2;
	Fri, 30 Aug 2024 21:45:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725054345;
	bh=gQZYClDLYrAxB6vLmvF7InQ2fP2LuhVeO6WF+Lu5hnk=;
	h=Date:To:From:Subject:From;
	b=QCuMFq4dtVmFLt99EHEU+4bPtVteQtMj2SVf6Q4uL11TZRTKWZnkjKmvxk63TWp+V
	 nuMojgeFarbL3UCNXoXQuaCjKxhxb0dfa1Yi34aNpdWleYviUuNhl0MtMhCa7fai7x
	 x8o24Bg//D5zABpGcjI3n6En9K1pesJ0s+BGfF1k=
Date: Fri, 30 Aug 2024 14:45:45 -0700
To: mm-commits@vger.kernel.org,xuanzhuo@linux.alibaba.com,xieyongji@bytedance.com,vbabka@suse.cz,urezki@gmail.com,torvalds@linux-foundation.org,roman.gushchin@linux.dev,rientjes@google.com,penberg@kernel.org,mst@redhat.com,mhocko@suse.com,maxime.coquelin@redhat.com,lorenzo.stoakes@oracle.com,laoar.shao@gmail.com,kees@kernel.org,jasowang@redhat.com,iamjoonsoo.kim@lge.com,hch@lst.de,hch@infradead.org,hailong.liu@oppo.com,eperezma@redhat.com,david@redhat.com,dave@stgolabs.net,cl@linux.com,42.hyeyoo@gmail.com,v-songbaohua@oppo.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-document-__gfp_nofail-must-be-blockable.patch added to mm-unstable branch
Message-Id: <20240830214545.D595BC4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: document __GFP_NOFAIL must be blockable
has been added to the -mm mm-unstable branch.  Its filename is
     mm-document-__gfp_nofail-must-be-blockable.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-document-__gfp_nofail-must-be-blockable.patch

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
From: Barry Song <v-songbaohua@oppo.com>
Subject: mm: document __GFP_NOFAIL must be blockable
Date: Sat, 31 Aug 2024 08:28:22 +1200

Non-blocking allocation with __GFP_NOFAIL is not supported and may still
result in NULL pointers (if we don't return NULL, we result in busy-loop
within non-sleepable contexts):

static inline struct page *
__alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
						struct alloc_context *ac)
{
	...
	/*
	 * Make sure that __GFP_NOFAIL request doesn't leak out and make sure
	 * we always retry
	 */
	if (gfp_mask & __GFP_NOFAIL) {
		/*
		 * All existing users of the __GFP_NOFAIL are blockable, so warn
		 * of any new users that actually require GFP_NOWAIT
		 */
		if (WARN_ON_ONCE_GFP(!can_direct_reclaim, gfp_mask))
			goto fail;
		...
	}
	...
fail:
	warn_alloc(gfp_mask, ac->nodemask,
			"page allocation failure: order:%u", order);
got_pg:
	return page;
}

Highlight this in the documentation of __GFP_NOFAIL so that non-mm
subsystems can reject any illegal usage of __GFP_NOFAIL with GFP_ATOMIC,
GFP_NOWAIT, etc.

Link: https://lkml.kernel.org/r/20240830202823.21478-3-21cnbao@gmail.com
Signed-off-by: Barry Song <v-songbaohua@oppo.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Davidlohr Bueso <dave@stgolabs.net>
Cc: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>
Cc: "Eugenio Pérez" <eperezma@redhat.com>
Cc: Hailong.Liu <hailong.liu@oppo.com>
Cc: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Cc: Jason Wang <jasowang@redhat.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Kees Cook <kees@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Maxime Coquelin <maxime.coquelin@redhat.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Uladzislau Rezki (Sony) <urezki@gmail.com>
Cc: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Xie Yongji <xieyongji@bytedance.com>
Cc: Yafang Shao <laoar.shao@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/gfp_types.h |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/include/linux/gfp_types.h~mm-document-__gfp_nofail-must-be-blockable
+++ a/include/linux/gfp_types.h
@@ -215,7 +215,8 @@ enum {
  * the caller still has to check for failures) while costly requests try to be
  * not disruptive and back off even without invoking the OOM killer.
  * The following three modifiers might be used to override some of these
- * implicit rules.
+ * implicit rules. Please note that all of them must be used along with
+ * %__GFP_DIRECT_RECLAIM flag.
  *
  * %__GFP_NORETRY: The VM implementation will try only very lightweight
  * memory direct reclaim to get some memory under memory pressure (thus
@@ -246,6 +247,8 @@ enum {
  * cannot handle allocation failures. The allocation could block
  * indefinitely but will never return with failure. Testing for
  * failure is pointless.
+ * It _must_ be blockable and used together with __GFP_DIRECT_RECLAIM.
+ * It should _never_ be used in non-sleepable contexts.
  * New users should be evaluated carefully (and the flag should be
  * used only when there is no reasonable failure policy) but it is
  * definitely preferable to use the flag rather than opencode endless
_

Patches currently in -mm which might be from v-songbaohua@oppo.com are

mm-extend-usage-parameter-so-that-cluster_swap_free_nr-can-be-reused.patch
mm-swap-add-nr-argument-in-swapcache_prepare-and-swapcache_clear-to-support-large-folios.patch
mm-swap-add-nr-argument-in-swapcache_prepare-and-swapcache_clear-to-support-large-folios-fix.patch
mm-rename-instances-of-swap_info_struct-to-meaningful-si.patch
mm-attempt-to-batch-free-swap-entries-for-zap_pte_range.patch
mm-attempt-to-batch-free-swap-entries-for-zap_pte_range-fix.patch
mm-override-mthp-enabled-defaults-at-kernel-cmdline-fix.patch
mm-count-the-number-of-anonymous-thps-per-size.patch
mm-count-the-number-of-partially-mapped-anonymous-thps-per-size.patch
mm-add-nr-argument-in-mem_cgroup_swapin_uncharge_swap-helper-to-support-large-folios.patch
mm-document-__gfp_nofail-must-be-blockable.patch
mm-warn-about-illegal-__gfp_nofail-usage-in-a-more-appropriate-location-and-manner.patch

