Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EAFF1BC59
	for <mm-commits@vger.kernel.org>; Fri, 12 Jul 2024 22:32:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720823562; cv=none; b=IRUK1KwpEQh65qozw/rGaJ90xKdAWEBf9KTc4tpGub7LUMYsZalKTocvgpK4nzbSysGU02bINKPh/4Xm63nAvg8SY6bGojUdgnQ5n6386Zm4jwdMY2Nwq+02iMJiHsbK6eVMvyRFd2ifgYzn8lCTgaHXzw0pxazMfs52EuSN/QM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720823562; c=relaxed/simple;
	bh=8GDVj+cw/SAiwcW2Jf+3wEfRbnPkqsI2TIW9ZPZ0VyU=;
	h=Date:To:From:Subject:Message-Id; b=N7v5yEz6sQrv24otiM9zDj1QVC2Rc0yQkHQpyGwRt/AmVF9VzgEgFYJtXYW2QmITEH52eSx6ylu1U6WGR7yHB7qR9slTnrUHQszdnrVwgu3ECt75qtWhJhpZIMAcOPFsF/7ZdI0UmaTiNsf6M6rOpnde4S0eTLt5RAXby/hMjCM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=KRJO+MaA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="KRJO+MaA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C547C32782;
	Fri, 12 Jul 2024 22:32:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1720823562;
	bh=8GDVj+cw/SAiwcW2Jf+3wEfRbnPkqsI2TIW9ZPZ0VyU=;
	h=Date:To:From:Subject:From;
	b=KRJO+MaA6GOL2UA0ZpPxc40A02glTHe2pcr2gFlVgyTuyq402C6upM/DRu6JeatfK
	 QszKK98fgC0Uc/QsrbE+wOBj495KFZnhnBOiS506Hk5f8S/GgXVkFKXYBC15Hwad6X
	 Hqd7puI94whwFphMOrCAB7IVXNWjK2H7GZmqK1FQ=
Date: Fri, 12 Jul 2024 15:32:41 -0700
To: mm-commits@vger.kernel.org,vivek.kasireddy@intel.com,sj@kernel.org,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [withdrawn] mm-gup-introduce-memfd_pin_folios-for-pinning-memfd-folios-fix-fix.patch removed from -mm tree
Message-Id: <20240712223242.0C547C32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-gup-introduce-memfd_pin_folios-for-pinning-memfd-folios-fix-fix
has been removed from the -mm tree.  Its filename was
     mm-gup-introduce-memfd_pin_folios-for-pinning-memfd-folios-fix-fix.patch

This patch was dropped because it was withdrawn

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-gup-introduce-memfd_pin_folios-for-pinning-memfd-folios-fix-fix
Date: Fri Jul  5 03:12:47 PM PDT 2024

propagate try_grab_folio() retval, including the weird -EREMOTEIO

Cc: SeongJae Park <sj@kernel.org>
Cc: Vivek Kasireddy <vivek.kasireddy@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/mm/gup.c~mm-gup-introduce-memfd_pin_folios-for-pinning-memfd-folios-fix-fix
+++ a/mm/gup.c
@@ -3851,6 +3851,8 @@ long memfd_pin_folios(struct file *memfd
 
 			next_idx = 0;
 			for (i = 0; i < nr_found; i++) {
+				int ret2;
+
 				/*
 				 * As there can be multiple entries for a
 				 * given folio in the batch returned by
@@ -3863,10 +3865,10 @@ long memfd_pin_folios(struct file *memfd
 					continue;
 
 				folio = page_folio(&fbatch.folios[i]->page);
-
-				if (try_grab_folio(folio, 1, FOLL_PIN)) {
+				ret2 = try_grab_folio(folio, 1, FOLL_PIN);
+				if (ret2) {
 					folio_batch_release(&fbatch);
-					ret = -EINVAL;
+					ret = ret2;
 					goto err;
 				}
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-hugetlbc-undo-errant-change.patch
mm-gup-introduce-memfd_pin_folios-for-pinning-memfd-folios-fix.patch
mm-migrate-putback-split-folios-when-numa-hint-migration-fails-fix.patch

