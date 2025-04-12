Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18DAADDAB
	for <mm-commits@vger.kernel.org>; Sat, 12 Apr 2025 00:33:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744418034; cv=none; b=teT9jD5AdKFykqYDTxOVva905SxnYvO9afcFTJ8cdznIozgGV3R/M2OjSemINjO/yVjL0uYutU/fNMPJR+3YTBOgEaKJTHx8lfYh/EPYl/hYF39/pIejVEmlsstaLuurRFUiXR05m7oVox4WCECLEgOIn+pTKJJIzNfXDSAu69U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744418034; c=relaxed/simple;
	bh=wb3j0fw6tNMeFY/QTDg991KgiAyqr2op54RgGun1fLw=;
	h=Date:To:From:Subject:Message-Id; b=TG+yfgxw/+HSHrqp+JRH08y4b25Qjo4OAYaitBS3iKXJws5hzMBBZL6aHlqcu2F28Gx8Jf/wX0ky1esvNjOov92aChlRRWhjTKdj/KUwt3WSXy7tsSljtdtGZ7CN1k+lnxqje4Lqql0Dp162metcg7tQ1J/e8ftAE5b6elb4Els=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=K0uYoQdb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="K0uYoQdb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6E5EC4CEE2;
	Sat, 12 Apr 2025 00:33:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1744418033;
	bh=wb3j0fw6tNMeFY/QTDg991KgiAyqr2op54RgGun1fLw=;
	h=Date:To:From:Subject:From;
	b=K0uYoQdb326RQ5Q0kScjr/7iH9iYvP+bqSjZ/3Xl+CvX1CkW8Ea0JMbGPaPGJ6ryZ
	 XGa1pl7lowe/7IdSLBRcOEpMDLYNCYkIslfe56jyOlKJTjjPf44KyTr78ryPM4m+/t
	 8Cd/v7WcOt2hSyfDCoD1Y4T0Jj2vqeK0P+5OWQRo=
Date: Fri, 11 Apr 2025 17:33:53 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,peterx@redhat.com,muchun.song@linux.dev,mhocko@suse.com,david@redhat.com,osalvador@suse.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] maintainers-update-hugetlb-reviewers.patch removed from -mm tree
Message-Id: <20250412003353.D6E5EC4CEE2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: MAINTAINERS: update HUGETLB reviewers
has been removed from the -mm tree.  Its filename was
     maintainers-update-hugetlb-reviewers.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Oscar Salvador <osalvador@suse.de>
Subject: MAINTAINERS: update HUGETLB reviewers
Date: Wed, 9 Apr 2025 10:24:52 +0200

I have done quite some review on hugetlb code over the years, and some
work on it as well, the latest being the hugetlb pagewalk unification
which is a work in progress, and touches hugetlb code to great lengths.

HugeTLB does not have many reviewers, so I would like to help out by
offering myself as an official Reviewer.

Signed-of-by: Oscar Salvador <osalvador@suse.de>
Link: https://lkml.kernel.org/r/20250409082452.269180-1-osalvador@suse.de
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Muchun Song <muchun.song@linux.dev>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Peter Xu <peterx@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    1 +
 1 file changed, 1 insertion(+)

--- a/MAINTAINERS~maintainers-update-hugetlb-reviewers
+++ a/MAINTAINERS
@@ -10954,6 +10954,7 @@ F:	include/linux/platform_data/huawei-ga
 
 HUGETLB SUBSYSTEM
 M:	Muchun Song <muchun.song@linux.dev>
+R:	Oscar Salvador <osalvador@suse.de>
 L:	linux-mm@kvack.org
 S:	Maintained
 F:	Documentation/ABI/testing/sysfs-kernel-mm-hugepages
_

Patches currently in -mm which might be from osalvador@suse.de are

mmhugetlb-allocate-frozen-pages-in-alloc_buddy_hugetlb_folio.patch

