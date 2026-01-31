Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25AF038A9C2
	for <mm-commits@vger.kernel.org>; Sat, 31 Jan 2026 22:25:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769898348; cv=none; b=UTZDfqsLNR1mEJoci9GtLqXo5L7I73l/73LCNif7KYUNby2V/IboeqzwFKEMWnMfexiAxHn/LrVhw7aVvscSOq9PUFGcj8bFZfufuNnPRuqp/yg7fP6OlmYlpzqP5bmeAT55iuuY8cVfR7yju2+gYSOaqy2uyfnpA3Ha3MuSaD0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769898348; c=relaxed/simple;
	bh=rkRh43xxquTT9C4ZCDlkp/zgSEl+EPV13iJy581wLOU=;
	h=Date:To:From:Subject:Message-Id; b=Wnwq/NAgRNdoKd2mx7Ibbbt8dtN9yZcSm+MNwlTM+0KHSMtKtdgahV0rXS0NEAiP2pyTUH0HONZEMDM9EA8Dij58UPa7sgB9PAFRUI/EKH+39RhU8h2GIqCMgs935swZmYpy/lVkPIrs81dcUOIcMeWh0jyHIdfvmUHK/AXcW+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=FoOhz+DM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FoOhz+DM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0210C116D0;
	Sat, 31 Jan 2026 22:25:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769898348;
	bh=rkRh43xxquTT9C4ZCDlkp/zgSEl+EPV13iJy581wLOU=;
	h=Date:To:From:Subject:From;
	b=FoOhz+DMmN0o3XBlYTjCVOaDxF/OBEVSJjCZkUDQxfhiJ9rwJmEQZYqf2ojVza6wc
	 qwDni9bdRTU3TLNBxflL7ZneGnJL2fMlA3GHDXah09mlpwY1BZr29kVP/fza63iuxM
	 ubzU+H/fh854+68x/oclADkB3grflE0k8bIrOddM=
Date: Sat, 31 Jan 2026 14:25:47 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,rppt@kernel.org,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,david@kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] docs-mm-damon-design-document-damon-sample-modules.patch removed from -mm tree
Message-Id: <20260131222547.F0210C116D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: Docs/mm/damon/design: document DAMON sample modules
has been removed from the -mm tree.  Its filename was
     docs-mm-damon-design-document-damon-sample-modules.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: Docs/mm/damon/design: document DAMON sample modules
Date: Sun, 18 Jan 2026 10:02:54 -0800

People sometimes get confused about the purposes of DAMON special-purpose
modules and sample modules.  Clarify those on the design document by
adding a section describing their existence and purposes.

Link: https://lkml.kernel.org/r/20260118180305.70023-4-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/mm/damon/design.rst |   13 +++++++++++++
 1 file changed, 13 insertions(+)

--- a/Documentation/mm/damon/design.rst~docs-mm-damon-design-document-damon-sample-modules
+++ a/Documentation/mm/damon/design.rst
@@ -836,3 +836,16 @@ modules for proactive reclamation and LR
 more detail, please read the usage documents for those
 (:doc:`/admin-guide/mm/damon/reclaim` and
 :doc:`/admin-guide/mm/damon/lru_sort`).
+
+
+Sample DAMON Modules
+--------------------
+
+DAMON modules that provides example DAMON kernel API usages.
+
+kernel programmers can build their own special or general purpose DAMON modules
+using DAMON kernel API.  To help them easily understand how DAMON kernel API
+can be used, a few sample modules are provided under ``samples/damon/`` of the
+linux source tree.  Please note that these modules are not developed for being
+used on real products, but only for showing how DAMON kernel API can be used in
+simple ways.
_

Patches currently in -mm which might be from sj@kernel.org are


