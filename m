Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1AF233BBD7
	for <mm-commits@vger.kernel.org>; Tue, 26 May 2026 16:34:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779813267; cv=none; b=OZritgqWc+07vvpMLDImEWN9YlyzL30kl+CXbWLuQI+GDoaUEWekVpP/DW4PrlHBydhhmLgqFqTM73oloJWV+S4FMojK128ZejtYWnA1Z/nHJ9Qs7Aj+Mebp4YSswQht49atHoZkTPc5QhhSbDnXw+X+nPDIXSMduXMv0xKrWBU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779813267; c=relaxed/simple;
	bh=gmh99Qko4iN92TqaMsoLfTUtKqBDfBgbJV8x4T6IRus=;
	h=Date:To:From:Subject:Message-Id; b=aAie4wcFxsR1zonbmrAq1xxIS+te1YUxwFcb5x/nUkBAZ5J128b88b358RGMWXiy4uzBa3Xt6mkJ5v00d6527lREtONQyyXC7OwYSkBd75x9nUPmxNE3C2qUJ+Kxh9dBaEesNxHCVAI+p1TseJtqY6wIyO9fkDR8pDg0xedcaSU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=FQvNjmD9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FQvNjmD9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B33A1F000E9;
	Tue, 26 May 2026 16:34:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1779813265;
	bh=JYK/c/xNHG8cyQCYx/dUXNDcrh6fQAUnRw01N+Yi/kM=;
	h=Date:To:From:Subject;
	b=FQvNjmD9O1qKBx2IIMRPjIsMLOzZhMWG8hCSNe6YrwkIQ0AB4k2weisbnSJKMzAwa
	 9qlqDEuRK5fYjKy7HCPWp/EG0Aw7EsuXnHm5apr+dGOgcjbC5HKi8frOfFhlknlg45
	 bXksdsoSIKhuqQGXKw4PcSW1RSRBdjUzP+bpN2qY=
Date: Tue, 26 May 2026 09:34:24 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ryan.roberts@arm.com,ljs@kernel.org,liam@infradead.org,lance.yang@linux.dev,dev.jain@arm.com,david@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,npache@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + documentation-mm-update-the-admin-guide-for-mthp-collapse-fix.patch added to mm-unstable branch
Message-Id: <20260526163425.4B33A1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: add back note and edit doc about khugepaged limits
has been added to the -mm mm-unstable branch.  Its filename is
     documentation-mm-update-the-admin-guide-for-mthp-collapse-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/documentation-mm-update-the-admin-guide-for-mthp-collapse-fix.patch

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
From: Nico Pache <npache@redhat.com>
Subject: add back note and edit doc about khugepaged limits
Date: Tue May 26 07:47:42 2026 -0600

Link: https://lore.kernel.org/b457f6e9-ae12-4e1f-8484-f3043ca62276@redhat.com
Signed-off-by: Nico Pache <npache@redhat.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: "Liam R. Howlett" <liam@infradead.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Lance Yang <lance.yang@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/mm/transhuge.rst |    5 +++++
 1 file changed, 5 insertions(+)

--- a/Documentation/admin-guide/mm/transhuge.rst~documentation-mm-update-the-admin-guide-for-mthp-collapse-fix
+++ a/Documentation/admin-guide/mm/transhuge.rst
@@ -265,6 +265,11 @@ support the following arguments::
 Khugepaged controls
 -------------------
 
+.. note::
+   khugepaged currently only searches for opportunities to collapse file/shmem
+   to PMD-sized THP. Only anonymous memory will attempt to collapse to other THP
+   sizes.
+
 khugepaged runs usually at low frequency so while one may not want to
 invoke defrag algorithms synchronously during the page faults, it
 should be worth invoking defrag at least in khugepaged. However it's
_

Patches currently in -mm which might be from npache@redhat.com are

mm-khugepaged-generalize-hugepage_vma_revalidate-for-mthp-support.patch
mm-khugepaged-rework-max_ptes_-handling-with-helper-functions.patch
mm-khugepaged-generalize-__collapse_huge_page_-for-mthp-support.patch
mm-khugepaged-require-collapse_huge_page-to-enter-exit-with-the-lock-dropped.patch
mm-khugepaged-generalize-collapse_huge_page-for-mthp-collapse.patch
mm-khugepaged-skip-collapsing-mthp-to-smaller-orders.patch
mm-khugepaged-add-per-order-mthp-collapse-failure-statistics.patch
mm-khugepaged-improve-tracepoints-for-mthp-orders.patch
mm-khugepaged-introduce-collapse_allowable_orders-helper-function.patch
mm-khugepaged-introduce-mthp-collapse-support.patch
mm-khugepaged-introduce-mthp-collapse-support-fix.patch
mm-khugepaged-avoid-unnecessary-mthp-collapse-attempts.patch
documentation-mm-update-the-admin-guide-for-mthp-collapse.patch
documentation-mm-update-the-admin-guide-for-mthp-collapse-fix.patch

