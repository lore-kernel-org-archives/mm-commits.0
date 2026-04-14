Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 493AF3016E3;
	Tue, 14 Apr 2026 05:30:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776144648; cv=none; b=I4itkj5LW7F2e7YuAikCygfN6/As0HK35lo1gnS1eAVivcnMGtmKPGWGjFrVzVwgK2KaIutAy62hRZTGT9LP0N3U4Wdit81fPKPn0q+N150Cd4Y3w90hvupulbBgNdNQJLxS3FCS5wn2XUUtar1B2zBWzi6lcF2An+H40Smvgzs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776144648; c=relaxed/simple;
	bh=6hm1CUm/Zcxe0AkmadZChv/O9g89O8ndebP2XcAkT/M=;
	h=Date:To:From:Subject:Message-Id; b=Xomgsas6sb8U78GciGNeTKVZgT4YZ1he5t8CnobUZPMYMO7E/3L3iyXYXUdogc378J7DPkmRoLQzuV31ELzmRO1K5jNx5M0Bs+ZFQ97ed7N7N4boaLxu0dG1o7JHv4DbchwT/H2HdgjSm/aScbLRwqv9BcbC0JPZPeq9xdufTI0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Ncge+IHe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Ncge+IHe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B55CC19425;
	Tue, 14 Apr 2026 05:30:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1776144648;
	bh=6hm1CUm/Zcxe0AkmadZChv/O9g89O8ndebP2XcAkT/M=;
	h=Date:To:From:Subject:From;
	b=Ncge+IHe8FjOueQYAQ+UPMS5yjVRZNIBAyNeHD4gzpTa3ypee2ayUV1gtk2vAdPN4
	 MDpv9S1/3NOLkfcAXEA9l0ExL1uYf9RFjop8R5lmlMb8dDWuSnH8tsvCVKxLvv1mrv
	 cTp27OYSqoS1qkXXhMlUVwSJwTir4hFUBYz1UZiE=
Date: Mon, 13 Apr 2026 22:30:39 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,chenyichong@uniontech.com,bhe@redhat.com,urezki@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmalloc-take-vmap_purge_lock-in-shrinker.patch added to mm-hotfixes-unstable branch
Message-Id: <20260414053047.7B55CC19425@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/vmalloc: take vmap_purge_lock in shrinker
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-vmalloc-take-vmap_purge_lock-in-shrinker.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmalloc-take-vmap_purge_lock-in-shrinker.patch

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
From: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Subject: mm/vmalloc: take vmap_purge_lock in shrinker
Date: Mon, 13 Apr 2026 21:26:46 +0200

decay_va_pool_node() can be invoked concurrently from two paths:
__purge_vmap_area_lazy() when pools are being purged, and the shrinker via
vmap_node_shrink_scan().

However, decay_va_pool_node() is not safe to run concurrently, and the
shrinker path currently lacks serialization, leading to races and possible
leaks.

Protect decay_va_pool_node() by taking vmap_purge_lock in the shrinker
path to ensure serialization with purge users.

Link: https://lkml.kernel.org/r/20260413192646.14683-1-urezki@gmail.com
Fixes: 7679ba6b36db ("mm: vmalloc: add a shrinker to drain vmap pools")
Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Cc: chenyichong <chenyichong@uniontech.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/vmalloc.c~mm-vmalloc-take-vmap_purge_lock-in-shrinker
+++ a/mm/vmalloc.c
@@ -5416,6 +5416,7 @@ vmap_node_shrink_scan(struct shrinker *s
 {
 	struct vmap_node *vn;
 
+	guard(mutex)(&vmap_purge_lock);
 	for_each_vmap_node(vn)
 		decay_va_pool_node(vn, true);
 
_

Patches currently in -mm which might be from urezki@gmail.com are

mm-vmalloc-take-vmap_purge_lock-in-shrinker.patch

