Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 093644DF4C1
	for <mm-commits@vger.kernel.org>; Tue, 15 Sep 2026 23:40:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789515603; cv=none; b=f2VFEXqmpNTrcJKI7tkJIiLJ9lE4/Lm1urcUeYN49TrBArhujU2A7xm1yIjhuEbOx+BzkFu+MDFhDGtPJmjeHngZtKXCIA7L16B8XA0XVVr1Bkb121dOPwKB9kSO3YagNoPvyVTWs9E84M656/bXD70QUa3IImMFWyv/CHlyFuo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789515603; c=relaxed/simple;
	bh=ScW/gxC69Bnp4wg3jx/0wNFPymgTeI3QwHA1nwLhma4=;
	h=Date:To:From:Subject:Message-Id; b=GFXzON8q47TBNw1l+o0PElBtd30g4Sa7EI1zQR6JMDxiV86ETUS5VJLyvVsJF+66AqkFwF+bv18nLeGPK8KrEnTSWUzYpikrTWAJs/B4uc5c6t5snTXv+CEYRzSAM9vSoDVQb19Kd4xegIo8Q/hx2S5Dz78/ORpnUMk6UOltPqU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=SUr6dFzV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="SUr6dFzV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D82471F000FF;
	Tue, 15 Sep 2026 23:40:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789515601;
	bh=zP1kMsHkae3JBim8afGAsUngMEZVyqS5421+N8nNYAM=;
	h=Date:To:From:Subject;
	b=SUr6dFzVSNKCTy9Z/OmQfQReOc0EmLPKwYP6Osw4UXDma10DZYw1Zytl8upSP3qZw
	 BEhWRzMTInKBnNnascHBn2w1TOqtUK91m+rPoCNmaNmmwhmDMQGUmEWGfpcHS6Squt
	 i3Zs6x/egnE2jyI2wMqlGaI3OPnrcPyaxmrIxvBc=
Date: Tue, 15 Sep 2026 16:40:01 -0700
To: mm-commits@vger.kernel.org,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + docs-admin-guide-mm-damon-usage-update-for-hugepage_size-fix.patch added to mm-new branch
Message-Id: <20260915234001.D82471F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: docs-admin-guide-mm-damon-usage-update-for-hugepage_size-fix
has been added to the -mm mm-new branch.  Its filename is
     docs-admin-guide-mm-damon-usage-update-for-hugepage_size-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/docs-admin-guide-mm-damon-usage-update-for-hugepage_size-fix.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: docs-admin-guide-mm-damon-usage-update-for-hugepage_size-fix
Date: Tue Sep 15 04:33:09 PM PDT 2026

s/files acts/file acts/, per SJ

Cc: David Hildenbrand <david@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: SJ Park <sj@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/mm/damon/usage.rst |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/Documentation/admin-guide/mm/damon/usage.rst~docs-admin-guide-mm-damon-usage-update-for-hugepage_size-fix
+++ a/Documentation/admin-guide/mm/damon/usage.rst
@@ -309,7 +309,7 @@ named ``0`` to ``N-1``.  Each directory
 way similar to that for :ref:`DAMOS filter <sysfs_filters>`.  When the filter
 ``type`` is ``memcg``, ``path`` file acts as ``memcg_path`` for :ref:`DAMOS
 filter <sysfs_filters>`.  When the filter ``type`` is ``hugepage_size``,
-``min`` and ``max`` files acts as files of the same names for :ref:`DAMOS
+``min`` and ``max`` file acts as files of the same names for :ref:`DAMOS
 filter <sysfs_filters>`.
 
 .. _sysfs_targets:
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-memory_hotplug-factor-out-node_is_memoryless-fix.patch
docs-admin-guide-mm-damon-usage-update-for-hugepage_size-fix.patch
drivers-media-v4l2-core-v4l2-vp9c-reduce-inlining.patch

