Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1C3A29CB4D
	for <mm-commits@vger.kernel.org>; Tue, 28 Oct 2025 20:21:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761682875; cv=none; b=Pi+r1IodYGPlYFDC9AylVP7REvbwXzAYGEQx2o/p1nvtMeCMQHKUniEvmjwjIwMl/wHjjsNsFiPvZYWvgHPOSoUsxp5OqIAnFwltBbxU3r6a6l8IpElNidi3iVSKdOJbraYY9P3HPS2z3W/f88tkq448THT4YZtEXB50CBMK2uc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761682875; c=relaxed/simple;
	bh=N4tgzsYGM43TIIMprJq4f6KnDHoDfvjuyenmnnxJsjY=;
	h=Date:To:From:Subject:Message-Id; b=c0Zj5kHXRA0nShqKUvHWmWvGcCfoHdHG/dw+gTEcPR4nK5bsMgXqokGHq7sRcP1RV/s9eAkijaQHm73BgEfPha22F1UoY6MyZrz/CNInnJhI+Uib8wN8W0VK5auufPaKvRT/39gteuGNm1RDERCIG/wID8rPCi/KPNCqFdk7Kk4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=WoYSMtAL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="WoYSMtAL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A1EEC4CEFF;
	Tue, 28 Oct 2025 20:21:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1761682874;
	bh=N4tgzsYGM43TIIMprJq4f6KnDHoDfvjuyenmnnxJsjY=;
	h=Date:To:From:Subject:From;
	b=WoYSMtALEfzRgdv1CnQ5ktJhdki5F3FDobCScoDtuZWqf0MtIaohEb+y3i6KKunLB
	 ZnQfmlIUkRzPuIjhy9WmEenCCN1X5wn7Ge0FTnu7NtnoftoXcvMlIeiEBBpgcrvyhT
	 dTdqtW+9vsqOSrUzffdB4y416TmvLFWVtRz/RxBM=
Date: Tue, 28 Oct 2025 13:21:13 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,rppt@kernel.org,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,hughd@google.com,david@redhat.com,baolin.wang@linux.alibaba.com,d@ilvokhin.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-shmem-tmpfs-hugepage-defaults-config-choice-v2.patch added to mm-unstable branch
Message-Id: <20251028202114.5A1EEC4CEFF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-shmem-tmpfs-hugepage-defaults-config-choice-v2
has been added to the -mm mm-unstable branch.  Its filename is
     mm-shmem-tmpfs-hugepage-defaults-config-choice-v2.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-shmem-tmpfs-hugepage-defaults-config-choice-v2.patch

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
From: Dmitry Ilvokhin <d@ilvokhin.com>
Subject: mm-shmem-tmpfs-hugepage-defaults-config-choice-v2
Date: Tue, 28 Oct 2025 17:49:50 +0000

- Mentioned Kconfig options in Documentation/admin-guide/mm/transhuge.rst. 
  Didn't list all of them intentionally to avoid duplication and possible 
  content drift in the future.
- Expanded commit message with rationale behind the change. Mentioned Meta
  explicitly.

Link: https://lkml.kernel.org/r/aQECPpjd-fU_TC79@shell.ilvokhin.com
Signed-off-by: Dmitry Ilvokhin <d@ilvokhin.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/mm/transhuge.rst |    5 +++++
 1 file changed, 5 insertions(+)

--- a/Documentation/admin-guide/mm/transhuge.rst~mm-shmem-tmpfs-hugepage-defaults-config-choice-v2
+++ a/Documentation/admin-guide/mm/transhuge.rst
@@ -381,6 +381,11 @@ hugepage allocation policy for the tmpfs
 four valid policies for tmpfs (``always``, ``within_size``, ``advise``,
 ``never``). The tmpfs mount default policy is ``never``.
 
+Additionally, Kconfig options are available to set the default hugepage
+policies for shmem (``CONFIG_TRANSPARENT_HUGEPAGE_SHMEM_HUGE_*``) and tmpfs
+(``CONFIG_TRANSPARENT_HUGEPAGE_TMPFS_HUGE_*``) at build time. Refer to the
+Kconfig help for more details.
+
 In the same manner as ``thp_anon`` controls each supported anonymous THP
 size, ``thp_shmem`` controls each supported shmem THP size. ``thp_shmem``
 has the same format as ``thp_anon``, but also supports the policy
_

Patches currently in -mm which might be from d@ilvokhin.com are

mm-shmem-tmpfs-hugepage-defaults-config-choice.patch
mm-shmem-tmpfs-hugepage-defaults-config-choice-v2.patch

