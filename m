Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA1371A08CA
	for <mm-commits@vger.kernel.org>; Mon, 12 May 2025 00:52:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747011148; cv=none; b=JyZQLHPdYKD7N4BjFeonncpDhoeUam9Tjy46UxUBqBRr8IkPMzz8c+rdH51kMjJfCFpNar8dTkCex1JAjsIx3MNJuHusiHM+kRoMvevyJIMWsiLirdc3fEygP/QT6YOlZJVzgvU/LShptxTmGSm6ld+/qUvdUgYQMKLwFTF0D3o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747011148; c=relaxed/simple;
	bh=e065VsOmYETg5e26R3qqjojn2hgO+JQQED0Xj0iFGuc=;
	h=Date:To:From:Subject:Message-Id; b=T2gfO/Y+CQO1aGDZdu12pwhfpLlyTo/zVv4RdHDOhbaPlSriJgKF+fm/uhZ2w4fowCTrqD2eVkLEbPBGRLARw0NmcOeJg7VpCLkzq0bYPlDsN9HU3xMG+bGta3Q/exrQzHLGkpLuwMrXin9D7Onms3rpdAzQ3fpYs1A77jAlLYM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=D+f4UyYv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="D+f4UyYv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75CE6C4CEE4;
	Mon, 12 May 2025 00:52:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747011148;
	bh=e065VsOmYETg5e26R3qqjojn2hgO+JQQED0Xj0iFGuc=;
	h=Date:To:From:Subject:From;
	b=D+f4UyYvmmmZM05y/yw9uS5FesG72CumM64s5Os/TYPMz7E7JAGxlyCkmtyDqYmGh
	 wCcBvQN8/Jw/ZGKk5H5ihuCW71aJ5o691v+yJvH39U8RgsudnWz0Ei3IwRrUXKy/jr
	 nsnXOhncxVNeVAyyrnte+dTc18OP9YYDN2k6ttzg=
Date: Sun, 11 May 2025 17:52:27 -0700
To: mm-commits@vger.kernel.org,mjguzik@gmail.com,hch@infradead.org,bhe@redhat.com,ahuang12@lenovo.com,urezki@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] vmalloc-align-nr_vmalloc_pages-and-vmap_lazy_nr.patch removed from -mm tree
Message-Id: <20250512005228.75CE6C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: vmalloc: align nr_vmalloc_pages and vmap_lazy_nr
has been removed from the -mm tree.  Its filename was
     vmalloc-align-nr_vmalloc_pages-and-vmap_lazy_nr.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Subject: vmalloc: align nr_vmalloc_pages and vmap_lazy_nr
Date: Thu, 17 Apr 2025 18:12:16 +0200

Currently both atomics share one cache-line:

<snip>
...
ffffffff83eab400 b vmap_lazy_nr
ffffffff83eab408 b nr_vmalloc_pages
...
<snip>

those are global variables and they are only 8 bytes apart.  Since they
are modified by different threads this causes a false sharing.  This can
lead to a performance drop due to unnecessary cache invalidations.

After this patch it is aligned to a cache line boundary:

<snip>
...
ffffffff8260a600 d vmap_lazy_nr
ffffffff8260a640 d nr_vmalloc_pages
...
<snip>

Link: https://lkml.kernel.org/r/20250417161216.88318-4-urezki@gmail.com
Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Reviewed-by: Baoquan He <bhe@redhat.com>
Reviewed-by: Adrian Huang <ahuang12@lenovo.com>
Tested-by: Adrian Huang <ahuang12@lenovo.com>
Cc: Mateusz Guzik <mjguzik@gmail.com>
Cc: Christop Hellwig <hch@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/mm/vmalloc.c~vmalloc-align-nr_vmalloc_pages-and-vmap_lazy_nr
+++ a/mm/vmalloc.c
@@ -1008,7 +1008,8 @@ static BLOCKING_NOTIFIER_HEAD(vmap_notif
 static void drain_vmap_area_work(struct work_struct *work);
 static DECLARE_WORK(drain_vmap_work, drain_vmap_area_work);
 
-static atomic_long_t nr_vmalloc_pages;
+static __cacheline_aligned_in_smp atomic_long_t nr_vmalloc_pages;
+static __cacheline_aligned_in_smp atomic_long_t vmap_lazy_nr;
 
 unsigned long vmalloc_nr_pages(void)
 {
@@ -2117,8 +2118,6 @@ static unsigned long lazy_max_pages(void
 	return log * (32UL * 1024 * 1024 / PAGE_SIZE);
 }
 
-static atomic_long_t vmap_lazy_nr = ATOMIC_LONG_INIT(0);
-
 /*
  * Serialize vmap purging.  There is no actual critical section protected
  * by this lock, but we want to avoid concurrent calls for performance
_

Patches currently in -mm which might be from urezki@gmail.com are

maintainers-add-myself-as-vmalloc-co-maintainer.patch

