Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40CE61FAA
	for <mm-commits@vger.kernel.org>; Fri,  6 Jun 2025 05:02:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749186172; cv=none; b=pbBqS+Hfsvo+YqDhjnkoIBA8T0rAY7X1eniAec05rVDh+7fXBx3Bi9XBLtnaC/+KabKHK8DnnGTcWqp+cnQUj0hR+1yc7MOSnlNk8GVxFhPv/1kTLml3AxeYnI8npmt7Hdw55MpgOC2YVKlRxVeW92ouwKSeDMbzQcf5pKYrj7U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749186172; c=relaxed/simple;
	bh=a2EGzmgysdspM1fvObdsFGvVKkagHjKENASBtqSNcDk=;
	h=Date:To:From:Subject:Message-Id; b=CwLj9rSCe26ZEII+Y2EyYucqTbyzlmObxm4e5AWu8XLssZWOGqGCCeADfb91KUzmq8OxccPigz74I6G4VTuwL9aERIC3BNxwOsYbVyr7a0XfaSZGa7Yx+hW2hq9xIZps9ArwGEOBlgG4ZF3cqgCTPbHoPugU+IdLNEOuSCGBCII=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gVLPG9kt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gVLPG9kt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EB4CC4CEED;
	Fri,  6 Jun 2025 05:02:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1749186171;
	bh=a2EGzmgysdspM1fvObdsFGvVKkagHjKENASBtqSNcDk=;
	h=Date:To:From:Subject:From;
	b=gVLPG9ktDs5P5uBQeZ6efHT/VlQiDFnKrb+06y1E81vDfV7w7nFl6WxA0ICjEoTph
	 AJzZ9fw7rYQkSWKYa8zx4O0qPDKcikhU1KYniWwk+IDE668/YmZN/b6bp9anz0aeUf
	 +g3rSrVY1CWOEYIKJ/IMDdjxtLAB5uDWMlfCSMVY=
Date: Thu, 05 Jun 2025 22:02:51 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,shakeel.butt@linux.dev,mhocko@suse.com,johannes.thumshirn@wdc.com,hongyu.ning@linux.intel.com,hch@lst.de,hare@suse.de,axboe@kernel.dk,kirill.shutemov@linux.intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-fix-vmstat-after-removing-nr_bounce.patch removed from -mm tree
Message-Id: <20250606050251.8EB4CC4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: fix vmstat after removing NR_BOUNCE
has been removed from the -mm tree.  Its filename was
     mm-fix-vmstat-after-removing-nr_bounce.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: mm: fix vmstat after removing NR_BOUNCE
Date: Thu, 29 May 2025 13:38:32 +0300

Hongyu noticed that the nr_unaccepted counter kept growing even in the
absence of unaccepted memory on the machine.

This happens due to a commit that removed NR_BOUNCE: it removed the
counter from the enum zone_stat_item, but left it in the vmstat_text
array.

As a result, all counters below nr_bounce in /proc/vmstat are shifted by
one line, causing the numa_hit counter to be labeled as nr_unaccepted.

To fix this issue, remove nr_bounce from the vmstat_text array.

Link: https://lkml.kernel.org/r/20250529103832.2937460-1-kirill.shutemov@linux.intel.com
Fixes: 194df9f66db8 ("mm: remove NR_BOUNCE zone stat")
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Reported-by: Hongyu Ning <hongyu.ning@linux.intel.com>
Reviewed-by: Jens Axboe <axboe@kernel.dk>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmstat.c |    1 -
 1 file changed, 1 deletion(-)

--- a/mm/vmstat.c~mm-fix-vmstat-after-removing-nr_bounce
+++ a/mm/vmstat.c
@@ -1201,7 +1201,6 @@ const char * const vmstat_text[] = {
 	"nr_zone_unevictable",
 	"nr_zone_write_pending",
 	"nr_mlock",
-	"nr_bounce",
 #if IS_ENABLED(CONFIG_ZSMALLOC)
 	"nr_zspages",
 #endif
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

mm-vmstat-fix-build-with-memcg=y-and-vm_event_counters=n.patch
mm-strictly-check-vmstat_text-array-size.patch
mm-vmstat-utilize-designated-initializers-for-the-vmstat_text-array.patch

