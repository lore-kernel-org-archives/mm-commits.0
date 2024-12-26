Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7569A189BB0
	for <mm-commits@vger.kernel.org>; Thu, 26 Dec 2024 21:53:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735249991; cv=none; b=jAY5K5cJCVo3AvGJxqR3YL7k6zGkAysk1/MNxlNUr80vhEdkxLH53KG3f/L0elTcbOEF0oPgInwQvVJSnhTvZCYFQ3D6XLXrg4ELxF28qs2UBnyzd/GvH33jyPKBfxFEs3FuxRYSAoQYgyG/4y+uvhFDtogHDO2AjPy3F6GX0G4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735249991; c=relaxed/simple;
	bh=Rx6GiwbtmUjmhxG3ZIYIdL5WH571bYD8fISYSklIgBY=;
	h=Date:To:From:Subject:Message-Id; b=bbqIVDdsJsxCY/gOgU6XgVZVCrO7Q+VmAjkI38xuQC9T26El2HiKeQ8y8uetlOYhx+FaBX7GvKmXVx6bQQt/RTDYAyZ9+nM718sMpSuyKkDqsNAPiJ6L8Vo/S+mbvK+jXBpI9zMDjpWguPL/hv0y2+SKDyWdyIxIMJSo64m2GLY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=j0lRy0nq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="j0lRy0nq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D55D6C4CED1;
	Thu, 26 Dec 2024 21:53:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1735249990;
	bh=Rx6GiwbtmUjmhxG3ZIYIdL5WH571bYD8fISYSklIgBY=;
	h=Date:To:From:Subject:From;
	b=j0lRy0nqUmkDy9KZgF2XdP6RluPkmPApUva5DvIp7WbiNC7lcir+Lex0469Ydqqpk
	 KtYGtY9abLLdJghEUsxhaj34JVXuzFORnV+kbFBKbkEewTMiABJQCUREnRlPqeGSdz
	 03FT7LUMCjSrNatTms5lp0zYKNBEDFQk601k9tRs=
Date: Thu, 26 Dec 2024 13:53:10 -0800
To: mm-commits@vger.kernel.org,yaowenchao@jd.com,15645113830zzh@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-fix-missed-updates-of-lowmem_reserve-in-adjust_managed_page_count.patch added to mm-hotfixes-unstable branch
Message-Id: <20241226215310.D55D6C4CED1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: page_alloc: fix missed updates of lowmem_reserve in adjust_managed_page_count
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-page_alloc-fix-missed-updates-of-lowmem_reserve-in-adjust_managed_page_count.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_alloc-fix-missed-updates-of-lowmem_reserve-in-adjust_managed_page_count.patch

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
From: zihan zhou <15645113830zzh@gmail.com>
Subject: mm: page_alloc: fix missed updates of lowmem_reserve in adjust_managed_page_count
Date: Wed, 25 Dec 2024 10:10:35 +0800

In the kernel, the zone's lowmem_reserve and _watermark, and the global
variable 'totalreserve_pages' depend on the value of managed_pages, but
after running adjust_managed_page_count, these values aren't updated,
which caused some problems.

For example, in a system with six 1GB large pages, we found that the value
of protection in zoneinfo (zone->lowmem_reserve), is not right.  Its value
seems calculated from the initial managed_pages, but after the
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

mm-page_alloc-fix-missed-updates-of-lowmem_reserve-in-adjust_managed_page_count.patch

