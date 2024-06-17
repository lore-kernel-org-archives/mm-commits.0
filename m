Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD455198A03
	for <mm-commits@vger.kernel.org>; Mon, 17 Jun 2024 19:16:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718651760; cv=none; b=YMTh5dTvWDdCYxJyruQgIUc0VbYq+eqLHdCZAY6S/Lks/zR5v8blN977NaoMm88a5YwXwnOo7aucC/653SBGu7nC6pXDgaZivvBrhyBiLHswRv6pdQs37MtTBf2go/b/J5Tp9DNjqx19pjN7wloY0sK1KMzDDizbsqwh2JsWzGA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718651760; c=relaxed/simple;
	bh=xZqgEf+s7xp0H/aMmrYGNs3FWOcyepiXkofmB4yagUA=;
	h=Date:To:From:Subject:Message-Id; b=gOKUoPUQKMsRbosJP3wCyHOulWlRry/AcaE+XMxcdY5xw/QYpvUMAnMxvo9sW0veoAn//IKMwZKJ6IYCakMv83D/oAxnznXGB8V8JDMk4dVPvkvVRKkh0xVwOEnyxkaF/i15bm9u+qMC3juKqNxLm4mgt3gR1sY+64uwG1VX64U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Oprth+/4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Oprth+/4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2450BC2BD10;
	Mon, 17 Jun 2024 19:16:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1718651760;
	bh=xZqgEf+s7xp0H/aMmrYGNs3FWOcyepiXkofmB4yagUA=;
	h=Date:To:From:Subject:From;
	b=Oprth+/4MLCIAFyK28Bdv5ey3lIHnEYcSyeyEl5mI90avwRkdhNZEqO9jZLZuW3Wh
	 DSDKK/cWtGnQL4Dvb6D3vliItnuosbL6OzxQuL7fzuP41krPyu3yrqINKgmkui1ReU
	 fIY6nhBX6M8z0/9Ng3L4tlZ2t5d6WJ1FT7ngxs8E=
Date: Mon, 17 Jun 2024 12:15:59 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,rientjes@google.com,osalvador@suse.de,nao.horiguchi@gmail.com,muchun.song@linux.dev,linmiaohe@huawei.com,jane.chu@oracle.com,ioworker0@gmail.com,fvdl@google.com,corbet@lwn.net,jiaqiyan@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + docs-mm-add-enable_soft_offline-sysctl.patch added to mm-unstable branch
Message-Id: <20240617191600.2450BC2BD10@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: docs: mm: add enable_soft_offline sysctl
has been added to the -mm mm-unstable branch.  Its filename is
     docs-mm-add-enable_soft_offline-sysctl.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/docs-mm-add-enable_soft_offline-sysctl.patch

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
From: Jiaqi Yan <jiaqiyan@google.com>
Subject: docs: mm: add enable_soft_offline sysctl
Date: Mon, 17 Jun 2024 17:05:45 +0000

Add the documentation for soft offline behaviors / costs, and what
the new enable_soft_offline sysctl is for.

Link: https://lkml.kernel.org/r/20240617170545.3820912-4-jiaqiyan@google.com
Signed-off-by: Jiaqi Yan <jiaqiyan@google.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Frank van der Linden <fvdl@google.com>
Cc: Jane Chu <jane.chu@oracle.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Lance Yang <ioworker0@gmail.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/sysctl/vm.rst |   33 ++++++++++++++++++++++
 1 file changed, 33 insertions(+)

--- a/Documentation/admin-guide/sysctl/vm.rst~docs-mm-add-enable_soft_offline-sysctl
+++ a/Documentation/admin-guide/sysctl/vm.rst
@@ -36,6 +36,7 @@ Currently, these files are in /proc/sys/
 - dirtytime_expire_seconds
 - dirty_writeback_centisecs
 - drop_caches
+- enable_soft_offline
 - extfrag_threshold
 - highmem_is_dirtyable
 - hugetlb_shm_group
@@ -267,6 +268,38 @@ used::
 These are informational only.  They do not mean that anything is wrong
 with your system.  To disable them, echo 4 (bit 2) into drop_caches.
 
+enable_soft_offline
+===================
+Correctable memory errors are very common on servers. Soft-offline is kernel's
+solution for memory pages having (excessive) corrected memory errors.
+
+For different types of page, soft-offline has different behaviors / costs.
+- For a raw error page, soft-offline migrates the in-use page's content to
+  a new raw page.
+- For a page that is part of a transparent hugepage,  soft-offline splits the
+  transparent hugepage into raw pages, then migrates only the raw error page.
+  As a result, user is transparently backed by 1 less hugepage, impacting
+  memory access performance.
+- For a page that is part of a HugeTLB hugepage, soft-offline first migrates
+  the entire HugeTLB hugepage, during which a free hugepage will be consumed
+  as migration target.  Then the original hugepage is dissolved into raw
+  pages without compensation, reducing the capacity of the HugeTLB pool by 1.
+
+It is user's call to choose between reliability (staying away from fragile
+physical memory) vs performance / capacity implications in transparent and
+HugeTLB cases.
+
+For all architectures, enable_soft_offline controls whether to soft offline
+memory pages.  When setting to 1, kernel attempts to soft offline the pages
+whenever it thinks needed.  When setting to 0, kernel returns EOPNOTSUPP to
+the request to soft offline the pages.  Its default value is 1.
+
+It is worth mentioning that after setting enable_soft_offline to 0:
+- If RAS Correctable Errors Collector is running, its request to soft offline
+  pages will fail.
+- On ARM, the request to soft offline pages from GHES driver will fail.
+- On PARISC, the request to soft offline pages from Page Deallocation Table
+  will fail.
 
 extfrag_threshold
 =================
_

Patches currently in -mm which might be from jiaqiyan@google.com are

mm-memory-failure-userspace-controls-soft-offlining-pages.patch
selftest-mm-test-enable_soft_offline-behaviors.patch
docs-mm-add-enable_soft_offline-sysctl.patch

