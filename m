Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6132A3A9623
	for <mm-commits@vger.kernel.org>; Wed, 14 Jan 2026 22:05:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768428307; cv=none; b=M0V+idGvhsVA00Xo5Pl6Jr/WlXAki6mp8OwIg89MWurcBjaeK/bxDsg7J2A0mYNw70eyNw2KXSWInSKegADLyFKqtkXPoW9k0anl+Htdb9ZZ+JDuQUKnF6jFa8lA8317LBcjKskleVxko6l7gdvwaG3gyUKX9MoH0nrwpV1fDKM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768428307; c=relaxed/simple;
	bh=hzAl6V9ZcgPCk1cV8KaPyl6ArqnbREDNEicyHo4ftMo=;
	h=Date:To:From:Subject:Message-Id; b=D+HCt1h129y3vt62XqYpNwvdHiF3WwcS16SUCTvdUE+/BYK8ELLDLSljQ4YK2lTRHwEUqvXDdLfXq7UjRZ6wpMUrs18AKjWS1YqpEvRaSSzdxdi77aRPxEJAI8HrE89ZmX9FnoBS/v9JuIXnCn6U2m3b1qx9t2LeDiTgHU+FQ3I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=A/wgnBY+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="A/wgnBY+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E8B1C4CEF7;
	Wed, 14 Jan 2026 22:05:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768428306;
	bh=hzAl6V9ZcgPCk1cV8KaPyl6ArqnbREDNEicyHo4ftMo=;
	h=Date:To:From:Subject:From;
	b=A/wgnBY+X/8aW6WCQD9jz0hpQGUrjVrB34CWP0JrwQyoX3dZDa+zJElBVFULvmCy4
	 1raGlTfF/+2PaZD742pCikFY60tLaFkinUh+yYV8lO9ySYjmpyXkuJNwoQQgujDElm
	 CGyx6/MbAdYoLz1D+bN2MVU0f4dMqS/ctFeBWnSk=
Date: Wed, 14 Jan 2026 14:05:05 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,yury.norov@gmail.com,ying.huang@linux.alibaba.com,vbabka@suse.cz,tj@kernel.org,surenb@google.com,rppt@kernel.org,rakie.kim@sk.com,mkoutny@suse.com,mhocko@suse.com,matthew.brost@intel.com,lorenzo.stoakes@oracle.com,longman@redhat.com,linux@rasmusvillemoes.dk,liam.howlett@oracle.com,joshua.hahnjy@gmail.com,hannes@cmpxchg.org,gourry@gourry.net,david@kernel.org,byungchul@sk.com,apopple@nvidia.com,ynorov@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + nodemask-propagate-boolean-for-nodes_andnot.patch added to mm-new branch
Message-Id: <20260114220506.8E8B1C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: nodemask: propagate boolean for nodes_and{,not}
has been added to the -mm mm-new branch.  Its filename is
     nodemask-propagate-boolean-for-nodes_andnot.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/nodemask-propagate-boolean-for-nodes_andnot.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

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
From: Yury Norov <ynorov@nvidia.com>
Subject: nodemask: propagate boolean for nodes_and{,not}
Date: Wed, 14 Jan 2026 12:22:13 -0500

Patch series "nodemask: align nodes_and{,not} with underlying bitmap ops".

nodes_and{,not} are void despite that underlying bitmap_and(,not) return
boolean, true if the result bitmap is non-empty.  Align nodemask API, and
simplify client code.


This patch (of 3):

Bitmap functions bitmap_and{,not} return boolean depending on emptiness of
the result bitmap.  The corresponding nodemask helpers ignore the returned
value.

Propagate the underlying bitmaps result to nodemasks users, as it
simplifies user code.

Link: https://lkml.kernel.org/r/20260114172217.861204-1-ynorov@nvidia.com
Link: https://lkml.kernel.org/r/20260114172217.861204-2-ynorov@nvidia.com
Signed-off-by: Yury Norov <ynorov@nvidia.com>
Reviewed-by: Gregory Price <gourry@gourry.net>
Reviewed-by: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Byungchul Park <byungchul@sk.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Mathew Brost <matthew.brost@intel.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Michal Koutný <mkoutny@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Waiman Long <longman@redhat.com>
Cc: Yury Norov (NVIDIA) <yury.norov@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/nodemask.h |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/include/linux/nodemask.h~nodemask-propagate-boolean-for-nodes_andnot
+++ a/include/linux/nodemask.h
@@ -157,10 +157,10 @@ static __always_inline bool __node_test_
 
 #define nodes_and(dst, src1, src2) \
 			__nodes_and(&(dst), &(src1), &(src2), MAX_NUMNODES)
-static __always_inline void __nodes_and(nodemask_t *dstp, const nodemask_t *src1p,
+static __always_inline bool __nodes_and(nodemask_t *dstp, const nodemask_t *src1p,
 					const nodemask_t *src2p, unsigned int nbits)
 {
-	bitmap_and(dstp->bits, src1p->bits, src2p->bits, nbits);
+	return bitmap_and(dstp->bits, src1p->bits, src2p->bits, nbits);
 }
 
 #define nodes_or(dst, src1, src2) \
@@ -181,10 +181,10 @@ static __always_inline void __nodes_xor(
 
 #define nodes_andnot(dst, src1, src2) \
 			__nodes_andnot(&(dst), &(src1), &(src2), MAX_NUMNODES)
-static __always_inline void __nodes_andnot(nodemask_t *dstp, const nodemask_t *src1p,
+static __always_inline bool __nodes_andnot(nodemask_t *dstp, const nodemask_t *src1p,
 					const nodemask_t *src2p, unsigned int nbits)
 {
-	bitmap_andnot(dstp->bits, src1p->bits, src2p->bits, nbits);
+	return bitmap_andnot(dstp->bits, src1p->bits, src2p->bits, nbits);
 }
 
 #define nodes_copy(dst, src) __nodes_copy(&(dst), &(src), MAX_NUMNODES)
_

Patches currently in -mm which might be from ynorov@nvidia.com are

nodemask-propagate-boolean-for-nodes_andnot.patch
mm-use-nodes_and-return-value-to-simplify-client-code.patch
cgroup-use-nodes_and-output-where-appropriate.patch

