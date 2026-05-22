Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94695268690
	for <mm-commits@vger.kernel.org>; Fri, 22 May 2026 00:39:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779410375; cv=none; b=PjU9RYeR7rPXGduZybufTcdEzIXr/2jfw0RZmpR47auJtRwtw8pXIQ/PJPy8jPaKPACNybv32nJrQ4vI938wQzWKjNZjYqBCTJ/O/TzJwbTexKh34Ob9r57IiN+1wKs7ukF/nooShS1fkF/ehSCK9yn641y/IWUsjZzdhjhLKLk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779410375; c=relaxed/simple;
	bh=KUZnndmvd5aKCe9cx4vTLndp6H2z4Ipqx6EvF+y5x+k=;
	h=Date:To:From:Subject:Message-Id; b=GnNRlBdvFiCmRx6z7vXKrWxb+E6Obcvg3jlA0wNMTrRo6d7u9tdo9MUUPGqviI1RCjhcDeU3OpKKfbzwM5O/AaPUKdHLmRWN3FkeK4wad8fHmTPN4GWXmB77i4/pJXfjeDuhzOXoc5dewpC0TKWp77TBo21BlC4Sw+wCnYLbhMA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=BcU5uJb8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="BcU5uJb8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D2561F000E9;
	Fri, 22 May 2026 00:39:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1779410374;
	bh=hVxdSa+2iRQMcnO+6RgaDrsRPgrLubCutjfVg2fGPR4=;
	h=Date:To:From:Subject;
	b=BcU5uJb8boKZLT7bBP/iSYD3xYC25WB3rrhLP0yUxyLhJnrGCuvzWdgb4Hk9rhmDM
	 h51iKaYye1ZTcRkXRjGy8WXV2nt59sgaQCahN2a1Pi6tGb5EmFrslpLpSaWbYIWRXv
	 LpthMaEmTeo0FCG1alLzvOzFZf9r5yaBu20Bnqkk=
Date: Thu, 21 May 2026 17:39:33 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,surenb@google.com,skhan@linuxfoundation.org,sj@kernel.org,ryan.roberts@arm.com,rppt@kernel.org,npache@redhat.com,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,lance.yang@linux.dev,dev.jain@arm.com,david@kernel.org,corbet@lwn.net,baolin.wang@linux.alibaba.com,baohua@kernel.org,leon.hwang@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + documentation-admin-guide-mm-fix-typos-in-transhugerst.patch added to mm-unstable branch
Message-Id: <20260522003934.3D2561F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: Documentation/admin-guide/mm: fix typos in transhuge.rst
has been added to the -mm mm-unstable branch.  Its filename is
     documentation-admin-guide-mm-fix-typos-in-transhugerst.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/documentation-admin-guide-mm-fix-typos-in-transhugerst.patch

This patch will later appear in the mm-unstable branch at
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
From: Leon Hwang <leon.hwang@linux.dev>
Subject: Documentation/admin-guide/mm: fix typos in transhuge.rst
Date: Wed, 20 May 2026 13:17:51 +0800

Fix these two typos:

1. approporiately -> appropriately
2. presure -> pressure

Link: https://lore.kernel.org/20260520051751.74396-1-leon.hwang@linux.dev
Signed-off-by: Leon Hwang <leon.hwang@linux.dev>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Reviewed-by: SeongJae Park <sj@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Leon Hwang <leon.hwang@linux.dev>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Nico Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/mm/transhuge.rst |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/Documentation/admin-guide/mm/transhuge.rst~documentation-admin-guide-mm-fix-typos-in-transhugerst
+++ a/Documentation/admin-guide/mm/transhuge.rst
@@ -57,7 +57,7 @@ prominent because the size of each page
 variant and there is less memory to clear in each page fault. Some
 architectures also employ TLB compression mechanisms to squeeze more
 entries in when a set of PTEs are virtually and physically contiguous
-and approporiately aligned. In this case, TLB misses will occur less
+and appropriately aligned. In this case, TLB misses will occur less
 often.
 
 THP can be enabled system wide or restricted to certain tasks or even
@@ -211,7 +211,7 @@ PMD-mappable transparent hugepage::
 	cat /sys/kernel/mm/transparent_hugepage/hpage_pmd_size
 
 All THPs at fault and collapse time will be added to _deferred_list,
-and will therefore be split under memory presure if they are considered
+and will therefore be split under memory pressure if they are considered
 "underused". A THP is underused if the number of zero-filled pages in
 the THP is above max_ptes_none (see below). It is possible to disable
 this behaviour by writing 0 to shrink_underused, and enable it by writing
_

Patches currently in -mm which might be from leon.hwang@linux.dev are

documentation-admin-guide-mm-fix-typos-in-transhugerst.patch

