Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB6AF42069
	for <mm-commits@vger.kernel.org>; Thu, 31 Oct 2024 03:15:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730344507; cv=none; b=km0AB9WpnKnya/M3xl/sNFPQsj4OU2VQzLvFzKABjdnGBtCVQHNd4VUZTYLnFx/9jArxF7FbZH/WD7dRQddieBRKaQpN2soLCPloxmUOpdqsBV0FTFYm8m12GnUfn1+81wrV3F/McLc2f3+zirlLIU+hefHzySdESj4phQ2kIYE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730344507; c=relaxed/simple;
	bh=GlSYsR5PfhUDvqiqj+TOU2t2JZ7ABWf5dJtQLmZFiv8=;
	h=Date:To:From:Subject:Message-Id; b=C+vfgqTLgBfEEL4VdMzHlKo4gPILk0STOVY6BAaJRECjNfkIQEYBwhWPByh3nSU+7X8gKGeP7jWtAUdKrbpQ5CVNgM52vDu5YZoHW6QgzvrluRQ5Tj8V9Pu09g1EFee2WeQhwFhNs/g0M19Rx7NXFNL95ygsK18sFfSODXs9By8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=hkV9v/PD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="hkV9v/PD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D5F4C4CECE;
	Thu, 31 Oct 2024 03:15:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730344507;
	bh=GlSYsR5PfhUDvqiqj+TOU2t2JZ7ABWf5dJtQLmZFiv8=;
	h=Date:To:From:Subject:From;
	b=hkV9v/PDcWo12hvkkCw0iNWSnnE0K9xEB2TlxrAiHucniQSbSLrG5eJuh+aPdxFIy
	 Wpe8f6QFn3B6MOwYGuwjvUA3KHxPWrHa8L+IrQV215gosuQy826YzGPHaWzBbHOTFi
	 hn7p3YZTgg0vPh+oF991rwGAyXkomSXE1UbReRfA=
Date: Wed, 30 Oct 2024 20:15:06 -0700
To: mm-commits@vger.kernel.org,yosryahmed@google.com,ying.huang@intel.com,usamaarif642@gmail.com,ryan.roberts@arm.com,kasong@tencent.com,kanchana.p.sridhar@intel.com,david@redhat.com,chrisl@kernel.org,baolin.wang@linux.alibaba.com,v-songbaohua@oppo.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-fix-pswpin-counter-for-large-folios-swap-in.patch removed from -mm tree
Message-Id: <20241031031507.3D5F4C4CECE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: fix PSWPIN counter for large folios swap-in
has been removed from the -mm tree.  Its filename was
     mm-fix-pswpin-counter-for-large-folios-swap-in.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Barry Song <v-songbaohua@oppo.com>
Subject: mm: fix PSWPIN counter for large folios swap-in
Date: Thu, 24 Oct 2024 10:02:01 +1300

Similar to PSWPOUT, we should count the number of base pages instead of
large folios.

Link: https://lkml.kernel.org/r/20241023210201.2798-1-21cnbao@gmail.com
Fixes: 242d12c98174 ("mm: support large folios swap-in for sync io devices")
Signed-off-by: Barry Song <v-songbaohua@oppo.com>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: Yosry Ahmed <yosryahmed@google.com>
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

mm-add-per-order-mthp-swpin-counters.patch
mm-add-per-order-mthp-swpin-counters-v2.patch

