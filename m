Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF1EC146A79
	for <mm-commits@vger.kernel.org>; Wed, 23 Oct 2024 22:33:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729722797; cv=none; b=V+z4BIpjl/RH1cjJyN3TdYbUZRFni3hGhrPTfG/ot+wDa9Pusrh2ZXLmUqoU4s+Z3LW7Matpir4zUzJnqzsNBLRFkVjsrRMMmIG9xsWUAGeGy1tWYJ7n2yTF+cQTkDq+UOMILYHuHclclVAnArR3wxKrQUk6j6SbsIXKblEa0PI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729722797; c=relaxed/simple;
	bh=weURYkNUEcuWEyCXeiFn1XoItkKhBO3ktWaW1esKlPk=;
	h=Date:To:From:Subject:Message-Id; b=hoar2iFdjEnrOwY9wsZ9tpz2IDh/XME2YzJIHxiw/z2awachFsrlqPmFClo4FUkySCdjBDI6WrsmUFfLU7s/XVnRU7LuNHDeW2mH8RVHPb4nlGzxoXjFfaaSl3ZsPJBA7aVAVCarweEl67pw6c/5NBhMNSnP/+6kFo8KVit7jCw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=CnzMCqvv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="CnzMCqvv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E121C4CEC6;
	Wed, 23 Oct 2024 22:33:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1729722796;
	bh=weURYkNUEcuWEyCXeiFn1XoItkKhBO3ktWaW1esKlPk=;
	h=Date:To:From:Subject:From;
	b=CnzMCqvv1Ycbnw4feICK5eBLwP8UldeSgzu0DE/SK2iSu4sG/suZxEzbH0JloN3sr
	 RfeP8aIuw51D9Ge1kdB/Qa9/7/rl5JJCe95gIoXysGDhjc2EVVBNeLYPmpfUdEt0uI
	 Xd2hAzyuMmmxpnV6NDV3RTzvZJ9OQulrqlON6684=
Date: Wed, 23 Oct 2024 15:33:14 -0700
To: mm-commits@vger.kernel.org,yosryahmed@google.com,ying.huang@intel.com,usamaarif642@gmail.com,ryan.roberts@arm.com,kasong@tencent.com,kanchana.p.sridhar@intel.com,david@redhat.com,chrisl@kernel.org,baolin.wang@linux.alibaba.com,v-songbaohua@oppo.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-fix-pswpin-counter-for-large-folios-swap-in.patch added to mm-hotfixes-unstable branch
Message-Id: <20241023223316.4E121C4CEC6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: Fix PSWPIN counter for large folios swap-in
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-fix-pswpin-counter-for-large-folios-swap-in.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-fix-pswpin-counter-for-large-folios-swap-in.patch

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
From: Barry Song <v-songbaohua@oppo.com>
Subject: mm: Fix PSWPIN counter for large folios swap-in
Date: Thu, 24 Oct 2024 10:02:01 +1300

Similar to PSWPOUT, we should count the number of base pages instead of
large folios.

Link: https://lkml.kernel.org/r/20241023210201.2798-1-21cnbao@gmail.com
Fixes: 242d12c98174 ("mm: support large folios swap-in for sync io devices")
Signed-off-by: Barry Song <v-songbaohua@oppo.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: Yosry Ahmed <yosryahmed@google.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Kairui Song <kasong@tencent.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
Cc: Usama Arif <usamaarif642@gmail.com>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_io.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/page_io.c~mm-fix-pswpin-counter-for-large-folios-swap-in
+++ a/mm/page_io.c
@@ -570,7 +570,7 @@ static void swap_read_folio_bdev_sync(st
 	 * attempt to access it in the page fault retry time check.
 	 */
 	get_task_struct(current);
-	count_vm_event(PSWPIN);
+	count_vm_events(PSWPIN, folio_nr_pages(folio));
 	submit_bio_wait(&bio);
 	__end_swap_bio_read(&bio);
 	put_task_struct(current);
@@ -585,7 +585,7 @@ static void swap_read_folio_bdev_async(s
 	bio->bi_iter.bi_sector = swap_folio_sector(folio);
 	bio->bi_end_io = end_swap_bio_read;
 	bio_add_folio_nofail(bio, folio, folio_size(folio), 0);
-	count_vm_event(PSWPIN);
+	count_vm_events(PSWPIN, folio_nr_pages(folio));
 	submit_bio(bio);
 }
 
_

Patches currently in -mm which might be from v-songbaohua@oppo.com are

mm-avoid-unconditional-one-tick-sleep-when-swapcache_prepare-fails.patch
mm-avoid-unconditional-one-tick-sleep-when-swapcache_prepare-fails-fix.patch
mm-fix-pswpin-counter-for-large-folios-swap-in.patch

