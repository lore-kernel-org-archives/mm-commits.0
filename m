Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC1042DC797
	for <mm-commits@vger.kernel.org>; Thu,  6 Nov 2025 23:42:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762472543; cv=none; b=qKEZnvQJBx/60BRC1W4u0NrM3/NvsZOofXccJlWI6pJ5vRekDVPFlfiy1NH9L/1dGPELIs7wfoE6r4IJTigGx4TxNQH9WgNyXlutEpv131rX+rSXHu612oRUnunSCVyEjjeZKV+G811TDBzLd4764jRrWhrKSouaP1rlDzy1VCs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762472543; c=relaxed/simple;
	bh=Vkt5Q0L1um9syRCVgSb4cHdzeh9sDGD0V5zYRykUA7A=;
	h=Date:To:From:Subject:Message-Id; b=Y50jzQIEWXYQ+PXgS8yXZoF21sadmx1NkmtmOnLwh70E9NcDE9PInH+BnH9cZaisC+Fd5Wx65enT8lvqK+yUrT3PCuDTpE4k55xi9/l4WRbanM+Qn0wcB62ZVz+Q/5uroU0CwJu824bf7ariQR4Iy9JwB28pKe84sj9Pb6gKfVk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=MbNb/bKp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="MbNb/bKp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F605C116D0;
	Thu,  6 Nov 2025 23:42:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1762472543;
	bh=Vkt5Q0L1um9syRCVgSb4cHdzeh9sDGD0V5zYRykUA7A=;
	h=Date:To:From:Subject:From;
	b=MbNb/bKpN6r85a7ELXnjKq/ZfhtEpF6OssY8cPfjaXgw15ClI5WfyGi5Q2yolkAqa
	 kPaSYfunjCGcMMqX3zayaihuUBVfCBMb+0GSmQQYH+uyc4TDWeHgP/JMayuGHOtlby
	 EEvn1yCC91dO2wQDiJmIZ4C4EmuuBW3NjLv4XiBM=
Date: Thu, 06 Nov 2025 15:42:22 -0800
To: mm-commits@vger.kernel.org,osalvador@suse.de,david@kernel.org,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + memory_hotplug-optimise-try_offline_memory_block.patch added to mm-new branch
Message-Id: <20251106234223.6F605C116D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: memory_hotplug: optimise try_offline_memory_block()
has been added to the -mm mm-new branch.  Its filename is
     memory_hotplug-optimise-try_offline_memory_block.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/memory_hotplug-optimise-try_offline_memory_block.patch

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
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: memory_hotplug: optimise try_offline_memory_block()
Date: Thu, 6 Nov 2025 20:14:50 +0000

Extract the zone number directly from the page instead of using the page's
zone number to look up the zone and asking the zone what its number is.

Link: https://lkml.kernel.org/r/20251106201452.2292631-3-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memory_hotplug.c~memory_hotplug-optimise-try_offline_memory_block
+++ a/mm/memory_hotplug.c
@@ -2327,7 +2327,7 @@ static int try_offline_memory_block(stru
 	 * by offlining code ... so we don't care about that.
 	 */
 	page = pfn_to_online_page(section_nr_to_pfn(mem->start_section_nr));
-	if (page && zone_idx(page_zone(page)) == ZONE_MOVABLE)
+	if (page && page_zonenum(page) == ZONE_MOVABLE)
 		online_type = MMOP_ONLINE_MOVABLE;
 
 	rc = device_offline(&mem->dev);
_

Patches currently in -mm which might be from willy@infradead.org are

hugetlb-optimise-hugetlb_folio_init_tail_vmemmap.patch
migrate-optimise-alloc_migration_target.patch
memory_hotplug-optimise-try_offline_memory_block.patch

