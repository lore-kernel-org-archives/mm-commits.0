Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D695526ACB
	for <mm-commits@vger.kernel.org>; Thu, 10 Apr 2025 01:29:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744248540; cv=none; b=iOT2KW7fh93UCHwjr1pJZCBVpeP0NWZPe1rLNh5TJhpq6VJTA93NAxKvXXIfbr2CQ27ApElE0qqs16PFLrTagDpewY+ZcXA//FKHpX995kvBxGT7wZkUxivA8ym4AhQIu/zxvgqDEgRPpWXySRVg8ErlbjnEa1GfIjLrpjJvqYk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744248540; c=relaxed/simple;
	bh=i/k0hzY0qr7qsqJW+IPyN+wO8UCUJV/EJ3mpxaudctc=;
	h=Date:To:From:Subject:Message-Id; b=DCQ6nyT2Iv6Zhm7jfMPmlJgSvvL8hj4xW17BBIwT3YSRxahfadYCKa8A0817A06wA8/+1Nb+oy5Gs5At1LGII69+0ushq1/C5a6N5JRO6X/dlcEUNUUMM8jxpIA4ymL4nJSDI3hEvowEH9y/vCoesMmJimgQmDW5RT3uWK0INJQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=SnUqEmEU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="SnUqEmEU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 380A1C4CEE2;
	Thu, 10 Apr 2025 01:29:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1744248540;
	bh=i/k0hzY0qr7qsqJW+IPyN+wO8UCUJV/EJ3mpxaudctc=;
	h=Date:To:From:Subject:From;
	b=SnUqEmEUUHNYcbiexpTg59y5Ep2a946Sg80ov5eW0x5ARLZEZaNndszzjGmvhzyxE
	 M0URKYiaYkWR5HDvEYQrHZkjXWnjYVSXAxURNdZ2cfveddH5C/RXaXnsWiRRQ5pVo3
	 2xQgnwwj7GM8tahVYR1J9HIVz/9BHm+nC6D0485M=
Date: Wed, 09 Apr 2025 18:28:59 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,peterx@redhat.com,muchun.song@linux.dev,mhocko@suse.com,david@redhat.com,osalvador@suse.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maintainers-update-hugetlb-reviewers.patch added to mm-hotfixes-unstable branch
Message-Id: <20250410012900.380A1C4CEE2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: MAINTAINERS: update HUGETLB reviewers
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     maintainers-update-hugetlb-reviewers.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maintainers-update-hugetlb-reviewers.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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

maintainers-update-hugetlb-reviewers.patch

