Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53A5517D353
	for <mm-commits@vger.kernel.org>; Wed, 12 Jun 2024 15:59:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718207995; cv=none; b=YYG8ebSaCkFaGegi+hoXlbid2ThwwiZFPiuo10YYR2gzeTZmJEKxmrV50PsgbeWiIKBN8lpPpG/RAB2+GBwj8EPRP5Nx9/10doOsFejM4eYoAWP9a8d1D01C++CKrKJ74qsg8P7iTQhhN5Y9YGPovbvQNO65rveXXvmbwrwa4IQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718207995; c=relaxed/simple;
	bh=wAJPtHZchM/NTgkn9OU/zehJgb9H/euYnL1EXKl0SBo=;
	h=Date:To:From:Subject:Message-Id; b=Yp3p1+Gm/bnPH6b4BTZu2nvPh8+EdbdBbRgnr6N9mIRejzXyDvWwJKl8QgcBhSUfVIPfqDa7jvCGTbS0QrSTpxRoRrNraN2boLkhG8jRjgysiko2ThZXOGpF+h4irb+l7W5vmIIIpM9EyXR97ClsGvZj42kDmYPQMm5u5ROHe/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=lderNzD9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="lderNzD9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9585FC116B1;
	Wed, 12 Jun 2024 15:59:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1718207994;
	bh=wAJPtHZchM/NTgkn9OU/zehJgb9H/euYnL1EXKl0SBo=;
	h=Date:To:From:Subject:From;
	b=lderNzD9CT7/xRaB7Ml3Ft82WPB1Qbb7PJQDfiacw8dURzLNIjDV+eBmNo4zg40zR
	 yQr3hmuABFY89TroxLXVyrCISIlXT54oV7dLM/mPanQAkSC1xm2a6kdRo3CojvluVb
	 a5auVVM7NlsNohS1bQ1OqXIB+yf3pBM09Miv6gTU=
Date: Wed, 12 Jun 2024 08:59:53 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ying.huang@intel.com,david@redhat.com,baolin.wang@linux.alibaba.com,hughd@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-migrate-fix-kernel-bug-at-mm-compactionc-2761.patch added to mm-hotfixes-unstable branch
Message-Id: <20240612155954.9585FC116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/migrate: fix kernel BUG at mm/compaction.c:2761!
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-migrate-fix-kernel-bug-at-mm-compactionc-2761.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-migrate-fix-kernel-bug-at-mm-compactionc-2761.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Hugh Dickins <hughd@google.com>
Subject: mm/migrate: fix kernel BUG at mm/compaction.c:2761!
Date: Tue, 11 Jun 2024 22:06:20 -0700 (PDT)

I hit the VM_BUG_ON(!list_empty(&cc->migratepages)) in compact_zone(); and
if DEBUG_VM were off, then pages would be lost on a local list.

Our convention is that if migrate_pages() reports complete success (0),
then the migratepages list will be empty; but if it reports an error or
some pages remaining, then its caller must putback_movable_pages().

There's a new case in which migrate_pages() has been reporting complete
success, but returning with pages left on the migratepages list: when
migrate_pages_batch() successfully split a folio on the deferred list, but
then the "Failure isn't counted" call does not dispose of them all.

Since that block is expecting the large folio to have been counted as 1
failure already, and since the return code is later adjusted to success
whenever the returned list is found empty, the simple way to fix this
safely is to count splitting the deferred folio as "a failure".

Link: https://lkml.kernel.org/r/46c948b4-4dd8-6e03-4c7b-ce4e81cfa536@google.com
Fixes: 7262f208ca68 ("mm/migrate: split source folio if it is on deferred split list")
Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/mm/migrate.c~mm-migrate-fix-kernel-bug-at-mm-compactionc-2761
+++ a/mm/migrate.c
@@ -1654,7 +1654,12 @@ static int migrate_pages_batch(struct li
 
 			/*
 			 * The rare folio on the deferred split list should
-			 * be split now. It should not count as a failure.
+			 * be split now. It should not count as a failure:
+			 * but increment nr_failed because, without doing so,
+			 * migrate_pages() may report success with (split but
+			 * unmigrated) pages still on its fromlist; whereas it
+			 * always reports success when its fromlist is empty.
+			 *
 			 * Only check it without removing it from the list.
 			 * Since the folio can be on deferred_split_scan()
 			 * local list and removing it can cause the local list
@@ -1669,6 +1674,7 @@ static int migrate_pages_batch(struct li
 			if (nr_pages > 2 &&
 			   !list_empty(&folio->_deferred_list)) {
 				if (try_split_folio(folio, split_folios) == 0) {
+					nr_failed++;
 					stats->nr_thp_split += is_thp;
 					stats->nr_split++;
 					continue;
_

Patches currently in -mm which might be from hughd@google.com are

mm-migrate-fix-kernel-bug-at-mm-compactionc-2761.patch

