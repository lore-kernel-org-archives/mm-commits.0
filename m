Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795388414;
	b=hct5nBvoKzt7kYOt1PTZN1b7uCif33E70OGau3BlV02txnXNt51GDqNA6F6jH+M2YdhB
	 ItlQaT4pyFyQrrzZb0OCh1Ce6uCV9jmO1RktOEc8pKqo9Xvgj5MSycuwd7Z6Uo2aBBHD2
	 YzdMAWoSoUvQalkO+vZ3VTU1kfDw9CRdufgxW4FWaghP9cLY3t4V+WGNxqtMFjqwlqBO8
	 aj+ZeHAWx2MR9uUaXFJTq71HkHuzhgzC1g9SYw2tZblWAOcqo4K4byUtz5B2y/4tHofO+
	 Nhts47tsSc3WoIfg8hHrzeDXH7goltsDNZmJibi0NHv3yAocXO1WHlf2dyW4uKS23Jg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795388414;
	h=Received:DKIM-Signature:Date:To:From:In-Reply-To:References:Subject:
	 Message-Id;
	bh=VhKP+/MQutg0Bszjfs5xb29ASUGYeBXd3PTCVceqGu8=;
	b=oY3nrUFPyiqnDriUC833A0q0fTwd+nIqhJYOQqPaejZjGEYUuhML4zVJyCstSNp6A2NB
	 5bZzg12lV/pcRDU5Sjx9o1bIbUXwsfxScr49+QcEU6oVVZ8zazncFD3Yw7OsdBCJwAJXp
	 ynvas90RMTQpS5K9Rck6ThJ7aKnQFwSN6uiVreVhVYTu8EwUxeR90yKGDOttINWSA+cqK
	 R22/mShMztZqo5rFgZIo6AFYix4bLCKuc62o7ovtUNovU6IoggN70YGXdklO89XXYduu7
	 nGDfQe4tJ7eIALSQnru7Lxi+be+rjIWzcAAcRdITlfG+ZojysLnDbFifangV3X2IWkA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=wz+1WRxL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 075EF606A32A;
	Sun, 22 Nov 2026 23:00:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=wz+1WRxL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BB8F1F000C4;
	Sun, 22 Nov 2026 23:00:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795388413;
	bh=VhKP+/MQutg0Bszjfs5xb29ASUGYeBXd3PTCVceqGu8=;
	h=Date:To:From:In-Reply-To:References:Subject;
	b=wz+1WRxLu/WeW+KXBUqA5k4Mp8t/P0stqIsTZKoKKEBz4UNWyziJg28WQOF+jvFa4
	 xHbUdCxipfKM96nn+2BPQsaF2LjYDSsfQGwogHIQqCgFNlrepyVzWdbb2EWJafaVwF
	 +VBGnqbcACCGj9TN4ZOjdKSs7tk6fFKrP4oxwJ2Y=
Date: Sun, 22 Nov 2026 15:00:12 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,shakeel.butt@linux.dev,
	roman.gushchin@linux.dev,qi.zheng@linux.dev,kasong@tencent.com,
	david@fromorbit.com,azpijr@gmail.com,songmuchun@bytedance.com,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20261122031143.3639941-1-songmuchun@bytedance.com>
References: <20261122031143.3639941-1-songmuchun@bytedance.com>
Subject: + mm-list_lru-fix-potential-infinite-loop-on-xa-node-allocation-failure.patch added to mm-new branch
Message-Id: <20261122230013.3BB8F1F000C4@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm/list_lru: fix potential infinite loop on xa node allocation failure
has been added to the -mm mm-new branch.  Its filename is
     mm-list_lru-fix-potential-infinite-loop-on-xa-node-allocation-failure.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-list_lru-fix-potential-infinite-loop-on-xa-node-allocation-failure.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Muchun Song <songmuchun@bytedance.com>
Subject: mm/list_lru: fix potential infinite loop on xa node allocation failure
Date: Sun, 22 Nov 2026 11:11:43 +0800

__memcg_list_lru_alloc() populates missing list_lru_memcg entries
top-down, from the farthest unpopulated ancestor down to @memcg.  When
storing the entry for an ancestor (pos != memcg) needs a new xa_node,
xas_store() sets XA_ERROR(-ENOMEM) and leaves @pos unpopulated.

If the following xas_nomem() also fails to allocate, the inner loop exits
with the error still set, but the outer loop ignores it and reruns on the
same unpopulated ancestor: xas_set() then resets the state to XAS_RESTART
and retries the store.

A one-off failure is recovered on that retry, but as long as the
allocation keeps failing, e.g.  under sustained memory pressure, the loop
makes no progress and, with no schedule point, becomes an RCU stall / hard
lockup when the caller holds mapping->i_pages.xa_lock with IRQs disabled.

Stop the outer walk when xas_error() is set so the existing cleanup frees
@mlru and the error is propagated to the caller.

Link: https://patch.msgid.link/20261122031143.3639941-1-songmuchun@bytedance.com
Fixes: 28e98022b31e ("mm/list_lru: simplify reparenting and initial allocation")
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/bug/linux-21c1dba9-8d6f-4368-b38b-9a57cacb056f
Acked-by: Qi Zheng <qi.zheng@linux.dev>
Reviewed-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Kairui Song <kasong@tencent.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: <stable@vger.kernel.org>

 mm/list_lru.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/list_lru.c~mm-list_lru-fix-potential-infinite-loop-on-xa-node-allocation-failure
+++ a/mm/list_lru.c
@@ -626,7 +626,7 @@ static int __memcg_list_lru_alloc(struct
 			}
 			xas_unlock_irqrestore(&xas, flags);
 		} while (xas_nomem(&xas, gfp));
-	} while (pos != memcg && !css_is_dying(&pos->css));
+	} while (pos != memcg && !css_is_dying(&pos->css) && !xas_error(&xas));
 
 	if (unlikely(mlru))
 		kfree(mlru);
_

Patches currently in -mm which might be from songmuchun@bytedance.com are

powerpc-mm-make-vmemmap_populate_compound_pages-static.patch
powerpc-mm-drop-powerpc-vmemmap_can_optimize.patch
mm-sparse-vmemmap-drop-vmemmap_can_optimize.patch
mm-sparse-vmemmap-drop-pgmap-from-vmemmap-population-apis.patch
mm-hugetlb_vmemmap-fix-hwpoison-state-races-during-optimization.patch
mm-hugetlb_vmemmap-fix-pmd-split-tlb-flush-race.patch
mm-hugetlb_vmemmap-fix-deadlock-during-pmd-split.patch
mm-list_lru-fix-potential-infinite-loop-on-xa-node-allocation-failure.patch

