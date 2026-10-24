Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792832283;
	b=ns4tEHtuYOra0UPY2ugALcdva30j63XVN1+rW7urgReRVirxdZNd6gAgjizs52Pwiw1N
	 DOYUKQF7VEPof1FZLlYnJF8IoGltt8eNcL6s1YeroUmiQ49tK7j9BQ/6EMFNT8ivVmPVU
	 HX9uT89q3kZ9BTAs+wxJhKeZNiFHbUR4xSrfeojcNzMPRd2bf0CGRYZ5arZ5cIKRbkDVr
	 bq/5C+jVYW/Mozevo5an2or5yn2ONjPP0GwRpZj5RSb4FZ191n83g9lO88VgcvvgIxbv+
	 C4N1f6Cbs0L7lusWtgIOFFXvOzRQnN4pZE8Mb5yatFjMxZ3Em29ucDSCUGQdIGW31ig==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792832283;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=hadey08sajJamprwUuhgBgAL3kN7/dr+JxYsSBaCPKY=;
	b=LbrLg/uoz6F26rDfm22E1thScgPNb3SFQmeosKxwp3wogrShvvkAYw953h/pkvFSe1j5
	 47I7q02bkpLtNuQ357qJ7DdeEIST2Xb7H2lTNCJDC9kdTalFscBp1NIq/8NffpsJmTICJ
	 9vw8+m7NQCW90O/ptmUsGcUDHoDql04QnztTLlRdN+gadXNK28d1O+pbDrI5qPRwj+4G2
	 7r08CpDbi/F4mzl4JJu8eLwMRT8e/s+0iq0xenBLBw7PoOU95QamLQvdq99KI0hyw3pxt
	 Ch4XkZ1m91f8M1bE9+ipdA3lcddwSef+894ofvFQBi7i6CL8SB3gLdTSm3P6NsYIDHw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=z9QFCwlH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7F4E606A31B
	for <mm-commits@vger.kernel.org>; Sat, 24 Oct 2026 08:58:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=z9QFCwlH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A38031F01825;
	Sat, 24 Oct 2026 08:58:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792832282;
	bh=hadey08sajJamprwUuhgBgAL3kN7/dr+JxYsSBaCPKY=;
	h=Date:To:From:Subject;
	b=z9QFCwlHA3uCOqLfjY5s8lMKxIEFf9lwzU3gWTMuoybVXpF0W+CEpANCh2Xw0i1XE
	 qZ6LVfKsmzApHlvCNMgiGQZNO8GCs/nBManLD3RPJ14hA2JI6ZmRr3adBzfkeSK9n6
	 xab2SY42qqY4KyR73qgkorh5d0lhlqLbzvQOCWqQ=
Date: Sat, 24 Oct 2026 01:58:02 -0700
To: mm-commits@vger.kernel.org,urezki@gmail.com,syzbot+442828bb356b10813a47@syzkaller.appspotmail.com,shuah@kernel.org,me@brighamcampbell.com,dev.jain@arm.com,baoquan.he@linux.dev,akpm@linux-foundation.org,raghunathpalla.0209@gmail.com
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-vmalloc-do-not-warn-on-enomem-from-va_clip-in-pcpu_get_vm_areas.patch removed from -mm tree
Message-Id: <20261024085802.A38031F01825@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: mm/vmalloc: do not warn on -ENOMEM from va_clip() in pcpu_get_vm_areas()
has been removed from the -mm tree.  Its filename was
     mm-vmalloc-do-not-warn-on-enomem-from-va_clip-in-pcpu_get_vm_areas.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Palla Raghunath <raghunathpalla.0209@gmail.com>
Subject: mm/vmalloc: do not warn on -ENOMEM from va_clip() in pcpu_get_vm_areas()
Date: Fri, 25 Sep 2026 21:54:49 +0100

When pcpu_get_vm_areas() has to split a free vmap_area in the middle
(NE_FIT_TYPE), va_clip() needs an extra vmap_area object. It takes the
per-cpu ne_fit_preload_node if one is there, and otherwise falls back
to kmem_cache_alloc(GFP_NOWAIT), which may fail and return -ENOMEM.
pcpu_get_vm_areas() never preloads, and a single call can do more than
one such split: on a NUMA system it places one area per node group, so
the first split consumes the preloaded object and the next one depends
on the GFP_NOWAIT allocation.

That failure is expected and already handled: the recovery path returns
the areas clipped so far to the free tree, purges lazily freed areas and
retries. But the error is checked with WARN_ON_ONCE(), so a transient
allocation failure under memory pressure or fault injection triggers a
kernel warning, and a panic with panic_on_warn. syzbot hit this on a
two-node VM while creating a per-cpu BPF array map.

Keep the WARN_ON_ONCE() for errors other than -ENOMEM, which do indicate
a bug, and take the recovery path either way. This matches what commit
b9183788a2de ("mm/vmalloc: do not warn on -ENOMEM from va_alloc()") did
for the other va_clip() caller.

Link: https://lore.kernel.org/20260925205450.21262-1-raghunathpalla.0209@gmail.com
Fixes: 1b23ff80b399 ("mm/vmalloc: invoke classify_va_fit_type() in adjust_va_to_fit_type()")
Signed-off-by: Palla Raghunath <raghunathpalla.0209@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reported-by: <syzbot+442828bb356b10813a47@syzkaller.appspotmail.com>
Closes: https://syzkaller.appspot.com/bug?extid=442828bb356b10813a47
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Reviewed-by: Dev Jain <dev.jain@arm.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Brigham Campbell <me@brighamcampbell.com>
Cc: Baoquan He <baoquan.he@linux.dev>
---

 mm/vmalloc.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/mm/vmalloc.c~mm-vmalloc-do-not-warn-on-enomem-from-va_clip-in-pcpu_get_vm_areas
+++ a/mm/vmalloc.c
@@ -5122,9 +5122,14 @@ retry:
 
 		ret = va_clip(&free_vmap_area_root,
 			&free_vmap_area_list, va, start, size);
-		if (WARN_ON_ONCE(unlikely(ret)))
-			/* It is a BUG(), but trigger recovery instead. */
+		if (unlikely(ret)) {
+			/*
+			 * -ENOMEM from the GFP_NOWAIT fallback is expected.
+			 * Anything else is a BUG(), but trigger recovery instead.
+			 */
+			WARN_ON_ONCE(ret != -ENOMEM);
 			goto recovery;
+		}
 
 		/* Allocated area. */
 		va = vas[area];
_

Patches currently in -mm which might be from raghunathpalla.0209@gmail.com are


