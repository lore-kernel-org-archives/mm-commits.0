Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7878E7D3E8
	for <mm-commits@vger.kernel.org>; Fri, 12 Jul 2024 22:54:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720824858; cv=none; b=JcDppcxrJzwd6i8j9pLnP86wlnekw2WSSi0nZ2zuz6dgADkqV/LorpDKMTjMnsEKTk1TMBN5N7/a6HuOslkq3fBgmFHbUtk2QAnXCcwX9RD1NnWy5yI9oV1CldNCzECQTqaZnF2mLYpDMoX76CPz9+y8MOlLppVWV3gzV5Tc4/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720824858; c=relaxed/simple;
	bh=q32z7m7ifgeRgdX382ySSL10TAVkEjU0tfbNx/rScn4=;
	h=Date:To:From:Subject:Message-Id; b=S1wcHJOCEPR5cI0qJH/EBl3ML44VdvhxCsmEwn+B57nwyUR1nypKyGlMuZ/SAln6Scv9/rfgqKB+fAsTLOmf5g+W5tADbB/QVAwI0Rjnn0gCIDXP1HJlsNoGiVgp49gQYcVpThxZ2IqwiVfBep8MYqQVQ72TfeHm47qfi/LZCuI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=oOek/XuC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="oOek/XuC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C866C32782;
	Fri, 12 Jul 2024 22:54:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1720824858;
	bh=q32z7m7ifgeRgdX382ySSL10TAVkEjU0tfbNx/rScn4=;
	h=Date:To:From:Subject:From;
	b=oOek/XuCoHLOWdonSkB6WWtcK+ivT9qoQIoj/DkCiN1EaQV2ALQLaoRuvGF6YHUh5
	 4LE564wuZKRRoStvrBsTx38hVXJt9tDJk5Ju1X0snqx8qQj/G5V7cHLh2Q7b8jbYSi
	 nMLE81mRQ0tE1yKC4u5fCYyoM0oVeESxEeMQKuH8=
Date: Fri, 12 Jul 2024 15:54:17 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,shy828301@gmail.com,ryan.roberts@arm.com,mingzhe.yang@ly.com,libang.li@antgroup.com,david@redhat.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,ioworker0@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-add-docs-for-per-order-mthp-split-counters.patch removed from -mm tree
Message-Id: <20240712225418.4C866C32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: add docs for per-order mTHP split counters
has been removed from the -mm tree.  Its filename was
     mm-add-docs-for-per-order-mthp-split-counters.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lance Yang <ioworker0@gmail.com>
Subject: mm: add docs for per-order mTHP split counters
Date: Fri, 28 Jun 2024 21:07:50 +0800

This commit introduces documentation for mTHP split counters in
transhuge.rst.

[ioworker0@gmail.com: improve the doc as suggested by Ryan]
  Link: https://lkml.kernel.org/r/20240704012905.42971-3-ioworker0@gmail.com
[ioworker0@gmail.com: tweak Documentation/admin-guide/mm/transhuge.rst]
  Link: https://lkml.kernel.org/r/20240707013659.1151-1-ioworker0@gmail.com
Link: https://lkml.kernel.org/r/20240628130750.73097-3-ioworker0@gmail.com
Signed-off-by: Mingzhe Yang <mingzhe.yang@ly.com>
Signed-off-by: Lance Yang <ioworker0@gmail.com>
Reviewed-by: Barry Song <baohua@kernel.org>
Reviewed-by: Ryan Roberts <ryan.roberts@arm.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Bang Li <libang.li@antgroup.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/mm/transhuge.rst |   19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

--- a/Documentation/admin-guide/mm/transhuge.rst~mm-add-docs-for-per-order-mthp-split-counters
+++ a/Documentation/admin-guide/mm/transhuge.rst
@@ -369,10 +369,6 @@ also applies to the regions registered i
 Monitoring usage
 ================
 
-.. note::
-   Currently the below counters only record events relating to
-   PMD-sized THP. Events relating to other THP sizes are not included.
-
 The number of PMD-sized anonymous transparent huge pages currently used by the
 system is available by reading the AnonHugePages field in ``/proc/meminfo``.
 To identify what applications are using PMD-sized anonymous transparent huge
@@ -514,6 +510,21 @@ file_fallback_charge
 	falls back to using small pages even though the allocation was
 	successful.
 
+split
+	is incremented every time a huge page is successfully split into
+	smaller orders. This can happen for a variety of reasons but a
+	common reason is that a huge page is old and is being reclaimed.
+
+split_failed
+	is incremented if kernel fails to split huge
+	page. This can happen if the page was pinned by somebody.
+
+split_deferred
+        is incremented when a huge page is put onto split queue.
+        This happens when a huge page is partially unmapped and splitting
+        it would free up some memory. Pages on split queue are going to
+        be split under memory pressure, if splitting is possible.
+
 As the system ages, allocating huge pages may be expensive as the
 system uses memory compaction to copy data around memory to free a
 huge page for use. There are some counters in ``/proc/vmstat`` to help
_

Patches currently in -mm which might be from ioworker0@gmail.com are


