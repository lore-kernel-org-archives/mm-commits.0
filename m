Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EE59126F0A
	for <mm-commits@vger.kernel.org>; Mon, 19 May 2025 23:01:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747695688; cv=none; b=WjpiKUPHLrKmna9nhFA0X3Hp5eSNjiRkQJIjV0eb6PzDHd61uhO4pPDNzakrVB23pSAYR+3EvLdBeIL86b7pyw9wEnOVA0EiTLUmEDz4re+NAukQ3cMV1esEAEw2BG1eSJixC0yCjbS0M6h8zCQktcuw0ddM9UMfeVFDVX+vEa0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747695688; c=relaxed/simple;
	bh=X42d+CLfh00WineQRK2nKA3Hk/zhVFgUwvNXvu8BDxE=;
	h=Date:To:From:Subject:Message-Id; b=uTzm6jHHhgHdwb9g9tN5vFN2ukpKBVuiti3M+sHqk5iodlolqZs1CvndoLhb3wiRSsBYZyPr7O7+q5B3aN6OsCr5mhCr98Xsxi3lnLcjt3KNZhP1DLASwDIEveWV2K8AExgbAEKatFYLyhq/dacf1MYGHqGZUedgoeQ1z7kzfRc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=2OA5g4rb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="2OA5g4rb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C12BC4CEE4;
	Mon, 19 May 2025 23:01:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747695687;
	bh=X42d+CLfh00WineQRK2nKA3Hk/zhVFgUwvNXvu8BDxE=;
	h=Date:To:From:Subject:From;
	b=2OA5g4rbdbmsFII2T19Z0U8LpZ+izXLD9LY2luftDpslKYxQrJZismK0G2OjL1EMK
	 BleZdz5fSf+PJlAGJOdeoDz0UREebmoXSrLclbQPMDymBtV+wbJYoYUGzGTD6upUvA
	 TavSVx9YJC5E3E4yi8t+MWH0aTKfCTGR2JTH1teQ=
Date: Mon, 19 May 2025 16:01:26 -0700
To: mm-commits@vger.kernel.org,oliver.sang@intel.com,kasong@tencent.com,hughd@google.com,baolin.wang@linux.alibaba.com,shikemeng@huaweicloud.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-shmem-avoid-unpaired-folio_unlock-in-shmem_swapin_folio.patch added to mm-new branch
Message-Id: <20250519230127.3C12BC4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: shmem: avoid unpaired folio_unlock() in shmem_swapin_folio()
has been added to the -mm mm-new branch.  Its filename is
     mm-shmem-avoid-unpaired-folio_unlock-in-shmem_swapin_folio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-shmem-avoid-unpaired-folio_unlock-in-shmem_swapin_folio.patch

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
From: Kemeng Shi <shikemeng@huaweicloud.com>
Subject: mm: shmem: avoid unpaired folio_unlock() in shmem_swapin_folio()
Date: Sat, 17 May 2025 01:09:35 +0800

Patch series "Some random fixes and cleanup to shmem", v3.

This series contains some simple fixes and cleanup which are made during
learning shmem.  More details can be found in respective patches.


This patch (of 5):

If we get a folio from swap_cache_get_folio() successfully but encounter a
failure before the folio is locked, we will unlock the folio which was not
previously locked.

Put the folio and set it to NULL when a failure occurs before the folio is
locked to fix the issue.

Link: https://lkml.kernel.org/r/20250516170939.965736-1-shikemeng@huaweicloud.com
Link: https://lkml.kernel.org/r/20250516170939.965736-2-shikemeng@huaweicloud.com
Fixes: 058313515d5aa ("mm: shmem: fix potential data corruption during shmem swapin")
Signed-off-by: Kemeng Shi <shikemeng@huaweicloud.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Kairui Song <kasong@tencent.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: kernel test robot <oliver.sang@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/shmem.c~mm-shmem-avoid-unpaired-folio_unlock-in-shmem_swapin_folio
+++ a/mm/shmem.c
@@ -2335,6 +2335,8 @@ static int shmem_swapin_folio(struct ino
 		 */
 		split_order = shmem_split_large_entry(inode, index, swap, gfp);
 		if (split_order < 0) {
+			folio_put(folio);
+			folio = NULL;
 			error = split_order;
 			goto failed;
 		}
_

Patches currently in -mm which might be from shikemeng@huaweicloud.com are

mm-shmem-avoid-unpaired-folio_unlock-in-shmem_swapin_folio.patch
mm-shmem-add-missing-shmem_unacct_size-in-__shmem_file_setup.patch
mm-shmem-fix-potential-dead-loop-in-shmem_unuse.patch
mm-shmem-only-remove-inode-from-swaplist-when-its-swapped-page-count-is-0.patch
mm-shmem-remove-unneeded-xa_is_value-check-in-shmem_unuse_swap_entries.patch

