Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7BB218E754
	for <mm-commits@vger.kernel.org>; Mon,  9 Sep 2024 23:41:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725925308; cv=none; b=L3Hks2Ghi7qZ0W8QsistMSZepQ81Yo7Hj7ygFyd0/FnrtlFMtMsoxZStd21zOwzWKVZUQbV6PCztHAQP+eGoqw392AdkLFNpo18L9QlGnd7ma0+bjJLsumN8i9g4HsBZR11bJVmoyIf9pRoUHjhmFVE1icGgIY1rAH/FnQdMHFg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725925308; c=relaxed/simple;
	bh=SSwQyUpt/zYzTux6u4MB0Hb3Z09kfp+UbOZr4Wr5OZY=;
	h=Date:To:From:Subject:Message-Id; b=jSyLWw+y4iJngfoCUgaFmogKniuVs91foHS0AAWwFrq5lpww8CT+P4QNQpwhq9OBlasSGqIAg51Dv30omEqEoZgT48jqZTV7Q1mwpxYfJ/ith9y7KfMKwN8k8dh8dDCMNpfv20pMIUDtSPuNExIoLcJShoqtrZ2k2p5sSo4ijwU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=kktBcYQq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="kktBcYQq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 800D9C4CEC5;
	Mon,  9 Sep 2024 23:41:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725925308;
	bh=SSwQyUpt/zYzTux6u4MB0Hb3Z09kfp+UbOZr4Wr5OZY=;
	h=Date:To:From:Subject:From;
	b=kktBcYQqNW9FTxUMX9JqxJWLtFxhh5hQvPKa/4t8JN3lTIM7zGzBb24/9ACPLNwxZ
	 Y5zP3RPoVt4c1ImN/kxMZVcPAHDSGvxxrs89cpFiTwii6wpIIcVcGB5wF8rJlZhNjh
	 npJrdGoa88H6xybVZcOv/BLGANtmPFlU7Nu+JtUQ=
Date: Mon, 09 Sep 2024 16:41:48 -0700
To: mm-commits@vger.kernel.org,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-migrate-remove-unused-includes.patch removed from -mm tree
Message-Id: <20240909234148.800D9C4CEC5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: migrate: remove unused includes
has been removed from the -mm tree.  Its filename was
     mm-migrate-remove-unused-includes.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

mm-support-poison-recovery-from-do_cow_fault.patch
mm-support-poison-recovery-from-copy_present_page.patch

