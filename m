Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D48A5466B
	for <mm-commits@vger.kernel.org>; Mon,  2 Sep 2024 03:28:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725247739; cv=none; b=bKRn/q3NfF7M7M5CcaU10WWgr0qiUXmK92C2qGeZcC9QfCCPa/0p45EIozV1UnnJM687P2P0CqzjVdibzvKZ/ngGDVuOh7UTp+EspeRZZGpaMwouhgpVL6OEzunT/uB9SLq1Mg+jmwftQP7O3vygv9PaxNK0jttQubk0aR8obUM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725247739; c=relaxed/simple;
	bh=8GvvTSp+9sIKhjIgGaYmVdYvitYdBO0tgbzlzWAh9LQ=;
	h=Date:To:From:Subject:Message-Id; b=k+AfUuc6K4/BitxJ0aspdx883slKAN5cY377zauka0weMxrS/KJliC21NIcQr7riBXzTEBs5drlXN7nIsSG7shNz9DH8kzgZhRAGMvBnIxKGcMdjJwz6Da63tZQ3Dlx1tJCICGPf1NBB8GQ17QmHhm09V0ip2DPdtVOxktbLVlI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=umBUT/Vp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="umBUT/Vp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14ABBC4CEC7;
	Mon,  2 Sep 2024 03:28:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725247739;
	bh=8GvvTSp+9sIKhjIgGaYmVdYvitYdBO0tgbzlzWAh9LQ=;
	h=Date:To:From:Subject:From;
	b=umBUT/VpsMEE7Fh7nzRGLWE2MKugJhobtlQCyLP2bBd+X7GLTlWJthem/4nW2Fe62
	 EX7VZipPU5KmwaKRbgbMP37xbFfF/AzcoOtEVo790iqrP9ouMX2IYSkolgB6aZfVeh
	 hiGapop15V1KDqo+vZeRAyjs44yzG9J6mhVBD84w=
Date: Sun, 01 Sep 2024 20:28:58 -0700
To: mm-commits@vger.kernel.org,hannes@cmpxchg.org,kaiyang2@cs.cmu.edu,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-print-the-promo-watermark-in-zoneinfo.patch removed from -mm tree
Message-Id: <20240902032859.14ABBC4CEC7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: print the promo watermark in zoneinfo
has been removed from the -mm tree.  Its filename was
     mm-print-the-promo-watermark-in-zoneinfo.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kaiyang Zhao <kaiyang2@cs.cmu.edu>
Subject: mm: print the promo watermark in zoneinfo
Date: Thu, 1 Aug 2024 23:25:48 +0000

Print the promo watermark in zoneinfo just like other watermarks.  This
helps users check and verify all the watermarks are appropriate.

Link: https://lkml.kernel.org/r/20240801232548.36604-3-kaiyang2@cs.cmu.edu
Signed-off-by: Kaiyang Zhao <kaiyang2@cs.cmu.edu>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmstat.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/vmstat.c~mm-print-the-promo-watermark-in-zoneinfo
+++ a/mm/vmstat.c
@@ -1743,6 +1743,7 @@ static void zoneinfo_show_print(struct s
 		   "\n        min      %lu"
 		   "\n        low      %lu"
 		   "\n        high     %lu"
+		   "\n        promo    %lu"
 		   "\n        spanned  %lu"
 		   "\n        present  %lu"
 		   "\n        managed  %lu"
@@ -1752,6 +1753,7 @@ static void zoneinfo_show_print(struct s
 		   min_wmark_pages(zone),
 		   low_wmark_pages(zone),
 		   high_wmark_pages(zone),
+		   promo_wmark_pages(zone),
 		   zone->spanned_pages,
 		   zone->present_pages,
 		   zone_managed_pages(zone),
_

Patches currently in -mm which might be from kaiyang2@cs.cmu.edu are

mmmemcg-provide-per-cgroup-counters-for-numa-balancing-operations.patch
mmmemcg-provide-per-cgroup-counters-for-numa-balancing-operations-v4.patch

