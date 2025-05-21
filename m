Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D476832C85
	for <mm-commits@vger.kernel.org>; Wed, 21 May 2025 05:50:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747806618; cv=none; b=Le1nBv3A0OYNSVEPU4bIjdHpWf5vEdIJQes50tk+m9OU127udL96EhoUjjLr6qKyAOoKsmIHIpil/avVe6fYi1J6471pS8y7Ge1Zc5dLywQ1fHtDmRUwcuWwUXxqzyyKJioJMBdu7rvO0ti+mx4TYdvWVpbf0W4usl1NEam0eWs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747806618; c=relaxed/simple;
	bh=HBPUhNu9HvS7hfqUeasayja/4kKA5w76pvc4EICSA/g=;
	h=Date:To:From:Subject:Message-Id; b=He5YbHXulu1YCxhUk+5LgzZ8tRmjlKeki+6aFUVFNneIW+F01MCxOis9VxZyVU6qTplXulSD3A3ILLCUDdusiVzkZEHUSHa28YaNRTp0BoTKeuseC12pVD10s6i78mu0hNx/taMhV2CZhCKAlxmJrx7QLy+zVFExli7VvZxiu8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Duf99Q5h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Duf99Q5h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F068C4CEE4;
	Wed, 21 May 2025 05:50:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747806618;
	bh=HBPUhNu9HvS7hfqUeasayja/4kKA5w76pvc4EICSA/g=;
	h=Date:To:From:Subject:From;
	b=Duf99Q5h53USE9XSR9RJJbV/+wAXD5KvaLP8Fb6N3sfPHoYc8gJM7mcaQ0fSy3Kxr
	 mk9ZXON2xXlHvQKvbvv6jrzZLG6/k2BXDCW6WYfjGa+PDVz+y39y4FIn50TWJTrHIA
	 B34UzNJOR/zU0pugkdzcnBiEsPu7i3OiTgjQC9JE=
Date: Tue, 20 May 2025 22:50:17 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ying.huang@linux.alibaba.com,rakie.kim@sk.com,matthew.brost@intel.com,joshua.hahnjy@gmail.com,gourry@gourry.net,david@redhat.com,byungchul@sk.com,apopple@nvidia.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] maintainers-add-mm-memory-policy-section.patch removed from -mm tree
Message-Id: <20250521055018.3F068C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: MAINTAINERS: add mm memory policy section
has been removed from the -mm tree.  Its filename was
     maintainers-add-mm-memory-policy-section.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: MAINTAINERS: add mm memory policy section
Date: Thu, 15 May 2025 20:13:58 +0100

As part of the ongoing efforts to sub-divide memory management
maintainership and reviewership, establish a section for memory policy and
migration and add appropriate maintainers and reviewers.

[lorenzo.stoakes@oracle.com: add Ying as reviewer]
  Link: https://lkml.kernel.org/r/ed6f0fc2-5608-4eea-b1be-07e3e19be263@lucifer.local
Link: https://lkml.kernel.org/r/20250515191358.205684-1-lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Rakie Kim <rakie.kim@sk.com>
Acked-by: Matthew Brost <matthew.brost@intel.com>
Reviewed-by: Joshua Hahn <joshua.hahnjy@gmail.com>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Zi Yan <ziy@nvidia.com>
Acked-by: Huang Ying <ying.huang@linux.alibaba.com>
Acked-by: Byungchul Park <byungchul@sk.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Gregory Price <gourry@gourry.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |   20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

--- a/MAINTAINERS~maintainers-add-mm-memory-policy-section
+++ a/MAINTAINERS
@@ -15577,6 +15577,26 @@ F:	include/linux/ksm.h
 F:	include/trace/events/ksm.h
 F:	mm/ksm.c
 
+MEMORY MANAGEMENT - MEMORY POLICY AND MIGRATION
+M:	Andrew Morton <akpm@linux-foundation.org>
+M:	David Hildenbrand <david@redhat.com>
+R:	Zi Yan <ziy@nvidia.com>
+R:	Matthew Brost <matthew.brost@intel.com>
+R:	Joshua Hahn <joshua.hahnjy@gmail.com>
+R:	Rakie Kim <rakie.kim@sk.com>
+R:	Byungchul Park <byungchul@sk.com>
+R:	Gregory Price <gourry@gourry.net>
+R:	Ying Huang <ying.huang@linux.alibaba.com>
+L:	linux-mm@kvack.org
+S:	Maintained
+W:	http://www.linux-mm.org
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
+F:	include/linux/mempolicy.h
+F:	include/linux/migrate.h
+F:	mm/mempolicy.c
+F:	mm/migrate.c
+F:	mm/migrate_device.c
+
 MEMORY MANAGEMENT - NUMA MEMBLOCKS AND NUMA EMULATION
 M:	Andrew Morton <akpm@linux-foundation.org>
 M:	Mike Rapoport <rppt@kernel.org>
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

maintainers-add-kernel-forkc-to-relevant-sections.patch
mm-remove-warn_on_once-in-file_has_valid_mmap_hooks.patch
memcg-memcg_rstat_updated-re-entrant-safe-against-irqs-fix.patch

