Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9941155326
	for <mm-commits@vger.kernel.org>; Tue, 11 Jun 2024 21:58:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718143108; cv=none; b=EAEq8ZJUZWrzpbnPRh2UuJhz/OO9GJUMXe9Op9rUEvFAibXbZQnkwbddif0zu5TV3+jrqQqycHQiUe7Rjhb1Ko1xh9oZohWmKQk+ndoQE4MzKo+7A32NsS7PUy6I1jegmYYGZ9QK5xHU9sQEnjFVXYreKZHzqiXKTOT8iAD5nOk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718143108; c=relaxed/simple;
	bh=FOZ6Lr4T+zeso16Zi84Y9aZkQ/0aMcUOwZlM9aEZbao=;
	h=Date:To:From:Subject:Message-Id; b=PGHmIGj3NRBXEAkWG33aLBXSwlnC+e+9Je93nRgBhP1qzi8H62jCKUAe+939G/OYQ3PfrQt7DVgeLXUcoxQMZ2yW6qlsRAOITVF6R2ikCUssBFybE9f7nmo27VjHsTWmcZRGvpGnB87Ai+k1DCJCM539EMrd2gMt5K77ekhTtA4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=x4RYBgwS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="x4RYBgwS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E1AFC2BD10;
	Tue, 11 Jun 2024 21:58:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1718143108;
	bh=FOZ6Lr4T+zeso16Zi84Y9aZkQ/0aMcUOwZlM9aEZbao=;
	h=Date:To:From:Subject:From;
	b=x4RYBgwSzFBeuvExXMo4ALH0YNGZnvkuSA33HvoNUEVaeBwzjv/n8oR7kGu/KGhdc
	 Gwk0aCVb6WtAbErtXYuk/68WsrbI2pZfDP/GPI/PtO8XubpF//1MGw7o1Er6IixNAO
	 uH7VULFzHLeSreaDCPxxHVbDAXFPOuQTUnYBUGt8=
Date: Tue, 11 Jun 2024 14:58:27 -0700
To: mm-commits@vger.kernel.org,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-shmem-add-multi-size-thp-sysfs-interface-for-anonymous-shmem-fix-fix.patch added to mm-unstable branch
Message-Id: <20240611215828.6E1AFC2BD10@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-shmem-add-multi-size-thp-sysfs-interface-for-anonymous-shmem-fix-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-shmem-add-multi-size-thp-sysfs-interface-for-anonymous-shmem-fix-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-shmem-add-multi-size-thp-sysfs-interface-for-anonymous-shmem-fix-fix.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-shmem-add-multi-size-thp-sysfs-interface-for-anonymous-shmem-fix-fix
Date: Tue Jun 11 02:56:34 PM PDT 2024

reflow transhuge.rst addition to 80 cols

Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/mm/transhuge.rst |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

--- a/Documentation/admin-guide/mm/transhuge.rst~mm-shmem-add-multi-size-thp-sysfs-interface-for-anonymous-shmem-fix-fix
+++ a/Documentation/admin-guide/mm/transhuge.rst
@@ -332,12 +332,13 @@ deny
 force
     Force the huge option on for all - very useful for testing;
 
-Shmem can also use "multi-size THP" (mTHP) by adding a new sysfs knob to control
-mTHP allocation: '/sys/kernel/mm/transparent_hugepage/hugepages-<size>kB/shmem_enabled',
-and its value for each mTHP is essentially consistent with the global setting.
-An 'inherit' option is added to ensure compatibility with these global settings.
-Conversely, the options 'force' and 'deny' are dropped, which are rather testing
-artifacts from the old ages.
+Shmem can also use "multi-size THP" (mTHP) by adding a new sysfs knob to
+control mTHP allocation:
+'/sys/kernel/mm/transparent_hugepage/hugepages-<size>kB/shmem_enabled',
+and its value for each mTHP is essentially consistent with the global
+setting.  An 'inherit' option is added to ensure compatibility with these
+global settings.  Conversely, the options 'force' and 'deny' are dropped,
+which are rather testing artifacts from the old ages.
 
 always
     Attempt to allocate <size> huge pages every time we need a new page;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

writeback-factor-out-balance_wb_limits-to-remove-repeated-code-v3-fix.patch
mm-allow-reuse-of-the-lower-16-bit-of-the-page-type-with-an-actual-type-fix.patch
mm-shmem-add-multi-size-thp-sysfs-interface-for-anonymous-shmem-fix-fix.patch

