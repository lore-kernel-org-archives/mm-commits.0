Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60B6E8634E
	for <mm-commits@vger.kernel.org>; Thu, 16 Jan 2025 05:16:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737004577; cv=none; b=J4x+6SeyzI7UZDGxI2POLhwlMGqyNbhT6Wr1kFRFDxD4er5Bf3vg2sUIsE/L9KIwwTxq0ZJMsMynDvQQAQMcq2BA/aGI6it/qaQZazs14fEn5WzJhiY3eILTQM0n3KQM+s/dQDQFeOj2uDmGvKPP7ZKUmtfyi2Ph2x+5RfaZea8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737004577; c=relaxed/simple;
	bh=oWa/h0QKDmDENj3h3u7NmeJmoRQ7cPZfioHA8aRBVVo=;
	h=Date:To:From:Subject:Message-Id; b=MdfXWhM+Xrc9kQUeMXRa4ADHphuxoqmvEcK26TA+ZtAiweQdcRG5xDnhBmJCBfGbZ+OLrEnUF0+xkOfmg9S3ILlqms2qTaxgrFlSCMGGAHK8TQEVTTkR/KEb3swUpFJfUs19CyH6RkdBFCHHTbjI7HLxwYWAIXUeGcgE83zAl2M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=sJ/D5oyD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="sJ/D5oyD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C26EFC4CED6;
	Thu, 16 Jan 2025 05:16:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1737004576;
	bh=oWa/h0QKDmDENj3h3u7NmeJmoRQ7cPZfioHA8aRBVVo=;
	h=Date:To:From:Subject:From;
	b=sJ/D5oyDCqxCYUBqh2JBH0yp4OIyBIqfE4SGBjRSZu/ZqxUvHEfsiNRhB/ERNguUj
	 0TgFaCNxYhuVmTv7i204YyVmPiBH5cpt1/Ys1mpHivncvKPegOHpNyW46O7D8MTET7
	 CFmMyrDzld0EoGYT8atIsj8ny32mxiSoEy55W4Sw=
Date: Wed, 15 Jan 2025 21:16:16 -0800
To: mm-commits@vger.kernel.org,yaowenchao@jd.com,15645113830zzh@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-page_alloc-fix-missed-updates-of-lowmem_reserve-in-adjust_managed_page_count.patch removed from -mm tree
Message-Id: <20250116051616.C26EFC4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: page_alloc: fix missed updates of lowmem_reserve in adjust_managed_page_count
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-fix-missed-updates-of-lowmem_reserve-in-adjust_managed_page_count.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: zihan zhou <15645113830zzh@gmail.com>
Subject: mm: page_alloc: fix missed updates of lowmem_reserve in adjust_managed_page_count
Date: Wed, 25 Dec 2024 10:10:35 +0800

In the kernel, the zone's lowmem_reserve and _watermark, and the global
variable 'totalreserve_pages' depend on the value of managed_pages, but
after running adjust_managed_page_count, these values aren't updated,
which causes some problems.

For example, in a system with six 1GB large pages, we found that the value
of protection in zoneinfo (zone->lowmem_reserve), is not right.  Its value
seems to be calculated from the initial managed_pages, but after the
managed_pages changed, was not updated.  Only after reading the file
/proc/sys/vm/lowmem_reserve_ratio, updates happen.

read file /proc/sys/vm/lowmem_reserve_ratio:

lowmem_reserve_ratio_sysctl_handler
----setup_per_zone_lowmem_reserve
--------calculate_totalreserve_pages

protection changed after reading file:

[root@test ~]# cat /proc/zoneinfo | grep protection
        protection: (0, 2719, 57360, 0)
        protection: (0, 0, 54640, 0)
        protection: (0, 0, 0, 0)
        protection: (0, 0, 0, 0)
[root@test ~]# cat /proc/sys/vm/lowmem_reserve_ratio
256     256     32      0
[root@test ~]# cat /proc/zoneinfo | grep protection
        protection: (0, 2735, 63524, 0)
        protection: (0, 0, 60788, 0)
        protection: (0, 0, 0, 0)
        protection: (0, 0, 0, 0)

lowmem_reserve increased also makes the totalreserve_pages increased,
which causes a decrease in available memory.  The one above is just a test
machine, and the increase is not significant.  On our online machine, the
reserved memory will increase by several GB due to reading this file.  It
is clearly unreasonable to cause a sharp drop in available memory just by
reading a file.

In this patch, we update reserve memory when update managed_pages, The
size of reserved memory becomes stable.  But it seems that the _watermark
should also be updated along with the managed_pages.  We have not done it
because we are unsure if it is reasonable to set the watermark through the
initial managed_pages.  If it is not reasonable, we will propose new
patch.

Link: https://lkml.kernel.org/r/20241225021034.45693-1-15645113830zzh@gmail.com
Signed-off-by: zihan zhou <15645113830zzh@gmail.com>
Signed-off-by: yaowenchao <yaowenchao@jd.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/mm/page_alloc.c~mm-page_alloc-fix-missed-updates-of-lowmem_reserve-in-adjust_managed_page_count
+++ a/mm/page_alloc.c
@@ -5692,10 +5692,13 @@ __meminit void zone_pcp_init(struct zone
 			 zone->present_pages, zone_batchsize(zone));
 }
 
+static void setup_per_zone_lowmem_reserve(void);
+
 void adjust_managed_page_count(struct page *page, long count)
 {
 	atomic_long_add(count, &page_zone(page)->managed_pages);
 	totalram_pages_add(count);
+	setup_per_zone_lowmem_reserve();
 }
 EXPORT_SYMBOL(adjust_managed_page_count);
 
_

Patches currently in -mm which might be from 15645113830zzh@gmail.com are


