Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DE953845CE
	for <mm-commits@vger.kernel.org>; Tue, 24 Mar 2026 21:44:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774388674; cv=none; b=IfoCxNidfwWyuDHY09fx7foganB0HZH+6lgujJVOx0BEloSAbk8h3sX9pj+usquoE975dDeMKLaWQMvEVb2vMO/pssSrPYc1wAUbdFKuR1kii7fbcK6xrrTYDZa7N3HruBWq1th1dn9k0eRSmAFmHtiu1QLFbKRGGFkZvvZ00K0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774388674; c=relaxed/simple;
	bh=uQ3mj/2S6MMPn5p2mtP3jTOG8FBKkIbrQuawGspaKPo=;
	h=Date:To:From:Subject:Message-Id; b=pJc2Yg0OhqYzhQI5MKQJU5pNAvp1qHYlu4w4JHMHarhovlEYSefmUA+t1COuRtcXoWNSJN+THziS/9kuzE4JWUBG8zYZHhGlswYT9uQumLu4RseprWjxeDcOJYwEoMr2fGnl4Dha5wpH2bBacc3n56hr9hkDZvqrbFGbRZuPXZg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rLDqtrlW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rLDqtrlW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78C2EC19424;
	Tue, 24 Mar 2026 21:44:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774388674;
	bh=uQ3mj/2S6MMPn5p2mtP3jTOG8FBKkIbrQuawGspaKPo=;
	h=Date:To:From:Subject:From;
	b=rLDqtrlW0M8OWd+K3qilgw5BTTRh7v8MuWYPImAGghy0mOSLdInkSQv2s0ghY9OKW
	 nOgYW0HbwgXhSIXCfnoL8qQcU1IKZkS7y6YjscVbDc9sWxZVM2BQHMk4mY2ZBpJCIm
	 2IPxLBQzQSwCiSrkXqrLxTZdznAzFhv+gXbEiuS8=
Date: Tue, 24 Mar 2026 14:44:34 -0700
To: mm-commits@vger.kernel.org,vishal.moola@gmail.com,mpatocka@redhat.com,mhocko@suse.com,bhe@redhat.com,urezki@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-vmalloc-fix-incorrect-size-reporting-on-allocation-failure.patch removed from -mm tree
Message-Id: <20260324214434.78C2EC19424@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/vmalloc: fix incorrect size reporting on allocation failure
has been removed from the -mm tree.  Its filename was
     mm-vmalloc-fix-incorrect-size-reporting-on-allocation-failure.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Reviewed-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Michal Hocko <mhocko@suse.com>
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


