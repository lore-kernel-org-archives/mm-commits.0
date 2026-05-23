Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF8213148DD
	for <mm-commits@vger.kernel.org>; Sat, 23 May 2026 02:50:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779504627; cv=none; b=TgdpSrnBTcskwTdEu5t7i7SXEaxXcjZCtMkC0neMaj1t+phrp2HA2K2s4BgXDIPb4XmrArpqAOvw7PMrnTlgVKRwKJFPSvGm8F/PFCO87qrB3L1+iS0PZ0TNBLKw8vVzQawrYpn1ZOhbmQNOumu5nNKh7lMp1CrNdN6RKDpZa1s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779504627; c=relaxed/simple;
	bh=RnoETwnm8PigNUe0oYcfKP6By255dgqpsmSM7KCrfcc=;
	h=Date:To:From:Subject:Message-Id; b=ZsQK56uIFxaux5Zhmxt+A2gKa6pLc880JFC2BLBGFHQABxvDmKRSMK2IT45j9PjEjgEz4X29l08uNKsF1epQevjQt/CJQPy36ue+UX5X4+l5zXZZk2BQKGgNi4SkTUcb7E7wBn1S/y6qT1Gd1s9WTTNS/aDpSnRwdmNCh7mcwzM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=JKzAwdTV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="JKzAwdTV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F4C81F000E9;
	Sat, 23 May 2026 02:50:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1779504625;
	bh=FWwDYFDqGaBNm/QMRTsIfFDY6bRqMbMqAj/3DyzKke0=;
	h=Date:To:From:Subject;
	b=JKzAwdTVnICuQYdVlzsGt8dB/UM0NNsltXVLrUQZiOtFKPvEX7M9iZCPgnA/tAFvl
	 7Li/hYcB5XeFDE1hTtXMjZJJW34nKwQhfakQG5plKECNEG7I+i1AGo+qAf7/VPiKNR
	 2Kvcu88exyf/VL1JVRzDsyrFueV2dnqutiFBEZM0=
Date: Fri, 22 May 2026 19:50:24 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,songmuchun@bytedance.com,rppt@kernel.org,muchun.song@linux.dev,minchan@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,jhubbard@nvidia.com,gregkh@linuxfoundation.org,digetx@gmail.com,david@kernel.org,chengkaitao@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-cma_sysfs-skip-inactive-cma-areas-in-sysfs.patch added to mm-hotfixes-unstable branch
Message-Id: <20260523025025.4F4C81F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/cma_sysfs: skip inactive CMA areas in sysfs
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-cma_sysfs-skip-inactive-cma-areas-in-sysfs.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-cma_sysfs-skip-inactive-cma-areas-in-sysfs.patch

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
From: Kaitao Cheng <chengkaitao@kylinos.cn>
Subject: mm/cma_sysfs: skip inactive CMA areas in sysfs
Date: Fri, 22 May 2026 21:14:34 +0800

cma_activate_area() can fail after a CMA area has already been added to
cma_areas[].  In that case the area is left in the global array, but it
does not reach the point where CMA_ACTIVATED is set.

cma_sysfs_init() currently walks all cma_area_count entries and creates
sysfs files for every area, including ones that failed activation.  These
areas are not usable CMA areas and should not be exposed to userspace as
valid CMA regions.

Skip CMA areas that did not reach CMA_ACTIVATED when creating the sysfs
objects.  Since inactive entries can now be skipped, make the error unwind
tolerate entries that never had cma_kobj initialized.

Link: https://lore.kernel.org/20260522131434.78532-1-kaitao.cheng@linux.dev
Fixes: 43ca106fa8ec ("mm: cma: support sysfs")
Signed-off-by: Kaitao Cheng <chengkaitao@kylinos.cn>
Reported-by: David Hildenbrand (Arm) <david@kernel.org>
Reported-by: Muchun Song <songmuchun@bytedance.com>
Closes: https://lore.kernel.org/linux-mm/55481a8b-dcfc-4bef-ba59-aa0b43dca88b@kernel.org/
Acked-by: Muchun Song <muchun.song@linux.dev>
Cc: David Hildenbrand <david@kernel.org>
Cc: Dmitry Osipenko <digetx@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/cma_sysfs.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/mm/cma_sysfs.c~mm-cma_sysfs-skip-inactive-cma-areas-in-sysfs
+++ a/mm/cma_sysfs.c
@@ -117,13 +117,16 @@ static int __init cma_sysfs_init(void)
 		return -ENOMEM;
 
 	for (i = 0; i < cma_area_count; i++) {
+		cma = &cma_areas[i];
+		if (!test_bit(CMA_ACTIVATED, &cma->flags))
+			continue;
+
 		cma_kobj = kzalloc_obj(*cma_kobj);
 		if (!cma_kobj) {
 			err = -ENOMEM;
 			goto out;
 		}
 
-		cma = &cma_areas[i];
 		cma->cma_kobj = cma_kobj;
 		cma_kobj->cma = cma;
 		err = kobject_init_and_add(&cma_kobj->kobj, &cma_ktype,
@@ -138,7 +141,8 @@ static int __init cma_sysfs_init(void)
 out:
 	while (--i >= 0) {
 		cma = &cma_areas[i];
-		kobject_put(&cma->cma_kobj->kobj);
+		if (cma->cma_kobj)
+			kobject_put(&cma->cma_kobj->kobj);
 	}
 	kobject_put(cma_kobj_root);
 
_

Patches currently in -mm which might be from chengkaitao@kylinos.cn are

mm-cma_sysfs-skip-inactive-cma-areas-in-sysfs.patch
mm-convert-vmemmap_pd_populate-to-static-functions.patch
mm-memory-failure-use-zone_pcp_disable-for-poison-handling.patch

