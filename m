Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 967BB383981
	for <mm-commits@vger.kernel.org>; Wed, 24 Jun 2026 21:01:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782334881; cv=none; b=Y0OKMPbrXoiUWsd14VQ1js6JBF/O8H+0ksQELrgjTUYT1LldF4WxPdEkVrs/qavXiipbaZnypcrnFJV8NATPTLylFLZmbBVT1QTjkFPq1EUav2KkKnvZJ3x3tHpotRbxNCB0aE4IEvRYTuc1+r/rDBamxM9DQKQdL2fjJb1ZM8c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782334881; c=relaxed/simple;
	bh=aOT+CVrhhcWpKxF/fPqawvy4css1g1xuzk/+P+3+YTQ=;
	h=Date:To:From:Subject:Message-Id; b=rc11lxhdta8w+vhSoeeVE1WUpjmWWymoAT4huxns5T5FCLrxqwJwKktzvHGhhGmf59cPOSJAD9HSIs2sbxvJiE2r62leOz8qhcfIWqNNzRbJZlK237wFKgk8CegFP28hr5ayMw0SCrA5ojmAa+nwYl/LX/ymtq1nsoXAskXxoEE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qN079UB6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qN079UB6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A0AE1F000E9;
	Wed, 24 Jun 2026 21:01:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782334880;
	bh=ZAQbNo6VboGyg6l4J/fBsK1DCUiJ2owcd6tQI9yM4Ik=;
	h=Date:To:From:Subject;
	b=qN079UB6Mo7Mn7eySkuKrC+bsGcesy1xeZwefuhUu1nsE3B3hwy92VVccDmzLSOGv
	 4hGPV4yhY+Kq6ISzs2jOYj7xWDqf3O+H33agpbMGjhwFPoUrmjjVdyGalO5EoGvSVz
	 SS/hVnpoj8fk41vgWY3a711GSL7WG7C/D0YPwYEs=
Date: Wed, 24 Jun 2026 14:01:19 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,david@kernel.org,zhuhui@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-avoid-kcsan-false-positive-in-memdesc_nid.patch added to mm-new branch
Message-Id: <20260624210120.1A0AE1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: avoid KCSAN false positive in memdesc_nid()
has been added to the -mm mm-new branch.  Its filename is
     mm-avoid-kcsan-false-positive-in-memdesc_nid.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-avoid-kcsan-false-positive-in-memdesc_nid.patch

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
From: Hui Zhu <zhuhui@kylinos.cn>
Subject: mm: avoid KCSAN false positive in memdesc_nid()
Date: Tue, 23 Jun 2026 16:44:32 +0800

KCSAN reports a data race between page_to_nid()/folio_nid() reading
page->flags and folio_trylock()/folio_lock() concurrently doing
test_and_set_bit_lock(PG_locked, ...) on the same word, e.g.:

  BUG: KCSAN: data-race in __lruvec_stat_mod_folio / shmem_get_folio_gfp

The node id occupies a fixed bit-range of page->flags that is set once at
page init and never modified afterwards, so it can never overlap with the
low PG_locked/PG_waiters bits touched by the folio lock path.

Use ASSERT_EXCLUSIVE_BITS() in memdesc_nid() to scope the exemption to
just the node-id bits, consistent with how memdesc_zonenum() already
handles the same class of race for the zone-id bits.

Link: https://lore.kernel.org/20260623084432.701120-1-hui.zhu@linux.dev
Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    1 +
 1 file changed, 1 insertion(+)

--- a/include/linux/mm.h~mm-avoid-kcsan-false-positive-in-memdesc_nid
+++ a/include/linux/mm.h
@@ -2290,6 +2290,7 @@ int memdesc_nid(memdesc_flags_t mdf);
 #else
 static inline int memdesc_nid(memdesc_flags_t mdf)
 {
+	ASSERT_EXCLUSIVE_BITS(mdf.f, NODES_MASK << NODES_PGSHIFT);
 	return (mdf.f >> NODES_PGSHIFT) & NODES_MASK;
 }
 #endif
_

Patches currently in -mm which might be from zhuhui@kylinos.cn are

mm-avoid-kcsan-false-positive-in-memdesc_nid.patch

