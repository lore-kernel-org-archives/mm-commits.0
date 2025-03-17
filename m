Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF29C170A23
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 04:32:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742185937; cv=none; b=W0EqQX/bXJStm2cNLqsqJ7Lo59SEpCH9Go8zB87VsUIuMkFSwHKt5XV55eDOZqCdXq57Dv63aCoWGRq2wqME3WE1pUlJzDlPxEFs8j0K59MyEyfG0xm7GknIT8f0DKs+THp2Rqgew0ZhIldXhv3WD3/QRcIUWJsZCtuqd74SAPc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742185937; c=relaxed/simple;
	bh=4MEGjIrNPgdhKusRjAbiTyFHnXuHJxBC+axoX+MEHlw=;
	h=Date:To:From:Subject:Message-Id; b=jywv9WfO8cF0SQpjs0NJ+7jL2RRt4lIouWQe7/ArG5ZV6aTSaaC65A28Z1SPUvlZIO5p5IwS0OZVDwoPCv3O43wsSCv6JWI3gKs8uovE+3km/6a01w3Tbor0TLX48PHGK6iZkQpcIKgd/W5y+AXo1Cwej/wQu/3JcfQrFWHsV+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=nUmA5EKt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="nUmA5EKt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A192C4CEEC;
	Mon, 17 Mar 2025 04:32:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742185934;
	bh=4MEGjIrNPgdhKusRjAbiTyFHnXuHJxBC+axoX+MEHlw=;
	h=Date:To:From:Subject:From;
	b=nUmA5EKtxSC+kqoCa3aFewkrSgbA+dOJVWQbpXeI9xaRUMJ2DNIbQa3C4yvMZql/P
	 B21pv31eExDmU8cj+GHboKt8QLnkl2ybFPY8PiUzYvgQB86YO6Z8+7KZyWfM/oB7Q8
	 lIr/TGkwMCiTS+qBOpHvQai5uBSCnB7rxI4zSCwI=
Date: Sun, 16 Mar 2025 21:32:13 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,sj@kernel.org,shakeel.butt@linux.dev,lorenzo.stoakes@oracle.com,howlett@gmail.com,david@redhat.com,dave@stgolabs.net,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-madvise-remove-redundant-mmap_lock-operations-from-process_madvise-fix.patch removed from -mm tree
Message-Id: <20250317043214.4A192C4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-madvise-remove-redundant-mmap_lock-operations-from-process_madvise-fix
has been removed from the -mm tree.  Its filename was
     mm-madvise-remove-redundant-mmap_lock-operations-from-process_madvise-fix.patch

This patch was dropped because it was folded into mm-madvise-remove-redundant-mmap_lock-operations-from-process_madvise.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-madvise-remove-redundant-mmap_lock-operations-from-process_madvise-fix
Date: Thu Feb  6 04:34:29 PM PST 2025

update comment, per Lorenzo

Cc: David Hildenbrand <david@redhat.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Liam R. Howlett <howlett@gmail.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: SeongJae Park <sj@kernel.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/madvise.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/madvise.c~mm-madvise-remove-redundant-mmap_lock-operations-from-process_madvise-fix
+++ a/mm/madvise.c
@@ -1804,7 +1804,7 @@ static ssize_t vector_madvise(struct mm_
 		 * the operation in aggregate, and would be surprising to the
 		 * user.
 		 *
-		 * As we have already dropped locks, it is safe to just loop and
+		 * We drop and reacquire locks so it is safe to just loop and
 		 * try again. We check for fatal signals in case we need exit
 		 * early anyway.
 		 */
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-madvise-remove-redundant-mmap_lock-operations-from-process_madvise.patch
mm-hugetlb-add-hugetlb_alloc_threads-cmdline-option-fix.patch
mm-pgtable-convert-some-architectures-to-use-tlb_remove_ptdesc-v2-fix.patch
lib-plistc-add-shortcut-for-plist_requeue-fix.patch
scsi-lpfc-convert-timeouts-to-secs_to_jiffies-fix.patch
signal-avoid-clearing-tif_sigpending-in-recalc_sigpending-if-unset-fix.patch
hung_task-show-the-blocker-task-if-the-task-is-hung-on-mutex-fix.patch

