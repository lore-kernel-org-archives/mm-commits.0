Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18B683176F0
	for <mm-commits@vger.kernel.org>; Sat, 16 Aug 2025 06:21:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755325277; cv=none; b=TH/mH7hQQ7TFe2+aByB4ocmT3/P+O2qseb7I/mdVnEVcd7lRuO3PvlM20AHrBUXNz9RjpZV09eMN1GbWYU9ZEhWCFoDyXlP4iWjRpyBteIkzqh/abcRekUxAPYyfQGKktD1dzCQW62i79wt9lLiF4aeSi9WQZQv2LKanDauYRFc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755325277; c=relaxed/simple;
	bh=cfFLbz2vmd6U+chPCXFPf1+oe23WIWyiUNLBdGT+5Cw=;
	h=Date:To:From:Subject:Message-Id; b=cLx4bpea39MukqoJ9qrioLQlIDJoc+6I1cwj6oDCeJUFiIm5qAgDiDRBLFaql4vlkvSSX3OD4SwQ4+lzItKDBz319jl09HtJSDJccO+xChshQy3n0oZY0bs/ETqp7ZUx3XSIl94FgCz/NmRQfetj0uvwMnX7t+qVhGMQrKklu0w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZAKLPQ1I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZAKLPQ1I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7B04C4CEEF;
	Sat, 16 Aug 2025 06:21:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1755325275;
	bh=cfFLbz2vmd6U+chPCXFPf1+oe23WIWyiUNLBdGT+5Cw=;
	h=Date:To:From:Subject:From;
	b=ZAKLPQ1ISLFUJoiYKRLOuyHtPjaYiisuFDenhZ+bQMOs40tvFsnsOnzvhNL+5iImn
	 ZUdqxCCZHmcC3LKQib5VDLaqJYWxsosUJ9VOfe+8wGibUSx3UV3e8Br2EuqNkh/omP
	 MSvARGGonEdBeajweqCqO5AM/EjOraKVujxGcv4g=
Date: Fri, 15 Aug 2025 23:21:15 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@suse.cz,surenb@google.com,sj@kernel.org,shakeel.butt@linux.dev,ryan.roberts@arm.com,rppt@kernel.org,riel@surriel.com,npache@redhat.com,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,laoar.shao@gmail.com,jannh@google.com,hannes@cmpxchg.org,dev.jain@arm.com,david@redhat.com,corbet@lwn.net,baolin.wang@linux.alibaba.com,baohua@kernel.org,arnd@arndb.de,usamaarif642@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + docs-transhuge-document-process-level-thp-controls.patch added to mm-new branch
Message-Id: <20250816062115.A7B04C4CEEF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: docs: transhuge: document process level THP controls
has been added to the -mm mm-new branch.  Its filename is
     docs-transhuge-document-process-level-thp-controls.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/docs-transhuge-document-process-level-thp-controls.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: Usama Arif <usamaarif642@gmail.com>
Subject: docs: transhuge: document process level THP controls
Date: Fri, 15 Aug 2025 14:54:56 +0100

This includes the PR_SET_THP_DISABLE/PR_GET_THP_DISABLE pair of prctl
calls as well the newly introduced PR_THP_DISABLE_EXCEPT_ADVISED flag for
the PR_SET_THP_DISABLE prctl call.

Link: https://lkml.kernel.org/r/20250815135549.130506-5-usamaarif642@gmail.com
Signed-off-by: Usama Arif <usamaarif642@gmail.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Jann Horn <jannh@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Mariano Pache <npache@redhat.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Rik van Riel <riel@surriel.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: SeongJae Park <sj@kernel.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Yafang <laoar.shao@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/mm/transhuge.rst |   36 +++++++++++++++++++
 1 file changed, 36 insertions(+)

--- a/Documentation/admin-guide/mm/transhuge.rst~docs-transhuge-document-process-level-thp-controls
+++ a/Documentation/admin-guide/mm/transhuge.rst
@@ -225,6 +225,42 @@ to "always" or "madvise"), and it'll be
 PMD-sized THP is disabled (when both the per-size anon control and the
 top-level control are "never")
 
+process THP controls
+--------------------
+
+A process can control its own THP behaviour using the ``PR_SET_THP_DISABLE``
+and ``PR_GET_THP_DISABLE`` pair of prctl(2) calls. The THP behaviour set using
+``PR_SET_THP_DISABLE`` is inherited across fork(2) and execve(2). These calls
+support the following arguments::
+
+	prctl(PR_SET_THP_DISABLE, 1, 0, 0, 0):
+		This will disable THPs completely for the process, irrespective
+		of global THP controls or madvise(..., MADV_COLLAPSE) being used.
+
+	prctl(PR_SET_THP_DISABLE, 1, PR_THP_DISABLE_EXCEPT_ADVISED, 0, 0):
+		This will disable THPs for the process except when the usage of THPs is
+		advised. Consequently, THPs will only be used when:
+		- Global THP controls are set to "always" or "madvise" and
+		  madvise(..., MADV_HUGEPAGE) or madvise(..., MADV_COLLAPSE) is used.
+		- Global THP controls are set to "never" and madvise(..., MADV_COLLAPSE)
+		  is used. This is the same behavior as if THPs would not be disabled on
+		  a process level.
+		Note that MADV_COLLAPSE is currently always rejected if
+		madvise(..., MADV_NOHUGEPAGE) is set on an area.
+
+	prctl(PR_SET_THP_DISABLE, 0, 0, 0, 0):
+		This will re-enable THPs for the process, as if they were never disabled.
+		Whether THPs will actually be used depends on global THP controls and
+		madvise() calls.
+
+	prctl(PR_GET_THP_DISABLE, 0, 0, 0, 0):
+		This returns a value whose bits indicate how THP-disable is configured:
+		Bits
+		 1 0  Value  Description
+		|0|0|   0    No THP-disable behaviour specified.
+		|0|1|   1    THP is entirely disabled for this process.
+		|1|1|   3    THP-except-advised mode is set for this process.
+
 Khugepaged controls
 -------------------
 
_

Patches currently in -mm which might be from usamaarif642@gmail.com are

docs-transhuge-document-process-level-thp-controls.patch
selftest-mm-extract-sz2ord-function-into-vm_utilh.patch
selftests-prctl-introduce-tests-for-disabling-thps-completely.patch
selftests-prctl-introduce-tests-for-disabling-thps-except-for-madvise.patch

