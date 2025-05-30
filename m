Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DD792AD11
	for <mm-commits@vger.kernel.org>; Fri, 30 May 2025 04:12:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748578376; cv=none; b=mWqeNtr2d0dalpgeCXQQ+TSqJIBGEYyZhTg0lzN2WH4vUBSXZ+T8z/KkMUceLVEMyY96zR6Wxp10kieQ5jPBAKkb8BxkqoalVfqbMyBlJtrOstgx/XyEO47/fh/mzkDpsgY8xFsLDtAzsG4j2un7aN17YUdABNDOp0yMcYFSXQQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748578376; c=relaxed/simple;
	bh=2ze4QLqAXk637M0AYoHxYEReOZOwRKDkrVJ5li95DJc=;
	h=Date:To:From:Subject:Message-Id; b=R4eaUhgoPVH8/Fo+MYQ/CWl/YajjR+ngJnCsXiQJQGp+UTe5g/WISJkLYMRY0ekVgmGjbkdhQICagSVeZREld5I2+dgc71h0haKfhSkbIselEn1iY2d4s+R6vIeJLcxnbir6MPo24c1Q0OwJCiHSdmizn/7Vr/TnI3QnSdSu1Nw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=UIcAN0ZT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="UIcAN0ZT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2D2BC4CEE9;
	Fri, 30 May 2025 04:12:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1748578375;
	bh=2ze4QLqAXk637M0AYoHxYEReOZOwRKDkrVJ5li95DJc=;
	h=Date:To:From:Subject:From;
	b=UIcAN0ZT06xymyleO1ILbhnNf3WwGx/cbH6RXByPWSAKCbcvuDQsqCyqlZ2Fbz9EI
	 hUDx5EU3vS/3pKWmWqBkLUJY6eZak8XanjblWUSnqNgeKc6ebcscA634KN0okKwIob
	 qnRQswrW7biWAtYEb8+1axNHsTRYpPry66iZmtbg=
Date: Thu, 29 May 2025 21:12:55 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,shakeel.butt@linux.dev,mhocko@suse.com,johannes.thumshirn@wdc.com,hongyu.ning@linux.intel.com,hch@lst.de,hare@suse.de,axboe@kernel.dk,kirill.shutemov@linux.intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-fix-vmstat-after-removing-nr_bounce.patch added to mm-hotfixes-unstable branch
Message-Id: <20250530041255.B2D2BC4CEE9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: fix vmstat after removing NR_BOUNCE
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-fix-vmstat-after-removing-nr_bounce.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-fix-vmstat-after-removing-nr_bounce.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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

mm-fix-vmstat-after-removing-nr_bounce.patch
mm-strictly-check-vmstat_text-array-size.patch

