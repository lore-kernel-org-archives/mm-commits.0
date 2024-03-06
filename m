Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 444EE175AD
	for <mm-commits@vger.kernel.org>; Wed,  6 Mar 2024 21:05:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709759111; cv=none; b=iKpiSoEEggbfkLgLntjpAjq67TbfhDgT6bh96EscK/IjqUICf/IiQr4d0tm2vAm2uA3MKt5McFqP2oHttrJWq+2+PnHdipl9LLB8WcXc0bBFGPsxyM1wioaru9bTcro8GC2Fx2rYJ8rk+NHU6TYfbmRKLiYxxSUJbYxluNvgMjw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709759111; c=relaxed/simple;
	bh=UmkkaegYomIIB/7SlrnfE4OIBENRxkxZ8g29rZ69uEc=;
	h=Date:To:From:Subject:Message-Id; b=Xzyx8xuOOnwUUQ58seIeDiuHD/d8rZFWWkOj+2THMP41GLTCvOnYZZMEJv97PzYqF/CJFQmliGn9teNpi2uqmyLGdyP9VIPcsaK8D1KZuYNnAiPSDTvqyahzMjrxRTSv3Fd3sDaXLvVBzR3iep9FRx/dF7hlaZ6sK+TGsPwAf5w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=JlhDOzTS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="JlhDOzTS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 175AFC433F1;
	Wed,  6 Mar 2024 21:05:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1709759111;
	bh=UmkkaegYomIIB/7SlrnfE4OIBENRxkxZ8g29rZ69uEc=;
	h=Date:To:From:Subject:From;
	b=JlhDOzTSQwSV1WUxjhljc2l6J0hSaKejHvnueiSZeyXm5Ahc2mjpj+MQ+vNs1t1e6
	 pjcLJ7zRszPUdE9VlWdaIlLatlptbltC8bhaynlI50WAQNBeF4PFPsxr0BlgtNb9vM
	 nvwNDDZCCOEQ6+jlwOIQBCCiRskidJ6dl1nzn4qQ=
Date: Wed, 06 Mar 2024 13:05:10 -0800
To: mm-commits@vger.kernel.org,thorsten.blum@toblux.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_alloc-use-div64_ul-instead-of-do_div.patch removed from -mm tree
Message-Id: <20240306210511.175AFC433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: page_alloc: use div64_ul() instead of do_div()
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-use-div64_ul-instead-of-do_div.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Thorsten Blum <thorsten.blum@toblux.com>
Subject: mm: page_alloc: use div64_ul() instead of do_div()
Date: Wed, 28 Feb 2024 23:49:12 +0100

Fixes Coccinelle/coccicheck warning reported by do_div.cocci.

Compared to do_div(), div64_ul() does not implicitly cast the divisor and
does not unnecessarily calculate the remainder.

Link: https://lkml.kernel.org/r/20240228224911.1164-2-thorsten.blum@toblux.com
Signed-off-by: Thorsten Blum <thorsten.blum@toblux.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/page_alloc.c~mm-page_alloc-use-div64_ul-instead-of-do_div
+++ a/mm/page_alloc.c
@@ -5848,7 +5848,7 @@ static void __setup_per_zone_wmarks(void
 
 		spin_lock_irqsave(&zone->lock, flags);
 		tmp = (u64)pages_min * zone_managed_pages(zone);
-		do_div(tmp, lowmem_pages);
+		tmp = div64_ul(tmp, lowmem_pages);
 		if (is_highmem(zone) || zone_idx(zone) == ZONE_MOVABLE) {
 			/*
 			 * __GFP_HIGH and PF_MEMALLOC allocations usually don't
_

Patches currently in -mm which might be from thorsten.blum@toblux.com are

nilfs2-use-div64_ul-instead-of-do_div.patch

