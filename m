Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E55924825B8
	for <mm-commits@vger.kernel.org>; Tue, 13 Oct 2026 04:32:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791865962; cv=none; b=TCipdarR0gCDEGsdx+88vvKMwXrqbvRtB+IaP7BcoiefcxZydw7y/nWvcHSmD7R28qEyg5ISreLnBekHL1kJx5YNOfddQ9xnoa/L7TB2oa7oln2ioOXf5EmtF+/+GtCVpE/2Ge0H29s5L2qyDVQQszLJl4dYwosotn9BLpMzbW4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791865962; c=relaxed/simple;
	bh=KJTDfm92TH34lMeyj7ZyC/kWa9Ykw6ZDCQLW9UZxwRo=;
	h=Date:To:From:Subject:Message-Id; b=ISWiGHUaxCGkQB1WlACPKQtGMVDxqQUuTmOa/a3ojXaSaXMkKlhfMTWf8re1cpKO0VLbnKH0+sBiC23LVkV7xkQUCVA17g11yxA0UmOW6YcEEgbCWrHSUNhv81RJCxm3XxTDP2IBbKzg5yAH9T3T4cUBqSwPYdmLKMqBHU6a0Ik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=2e12Urcq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="2e12Urcq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAF1F1F000FF;
	Tue, 13 Oct 2026 04:32:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791865961;
	bh=JlccenGbAMNVDxCh8psA9bybY6JQ6V452Gpu9JgSmoU=;
	h=Date:To:From:Subject;
	b=2e12Urcql4l8uV8KF6oNo8UG0ip7OJV/J9y/OMZdcDSDcsNXdLQeEaXldE4OBUE+O
	 tQwEoNyba5xqVmV9DpxBU8fbOtgD7vH3LhvrqK4DWL6YMoNtQCipMAezPsuWv7cbTR
	 URoxLWDVDsbEtrnF3f7Vk0xgrHohNwXz1sAhy2Hk=
Date: Mon, 12 Oct 2026 21:32:41 -0700
To: mm-commits@vger.kernel.org,ruirui.yang@linux.dev,rppt@kernel.org,pratyush@kernel.org,pasha.tatashin@soleen.com,baoquan.he@linux.dev,tz2294@columbia.edu,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] vmcore-convert-mmap_vmcore_fault-to-use-folios.patch removed from -mm tree
Message-Id: <20261013043241.BAF1F1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: vmcore: convert mmap_vmcore_fault() to use folios
has been removed from the -mm tree.  Its filename was
     vmcore-convert-mmap_vmcore_fault-to-use-folios.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Tal Zussman <tz2294@columbia.edu>
Subject: vmcore: convert mmap_vmcore_fault() to use folios
Date: Tue, 15 Sep 2026 19:42:15 -0400

Use a folio for the page cache page the s390 fault handler reads the old
kernel's memory into.  This removes four compound_head() calls and one of
the last callers of find_or_create_page().

The vmcore mapping only has order-0 folios, so the logic is unchanged.

Compile tested for s390.

Link: https://lore.kernel.org/20260915-vmcore-fault-folio-v1-1-a0cb6278670f@columbia.edu
Signed-off-by: Tal Zussman <tz2294@columbia.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Pratyush Yadav <pratyush@kernel.org>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Dave Young <ruirui.yang@linux.dev>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
---

 fs/proc/vmcore.c |   27 ++++++++++++++-------------
 1 file changed, 14 insertions(+), 13 deletions(-)

--- a/fs/proc/vmcore.c~vmcore-convert-mmap_vmcore_fault-to-use-folios
+++ a/fs/proc/vmcore.c
@@ -474,29 +474,30 @@ static vm_fault_t mmap_vmcore_fault(stru
 	pgoff_t index = vmf->pgoff;
 	struct iov_iter iter;
 	struct kvec kvec;
-	struct page *page;
+	struct folio *folio;
 	loff_t offset;
 	int rc;
 
-	page = find_or_create_page(mapping, index, GFP_KERNEL);
-	if (!page)
+	folio = __filemap_get_folio(mapping, index,
+			FGP_LOCK | FGP_ACCESSED | FGP_CREAT, GFP_KERNEL);
+	if (IS_ERR(folio))
 		return VM_FAULT_OOM;
-	if (!PageUptodate(page)) {
-		offset = (loff_t) index << PAGE_SHIFT;
-		kvec.iov_base = page_address(page);
-		kvec.iov_len = PAGE_SIZE;
-		iov_iter_kvec(&iter, ITER_DEST, &kvec, 1, PAGE_SIZE);
+	if (!folio_test_uptodate(folio)) {
+		offset = folio_pos(folio);
+		kvec.iov_base = folio_address(folio);
+		kvec.iov_len = folio_size(folio);
+		iov_iter_kvec(&iter, ITER_DEST, &kvec, 1, folio_size(folio));
 
 		rc = __read_vmcore(&iter, &offset);
 		if (rc < 0) {
-			unlock_page(page);
-			put_page(page);
+			folio_unlock(folio);
+			folio_put(folio);
 			return vmf_error(rc);
 		}
-		SetPageUptodate(page);
+		folio_mark_uptodate(folio);
 	}
-	unlock_page(page);
-	vmf->page = page;
+	folio_unlock(folio);
+	vmf->page = folio_file_page(folio, index);
 	return 0;
 #else
 	return VM_FAULT_SIGBUS;
_

Patches currently in -mm which might be from tz2294@columbia.edu are


