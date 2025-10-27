Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 686552857CD
	for <mm-commits@vger.kernel.org>; Mon, 27 Oct 2025 22:23:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761603839; cv=none; b=DmJFx/DRVt6M5morUCCSr7SL7zEcLtlamnXPA67ocGySltMmicFuULEtoMR6KLgba0GJVGm80K+Vkfs92Wwn1D4tOzWnfbr4WIhMurOVZRqdCE+GIar0qPZ6JYDVf0ZXgcQCWV5yAcRbl6aevdLFlLsnMgNTkwW1aRXe+jaQjjI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761603839; c=relaxed/simple;
	bh=5ZVF3xIr0XHawUZgweSC7n0/IuHNBR1kgCgMRklWPLA=;
	h=Date:To:From:Subject:Message-Id; b=jVRO0/7mPI++a+e51bDCwdIiPNc5Kg1RkdpMpUjAMhHs5y5GgaU850Sw89kM4aqYkV9XE53m46Syi7yH49M798kLnsP8Q8BkoYrvuhxzRKT1dKd+qL97o8HttBOHhHt5JWGwbhAeNBNLLD6PuO6PDp7aT3G0rn0WWHKHRWKT02M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rvK/XbF5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rvK/XbF5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF847C4CEF1;
	Mon, 27 Oct 2025 22:23:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1761603838;
	bh=5ZVF3xIr0XHawUZgweSC7n0/IuHNBR1kgCgMRklWPLA=;
	h=Date:To:From:Subject:From;
	b=rvK/XbF5kXd6dFh7qr2eNVp0SAtxUBZkVnCLmZ/rpo/bgOxHmzvIJ6gVghclCAta7
	 JTZfHpAUrHImuIViN1aD1uIr8aST5DXIKfPIUnPsp/kyk8hFirmuU9Nxmp49q7o9SE
	 iE/2LyEe6CHRuceyxgG5Kd9rhF24ud1LA2a0a2U4=
Date: Mon, 27 Oct 2025 15:23:58 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,rppt@kernel.org,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,david@redhat.com,jiayuan.chen@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmstat-output-reserved_highatomic-and-free_highatomic-in-zoneinfo.patch added to mm-new branch
Message-Id: <20251027222358.CF847C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: vmstat: output reserved_highatomic and free_highatomic in zoneinfo
has been added to the -mm mm-new branch.  Its filename is
     mm-vmstat-output-reserved_highatomic-and-free_highatomic-in-zoneinfo.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmstat-output-reserved_highatomic-and-free_highatomic-in-zoneinfo.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: Jiayuan Chen <jiayuan.chen@linux.dev>
Subject: mm: vmstat: output reserved_highatomic and free_highatomic in zoneinfo
Date: Mon, 27 Oct 2025 22:18:17 +0800

The nr_free_highatomic is a key factor in calculating watermarks as it
affects the free pages count.  Adding this metric, along with
nr_reserved_highatomic, to /proc/zoneinfo facilitates easier diagnosis
memory watermark calculations and memory pressure states.

Sample output:
cat /proc/zoneinfo
......
pagesets
cpu: 0
		  count:    52069
		  high:     52675
		  batch:    63
		  high_min: 13971
		  high_max: 62284
vm stats threshold: 10
node_unreclaimable:  0
start_pfn:           4096
reserved_highatomic: 5120
free_highatomic:     2081

Link: https://lkml.kernel.org/r/20251027141818.283587-1-jiayuan.chen@linux.dev
Signed-off-by: Jiayuan Chen <jiayuan.chen@linux.dev>
Cc: David Hildenbrand <david@redhat.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmstat.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/mm/vmstat.c~mm-vmstat-output-reserved_highatomic-and-free_highatomic-in-zoneinfo
+++ a/mm/vmstat.c
@@ -1852,9 +1852,13 @@ static void zoneinfo_show_print(struct s
 	}
 	seq_printf(m,
 		   "\n  node_unreclaimable:  %u"
-		   "\n  start_pfn:           %lu",
+		   "\n  start_pfn:           %lu"
+		   "\n  reserved_highatomic: %lu"
+		   "\n  free_highatomic:     %lu",
 		   atomic_read(&pgdat->kswapd_failures) >= MAX_RECLAIM_RETRIES,
-		   zone->zone_start_pfn);
+		   zone->zone_start_pfn,
+		   zone->nr_reserved_highatomic,
+		   zone->nr_free_highatomic);
 	seq_putc(m, '\n');
 }
 
_

Patches currently in -mm which might be from jiayuan.chen@linux.dev are

mm-vmscan-skip-increasing-kswapd_failures-when-reclaim-was-boosted.patch
mm-vmstat-output-reserved_highatomic-and-free_highatomic-in-zoneinfo.patch

