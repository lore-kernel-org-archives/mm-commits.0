Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DB7322089
	for <mm-commits@vger.kernel.org>; Mon,  6 May 2024 00:58:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714957093; cv=none; b=ptRkWmajg1niIKXLMZpsdAudbo68Q/XECKSVRlb0rxcfLNvXYHLUadn8Fpa1gCcsonNPYGk2W7YIZAZ7fiw0BpwuNXxW/3VHmD4p5nZRoEoVju0ccga3IYWIlisYRJ2vrhs59OAyTz92A+L9EHqhe70wBY9iZi9DK2/iCKc5zbs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714957093; c=relaxed/simple;
	bh=83G+kT2ByrevhhFFVtOYGfwfj4lKC2dBRHx5NkYiVFs=;
	h=Date:To:From:Subject:Message-Id; b=twflO7WcNq0By5GMluGuzvdoK9U69hUqsfsdeHhR5mV4juThn2WdrT/1dIaRR6Z8vS/4LLGJqf/6rzu8WKZjHdRnD1ttZnNZUcFvIMRBITPdDAdA78ThzWtA/NH3HgGO8LdfTgkqYMCORWpciuonx7QdURC3zhWTQ7TqhHXzPrY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=EZrzaBZ5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="EZrzaBZ5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 572AEC113CC;
	Mon,  6 May 2024 00:58:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714957093;
	bh=83G+kT2ByrevhhFFVtOYGfwfj4lKC2dBRHx5NkYiVFs=;
	h=Date:To:From:Subject:From;
	b=EZrzaBZ5D8TszOy2JFmnMShOloyljeGdzpHyllrH4cfNstA3IdcqvJ6Rm6TPnsgo4
	 gECX+BhWEtQ8S2XpHl/eh9mjO6A3Z7tlMFKm5UCAgWRrRHqgz5TTYo1s8KM0MaDcAs
	 5KZtghBGz8Bp3sPJ3NSfVqmC+AAJhlXj5YAJcAGo=
Date: Sun, 05 May 2024 17:58:12 -0700
To: mm-commits@vger.kernel.org,osalvador@suse.de,linmiaohe@huawei.com,jane.chu@oracle.com,dan.j.williams@intel.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memory-failure-use-folio-functions-throughout-collect_procs.patch removed from -mm tree
Message-Id: <20240506005813.572AEC113CC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/memory-failure: use folio functions throughout collect_procs()
has been removed from the -mm tree.  Its filename was
     mm-memory-failure-use-folio-functions-throughout-collect_procs.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm/memory-failure: use folio functions throughout collect_procs()
Date: Fri, 12 Apr 2024 20:35:07 +0100

Saves a couple of calls to compound_head().

Link: https://lkml.kernel.org/r/20240412193510.2356957-11-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Jane Chu <jane.chu@oracle.com>
Acked-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Oscar Salvador <osalvador@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/memory-failure.c~mm-memory-failure-use-folio-functions-throughout-collect_procs
+++ a/mm/memory-failure.c
@@ -728,9 +728,9 @@ static void collect_procs(struct folio *
 {
 	if (!folio->mapping)
 		return;
-	if (unlikely(PageKsm(page)))
+	if (unlikely(folio_test_ksm(folio)))
 		collect_procs_ksm(page, tokill, force_early);
-	else if (PageAnon(page))
+	else if (folio_test_anon(folio))
 		collect_procs_anon(folio, page, tokill, force_early);
 	else
 		collect_procs_file(folio, page, tokill, force_early);
_

Patches currently in -mm which might be from willy@infradead.org are

squashfs-convert-squashfs_symlink_read_folio-to-use-folio-apis.patch
squashfs-remove-calls-to-set-the-folio-error-flag.patch
nilfs2-remove-calls-to-folio_set_error-and-folio_clear_error.patch

