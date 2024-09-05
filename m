Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C47FD15687C
	for <mm-commits@vger.kernel.org>; Thu,  5 Sep 2024 21:30:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725571844; cv=none; b=O5YaRQ8tmazb7OkC/xfhJIQTShqhgsIsXz1ZQFryjwkN7jSq0SZW2HivIc6UrtHPutfdNa1OxkMIBfJkWuQl86xRm4aTKcVB7NBnhSATSmoHF7VUvTROzN/oiK9JGm9Yl3SreYq+j9DKiYLdkrMFHyVU0xm79QCgWGKm9x51Yow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725571844; c=relaxed/simple;
	bh=kR2pfvHbjvg/2NyZtzSKZbjfkMnAYCTw/tTyLjEE2Ow=;
	h=Date:To:From:Subject:Message-Id; b=fL81U+jMyiNLiHPQACzyUUKDbtsTxdQboUO8lTv7VizJYSedFkKAHY+4VefxxvBrSC4LXLSPqllFlYiiTjEr5L5pwc7c081TpYqlb9LeOMBGyB2JEUYWVFPeF3Vstmbnvd53VfZTJ2N7W1ZpBFytZ6o3Asb5RXTKVWr0Cxd2AS4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=aYbbxsn6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="aYbbxsn6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D4FEC4CEC3;
	Thu,  5 Sep 2024 21:30:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725571844;
	bh=kR2pfvHbjvg/2NyZtzSKZbjfkMnAYCTw/tTyLjEE2Ow=;
	h=Date:To:From:Subject:From;
	b=aYbbxsn61CTs+n2iT8004QQDqQbpriqhS+k2t5WdjRQeHH7ZpHtYuReAmdhHFogUW
	 0kp1Sgd1g3GQc2X2qQbICeOJuI2XDtKicRoBAH7sUVMAejPiKnnQoIixmb6J7tY7oz
	 d1zYxk+cwPgisNeB5xtAiTHsi2QarPTrs8QOGha4=
Date: Thu, 05 Sep 2024 14:30:43 -0700
To: mm-commits@vger.kernel.org,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-migrate-remove-unused-includes.patch added to mm-unstable branch
Message-Id: <20240905213044.3D4FEC4CEC3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: migrate: remove unused includes
has been added to the -mm mm-unstable branch.  Its filename is
     mm-migrate-remove-unused-includes.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-migrate-remove-unused-includes.patch

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
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm: migrate: remove unused includes
Date: Thu, 5 Sep 2024 23:24:32 +0800

random.h is not needed since commit 6c542ab75714 ("mm/demotion: build
demotion targets based on explicit memory tiers"), all functions moved
into memory-tiers.

nsproxy.h is not needed since commit 228ebcbe634a ("Uninline
find_task_by_xxx set of functions"), no nsproxy, we only call
find_task_by_vpid() now.

hugetlb_cgroup.h is not needed since commit ab5ac90aecf5 ("mm, hugetlb: do
not rely on overcommit limit during migration"), move_hugetlb_state() is
called and it belongs to hugetlb.h, which is already included.

balloon_compaction.h, we have more general movable_operations for non-lru
movable page migration, so it could be dropped.

memremap.h, userfaultfd_k.h and oom.h are introduced for zone device page
migration, but all functions are moved into migrate_device.c, so no needed
anymore too.

Link: https://lkml.kernel.org/r/20240905152432.626877-1-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |    7 -------
 1 file changed, 7 deletions(-)

--- a/mm/migrate.c~mm-migrate-remove-unused-includes
+++ a/mm/migrate.c
@@ -20,7 +20,6 @@
 #include <linux/pagemap.h>
 #include <linux/buffer_head.h>
 #include <linux/mm_inline.h>
-#include <linux/nsproxy.h>
 #include <linux/ksm.h>
 #include <linux/rmap.h>
 #include <linux/topology.h>
@@ -35,19 +34,13 @@
 #include <linux/syscalls.h>
 #include <linux/compat.h>
 #include <linux/hugetlb.h>
-#include <linux/hugetlb_cgroup.h>
 #include <linux/gfp.h>
 #include <linux/pfn_t.h>
-#include <linux/memremap.h>
-#include <linux/userfaultfd_k.h>
-#include <linux/balloon_compaction.h>
 #include <linux/page_idle.h>
 #include <linux/page_owner.h>
 #include <linux/sched/mm.h>
 #include <linux/ptrace.h>
-#include <linux/oom.h>
 #include <linux/memory.h>
-#include <linux/random.h>
 #include <linux/sched/sysctl.h>
 #include <linux/memory-tiers.h>
 #include <linux/pagewalk.h>
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

mm-migrate_device-convert-to-migrate_device_coherent_folio.patch
mm-migrate_device-use-a-folio-in-migrate_device_range.patch
mm-migrate_device-use-more-folio-in-migrate_device_unmap.patch
mm-migrate_device-use-more-folio-in-migrate_device_finalize.patch
mm-remove-isolate_lru_page.patch
mm-remove-isolate_lru_page-fix.patch
mm-remove-putback_lru_page.patch
mm-migrate-remove-unused-includes.patch

