Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 173A830B53F
	for <mm-commits@vger.kernel.org>; Wed, 26 Aug 2026 21:17:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787779025; cv=none; b=AVJ67DAXLcIztyH4ker+w8VVQseqQBvcic4tkknRFlYDVPmbeyvBrNOSR4qBe30BtBY9ccBeTXhI6479ezu7MBgpsqqDuF98weMTsWhF6DSy3TA5H/xf8AiMl3OPedbFpOJlPwMqM4VIqwdA0kAa5kFxNXCBfpRKoYsXUXWrEGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787779025; c=relaxed/simple;
	bh=K7MFgodgMDjeWPTPQBlpNFRKpwrBurXIe9JHbQ5xwFw=;
	h=Date:To:From:Subject:Message-Id; b=UnWigcE8YfalmNYySN0gES3yCaM/OmNjX/JUFFSUk93yG7J1l2uHfTokosBpaJL63aP9xSz0INciL6Sa85EKmdlyf7OTS4qkfaKVEyQ3m+HYcQT0zWz9bnKaHO84NIp9XIP5LiyJcnXBpvP//iVscdCPmjqMmAkWH4GW6Fdr/5I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qUxiIW79; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qUxiIW79"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9557A1F000E9;
	Wed, 26 Aug 2026 21:17:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787779023;
	bh=MjZtwKmDM7v2cYi0l6992zYkPnW3MgWu6Fwri40QBKY=;
	h=Date:To:From:Subject;
	b=qUxiIW79Wee6L5V3xYhezw8OtX1HpBlo+riryLzqdH7XiHn/4VJRBzffMdwUcN1X3
	 zTd49Y1h9i3fYyuLuuDgogZ2eIIfRpzHBNlKspc1+Pd+FDtCDyRWFjNbxuJu1QUg5s
	 g0wVsdXKwpEsSXMLqu/PG5hVHOdr5jLlhFs8rn4E=
Date: Wed, 26 Aug 2026 14:17:02 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ryan.roberts@arm.com,liam@infradead.org,lance.yang@linux.dev,kirill@shutemov.name,dev.jain@arm.com,david@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,ljs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maintainers-remove-myself-as-thp-co-maintainer.patch added to mm-hotfixes-unstable branch
Message-Id: <20260826211703.9557A1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: MAINTAINERS: remove Lorenzo as THP co-maintainer
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     maintainers-remove-myself-as-thp-co-maintainer.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maintainers-remove-myself-as-thp-co-maintainer.patch

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
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Subject: MAINTAINERS: remove Lorenzo as THP co-maintainer
Date: Wed, 26 Aug 2026 10:56:39 +0100

Unfortunately my workload is such that I simply no longer have the time to
give THP the focus that it deserves.

So, at least temporarily, step down from the role.

Link: https://lore.kernel.org/20260826-drop-thp-maintainership-v1-1-3d102748fa17@kernel.org
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Cc:
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Kiryl Shutsemau <kirill@shutemov.name>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    1 -
 1 file changed, 1 deletion(-)

--- a/MAINTAINERS~maintainers-remove-myself-as-thp-co-maintainer
+++ a/MAINTAINERS
@@ -17249,7 +17249,6 @@ F:	mm/swapfile.c
 MEMORY MANAGEMENT - THP (TRANSPARENT HUGE PAGE)
 M:	Andrew Morton <akpm@linux-foundation.org>
 M:	David Hildenbrand <david@kernel.org>
-M:	Lorenzo Stoakes <ljs@kernel.org>
 R:	Zi Yan <ziy@nvidia.com>
 R:	Baolin Wang <baolin.wang@linux.alibaba.com>
 R:	Liam R. Howlett <liam@infradead.org>
_

Patches currently in -mm which might be from ljs@kernel.org are

maintainers-remove-myself-as-thp-co-maintainer.patch

