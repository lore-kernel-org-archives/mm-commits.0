Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795572383;
	b=a4fPEXKKDnfXinhDdt8CfJ6FuUZdx8CXq0uuQ8kKVuGmVjrh/GyCG6lCnaH4pvTg2aJe
	 Cubjfh99mSB10qWTkZ0cte8F21X/iGMgevCjeFRjbFM1Cmt2g61ghiKmpK0OVlzncn3iy
	 ABuWQvEHSuyC+S+vQ0UL8Qn2abTmEvx9LnYgykc7FOGLpHPelA5GtiK6GELEThipAMkie
	 5vidlCgvM0wAW07xZvy9FEdDjiEDy5QXfTawQri+/7R0/3R5cDzM6QOEAjx8AskCh1FI7
	 p1UvdUG70+j7LPANgTmf1jnjXbpXU4yRkjqRrlEqkn1th4Z/ENbCpcV8NQGnh/nEaQg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795572383;
	h=Received:DKIM-Signature:Date:To:From:In-Reply-To:References:Subject:
	 Message-Id;
	bh=DzW4OywvkIOQHGkkTkQSg2ROpxDIzTr7rPoVXr8Svq8=;
	b=Vroo6B81LoBOx5vtPEw3VXPjV6SpZx68cWYfP5/16EX1uvwBpzkIIzO6U937AXn7aECh
	 LEe3tJE7YBmSbUhm56D3gNROudFNDzL3hkFD75/b+r3Tzus0B6BBneuL0RojkbRl62p7x
	 3fXzQEfswqFYbuZwv92db0JsguVImZl0pg83I31Q/v9sRgcQ/NssDrQb4wSUdGNXv+WNW
	 6Xas4tdOgbtBvy7h9wBV53145K3e8YXjOj+w29aCUNss9FuH8Q0WsY+IT/LvQSfyLB78U
	 RYx1QC+1Y2a8NxuvHlUfeFIHROT6RB6/9KMxiev9LM5RXhM5wW45JWEZR6NnXI+I1ag==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=vYdEjZG0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2414F606A330;
	Wed, 25 Nov 2026 02:06:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=vYdEjZG0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A580A1F01577;
	Wed, 25 Nov 2026 02:06:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795572382;
	bh=DzW4OywvkIOQHGkkTkQSg2ROpxDIzTr7rPoVXr8Svq8=;
	h=Date:To:From:In-Reply-To:References:Subject;
	b=vYdEjZG0oeOxfkKo1PsnF7vRFjCxdjjSkIB7az8bY4Hxyt2UG9lmLNUeMu1vNoo3B
	 F9SOiLv6HHePCF9bOAGT6qX58FD3Dj6vt5qUVJT7JeSwWj/MG+vc7pv6VC/U+0lEtf
	 9hiclU3+jeTixb5OBax1CDrhP9yCN9kVJSfZdb3A=
Date: Tue, 24 Nov 2026 18:06:22 -0800
To: mm-commits@vger.kernel.org,tj@kernel.org,stable@vger.kernel.org,
	roman.gushchin@linux.dev,dennis@kernel.org,cl@gentwo.org,
	chriswiseman@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <18e88cd2a725491b.3137322e32332e3235332e313736.c1dd7.0000sendgmr@google.com>
References: <18e88cd2a725491b.3137322e32332e3235332e313736.c1dd7.0000sendgmr@google.com>
Subject: + percpu-skip-sidelined-slot-in-pcpu_balance_populated.patch added to mm-new branch
Message-Id: <20261125020622.A580A1F01577@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: percpu: skip sidelined slot in pcpu_balance_populated()
has been added to the -mm mm-new branch.  Its filename is
     percpu-skip-sidelined-slot-in-pcpu_balance_populated.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/percpu-skip-sidelined-slot-in-pcpu_balance_populated.patch

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
From: Chris Wiseman <chriswiseman@google.com>
Subject: percpu: skip sidelined slot in pcpu_balance_populated()
Date: Mon, 16 Nov 2026 14:28:07 +0000

Commit f183324133ea ("percpu: implement partial chunk depopulation")
placed pcpu_sidelined_slot at __pcpu_size_to_slot(pcpu_unit_size) + 1 and
moved pcpu_free_slot to pcpu_sidelined_slot + 1 so pcpu_alloc() checks
sidelined chunks before free chunks.  pcpu_balance_populated() also loops
from pcpu_size_to_slot(PAGE_SIZE) through pcpu_free_slot, but was not
updated to skip pcpu_sidelined_slot.

When pcpu_nr_empty_pop_pages drops below PCPU_EMPTY_POP_PAGES_HIGH and
active chunks have no unpopulated pages, pcpu_balance_populated() walks
into pcpu_sidelined_slot and repopulates chunks that were just sidelined
to save memory.  Because chunk->isolated is still true on sidelined
chunks, pcpu_update_empty_pages() does not count those newly populated
pages toward pcpu_nr_empty_pop_pages.  That leaves the global empty page
count below the threshold, so subsequent balance passes keep refilling
every sidelined chunk back to 100% before reaching pcpu_free_slot.

Skip pcpu_sidelined_slot in pcpu_balance_populated() so sidelined chunks
stay depopulated until pcpu_alloc() actually needs them.

Benchmark results (4-CPU arm64, 4 sidelined chunks with 60 reclaimed pages
after triggering pcpu_balance_populated()):

   Metric                                    Before     After     Delta
   --------------------------------------------------------------------
   Sidelined pages repopulated                   60         0    -100%
   Sidelined backing pages (kB)                 960         0  -960 kB

Link: https://patch.msgid.link/18e88cd2a725491b.3137322e32332e3235332e313736.c1dd7.0000sendgmr@google.com
Fixes: f183324133ea ("percpu: implement partial chunk depopulation")
Signed-off-by: Chris Wiseman <chriswiseman@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Dennis Zhou <dennis@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Christoph Lameter <cl@gentwo.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: <stable@vger.kernel.org>

 mm/percpu.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/mm/percpu.c~percpu-skip-sidelined-slot-in-pcpu_balance_populated
+++ a/mm/percpu.c
@@ -2022,6 +2022,9 @@ retry_pop:
 		if (!nr_to_pop)
 			break;
 
+		if (slot == pcpu_sidelined_slot)
+			continue;
+
 		list_for_each_entry(chunk, &pcpu_chunk_lists[slot], list) {
 			nr_unpop = chunk->nr_pages - chunk->nr_populated;
 			if (nr_unpop)
_

Patches currently in -mm which might be from chriswiseman@google.com are

percpu-skip-sidelined-slot-in-pcpu_balance_populated.patch

