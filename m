Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794546449;
	b=tbzRXC3GftRdLpb70D3+rr+9nrY/+GDXd5IH4yjl+Bn1Z1ydDu4h3hj7VX4pobaiKeSI
	 XR6VRAWdUakv5gHLIbWsyxZuT+JnMouAxgRI21Ws496URMwFvNwn3SeG1QWIai2GM7hqe
	 7L2vtK9s/m+iAI7Ajn9KTbeHEpTm690CgO3hL+gV2/1zOI61iu6clnc3SJjgbn8mSBde8
	 Pec5ah67I57R7+aRjpbS+7w6Scdc4sdp8BWlcuzFBlUOhdJme6Mg7ImFDAIXE+IJPGVaw
	 xafVoTH7QLQYVaul5EZPs30d97kMvkhkuLhkzsrl3JkRzCfPMt1h/ROCHA6asuUV5yQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794546449;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=FgQTYmGcfeLyshhKwQIF8Ia+yLO8lvdeNYghbl0j2UI=;
	b=KS9/BpK6r1BCxlmBMDZWGj+NPWLdrTBGT+BECh9DSHTsQmn0w1l4GDvwODMZtKdRxnTN
	 QaB7YU5M/Bx9ilB5hQOPaN8g0eSbdCQWxeVOslvGdyr1ynUOLSE1iyHct5apT5TrlTthP
	 QiJfy78q6N3TxtRhm4sUgKso0LMN+YA6xYIFqANXQcN2+EuZL/pVaLJXxl6MqJW2yOLUE
	 GBZGSgai60U9u9oTfl8WievgTktgSW53CdloK0rmmyTzciLt7r8mNab8NzOwtBmPLsd2g
	 yDMT9Dj3iTQ/bo+FdOKMdr2yOjTgVULUmLhDF8T5DHf/EtHuWFYjTb0wSfJ1GHMezLw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=GmGRqqWf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1F12606A321
	for <mm-commits@vger.kernel.org>; Fri, 13 Nov 2026 05:07:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=GmGRqqWf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51BD21F000C5;
	Fri, 13 Nov 2026 05:07:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794546449;
	bh=FgQTYmGcfeLyshhKwQIF8Ia+yLO8lvdeNYghbl0j2UI=;
	h=Date:To:From:Subject;
	b=GmGRqqWf8qt3GTqgdGc3CNNfMcjT48crO0rSMfQziOHy+GJiOM36RtiNB39AppG+P
	 gX8sirxXvWvI6H/ojcrbOiOg+xn700AljaiVn5avofQdOSBAx5CHyFjc+Jv9prp0A4
	 O/rRojqhxOLMOcbVP5yjeCI9NSRWvznc7ucG9aUE=
Date: Thu, 12 Nov 2026 21:07:28 -0800
To: mm-commits@vger.kernel.org,shakeel.butt@linux.dev,
	roman.gushchin@linux.dev,qi.zheng@linux.dev,muchun.song@linux.dev,
	mhocko@kernel.org,mason@kernel.org,hannes@cmpxchg.org,david@kernel.org,
	david@fromorbit.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-list_lru-dont-use-a-new-memcgs-lists-for-an-offline-memcg-fix.patch added to mm-hotfixes-unstable branch
Message-Id: <20261113050729.51BD21F000C5@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm/list_lru: verify memcg owner before skipping allocation
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-list_lru-dont-use-a-new-memcgs-lists-for-an-offline-memcg-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-list_lru-dont-use-a-new-memcgs-lists-for-an-offline-memcg-fix.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm/list_lru: verify memcg owner before skipping allocation
Date: Thu, 12 Nov 2026 16:08:59 -0800

list_lru_from_memcg() rejects an entry at a reused kmemcg_id when it
belongs to another memcg.  memcg_list_lru_allocated() still treats any
entry at that index as a list for the requested memcg.  Its callers can
therefore skip the allocation of that memcg's ancestor lists.

With child C and parent P's lists both unallocated, a reader can retain C
while it is offlined.  If an unrelated new memcg reuses C's ID and
allocates its own list, the reader mistakes that entry for C's and skips
allocation of P's list.  Once the folio's objcg points to P,
deferred_split_folio() can add it to the root list.  If P later gets a
list, unqueue locks P's list while unlinking the folio from root's list,
which can corrupt that list under concurrent operations.

Require the entry to belong to the requested memcg before returning true. 
Hold RCU over the XArray load and owner comparison because this helper is
also called outside the folio fast path's RCU section.

Link: https://lore.kernel.org/20261112161502.18d9d72c0139b8f69bb88ff4@linux-foundation.org
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Reported-by: <sashiko-bot@kernel.org>
Closes: https://lore.kernel.org/sashiko-outbox-211977@kernel.org
Cc: Chris Mason <mason@kernel.org>
Cc: Dave Chinner <david@fromorbit.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Qi Zheng <qi.zheng@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
---

 mm/list_lru.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

--- a/mm/list_lru.c~mm-list_lru-dont-use-a-new-memcgs-lists-for-an-offline-memcg-fix
+++ a/mm/list_lru.c
@@ -568,9 +568,19 @@ void memcg_reparent_list_lrus(struct mem
 static inline bool memcg_list_lru_allocated(struct mem_cgroup *memcg,
 					    struct list_lru *lru)
 {
+	struct list_lru_memcg *mlru;
+	bool allocated;
 	int idx = memcg->kmemcg_id;
 
-	return idx < 0 || xa_load(&lru->xa, idx);
+	if (idx < 0)
+		return true;
+
+	rcu_read_lock();
+	mlru = xa_load(&lru->xa, idx);
+	allocated = mlru && mlru->memcg == memcg;
+	rcu_read_unlock();
+
+	return allocated;
 }
 
 static int __memcg_list_lru_alloc(struct mem_cgroup *memcg,
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-list_lru-dont-use-a-new-memcgs-lists-for-an-offline-memcg-fix.patch
shmem-consume-the-reserved-xattr-space-despite-remount.patch
selftests-mm-check-madv_cold-and-madv_pageout-on-partly-advised-thps-fix.patch
alloc_tag-introduce-ioctls-to-toggle-allocation-tracepoints-fix-fix.patch
alloc_tag-introduce-ioctls-to-toggle-allocation-tracepoints-fix.patch
selftests-mm-add-uffdio_move-huge-zeropage-pmd-regression-test-fix.patch
profile-account-for-partial-proc-profile-reads.patch
profile-simplify-proc-profile-read-layout.patch
ipc-msg-clamp-negative-msg_info-usage-counts.patch
squashfs-fix-leaked-page-locks-when-page-actor-allocation-fails-fix.patch
drivers-media-v4l2-core-v4l2-vp9c-reduce-inlining.patch

