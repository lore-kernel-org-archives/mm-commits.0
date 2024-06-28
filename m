Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2868147779
	for <mm-commits@vger.kernel.org>; Fri, 28 Jun 2024 18:30:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719599422; cv=none; b=hUVT+7IfPG1Pi9raET/HYZlx3gYFH+p0Rk9gP+uU/V3VrDFNBmN70jYpa5BMH/EczH8XAXSNI2AEB4zQXQ54w6hV8odnxJQVIqIO9++7+x5KOtc+gCCQw+GfjJdQ3IExTPa+9D4WmUd0Oc3P1Z4tnuT4pwyae8UKa5wS8ZQng2Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719599422; c=relaxed/simple;
	bh=OBBN2h8DvGqXh4LukDfVDoQZ+5b7pmXyhuVBWEAqF/Q=;
	h=Date:To:From:Subject:Message-Id; b=KyTnQTFyMC8Q79ZmKMz+NUXIVAjuWCWvMMdsT9l92SpCNSDwQQ3ayYOW+cES58GdCwhBisNbhF4dU9d+lCyGQedS+MWcJNpyzfWGAZdM8oSJjExjPwTWN+yFwV+tHY96gTfe7TYYEqpuJFAY7WbTfWmcBvUxknf16gQ+tfXnksI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=X+9cfN/Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="X+9cfN/Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9887EC116B1;
	Fri, 28 Jun 2024 18:30:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719599421;
	bh=OBBN2h8DvGqXh4LukDfVDoQZ+5b7pmXyhuVBWEAqF/Q=;
	h=Date:To:From:Subject:From;
	b=X+9cfN/YfkodGLid+8PcUF8s+G7MD3M0k5FLcPHb7pFeyP3DoAL8YLMXOBTfEWnqw
	 lwsjf+E9d63v+yiDmPb2GzKvH7RSfCJks+WP0CG7Wkk8GI8bn9M7QdLPdvD3d+De9A
	 qyIAtJFKzDDCgMw/KE7/v4iWVKqLQgXI7QiC8SnE=
Date: Fri, 28 Jun 2024 11:30:21 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,shy828301@gmail.com,ryan.roberts@arm.com,mingzhe.yang@ly.com,libang.li@antgroup.com,david@redhat.com,baolin.wang@linux.alibaba.com,ioworker0@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-add-docs-for-per-order-mthp-split-counters.patch added to mm-unstable branch
Message-Id: <20240628183021.9887EC116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: add docs for per-order mTHP split counters
has been added to the -mm mm-unstable branch.  Its filename is
     mm-add-docs-for-per-order-mthp-split-counters.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-add-docs-for-per-order-mthp-split-counters.patch

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
From: Lance Yang <ioworker0@gmail.com>
Subject: mm: add docs for per-order mTHP split counters
Date: Fri, 28 Jun 2024 21:07:50 +0800

This commit introduces documentation for mTHP split counters in
transhuge.rst.

Link: https://lkml.kernel.org/r/20240628130750.73097-3-ioworker0@gmail.com
Signed-off-by: Mingzhe Yang <mingzhe.yang@ly.com>
Signed-off-by: Lance Yang <ioworker0@gmail.com>
Cc: Bang Li <libang.li@antgroup.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/mm/transhuge.rst |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

--- a/Documentation/admin-guide/mm/transhuge.rst~mm-add-docs-for-per-order-mthp-split-counters
+++ a/Documentation/admin-guide/mm/transhuge.rst
@@ -514,6 +514,22 @@ file_fallback_charge
 	falls back to using small pages even though the allocation was
 	successful.
 
+split
+	is incremented every time a huge page is successfully split into
+	base pages. This can happen for a variety of reasons but a common
+	reason is that a huge page is old and is being reclaimed.
+	This action implies splitting any block mappings into PTEs.
+
+split_failed
+	is incremented if kernel fails to split huge
+	page. This can happen if the page was pinned by somebody.
+
+split_deferred
+	is incremented when a huge page is put onto split
+	queue. This happens when a huge page is partially unmapped and
+	splitting it would free up some memory. Pages on split queue are
+	going to be split under memory pressure.
+
 As the system ages, allocating huge pages may be expensive as the
 system uses memory compaction to copy data around memory to free a
 huge page for use. There are some counters in ``/proc/vmstat`` to help
_

Patches currently in -mm which might be from ioworker0@gmail.com are

mm-add-per-order-mthp-split-counters.patch
mm-add-docs-for-per-order-mthp-split-counters.patch

