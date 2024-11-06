Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DFE817BB03
	for <mm-commits@vger.kernel.org>; Wed,  6 Nov 2024 01:14:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730855653; cv=none; b=DjFVcxTU1vlTFZ39EY47615fcs9MooZOTw+dUTrSMm8U2apq3tr3Ih37Q2x4wH0csr577+xYm5PPr80FH9ExMURSdFWhQCJWlGQBql/2TfNR3N+SaJYLWcHWUpyxp5eJiA+/NHJinQNgZXf/GP6FBWdA59GfCefyYXCHMg0dw9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730855653; c=relaxed/simple;
	bh=cjLJSPrS23RSx8e2tbibIIHnnoGVzIWYiSPmYWmd3W0=;
	h=Date:To:From:Subject:Message-Id; b=Dq4kJqjzGE5nXKNlojJuL2+vVjYYswqeDr/bUcvPFQ8l/DnLLzz8b6GnZSO7NKKbJhS29BdquPQ9OaB41bh8LYwHNq1AdjTHgGqHQjzuSArUSmOJJdyiwmVeaHG6xl1dKiC8lRah6ksl7Zfl93rduC0rzt1mrDT+uEWSaH6ttiA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gJVdYC8i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gJVdYC8i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F844C4CECF;
	Wed,  6 Nov 2024 01:14:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730855653;
	bh=cjLJSPrS23RSx8e2tbibIIHnnoGVzIWYiSPmYWmd3W0=;
	h=Date:To:From:Subject:From;
	b=gJVdYC8ikMPDnBBVZzI8pq2JD4JABiobAwfrAckBIPrhPsTQVqDXyA9vmyde7nJH1
	 cP1fkvFuIIu6qyMPcxo3Irdgb20KD2zLS2gzEx3yApvkXGgvay8suJnrtdJCS0eR1m
	 FWbLaIqzChyCKSM7v0P8s5miw8UNY9tqS9Qpwf3Y=
Date: Tue, 05 Nov 2024 17:14:12 -0800
To: mm-commits@vger.kernel.org,visitorckw@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] maintainers-add-entry-for-min-heap-library-code.patch removed from -mm tree
Message-Id: <20241106011413.1F844C4CECF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: MAINTAINERS: add entry for min heap library code
has been removed from the -mm tree.  Its filename was
     maintainers-add-entry-for-min-heap-library-code.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kuan-Wei Chiu <visitorckw@gmail.com>
Subject: MAINTAINERS: add entry for min heap library code
Date: Sun, 27 Oct 2024 08:40:03 +0800

Add a new entry in the MAINTAINERS file for the min heap library code,
with myself as the maintainer.  I am pleased to take on the responsibility
of maintaining and reviewing patches for this library, as I am
well-acquainted with its details through recent contributions.

Link: https://lkml.kernel.org/r/20241027004003.987934-1-visitorckw@gmail.com
Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
Cc: Kuan-Wei Chiu <visitorckw@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/MAINTAINERS~maintainers-add-entry-for-min-heap-library-code
+++ a/MAINTAINERS
@@ -15461,6 +15461,15 @@ F:	arch/arm/boot/dts/marvell/armada-xp-c
 F:	arch/arm/boot/dts/marvell/armada-xp-crs328-4c-20s-4s-bit.dts
 F:	arch/arm/boot/dts/marvell/armada-xp-crs328-4c-20s-4s.dts
 
+MIN HEAP
+M:	Kuan-Wei Chiu <visitorckw@gmail.com>
+L:	linux-kernel@vger.kernel.org
+S:	Maintained
+F:	Documentation/core-api/min_heap.rst
+F:	include/linux/min_heap.h
+F:	lib/min_heap.c
+F:	lib/test_min_heap.c
+
 MIPI CCS, SMIA AND SMIA++ IMAGE SENSOR DRIVER
 M:	Sakari Ailus <sakari.ailus@linux.intel.com>
 L:	linux-media@vger.kernel.org
_

Patches currently in -mm which might be from visitorckw@gmail.com are


