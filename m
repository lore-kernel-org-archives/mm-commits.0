Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CCA73D9DA8
	for <mm-commits@vger.kernel.org>; Tue,  1 Sep 2026 21:46:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788299210; cv=none; b=CWaKMQaNbsWPHAXNoWxVOE+93NKiSRCEaKvKc4CvDnJBbHELlbyQnh33cJu8ZJcqE9pojDdnuwe7yqpW59EwN5mYOPIGIQQgg3ieiWzHU+V+J/6yOFHAlzB4qR6Q8r2PM0ydEIINbJkknhyvtSiXfVK2PRWe5voUcPOWYoyy5dc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788299210; c=relaxed/simple;
	bh=fd5/9Uw0Us3AJjOabk6NVT8swIJgBDsg6DCVRx7suk0=;
	h=Date:To:From:Subject:Message-Id; b=gzd0WlhMBMhSbn2rfcVZ4EfuFpmc3UhQEYn3f1ZoCEt8Cl+XlNJEvqjlEOdpn7mkAzB6huIEZ/Se6dyMEfTWWE5tAfGsdLSmBVLQY5avRIapKXudGZo58oI7sBO+GGKvlr+g/Lbhu4kR/vzKos9cKtIFvJI2XHvmQ5sbOjhL0FQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=NQ7gTeLN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="NQ7gTeLN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A17171F000E9;
	Tue,  1 Sep 2026 21:46:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788299204;
	bh=pQlwdhRXWxFDAb5Uqt082PBCWKFIN3621CwCeOMr1vA=;
	h=Date:To:From:Subject;
	b=NQ7gTeLNI4ovtwWon+uPtCP82q+UFk+jIFdmWKa14Hg3D6YFRA5PCTXj0rM9OqX+p
	 W4t9+OdOhV+yeaH4wdHY1LFtIZoYsPrwnNsEFR1drpde3j1uoNZotk9hrmd+ixEjpV
	 Ndh88KQENQKe3nst6H49sgiYSuwG+N0a4yLSnJxo=
Date: Tue, 01 Sep 2026 14:46:44 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,david@kernel.org,tz2294@columbia.edu,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-remove-unused-totalram_pages_inc-and-totalram_pages_dec.patch added to mm-new branch
Message-Id: <20260901214644.A17171F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: remove unused totalram_pages_inc() and totalram_pages_dec()
has been added to the -mm mm-new branch.  Its filename is
     mm-remove-unused-totalram_pages_inc-and-totalram_pages_dec.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-remove-unused-totalram_pages_inc-and-totalram_pages_dec.patch

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
From: Tal Zussman <tz2294@columbia.edu>
Subject: mm: remove unused totalram_pages_inc() and totalram_pages_dec()
Date: Tue, 01 Sep 2026 15:38:05 -0400

totalram_pages_inc() and totalram_pages_dec() have had no callers since
commit 7fbc5e26123e ("memblock: extract page freeing from
free_reserved_area() into a helper") and commit 287b89773d81
("powerpc/pseries/cmm: Use adjust_managed_page_count() insted of
totalram_pages_*"), respectively. Remove them.

Drop the totalram_pages_inc() stub from tools mm.h too.

Link: https://lore.kernel.org/20260901-mm-remove-unused-helpers-v2-2-f6474e169c23@columbia.edu
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: Tal Zussman <tz2294@columbia.edu>
Cc: David Hildenbrand <david@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h       |   10 ----------
 tools/include/linux/mm.h |    4 ----
 2 files changed, 14 deletions(-)

--- a/include/linux/mm.h~mm-remove-unused-totalram_pages_inc-and-totalram_pages_dec
+++ a/include/linux/mm.h
@@ -57,16 +57,6 @@ static inline unsigned long totalram_pag
 	return (unsigned long)atomic_long_read(&_totalram_pages);
 }
 
-static inline void totalram_pages_inc(void)
-{
-	atomic_long_inc(&_totalram_pages);
-}
-
-static inline void totalram_pages_dec(void)
-{
-	atomic_long_dec(&_totalram_pages);
-}
-
 static inline void totalram_pages_add(long count)
 {
 	atomic_long_add(count, &_totalram_pages);
--- a/tools/include/linux/mm.h~mm-remove-unused-totalram_pages_inc-and-totalram_pages_dec
+++ a/tools/include/linux/mm.h
@@ -33,10 +33,6 @@ static inline phys_addr_t virt_to_phys(v
 	return (phys_addr_t)address;
 }
 
-static inline void totalram_pages_inc(void)
-{
-}
-
 static inline void totalram_pages_add(long count)
 {
 }
_

Patches currently in -mm which might be from tz2294@columbia.edu are

mm-page_io-convert-write-completion-handlers-to-folios.patch
mm-remove-pagereclaim.patch
mm-page_io-use-swap-entries-directly-in-zeromap-helpers.patch
mm-page_io-rename-bio_associate_blkg_from_page.patch
mm-page_io-refer-to-folios-in-swap_writeout-comments.patch
mm-swap-rename-__swap_writepage-to-__swap_writeout.patch
mm-remove-unused-mark_page_reserved.patch
mm-remove-unused-totalram_pages_inc-and-totalram_pages_dec.patch

