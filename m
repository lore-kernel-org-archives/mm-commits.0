Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79728747F
	for <mm-commits@vger.kernel.org>; Wed, 31 Jul 2024 00:39:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722386378; cv=none; b=PtOjFbhr35qckecgl2QzH7SS+kXBvP4xSTDcRbyIj1N02gxvttJ+yMuUWeyKa2eZQ58kJlBn2N4J9VnaQJYCUx0YqjkOdp8+giQYLGTyu8sZKzmsUsZrBF8qZRmEt72IHrfJPL9uIjogxfRJFPaOMTOunXr8ljb+4AWgBO7BtUI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722386378; c=relaxed/simple;
	bh=dSYzzbJ/sBt3hVN04H4CYSnR/VuxMLsAXxn+a6RmQaU=;
	h=Date:To:From:Subject:Message-Id; b=Kgtc4gidKkPbqSPML+tf38dfNR4RNG7lhQH+UiBWws1UWcIY+GduZat5bjS5AKjteqMucVHWazhVpGoWw5HaDywUmerc/OvjsRKFEk230pDccPvMzJLRdS7vZLMUZNvX7GCac1JVWrHvRAXQhff1YlgkX0XcHN5njxKUjdrWeOc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=XOsltwrs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="XOsltwrs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F14FFC32782;
	Wed, 31 Jul 2024 00:39:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1722386378;
	bh=dSYzzbJ/sBt3hVN04H4CYSnR/VuxMLsAXxn+a6RmQaU=;
	h=Date:To:From:Subject:From;
	b=XOsltwrsEJC003Gn+dCiCSSj77ve4yMNbpRfSG4obYpQejoxI8jLvuhopH79cnQ7Q
	 mYhkhAUhfIF0Qam7sSAr3nsgi08WMjIpgSXnVOQvce08eoVMejSUgbO8kqi3KwON1J
	 UYIdFVoYxHsmQONHfP6zrGnEdou3V3ZjjK5ebnE8=
Date: Tue, 30 Jul 2024 17:39:37 -0700
To: mm-commits@vger.kernel.org,xuanzhuo@linux.alibaba.com,vbabka@suse.cz,urezki@gmail.com,torvalds@linux-foundation.org,roman.gushchin@linux.dev,rientjes@google.com,penberg@kernel.org,mst@redhat.com,mhocko@suse.com,maxime.coquelin@redhat.com,lstoakes@gmail.com,kees@kernel.org,jasowang@redhat.com,iamjoonsoo.kim@lge.com,hch@infradead.org,hailong.liu@oppo.com,eperezma@redhat.com,cl@linux.com,42.hyeyoo@gmail.com,v-songbaohua@oppo.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-bug_on-to-avoid-null-deference-while-__gfp_nofail-fails.patch added to mm-unstable branch
Message-Id: <20240731003937.F14FFC32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: BUG_ON to avoid NULL deference while __GFP_NOFAIL fails
has been added to the -mm mm-unstable branch.  Its filename is
     mm-bug_on-to-avoid-null-deference-while-__gfp_nofail-fails.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-bug_on-to-avoid-null-deference-while-__gfp_nofail-fails.patch

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
Subject: mm: BUG_ON to avoid NULL deference while __GFP_NOFAIL fails
Date: Wed, 31 Jul 2024 12:01:54 +1200

We have cases we still fail though callers might have __GFP_NOFAIL.  Since
they don't check the return, we are exposed to the security risks for NULL
deference.

Though BUG_ON() is not encouraged by Linus, this is an unrecoverable
situation.

Christoph Hellwig:
The whole freaking point of __GFP_NOFAIL is that callers don't handle
allocation failures.  So in fact a straight BUG is the right thing
here.

Vlastimil Babka:
It's just not a recoverable situation (WARN_ON is for recoverable
situations). The caller cannot handle allocation failure and at the same
time asked for an impossible allocation. BUG_ON() is a guaranteed oops
with stracktrace etc. We don't need to hope for the later NULL pointer
dereference (which might if really unlucky happen from a different
context where it's no longer obvious what lead to the allocation failing).

Michal Hocko:
Linus tends to be against adding new BUG() calls unless the failure is
absolutely unrecoverable (e.g. corrupted data structures etc.). I am
not sure how he would look at simply incorrect memory allocator usage to
blow up the kernel. Now the argument could be made that those failures
could cause subtle memory corruptions or even be exploitable which might
be a sufficient reason to stop them early.

Link: https://lkml.kernel.org/r/20240731000155.109583-4-21cnbao@gmail.com
Signed-off-by: Barry Song <v-songbaohua@oppo.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Uladzislau Rezki (Sony) <urezki@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Kees Cook <kees@kernel.org>
Cc: "Eugenio Pérez" <eperezma@redhat.com>
Cc: Hailong.Liu <hailong.liu@oppo.com>
Cc: Jason Wang <jasowang@redhat.com>
Cc: Maxime Coquelin <maxime.coquelin@redhat.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/slab.h |    4 +++-
 mm/page_alloc.c      |    4 +++-
 mm/util.c            |    1 +
 3 files changed, 7 insertions(+), 2 deletions(-)

--- a/include/linux/slab.h~mm-bug_on-to-avoid-null-deference-while-__gfp_nofail-fails
+++ a/include/linux/slab.h
@@ -827,8 +827,10 @@ kvmalloc_array_node_noprof(size_t n, siz
 {
 	size_t bytes;
 
-	if (unlikely(check_mul_overflow(n, size, &bytes)))
+	if (unlikely(check_mul_overflow(n, size, &bytes))) {
+		BUG_ON(flags & __GFP_NOFAIL);
 		return NULL;
+	}
 
 	return kvmalloc_node_noprof(bytes, flags, node);
 }
--- a/mm/page_alloc.c~mm-bug_on-to-avoid-null-deference-while-__gfp_nofail-fails
+++ a/mm/page_alloc.c
@@ -4673,8 +4673,10 @@ struct page *__alloc_pages_noprof(gfp_t
 	 * There are several places where we assume that the order value is sane
 	 * so bail out early if the request is out of bound.
 	 */
-	if (WARN_ON_ONCE_GFP(order > MAX_PAGE_ORDER, gfp))
+	if (WARN_ON_ONCE_GFP(order > MAX_PAGE_ORDER, gfp)) {
+		BUG_ON(gfp & __GFP_NOFAIL);
 		return NULL;
+	}
 
 	gfp &= gfp_allowed_mask;
 	/*
--- a/mm/util.c~mm-bug_on-to-avoid-null-deference-while-__gfp_nofail-fails
+++ a/mm/util.c
@@ -667,6 +667,7 @@ void *__kvmalloc_node_noprof(DECL_BUCKET
 
 	/* Don't even allow crazy sizes */
 	if (unlikely(size > INT_MAX)) {
+		BUG_ON(flags & __GFP_NOFAIL);
 		WARN_ON_ONCE(!(flags & __GFP_NOWARN));
 		return NULL;
 	}
_

Patches currently in -mm which might be from v-songbaohua@oppo.com are

mm-extend-usage-parameter-so-that-cluster_swap_free_nr-can-be-reused.patch
mm-swap-add-nr-argument-in-swapcache_prepare-and-swapcache_clear-to-support-large-folios.patch
vpda-try-to-fix-the-potential-crash-due-to-misusing-__gfp_nofail.patch
mm-document-__gfp_nofail-must-be-blockable.patch
mm-bug_on-to-avoid-null-deference-while-__gfp_nofail-fails.patch
mm-prohibit-null-deference-exposed-for-unsupported-non-blockable-__gfp_nofail.patch

