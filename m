Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDEBCDF72;
	Thu, 28 Aug 2025 22:34:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756420495; cv=none; b=g5IoCrpBGUNNFcuPJC3/FL63naGuX61wuYeH2I1G++tBpdKFHcFV5pfew42x4xlksKmG9zixW4FOxoFK975ZVuL3+dPO7ZpiMlK2HW3hJj6TkMizEp8uP7Vn/L4tgeG5GYk7gaxbgWfDOlqifPdtiz5V7tVHAZ5sEo78IM/enWA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756420495; c=relaxed/simple;
	bh=XqWrO9VGVmaPbuXQJEbBm+Fp5yOKlBbsxG3xTPt9V6I=;
	h=Date:To:From:Subject:Message-Id; b=OnqUf/3q1Z1GObDyq2E7Lu7cOtH+5oCArbyPbmaKjNjXlg0mzUiNrActkfYEOAhhjvNDvctlDmZrxI5MO08yEjfqFihPSs3Ts+QWFLZ068j/2oz2LWBZa88efaG7cbf+GCgbP9OI48DfGGtIM8XptfHh16NF9AZ1taXEAuVEs+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=u9n2VQFe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="u9n2VQFe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45768C4CEEB;
	Thu, 28 Aug 2025 22:34:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1756420495;
	bh=XqWrO9VGVmaPbuXQJEbBm+Fp5yOKlBbsxG3xTPt9V6I=;
	h=Date:To:From:Subject:From;
	b=u9n2VQFewebwRfU6EUFJvOAjKAx5Yte3TK0K3WDQx70qGTICunARMY2FAORBhYhow
	 XQRA1xW7IV4CBKqgiIPx3cks0p5xFXmsesCNJRgASMl9pb5JMqrTIj9P9WgKSYu90a
	 XjdloAoEOxGKOYrOHdCr8IYzXy24EWJeu+pZ/qcM=
Date: Thu, 28 Aug 2025 15:34:54 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,tony.luck@intel.com,surenb@google.com,stable@vger.kernel.org,russ.anderson@hpe.com,rppt@kernel.org,osalvador@suse.de,nao.horiguchi@gmail.com,mhocko@suse.com,lorenzo.stoakes@oracle.com,linmiaohe@huawei.com,liam.howlett@oracle.com,jiaqiyan@google.com,jane.chu@oracle.com,david@redhat.com,bp@alien8.de,kyle.meyer@hpe.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory-failure-fix-redundant-updates-for-already-poisoned-pages.patch added to mm-hotfixes-unstable branch
Message-Id: <20250828223455.45768C4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/memory-failure: fix redundant updates for already poisoned pages
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-memory-failure-fix-redundant-updates-for-already-poisoned-pages.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memory-failure-fix-redundant-updates-for-already-poisoned-pages.patch

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
From: Kyle Meyer <kyle.meyer@hpe.com>
Subject: mm/memory-failure: fix redundant updates for already poisoned pages
Date: Thu, 28 Aug 2025 13:38:20 -0500

Duplicate memory errors can be reported by multiple sources.

Passing an already poisoned page to action_result() causes issues:

* The amount of hardware corrupted memory is incorrectly updated.
* Per NUMA node MF stats are incorrectly updated.
* Redundant "already poisoned" messages are printed.

Avoid those issues by:

* Skipping hardware corrupted memory updates for already poisoned pages.
* Skipping per NUMA node MF stats updates for already poisoned pages.
* Dropping redundant "already poisoned" messages.

Make MF_MSG_ALREADY_POISONED consistent with other action_page_types and
make calls to action_result() consistent for already poisoned normal pages
and huge pages.

Link: https://lkml.kernel.org/r/aLCiHMy12Ck3ouwC@hpe.com
Fixes: b8b9488d50b7 ("mm/memory-failure: improve memory failure action_result messages")
Signed-off-by: Kyle Meyer <kyle.meyer@hpe.com>
Reviewed-by: Jiaqi Yan <jiaqiyan@google.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Borislav Betkov <bp@alien8.de>
Cc: Jane Chu <jane.chu@oracle.com>
Cc: Kyle Meyer <kyle.meyer@hpe.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: "Luck, Tony" <tony.luck@intel.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Russ Anderson <russ.anderson@hpe.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |   13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

--- a/mm/memory-failure.c~mm-memory-failure-fix-redundant-updates-for-already-poisoned-pages
+++ a/mm/memory-failure.c
@@ -956,7 +956,7 @@ static const char * const action_page_ty
 	[MF_MSG_BUDDY]			= "free buddy page",
 	[MF_MSG_DAX]			= "dax page",
 	[MF_MSG_UNSPLIT_THP]		= "unsplit thp",
-	[MF_MSG_ALREADY_POISONED]	= "already poisoned",
+	[MF_MSG_ALREADY_POISONED]	= "already poisoned page",
 	[MF_MSG_UNKNOWN]		= "unknown page",
 };
 
@@ -1349,9 +1349,10 @@ static int action_result(unsigned long p
 {
 	trace_memory_failure_event(pfn, type, result);
 
-	num_poisoned_pages_inc(pfn);
-
-	update_per_node_mf_stats(pfn, result);
+	if (type != MF_MSG_ALREADY_POISONED) {
+		num_poisoned_pages_inc(pfn);
+		update_per_node_mf_stats(pfn, result);
+	}
 
 	pr_err("%#lx: recovery action for %s: %s\n",
 		pfn, action_page_types[type], action_name[result]);
@@ -2094,12 +2095,11 @@ retry:
 		*hugetlb = 0;
 		return 0;
 	} else if (res == -EHWPOISON) {
-		pr_err("%#lx: already hardware poisoned\n", pfn);
 		if (flags & MF_ACTION_REQUIRED) {
 			folio = page_folio(p);
 			res = kill_accessing_process(current, folio_pfn(folio), flags);
-			action_result(pfn, MF_MSG_ALREADY_POISONED, MF_FAILED);
 		}
+		action_result(pfn, MF_MSG_ALREADY_POISONED, MF_FAILED);
 		return res;
 	} else if (res == -EBUSY) {
 		if (!(flags & MF_NO_RETRY)) {
@@ -2285,7 +2285,6 @@ try_again:
 		goto unlock_mutex;
 
 	if (TestSetPageHWPoison(p)) {
-		pr_err("%#lx: already hardware poisoned\n", pfn);
 		res = -EHWPOISON;
 		if (flags & MF_ACTION_REQUIRED)
 			res = kill_accessing_process(current, pfn, flags);
_

Patches currently in -mm which might be from kyle.meyer@hpe.com are

mm-memory-failure-fix-redundant-updates-for-already-poisoned-pages.patch

