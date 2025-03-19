Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BB6FE552;
	Wed, 19 Mar 2025 07:21:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742368918; cv=none; b=MRHMk0rGTPIuegVGf5V222xnDqpFkQY7hp/mu9QOsM0q7m7fkR5l1ZRu0tUIr750Tx+nv72q8Yo9wOEbtwDU4I5+xGZAGUKHavU04PeThuvraarMbKb+/nnD3E6qWXoTWVZdUCtvBF+7RQt04AVc5N9U8D/NuMgt+PDAvxD0lJA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742368918; c=relaxed/simple;
	bh=oPPCjbVwlCBSzHMDYmBre+f2rjt00v1FQMFj074Xsdg=;
	h=Date:To:From:Subject:Message-Id; b=Agvo7zYHEsrfa+NtoVJDp35Va86G0kpFfSaHwsbcQoxmQzIhlWrThryABaryHp68y24NfJ0BwJXWqJBAe2mmOdePx5jOKinDk+asfRfKxESdipPYk9QK9mOw1jDXo0AthLdJbTm6yRGpO6WnTMh8dKt+DdOUQLkWc5JnDMPjX4U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=JQMoc20U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="JQMoc20U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE3E5C4CEE9;
	Wed, 19 Mar 2025 07:21:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742368916;
	bh=oPPCjbVwlCBSzHMDYmBre+f2rjt00v1FQMFj074Xsdg=;
	h=Date:To:From:Subject:From;
	b=JQMoc20UT1uqIL7dYwvA1kHL3LHt3tWVhcbye7c37MXCigkJ2eGSy7V1ISsopzj8S
	 tBZyOgJyiwD8bU+0FQJ8A/1UhbnxqRoRLxIty9OvEXH2phTwLmz3R6+DEpBRteyPD2
	 Ib7NwCeRZ9emmpY+E8WivklaWd05mdPLnQ/UigKk=
Date: Wed, 19 Mar 2025 00:21:56 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,muchun.song@linux.dev,anshuman.khandual@arm.com,Marc.Herbert@linux.intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-move-hugetlb_sysctl_init-to-the-__init-section.patch added to mm-hotfixes-unstable branch
Message-Id: <20250319072156.AE3E5C4CEE9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/hugetlb: move hugetlb_sysctl_init() to the __init section
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-hugetlb-move-hugetlb_sysctl_init-to-the-__init-section.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-move-hugetlb_sysctl_init-to-the-__init-section.patch

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
From: Marc Herbert <Marc.Herbert@linux.intel.com>
Subject: mm/hugetlb: move hugetlb_sysctl_init() to the __init section
Date: Wed, 19 Mar 2025 06:00:30 +0000

hugetlb_sysctl_init() is only invoked once by an __init function and is
merely a wrapper around another __init function so there is not reason to
keep it.

Fixes the following warning when toning down some GCC inline options:

 WARNING: modpost: vmlinux: section mismatch in reference:
   hugetlb_sysctl_init+0x1b (section: .text) ->
     __register_sysctl_init (section: .init.text)

Link: https://lkml.kernel.org/r/20250319060041.2737320-1-marc.herbert@linux.intel.com
Signed-off-by: Marc Herbert <Marc.Herbert@linux.intel.com>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/hugetlb.c~mm-hugetlb-move-hugetlb_sysctl_init-to-the-__init-section
+++ a/mm/hugetlb.c
@@ -4912,7 +4912,7 @@ static const struct ctl_table hugetlb_ta
 	},
 };
 
-static void hugetlb_sysctl_init(void)
+static void __init hugetlb_sysctl_init(void)
 {
 	register_sysctl_init("vm", hugetlb_table);
 }
_

Patches currently in -mm which might be from Marc.Herbert@linux.intel.com are

mm-hugetlb-move-hugetlb_sysctl_init-to-the-__init-section.patch

