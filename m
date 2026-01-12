Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D244D22A4E8
	for <mm-commits@vger.kernel.org>; Mon, 12 Jan 2026 23:46:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768261593; cv=none; b=dzRZkT3Om1CSNmdS5Rf3FqipyGvO2my2wkp4vD/urPldVvuPes/yPUxkPYp0GnMRAp0xuyRDHJy3nvwLNnjKyDkEoT2qyaAyb+0gDvQzYybUJhZ2JrTe6rbwNomk7GGhnZzE5OdbzZ4btwQdWJipHh8qJNpnVOYyDZvqW/jute0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768261593; c=relaxed/simple;
	bh=etVvZnkZiNV9kP4WIOFDEbs/+6EeZ37oxPYOeNROE6E=;
	h=Date:To:From:Subject:Message-Id; b=kj0n79cV+3vfOl1R2R7OV4XamR2ebbGwBQrUNXeCbPUhAqwvvntV9PSo019GeThE6b5WFU6h/ZRXXqR8mA9VCZtPyleHxoUeJx3PVNgh/IgLJsV8vCrgQVDP2ZKnUM+td21C4AeJq0/EWSCBBZt1ukSgl0ynVWC7+A/aVtR1gZ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=HwiWTryD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HwiWTryD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60CFCC116D0;
	Mon, 12 Jan 2026 23:46:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768261592;
	bh=etVvZnkZiNV9kP4WIOFDEbs/+6EeZ37oxPYOeNROE6E=;
	h=Date:To:From:Subject:From;
	b=HwiWTryDVScyu3VRoLVV/jQYnRmYLvAxd2AW0pL6c9+NrY8fEpr1/yULX8BmTqtfi
	 cIqJkcqsPkNfZIRSbiq5gkyDTVlGKaeaPrH1pbD2H+UCOcqJQDtImx0vdwPvdCDTHI
	 Au0/7nElrKeTjAOpYdNkOOM4/D6vAmB5rCTcBJdM=
Date: Mon, 12 Jan 2026 15:46:31 -0800
To: mm-commits@vger.kernel.org,sj@kernel.org,shakeel.butt@linux.dev,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + memcg-rename-mem_cgroup_ino-to-mem_cgroup_id-fix-fix.patch added to mm-unstable branch
Message-Id: <20260112234632.60CFCC116D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: memcg-mem_cgroup_get_from_ino-returns-null-on-error-fix
has been added to the -mm mm-unstable branch.  Its filename is
     memcg-rename-mem_cgroup_ino-to-mem_cgroup_id-fix-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/memcg-rename-mem_cgroup_ino-to-mem_cgroup_id-fix-fix.patch

This patch will later appear in the mm-unstable branch at
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
Subject: memcg-mem_cgroup_get_from_ino-returns-null-on-error-fix
Date: Mon Jan 12 03:36:40 PM PST 2026

build fix

mm/memcontrol.c: In function 'mem_cgroup_get_from_id':
mm/memcontrol.c:3624:35: error: 'ino' undeclared (first use in this function); did you mean 'int'?
 3624 |         cgrp = cgroup_get_from_id(ino);
      |                                   ^~~
      |                                   int

Cc: SeongJae Park <sj@kernel.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memcontrol.c~memcg-rename-mem_cgroup_ino-to-mem_cgroup_id-fix-fix
+++ a/mm/memcontrol.c
@@ -3621,7 +3621,7 @@ struct mem_cgroup *mem_cgroup_get_from_i
 	struct cgroup_subsys_state *css;
 	struct mem_cgroup *memcg = NULL;
 
-	cgrp = cgroup_get_from_id(ino);
+	cgrp = cgroup_get_from_id(id);
 	if (IS_ERR(cgrp))
 		return NULL;
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-page_alloc-make-percpu_pagelist_high_fraction-reads-lock-free-fix.patch
mm-add-basic-tests-for-lazy_mmu-fix.patch
mm-vmscanc-shrink_folio_list-save-a-tabstop.patch
mm-block-fs-remove-laptop_mode-fix.patch
mm-fix-minor-spelling-mistakes-in-comments-fix.patch
memcg-rename-mem_cgroup_ino-to-mem_cgroup_id-fix-fix.patch
mm-memory-tiers-numa_emu-enable-to-create-memory-tiers-using-fake-numa-nodes-fix.patch
list-add-primitives-for-private-list-manipulations-fix.patch
init-mainc-check-if-rdinit-was-explicitly-set-before-printing-warning-fix.patch

