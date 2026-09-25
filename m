Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F1E63655E0
	for <mm-commits@vger.kernel.org>; Fri, 25 Sep 2026 22:17:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790374680; cv=none; b=VHE173ZqLEADvb44Rnqb1U+2OebknM3HUL4A2tSDt0oUIsW+ZlLvzCdxYANnNYiIz0c6Bs9awm75fgyv4gqExxDQp9Pl45dKUYpc3l76TSRdC1rEKAF6hIXULujueD61uk5OgnhohGA+Al8+z2SzOAK26I0KobTcDDKuUBQhP2U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790374680; c=relaxed/simple;
	bh=Oa0I4plkVAhCg0C0Y1y8K4sqg3VlJHrftNB2b+kJ7VA=;
	h=Date:To:From:Subject:Message-Id; b=NmB5m3ExR9FE6Dr3CdActFM5I/cg+ulvPeXuAfSv9Ko4p9zY4jyZst3vsgMFRZ8yo5aGbKwtsc3EHZf3ckDGcOuPU9KQIFP4p+f53ByNkLdvJ7UFm4uK31E/aJFWKvZoU9TTWGjQHd1GIHh5Prz499xom5kP6H3EbWrvAT875DA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rj1MgsfA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rj1MgsfA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83B631F000FF;
	Fri, 25 Sep 2026 22:17:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1790374678;
	bh=JXEoCTVfhGX5nxUf/1fp+NApMuY5CHT1i2t3YZUa+Qw=;
	h=Date:To:From:Subject;
	b=rj1MgsfAzm/8IMCLj+d+KI+Kr6SQ09146AwsZzIMIonK6Jbl4uXqH5VYvBp7IxfS+
	 CrI3CeRNFkqtKdqRcDHoKozhLfl3pTi+rLTbqGV7rbxowmLswytPJV27NZW1YZre9g
	 ZFcfYSF5InbwgtTYk3XX0NSFMPPCyRgHg+E8MFcI=
Date: Fri, 25 Sep 2026 15:17:58 -0700
To: mm-commits@vger.kernel.org,urezki@gmail.com,syzbot+442828bb356b10813a47@syzkaller.appspotmail.com,shuah@kernel.org,me@brighamcampbell.com,baoquan.he@linux.dev,akpm@linux-foundation.org,raghunathpalla.0209@gmail.com
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmalloc-do-not-warn-on-enomem-from-va_clip-in-pcpu_get_vm_areas.patch added to mm-new branch
Message-Id: <20260925221758.83B631F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/vmalloc: do not warn on -ENOMEM from va_clip() in pcpu_get_vm_areas()
has been added to the -mm mm-new branch.  Its filename is
     mm-vmalloc-do-not-warn-on-enomem-from-va_clip-in-pcpu_get_vm_areas.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmalloc-do-not-warn-on-enomem-from-va_clip-in-pcpu_get_vm_areas.patch

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
Cc: Shuah Khan <shuah@kernel.org>
Cc: Brigham Campbell <me@brighamcampbell.com>
Cc: Uladzislau Rezki (Sony) <urezki@gmail.com>
Cc: Baoquan He <baoquan.he@linux.dev>
---

 mm/vmalloc.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/mm/vmalloc.c~mm-vmalloc-do-not-warn-on-enomem-from-va_clip-in-pcpu_get_vm_areas
+++ a/mm/vmalloc.c
@@ -5136,9 +5136,14 @@ retry:
 
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

mm-vmalloc-do-not-warn-on-enomem-from-va_clip-in-pcpu_get_vm_areas.patch

