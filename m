Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72DB81DED5F
	for <mm-commits@vger.kernel.org>; Mon,  1 Sep 2025 19:02:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756753337; cv=none; b=MJJzaiVw/nZuin/Pa+2SsCfr9xLIwjxXoTpRbUCbNf4F2TN/21zTdBiqX9IF5N6BvZxtfcg6fT4CRHPxR+5H4uT3vet/HcK2wFN6o6+ijnENVDYyHoqwmssooFyQNchlJ4pjvipPOfs3MOB97WGqK7i0KL6vqUcnj0KwKeYQBU4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756753337; c=relaxed/simple;
	bh=mkC/bBf0CMcm78o2g/UTk87lTS83WT1+jWmrzY5KW80=;
	h=Date:To:From:Subject:Message-Id; b=WyKRAx+CPdPFI0LuJgv7JN7EawiyQohdReuCfbghIPNGyQVcSKWdTy8c8o0cM0VJX6RAyNJb5ZushlL+XrUDLz//RyibOIIn6Ht53fxjO+12S9asWIM3l3AxBL/Kha9wHt/jj5mpWWJB6Nzo6oPtH3xZglYuTzpGNHHzW6m6DSA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=hbIKaQWb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="hbIKaQWb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4DD1C4CEF0;
	Mon,  1 Sep 2025 19:02:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1756753334;
	bh=mkC/bBf0CMcm78o2g/UTk87lTS83WT1+jWmrzY5KW80=;
	h=Date:To:From:Subject:From;
	b=hbIKaQWbaBre12cSaf3CB52kjYJT4+jWQ+dFoK1y6/k4Du2qPm0vD3zRd4iRCPLfD
	 QR922MPSJTPykgXJPLhYDQqk2iIOhYNn4NGZcOOSgLOmhFJS3KXRnEgYsAuhRxSaXw
	 PFt3WXSLzHc3wZvCrqZs2u+nc/8PYYVw2Uuq6ueI=
Date: Mon, 01 Sep 2025 12:02:14 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@suse.cz,surenb@google.com,mhocko@suse.com,jackmanb@google.com,hannes@cmpxchg.org,cascardo@igalia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-show_mem-show-number-of-zspages-in-show_free_areas.patch added to mm-new branch
Message-Id: <20250901190214.D4DD1C4CEF0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: show_mem: show number of zspages in show_free_areas
has been added to the -mm mm-new branch.  Its filename is
     mm-show_mem-show-number-of-zspages-in-show_free_areas.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-show_mem-show-number-of-zspages-in-show_free_areas.patch

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
From: Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
Subject: mm: show_mem: show number of zspages in show_free_areas
Date: Mon, 1 Sep 2025 15:37:28 -0300

When OOM is triggered, it will show where the pages might be for each
zone.  When using zram, it might look like lots of pages are missing. 
After this patch, zspages are shown as below.

[   48.792859] Node 0 DMA free:2812kB boost:0kB min:60kB low:72kB high:84kB reserved_highatomic:0KB free_highatomic:0KB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB writepending:0kB zspages:11160kB present:15992kB managed:15360kB mlocked:0kB bounce:0kB free_pcp:0kB local_pcp:0kB free_cma:0kB
[   48.792962] lowmem_reserve[]: 0 956 956 956 956
[   48.792988] Node 0 DMA32 free:3512kB boost:0kB min:3912kB low:4888kB high:5864kB reserved_highatomic:0KB free_highatomic:0KB active_anon:0kB inactive_anon:28kB active_file:8kB inactive_file:16kB unevictable:0kB writepending:0kB zspages:916780kB present:1032064kB managed:978944kB mlocked:0kB bounce:0kB free_pcp:500kB local_pcp:248kB free_cma:0kB
[   48.793118] lowmem_reserve[]: 0 0 0 0 0

Link: https://lkml.kernel.org/r/20250901183729.3900578-1-cascardo@igalia.com
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/show_mem.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/show_mem.c~mm-show_mem-show-number-of-zspages-in-show_free_areas
+++ a/mm/show_mem.c
@@ -310,6 +310,7 @@ static void show_free_areas(unsigned int
 			" inactive_file:%lukB"
 			" unevictable:%lukB"
 			" writepending:%lukB"
+			" zspages:%lukB"
 			" present:%lukB"
 			" managed:%lukB"
 			" mlocked:%lukB"
@@ -332,6 +333,7 @@ static void show_free_areas(unsigned int
 			K(zone_page_state(zone, NR_ZONE_INACTIVE_FILE)),
 			K(zone_page_state(zone, NR_ZONE_UNEVICTABLE)),
 			K(zone_page_state(zone, NR_ZONE_WRITE_PENDING)),
+			K(zone_page_state(zone, NR_ZSPAGES)),
 			K(zone->present_pages),
 			K(zone_managed_pages(zone)),
 			K(zone_page_state(zone, NR_MLOCK)),
_

Patches currently in -mm which might be from cascardo@igalia.com are

mm-page_alloc-only-set-alloc_highatomic-for-__gpf_high-allocations.patch
mm-show_mem-show-number-of-zspages-in-show_free_areas.patch

