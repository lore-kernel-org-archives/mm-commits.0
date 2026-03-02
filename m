Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78C2C155A5D
	for <mm-commits@vger.kernel.org>; Mon,  2 Mar 2026 22:57:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772492250; cv=none; b=PyV1L7VFa/TEavM2xhD/AlpWYOguaQpnRZcMciWpu564rPf5+LQgocB631HfEXZLqKTW5fna5Ww0+4nT3x979XKduRRDK2ldI6NZVfKXbke4GiPxNmJfdH6ZOKIeskXF+EAgAus/z2zmrF/ELiZNQBOPCIfqIByDwoJsK38tk2M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772492250; c=relaxed/simple;
	bh=142v7ajadblFIl0wjzGNiVuqrnrM37YNEF03fM5ld08=;
	h=Date:To:From:Subject:Message-Id; b=hnLu4ugkPe/Auzb+dZ25Ao/yCaOCwKQWIGYuIyfyekGMGSa1h8H6CRZTazxHnHdvDVE9ckQmQsqtHdPhwEIZ2SYzqOBbWbwJPjEQ9SC3mlI31bmlEtpN4W+TK3HXBcxT5SSjwM5bD43gRLG+Cto7EWURskw3vf3ipS3odbyMjlA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=NJilSooY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="NJilSooY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B6FDC19423;
	Mon,  2 Mar 2026 22:57:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1772492250;
	bh=142v7ajadblFIl0wjzGNiVuqrnrM37YNEF03fM5ld08=;
	h=Date:To:From:Subject:From;
	b=NJilSooYzQhvmJ349tbibnCdNl0JlMoKGtsJGHAmJFFZC0k4otlNBCTrTCVzSiKyw
	 ibQQsvQcCS/FYW0dIap2OFcTLA8K8twQpu8+hZDjFp2CZ4PryfK0yzROANpRth8NjD
	 WxjcikXnrJ0ndQZ9KqtJKZEVXv7At20e6SlYaBLY=
Date: Mon, 02 Mar 2026 14:57:29 -0800
To: mm-commits@vger.kernel.org,vishal.moola@gmail.com,mpatocka@redhat.com,mhocko@suse.com,bhe@redhat.com,urezki@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmalloc-fix-incorrect-size-reporting-on-allocation-failure.patch added to mm-new branch
Message-Id: <20260302225730.0B6FDC19423@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/vmalloc: fix incorrect size reporting on allocation failure
has been added to the -mm mm-new branch.  Its filename is
     mm-vmalloc-fix-incorrect-size-reporting-on-allocation-failure.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmalloc-fix-incorrect-size-reporting-on-allocation-failure.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Subject: mm/vmalloc: fix incorrect size reporting on allocation failure
Date: Mon, 2 Mar 2026 12:47:39 +0100

When __vmalloc_area_node() fails to allocate pages, the failure message
may report an incorrect allocation size, for example:

  vmalloc error: size 0, failed to allocate pages, ...

This happens because the warning prints area->nr_pages * PAGE_SIZE.  At
this point, area->nr_pages may be zero or partly populated thus it is not
valid.

Report the originally requested allocation size instead by using
nr_small_pages * PAGE_SIZE, which reflects the actual number of pages
being requested by user.

Link: https://lkml.kernel.org/r/20260302114740.2668450-1-urezki@gmail.com
Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Reviewed-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/vmalloc.c~mm-vmalloc-fix-incorrect-size-reporting-on-allocation-failure
+++ a/mm/vmalloc.c
@@ -3894,7 +3894,7 @@ static void *__vmalloc_area_node(struct
 		if (!fatal_signal_pending(current) && page_order == 0)
 			warn_alloc(gfp_mask, NULL,
 				"vmalloc error: size %lu, failed to allocate pages",
-				area->nr_pages * PAGE_SIZE);
+				nr_small_pages * PAGE_SIZE);
 		goto fail;
 	}
 
_

Patches currently in -mm which might be from urezki@gmail.com are

mm-vmalloc-fix-incorrect-size-reporting-on-allocation-failure.patch

