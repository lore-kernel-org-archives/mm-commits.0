Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 482B93905FD
	for <mm-commits@vger.kernel.org>; Thu, 27 Aug 2026 17:02:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787850179; cv=none; b=IEHvk9OinNn1iHbGUGZ19Wfo3ipAl5dGfy3f4tNw2doJO0+xF1MUaBl2+5zDpktQIjy5y/K/eAz9SFAHltlrF6RnZo6aEV3IjN0VwJC73KIwAHdpXWrKi5EgqO/SbQ8jcsVUronc7WRCTwfgxjY+RGuNanBIlZiUROzcLcUfIBM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787850179; c=relaxed/simple;
	bh=O8q7w47pETNX6TDLDY5rcGR52kNHjkkKLElHcrBJbZg=;
	h=Date:To:From:Subject:Message-Id; b=LOHV9dP7gsrWnDy74PPvCqwheS3a5H04nCDJzkoDRrtCwy/uw+djUzyH8agLcwCWTG/uNHcn7k0/0ipodlh8Ou4Ty1D+Txm+1EbuyBxW+xknWo8Paa4r7/rX9uCDgKjb82ksUwj/LOEVD+xNqf/FG1BEJQjbfYaPM6qAGd9+H2c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=c8y6fvN+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="c8y6fvN+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0895F1F000E9;
	Thu, 27 Aug 2026 17:02:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787850176;
	bh=3HLEMVAfEZKF17Byx2GTQhHPyxhFj1ibSRQWSs1Bq/c=;
	h=Date:To:From:Subject;
	b=c8y6fvN+uXnSEnw4rnT43ghpaxPnObQK3L1hW0nXwXYcPMuDVROKwQfZ7mwdQ0rOI
	 OU/VVdGuVHIzo5nz1MTSUEOeCwVsm74rRyeE1D0lTQl45YXjjlBlVPgzV91RMd7Qvf
	 cK4z+0KRR6pXYG2gFrXrqnMXRpartWG5PbzRLot0=
Date: Thu, 27 Aug 2026 10:02:55 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,usama.arif@linux.dev,ryan.roberts@arm.com,ljs@kernel.org,liam@infradead.org,lance.yang@linux.dev,dev.jain@arm.com,david@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,kas@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maintainers-add-myself-as-a-thp-reviewer.patch added to mm-hotfixes-unstable branch
Message-Id: <20260827170256.0895F1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: MAINTAINERS: add Kiryl as a THP reviewer
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     maintainers-add-myself-as-a-thp-reviewer.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maintainers-add-myself-as-a-thp-reviewer.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
Subject: MAINTAINERS: add Kiryl as a THP reviewer
Date: Thu, 27 Aug 2026 11:34:35 +0100

I have been working on transparent hugepages since 2012, starting with the
huge zero page and file-backed THP.  A lot of the code that causes pain
now traces back to me.  It is only fair if I share the review load for
THP.

Add myself to the reviewer list so get_maintainer.pl puts me on Cc: as
well.  It is also my commitment to be more active in reviewing this code.

Link: https://lore.kernel.org/20260827103435.1371882-1-kas@kernel.org
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Reviewed-by: Barry Song <baohua@kernel.org>
Acked-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Acked-by: Usama Arif <usama.arif@linux.dev>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    1 +
 1 file changed, 1 insertion(+)

--- a/MAINTAINERS~maintainers-add-myself-as-a-thp-reviewer
+++ a/MAINTAINERS
@@ -17258,6 +17258,7 @@ R:	Dev Jain <dev.jain@arm.com>
 R:	Barry Song <baohua@kernel.org>
 R:	Lance Yang <lance.yang@linux.dev>
 R:	Usama Arif <usama.arif@linux.dev>
+R:	Kiryl Shutsemau <kas@kernel.org>
 L:	linux-mm@kvack.org
 S:	Maintained
 W:	http://www.linux-mm.org
_

Patches currently in -mm which might be from kas@kernel.org are

maintainers-add-myself-as-a-thp-reviewer.patch

