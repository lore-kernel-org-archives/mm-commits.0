Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A41B1EF38E
	for <mm-commits@vger.kernel.org>; Sun, 13 Jul 2025 23:40:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752450041; cv=none; b=MVPaCQ4iqo5U63HQgLEnr+eh7POLPBwOs0dCVOCwnrd226u9fP0w6MW1445cxdnpq06kH3Md3LhBxz9kAAspNBpWquq0VqRN0O+JgjBFUd7UMu/+/Oq6+YzLksUkC05k6trwQFxy0ziM/zbEEHA0F2JDo4gVQZbQQX1au3+2OHA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752450041; c=relaxed/simple;
	bh=E8sSl35k8Z0ZabwxtWvN0nmQtuH/PqL2b8GdGOhGCN8=;
	h=Date:To:From:Subject:Message-Id; b=j+N03laOXkK224Wq1w7+UfM3pEw9q5XppcGLE479eyAvo4uxnAr8XZGmQWFBDFFKSSxwqNKm16nkkvxA7k4ga6yumDxnvjX+gBZDAJ+z3mM2RdZAoffLu5cCjdWCGm0KKwMUk7Yi0zb9Tor4erIUKc7DroOztc4WTlNG927dBCk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=CpLJOEny; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="CpLJOEny"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11086C4CEE3;
	Sun, 13 Jul 2025 23:40:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752450041;
	bh=E8sSl35k8Z0ZabwxtWvN0nmQtuH/PqL2b8GdGOhGCN8=;
	h=Date:To:From:Subject:From;
	b=CpLJOEnyey9nOmpuDRhdtc2MhLoGfF3amlIjQ6xgls2GBWGfiqx/r6PfeUdevwXPh
	 bfWXpR+5uJKgql5GxY6kLMzEH54F5BZjildN3u/r28LaPUgFkvTqIf17VwP32eht7t
	 bbnRpLN0c7ytWb8TsTTrVsrgE2jtguEdPSL7zLFg=
Date: Sun, 13 Jul 2025 16:40:40 -0700
To: mm-commits@vger.kernel.org,peterx@redhat.com,muchun.song@linux.dev,gavinguo@igalia.com,david@redhat.com,osalvador@suse.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mmhugetlb-drop-obsolete-comment-about-non-present-pte-and-second-faults.patch removed from -mm tree
Message-Id: <20250713234041.11086C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm,hugetlb: drop obsolete comment about non-present pte and second faults
has been removed from the -mm tree.  Its filename was
     mmhugetlb-drop-obsolete-comment-about-non-present-pte-and-second-faults.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Oscar Salvador <osalvador@suse.de>
Subject: mm,hugetlb: drop obsolete comment about non-present pte and second faults
Date: Mon, 30 Jun 2025 16:42:11 +0200

There is a comment in hugetlb_fault() that does not hold anymore.  This
one:

 /*
  * vmf.orig_pte could be a migration/hwpoison vmf.orig_pte at this
  * point, so this check prevents the kernel from going below assuming
  * that we have an active hugepage in pagecache. This goto expects
  * the 2nd page fault, and is_hugetlb_entry_(migration|hwpoisoned)
  * check will properly handle it.
  */

This was written because back in the day we used to do:

 hugetlb_fault () {
  ptep = huge_pte_offset(...)
  if (ptep) {
    entry = huge_ptep_get(ptep)
    if (unlikely(is_hugetlb_entry_migration(entry))
        ...
    else if (unlikely(is_hugetlb_entry_hwpoisoned(entry)))
        ...
  }

  ...
  ...

  /*
   * entry could be a migration/hwpoison entry at this point, so this
   * check prevents the kernel from going below assuming that we have
   * a active hugepage in pagecache. This goto expects the 2nd page fault,
   * and is_hugetlb_entry_(migration|hwpoisoned) check will properly
   * handle it.
   */
  if (!pte_present(entry))
          goto out_mutex;
  ...
 }

The code was designed to check for hwpoisoned/migration entries upfront,
and then bail out if further down the pte was not present anymore, relying
on the second fault to properly handle migration/hwpoison entries that
time around.

The way we handle this is different nowadays, so drop the misleading
comment.

Link: https://lkml.kernel.org/r/20250627102904.107202-5-osalvador@suse.de
Link: https://lkml.kernel.org/r/20250630144212.156938-5-osalvador@suse.de
Signed-off-by: Oscar Salvador <osalvador@suse.de>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Gavin Guo <gavinguo@igalia.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Peter Xu <peterx@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

--- a/mm/hugetlb.c~mmhugetlb-drop-obsolete-comment-about-non-present-pte-and-second-faults
+++ a/mm/hugetlb.c
@@ -6727,13 +6727,7 @@ vm_fault_t hugetlb_fault(struct mm_struc
 
 	ret = 0;
 
-	/*
-	 * vmf.orig_pte could be a migration/hwpoison vmf.orig_pte at this
-	 * point, so this check prevents the kernel from going below assuming
-	 * that we have an active hugepage in pagecache. This goto expects
-	 * the 2nd page fault, and is_hugetlb_entry_(migration|hwpoisoned)
-	 * check will properly handle it.
-	 */
+	/* Not present, either a migration or a hwpoisoned entry */
 	if (!pte_present(vmf.orig_pte)) {
 		if (unlikely(is_hugetlb_entry_migration(vmf.orig_pte))) {
 			/*
_

Patches currently in -mm which might be from osalvador@suse.de are


