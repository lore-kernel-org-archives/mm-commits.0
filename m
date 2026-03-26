Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5D90384241
	for <mm-commits@vger.kernel.org>; Thu, 26 Mar 2026 23:39:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774568360; cv=none; b=u3+CsO66fc5geUVGmBjJ5zdx3oaTlhBklwy/3NT+iWBU1DkB+dBas28JDSjAzwjau6fijVDIRqlTJ1mpJAjbclkJ1yDg5hEGU6Ug7lALPFfK87QxCkb5KKGI1asjQry+r6UwkohTgHs0t9vmq7EYDHe3r2A0l6rgx/JCn/9vCiM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774568360; c=relaxed/simple;
	bh=9AXH9kmhekudtGdXyXpszPA6ZE+yyzLXUvqTbObSTjY=;
	h=Date:To:From:Subject:Message-Id; b=EnT+Wc+ih77luSziLtwnoBtlKjXoFKR+e3XUm6S4PY5RuFooyQnf4YBgtLiTIZU4SmCiEs6SWSbBi8Q5EDkha+7vmVXdHJZ3nQX12q8qqoS7RfrNH4mw96cFsc3eq1KePPsxqrLt1PzSUtTZedK0irl+lkzjDDnBtqwVoEJtLMM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=r0CkRXYW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="r0CkRXYW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40A90C116C6;
	Thu, 26 Mar 2026 23:39:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774568360;
	bh=9AXH9kmhekudtGdXyXpszPA6ZE+yyzLXUvqTbObSTjY=;
	h=Date:To:From:Subject:From;
	b=r0CkRXYW0lGJCgjwKYVnmtf1LjD4QhSAuNKImtHcQSdKUL+HRikLRUgfREeft2esx
	 FcAvdKagYPJ0vQHaUyxUWJlLX/3NvEjP6AHZSqyvzSpFGaCVqeUEArSo/6xrrUnS/h
	 M1BAbLZ5LGW8kkDPVKegOsNduapTL3n3dfknDNAg=
Date: Thu, 26 Mar 2026 16:39:19 -0700
To: mm-commits@vger.kernel.org,rppt@kernel.org,pratyush@kernel.org,pasha.tatashin@soleen.com,jianghaoran@kylinos.cn,duanchenghao@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memfd_luo-fix-integer-overflow-in-memfd_luo_preserve_folios.patch added to mm-new branch
Message-Id: <20260326233920.40A90C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/memfd_luo: fix integer overflow in memfd_luo_preserve_folios
has been added to the -mm mm-new branch.  Its filename is
     mm-memfd_luo-fix-integer-overflow-in-memfd_luo_preserve_folios.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memfd_luo-fix-integer-overflow-in-memfd_luo_preserve_folios.patch

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
From: Chenghao Duan <duanchenghao@kylinos.cn>
Subject: mm/memfd_luo: fix integer overflow in memfd_luo_preserve_folios
Date: Thu, 26 Mar 2026 16:47:27 +0800

In memfd_luo_preserve_folios(), two variables had types that could cause
silent data loss with large files:

1. 'size' was declared as 'long', truncating the 64-bit result of
   i_size_read(). On 32-bit systems a 4GB file would be truncated to 0,
   causing the function to return early and discard all data.

2. 'max_folios' was declared as 'unsigned int', causing overflow for
   sparse files larger than 4TB. For example, a 16TB+4KB file would
   calculate 0x100000001 folios but truncate to 1 when assigned to
   max_folios, causing memfd_pin_folios() to pin only the first folio.

Fix by changing both variables to 'u64' to match the types returned
by i_size_read() and the folio count calculations.

This issue was identified by the AI review.
https://sashiko.dev/#/patchset/20260323110747.193569-1-duanchenghao@kylinos.cn

Link: https://lkml.kernel.org/r/20260326084727.118437-8-duanchenghao@kylinos.cn
Signed-off-by: Chenghao Duan <duanchenghao@kylinos.cn>
Cc: Haoran Jiang <jianghaoran@kylinos.cn>
Cc: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Pratyush Yadav <pratyush@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memfd_luo.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/memfd_luo.c~mm-memfd_luo-fix-integer-overflow-in-memfd_luo_preserve_folios
+++ a/mm/memfd_luo.c
@@ -90,8 +90,8 @@ static int memfd_luo_preserve_folios(str
 {
 	struct inode *inode = file_inode(file);
 	struct memfd_luo_folio_ser *folios_ser;
-	unsigned int max_folios;
-	long i, size, nr_pinned;
+	u64 size, max_folios;
+	long i, nr_pinned;
 	struct folio **folios;
 	int err = -EINVAL;
 	pgoff_t offset;
_

Patches currently in -mm which might be from duanchenghao@kylinos.cn are

mm-memfd-use-folio_nr_pages-for-shmem-inode-accounting.patch
mm-memfd_luo-optimize-shmem_recalc_inode-calls-in-retrieve-path.patch
mm-memfd_luo-remove-unnecessary-memset-in-zero-size-memfd-path.patch
mm-memfd_luo-use-i_size_write-to-set-inode-size-during-retrieve.patch
mm-memfd_luo-fix-physical-address-conversion-in-put_folios-cleanup.patch
mm-memfd_luo-remove-folio-from-page-cache-when-accounting-fails.patch
mm-memfd_luo-fix-integer-overflow-in-memfd_luo_preserve_folios.patch

