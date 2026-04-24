Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC1553FE652
	for <mm-commits@vger.kernel.org>; Fri, 24 Apr 2026 20:13:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777061639; cv=none; b=rdArtACqLzBjfTqY7uNleOq1bAWa8zqaiSb3r68MR1VfoeSYlAL95gWDNxAGrOM1RFSUCTA3lCkV3M4ZoTZt9NVzMUMbs/MdvUosl20k+fNhpFmTMbDz1AnY+m3N/ljP8R9jdvXUM+Ou4uMHZGLnTCyGrVJxmEfFHOIuIoN16sE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777061639; c=relaxed/simple;
	bh=KTvNpvft2Xn5BrD5j/aPXhZBN1i4KvqPk+Ms94xxZko=;
	h=Date:To:From:Subject:Message-Id; b=aIRIXL7Fsfmuu8tM7tGMZCPbGw+sqlX3+RxsajR7GCjj7/YYx/7AXOLfb50vO/jIdqxhUdPMSDn8D7/yd22yMN9baCU2JpGkx8+K/0fmAtyW8OMkE+Jdr1b7/4KKFHB49hz9y3gCR+dvRJjN2EjPpphknpAUMmqJM9FyEl0B6Hw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=PO7LeBwt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="PO7LeBwt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51CF1C19425;
	Fri, 24 Apr 2026 20:13:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777061638;
	bh=KTvNpvft2Xn5BrD5j/aPXhZBN1i4KvqPk+Ms94xxZko=;
	h=Date:To:From:Subject:From;
	b=PO7LeBwtZL2X76b9ognEP99enASkowAPy2RXqWYxi61eD/edXhhXq3s/GE/2VEP0W
	 LakHklpVD8NgA5Ny7k01f/7ZuoGL64nYWLJQTjePxzqAGASt4OIiihS8vhNHxgS50H
	 bW7aZfBWPNvRkaJ1ZhaaULyjo3CYoMiFWSnANTlM=
Date: Fri, 24 Apr 2026 13:13:57 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,zhen.ni@easystack.cn,vbabka@kernel.org,surenb@google.com,mhocko@suse.com,jackmanb@google.com,hannes@cmpxchg.org,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_owner-add-numa-node-filter-with-nodelist-support-fix.patch added to mm-new branch
Message-Id: <20260424201358.51CF1C19425@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-page_owner-add-numa-node-filter-with-nodelist-support-fix
has been added to the -mm mm-new branch.  Its filename is
     mm-page_owner-add-numa-node-filter-with-nodelist-support-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_owner-add-numa-node-filter-with-nodelist-support-fix.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-page_owner-add-numa-node-filter-with-nodelist-support-fix
Date: Fri Apr 24 01:08:46 PM PDT 2026

remove READ_ONCE/WRITE_ONCE of nodemask_t

It triggers compile-time assertions.

Cc: Brendan Jackman <jackmanb@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Zhen Ni <zhen.ni@easystack.cn>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_owner.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/page_owner.c~mm-page_owner-add-numa-node-filter-with-nodelist-support-fix
+++ a/mm/page_owner.c
@@ -732,7 +732,7 @@ read_page_owner(struct file *file, char
 			continue;
 
 		/* NUMA node filter using bitmask */
-		mask = READ_ONCE(owner_filter.nid_mask);
+		mask = owner_filter.nid_mask;
 		if (!nodes_empty(mask)) {
 			int nid = page_to_nid(page);
 
@@ -1049,7 +1049,7 @@ static ssize_t nid_filter_write(struct f
 		goto out_free;
 	}
 
-	WRITE_ONCE(owner_filter.nid_mask, mask);
+	owner_filter.nid_mask = mask;
 	ret = count;
 
 out_free:
@@ -1059,7 +1059,7 @@ out_free:
 
 static int nid_filter_show(struct seq_file *m, void *v)
 {
-	nodemask_t mask = READ_ONCE(owner_filter.nid_mask);
+	nodemask_t mask = owner_filter.nid_mask;
 
 	if (nodes_empty(mask))
 		seq_puts(m, "-1\n");
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-page_alloc-fix-initialization-of-tags-of-the-huge-zero-folio-with-init_on_free-fix.patch
mm-page_owner-add-numa-node-filter-with-nodelist-support-fix.patch
proc-rewrite-next_tgid-fix.patch

