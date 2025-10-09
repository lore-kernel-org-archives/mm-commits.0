Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE39717D2
	for <mm-commits@vger.kernel.org>; Thu,  9 Oct 2025 01:09:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759972180; cv=none; b=AGWshjsg0vhyNF8EPxn6H7rnRsPWrWJh1kKMsAbvtKcqX6Ar10gar6KHufKstgXei7naWZyhTwTKA3BDAR266/HqoV+idrCgDxqr2CbHis4GugHg4xnVsWRQPwnCtjlmC3bwXvkSvL4k5T12KPCbkzbKEGjqatEB3pnZYFuW4WE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759972180; c=relaxed/simple;
	bh=/GZ41N4oQvT6CVZrLyT6rZ9VsNzHDYzzUGc7HVRYmLY=;
	h=Date:To:From:Subject:Message-Id; b=DQDF2H+TJP6i12knkL6eGSCaGBpgv7XZtukhdDsfvjqCv2/TwFiwR3gyacG0FV+v8n0qyf6p6EQbdPR9cjcBhWw/JSNelws34g2EXbacgX8R3V+O0oiQhO3wO9Bn9ZT9oWugUc5TWT+RwaZpLuZJJrX3z46XLiQEOrMZipgc3ZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ntAOvp+E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ntAOvp+E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 444F3C4CEE7;
	Thu,  9 Oct 2025 01:09:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1759972180;
	bh=/GZ41N4oQvT6CVZrLyT6rZ9VsNzHDYzzUGc7HVRYmLY=;
	h=Date:To:From:Subject:From;
	b=ntAOvp+EAem8nLdSiq/I0Vd8jrF3MX5+a/EcWBUJBIrtcayIksKLgj935dn6jIFTo
	 lu/Y95nXyGsFEiDcztu7ftkvY+Jl+KQsvzOxbJF2rt6RgfctcNmEzzlK6MNo3WwM4I
	 M9QzdvayXOc56X3t1YH/ZPXCV6W2c+y7Inyru/EE=
Date: Wed, 08 Oct 2025 18:09:39 -0700
To: mm-commits@vger.kernel.org,osalvador@suse.de,lance.yang@linux.dev,dev.jain@arm.com,david@redhat.com,anshuman.khandual@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-dirty-replace-read_once-with-pudp_get.patch added to mm-new branch
Message-Id: <20251009010940.444F3C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/dirty: replace READ_ONCE() with pudp_get()
has been added to the -mm mm-new branch.  Its filename is
     mm-dirty-replace-read_once-with-pudp_get.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-dirty-replace-read_once-with-pudp_get.patch

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
From: Anshuman Khandual <anshuman.khandual@arm.com>
Subject: mm/dirty: replace READ_ONCE() with pudp_get()
Date: Mon, 6 Oct 2025 06:52:14 +0100

Replace READ_ONCE() with a standard page table accessor i.e pudp_get() that
anyways defaults into READ_ONCE() in cases where platform does not override

Link: https://lkml.kernel.org/r/20251006055214.1845342-1-anshuman.khandual@arm.com
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Dev Jain <dev.jain@arm.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Cc: Lance Yang <lance.yang@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mapping_dirty_helpers.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/mapping_dirty_helpers.c~mm-dirty-replace-read_once-with-pudp_get
+++ a/mm/mapping_dirty_helpers.c
@@ -149,7 +149,7 @@ static int wp_clean_pud_entry(pud_t *pud
 			      struct mm_walk *walk)
 {
 #ifdef CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD
-	pud_t pudval = READ_ONCE(*pud);
+	pud_t pudval = pudp_get(pud);
 
 	/* Do not split a huge pud */
 	if (pud_trans_huge(pudval)) {
_

Patches currently in -mm which might be from anshuman.khandual@arm.com are

mm-thp-drop-follow_devmap_pmd-default-stub.patch
mm-ptdump-replace-read_once-with-standard-page-table-accessors.patch
mm-replace-read_once-with-standard-page-table-accessors.patch
mm-dirty-replace-read_once-with-pudp_get.patch

