Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4CD09476
	for <mm-commits@vger.kernel.org>; Fri, 30 May 2025 03:41:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748576468; cv=none; b=dfPUKCQ4MKWj6M1MWCBgIOE1vb6trnbkDPJAVHGDs5cQeHgjzF64MUdnvCB4AQTqoQzaHTpdtWBmPTk+qKzc09L75TOeFGKfVhkhw9rZ9kojkP816EGOf1nhdmkwdDtZLQvO8ALcGbWtUuZGqg+JSioyK588q2yhHrw/RE5nPqQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748576468; c=relaxed/simple;
	bh=OHog0hV5ORh7tDXYrW0KWn3IVQ8SfOGJLiJwHPbvvdY=;
	h=Date:To:From:Subject:Message-Id; b=la0qxCAQiz0pW61hb0cIqLBEPJeqUlwJf09GBeoTn+eZrSRfCh0LsfQ9/jQhGbUkv7M/XbY2R2vpaFED0X4AlIjykxkQTvG2qjYBZhKlpzwKMdilujFOCCSY+hYL7PBfnCS+xSObEDXpCfgzUsWx4Eat4dG4CWOP4bv1JKokM74=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=dWBOvOMo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="dWBOvOMo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 183F2C4CEE7;
	Fri, 30 May 2025 03:41:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1748576468;
	bh=OHog0hV5ORh7tDXYrW0KWn3IVQ8SfOGJLiJwHPbvvdY=;
	h=Date:To:From:Subject:From;
	b=dWBOvOMoFP9l7k8wSa0MScwpDyV4LzmisQMlqyXzU0tSSBTNwV6KXSLrXc3Pdq1GJ
	 +01FFGVv+bDOkcvJ00LKRat7WEFuuf8KBVRHKImQzmo8yItkXU6W+8pYP/cS7xE185
	 LgDIF8kUPrjp5PLt0qbCrYPXaCntqYr9yoQNwhv8=
Date: Thu, 29 May 2025 20:41:07 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,rakie.kim@sk.com,matthew.brost@intel.com,lorenzo.stoakes@oracle.com,joshua.hahnjy@gmail.com,david@redhat.com,apopple@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maintainers-add-myself-as-reviewer-of-mm-memory-policy.patch added to mm-unstable branch
Message-Id: <20250530034108.183F2C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: MAINTAINERS: add Alistair as reviewer of mm memory policy
has been added to the -mm mm-unstable branch.  Its filename is
     maintainers-add-myself-as-reviewer-of-mm-memory-policy.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maintainers-add-myself-as-reviewer-of-mm-memory-policy.patch

This patch will later appear in the mm-unstable branch at
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
From: Alistair Popple <apopple@nvidia.com>
Subject: MAINTAINERS: add Alistair as reviewer of mm memory policy
Date: Fri, 30 May 2025 11:49:17 +1000

I'm particularly familiar with mm/migrate.c and especially
mm/migrate_device.c so add myself to MAINTAINERS.

Link: https://lkml.kernel.org/r/20250530014917.2946940-1-apopple@nvidia.com
Signed-off-by: Alistair Popple <apopple@nvidia.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Mathew Brost <matthew.brost@intel.com>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    1 +
 1 file changed, 1 insertion(+)

--- a/MAINTAINERS~maintainers-add-myself-as-reviewer-of-mm-memory-policy
+++ a/MAINTAINERS
@@ -15602,6 +15602,7 @@ R:	Rakie Kim <rakie.kim@sk.com>
 R:	Byungchul Park <byungchul@sk.com>
 R:	Gregory Price <gourry@gourry.net>
 R:	Ying Huang <ying.huang@linux.alibaba.com>
+R:	Alistair Popple <apopple@nvidia.com>
 L:	linux-mm@kvack.org
 S:	Maintained
 W:	http://www.linux-mm.org
_

Patches currently in -mm which might be from apopple@nvidia.com are

fs-dax-fix-dont-skip-locked-entries-when-scanning-entries.patch
maintainers-add-myself-as-reviewer-of-mm-memory-policy.patch

