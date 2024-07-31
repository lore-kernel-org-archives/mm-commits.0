Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EEE14C80
	for <mm-commits@vger.kernel.org>; Wed, 31 Jul 2024 00:39:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722386381; cv=none; b=MOLkPbb86a7dXwf3rhmj7m8H1FuZOVQoDLG4SDLzZc+BKEk/TRlIY5fWM+AVHUMLuZFIBf/z1RAhgMjn94L+inAWl/srW76jmaDlPWDS6d8QJcq2j74Odksv08wBWVtYiPHAlVXLflFtuGFBZrNeSQkV1RO+wqqw4Zc8V0VaOBc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722386381; c=relaxed/simple;
	bh=przTzxwouz2jxj9VRABZiDF3/xUnSCWudoqgqCp0MU8=;
	h=Date:To:From:Subject:Message-Id; b=mvHV6aaW1FaQ9wuB7dVqXHjzZc1VNjKK3F6kUjHQ/ld6SOT2jko0auYzaVzLoEis+43iOP7QKHgtPcvYu9WCdfxNRA6GyrYRnhdVO1egFVKG18caO0OoYdJkmTe2wlfvfRYTrEMU+/HhMmXHdA/3hsnC2sf22Oc7uJjvsyNjJjE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=v7ABdd3a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="v7ABdd3a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C293CC32782;
	Wed, 31 Jul 2024 00:39:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1722386380;
	bh=przTzxwouz2jxj9VRABZiDF3/xUnSCWudoqgqCp0MU8=;
	h=Date:To:From:Subject:From;
	b=v7ABdd3ayq1+xvT8xcBAdKyEmNOJX/RcsTi/XQLU056JZxRwhX4WTls8tV+IMZ+x0
	 PVxqT93v5NltGXwbs6UAKG1/B0CtLBRfD648lGaRaC1OmY1zp93fy62OpaB2Lc7pPq
	 gwUq5giWpnA3WHzhwiulIhnyJBmy+9rQapLSqkUg=
Date: Tue, 30 Jul 2024 17:39:40 -0700
To: mm-commits@vger.kernel.org,xuanzhuo@linux.alibaba.com,vbabka@suse.cz,urezki@gmail.com,torvalds@linux-foundation.org,roman.gushchin@linux.dev,rientjes@google.com,penberg@kernel.org,mst@redhat.com,mhocko@suse.com,maxime.coquelin@redhat.com,lstoakes@gmail.com,kees@kernel.org,jasowang@redhat.com,iamjoonsoo.kim@lge.com,hch@infradead.org,hailong.liu@oppo.com,eperezma@redhat.com,cl@linux.com,42.hyeyoo@gmail.com,v-songbaohua@oppo.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-prohibit-null-deference-exposed-for-unsupported-non-blockable-__gfp_nofail.patch added to mm-unstable branch
Message-Id: <20240731003940.C293CC32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: prohibit NULL deference exposed for unsupported non-blockable __GFP_NOFAIL
has been added to the -mm mm-unstable branch.  Its filename is
     mm-prohibit-null-deference-exposed-for-unsupported-non-blockable-__gfp_nofail.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-prohibit-null-deference-exposed-for-unsupported-non-blockable-__gfp_nofail.patch

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
Subject: mm: prohibit NULL deference exposed for unsupported non-blockable __GFP_NOFAIL
Date: Wed, 31 Jul 2024 12:01:55 +1200

When users allocate memory with the __GFP_NOFAIL flag, they might
incorrectly use it alongside GFP_ATOMIC, GFP_NOWAIT, etc.  This kind of
non-blockable __GFP_NOFAIL is not supported and is pointless.  If we
attempt and still fail to allocate memory for these users, we have two
choices:

    1. We could busy-loop and hope that some other direct reclamation or
    kswapd rescues the current process. However, this is unreliable
    and could ultimately lead to hard or soft lockups, which might not
    be well supported by some architectures.

    2. We could use BUG_ON to trigger a reliable system crash, avoiding
    exposing NULL dereference.

This patch chooses the second option because the first is unreliable. 
Even if the process incorrectly using __GFP_NOFAIL is sometimes rescued,
the long latency might be unacceptable, especially considering that
misusing GFP_ATOMIC and __GFP_NOFAIL is likely to occur in atomic contexts
with strict timing requirements.

Link: https://lkml.kernel.org/r/20240731000155.109583-5-21cnbao@gmail.com
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

 mm/page_alloc.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/mm/page_alloc.c~mm-prohibit-null-deference-exposed-for-unsupported-non-blockable-__gfp_nofail
+++ a/mm/page_alloc.c
@@ -4404,11 +4404,11 @@ nopage:
 	 */
 	if (gfp_mask & __GFP_NOFAIL) {
 		/*
-		 * All existing users of the __GFP_NOFAIL are blockable, so warn
-		 * of any new users that actually require GFP_NOWAIT
+		 * All existing users of the __GFP_NOFAIL are blockable
+		 * otherwise we introduce a busy loop with inside the page
+		 * allocator from non-sleepable contexts
 		 */
-		if (WARN_ON_ONCE_GFP(!can_direct_reclaim, gfp_mask))
-			goto fail;
+		BUG_ON(!can_direct_reclaim);
 
 		/*
 		 * PF_MEMALLOC request from this context is rather bizarre
@@ -4439,7 +4439,7 @@ nopage:
 		cond_resched();
 		goto retry;
 	}
-fail:
+
 	warn_alloc(gfp_mask, ac->nodemask,
 			"page allocation failure: order:%u", order);
 got_pg:
_

Patches currently in -mm which might be from v-songbaohua@oppo.com are

mm-extend-usage-parameter-so-that-cluster_swap_free_nr-can-be-reused.patch
mm-swap-add-nr-argument-in-swapcache_prepare-and-swapcache_clear-to-support-large-folios.patch
vpda-try-to-fix-the-potential-crash-due-to-misusing-__gfp_nofail.patch
mm-document-__gfp_nofail-must-be-blockable.patch
mm-bug_on-to-avoid-null-deference-while-__gfp_nofail-fails.patch
mm-prohibit-null-deference-exposed-for-unsupported-non-blockable-__gfp_nofail.patch

