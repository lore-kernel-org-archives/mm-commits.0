Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25C9018A925
	for <mm-commits@vger.kernel.org>; Mon,  9 Sep 2024 23:40:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725925239; cv=none; b=NduzGrZmL+qFUJgr7ZfJQoks9mmV+WIDa+uEaUr0M9Sg5S8ZLmzIq3GNagoBjE9ovCiAPu5MOMh5fRKHiInSxwRSK8QOD7mwmS1RCHymWAkO4yac8nbihKJwcILSLloxhJce2JOeB9kWEFLao0LltbR2qtGw6k7IFA4/LdqlYeE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725925239; c=relaxed/simple;
	bh=/4L3dnCtl9anEfqltWxCwi63eAUeuHGetPHM1YFHgjo=;
	h=Date:To:From:Subject:Message-Id; b=GgEU9mZKBFqX1h+MUiQXwciZKzqOcg9S/XPnob/NT8yRC06S+j9pLC8GryA/pqC77ZxK7tJSE1TCScbVWD3CLkr8VUYIDYch8cK3Ak4kqA4YfbACJM+X672K+XHFf+AgRRgqJ5iITQxjTp2pqRUHuwdEIhfQ/k75AnJ3tc8Lp28=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=wlYqaJKQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wlYqaJKQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E057AC4CEC5;
	Mon,  9 Sep 2024 23:40:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725925239;
	bh=/4L3dnCtl9anEfqltWxCwi63eAUeuHGetPHM1YFHgjo=;
	h=Date:To:From:Subject:From;
	b=wlYqaJKQ3cUtEP+RS8o24Wb6Oictqc1ljKtwCAHcVLFXmq81hRDtmjtnWhW2VI3kv
	 +BD1sshPtdDKt9aGyMGrAHxJ8u6iUuOiE8GKFckUp0vX1TwJZF2nIEmTt0BTE2aJaX
	 tdYtV/BJgNFnQVGt6e4xAcUiKxVqpj31Ua/lXt4s=
Date: Mon, 09 Sep 2024 16:40:38 -0700
To: mm-commits@vger.kernel.org,xuanzhuo@linux.alibaba.com,xieyongji@bytedance.com,vbabka@suse.cz,urezki@gmail.com,torvalds@linux-foundation.org,roman.gushchin@linux.dev,rientjes@google.com,penberg@kernel.org,mst@redhat.com,mhocko@suse.com,maxime.coquelin@redhat.com,lorenzo.stoakes@oracle.com,laoar.shao@gmail.com,kees@kernel.org,jasowang@redhat.com,iamjoonsoo.kim@lge.com,hch@lst.de,hch@infradead.org,hailong.liu@oppo.com,eperezma@redhat.com,david@redhat.com,dave@stgolabs.net,cl@linux.com,42.hyeyoo@gmail.com,v-songbaohua@oppo.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-document-__gfp_nofail-must-be-blockable.patch removed from -mm tree
Message-Id: <20240909234038.E057AC4CEC5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: document __GFP_NOFAIL must be blockable
has been removed from the -mm tree.  Its filename was
     mm-document-__gfp_nofail-must-be-blockable.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Acked-by: David Hildenbrand <david@redhat.com>
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


