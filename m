Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 655E3B667;
	Tue, 27 May 2025 23:30:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748388637; cv=none; b=eM30Tn5EkRf8AvUT8x8C9rgX4ZyBkw7d2/AVbmbGszMA3lx+iRoanwmfbHRXD9kY1Rh9DorOHvnvL1ehOvtvTLp+H5BcUlLJROHVm0rMxheiBJmkUq2JqjKORF31Tb7duJ9RKlSGgh1l+Riz0RTP05KzMeZjcC8nsxeADLJASXw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748388637; c=relaxed/simple;
	bh=Xshyk68K4HFk9unHjGw2wUHwY+IrVKbGgX+b/HmNfGU=;
	h=Date:To:From:Subject:Message-Id; b=ApNGFVfh2Oosw4DBwjsFNZWTO0Bnjr+41rqbR02eYLGHtdbRtdv9Pk6eoZ5mVEhZXZzC7IiXlGYZaCtq0XB6yvxRcyX2I1a9K4OxoEblz+AfuHx4XQ9OeML6IB1ysEi8ouA28BAqgatw4iPCg8/eg51Y3h2AOzECg0oyJGPOVeA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1WhISlxp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1WhISlxp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5954C4CEE9;
	Tue, 27 May 2025 23:30:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1748388636;
	bh=Xshyk68K4HFk9unHjGw2wUHwY+IrVKbGgX+b/HmNfGU=;
	h=Date:To:From:Subject:From;
	b=1WhISlxpkIo4kNgNuwt3sRbHlXOk0GnnTeYqeAZ8nrTxZ+A/cv8/DeA9SUoFPWKJ0
	 9uocWjTCTyfmycibrTRySr5SAgPOn50D9DOemtPupDmvJVO4lUK2oVVuY9a0RpBo+O
	 OX4vkArToJ5VxWgzz9E94AzjTN5JZq4kxoTn7hM0=
Date: Tue, 27 May 2025 16:30:35 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,stable@vger.kernel.org,ryan.roberts@arm.com,npache@redhat.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,fengwei.yin@intel.com,dev.jain@arm.com,david@redhat.com,bharata@amd.com,baolin.wang@linux.alibaba.com,shivankg@amd.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-khugepaged-fix-race-with-folio-split-free-using-temporary-reference.patch added to mm-hotfixes-unstable branch
Message-Id: <20250527233036.B5954C4CEE9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/khugepaged: fix race with folio split/free using temporary reference
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-khugepaged-fix-race-with-folio-split-free-using-temporary-reference.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-khugepaged-fix-race-with-folio-split-free-using-temporary-reference.patch

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
From: Shivank Garg <shivankg@amd.com>
Subject: mm/khugepaged: fix race with folio split/free using temporary reference
Date: Mon, 26 May 2025 18:28:18 +0000

hpage_collapse_scan_file() calls is_refcount_suitable(), which in turn
calls folio_mapcount().  folio_mapcount() checks folio_test_large() before
proceeding to folio_large_mapcount(), but there is a race window where the
folio may get split/freed between these checks, triggering:

  VM_WARN_ON_FOLIO(!folio_test_large(folio), folio)

Take a temporary reference to the folio in hpage_collapse_scan_file(). 
This stabilizes the folio during refcount check and prevents incorrect
large folio detection due to concurrent split/free.  Use helper
folio_expected_ref_count() + 1 to compare with folio_ref_count() instead
of using is_refcount_suitable().

Link: https://lkml.kernel.org/r/20250526182818.37978-1-shivankg@amd.com
Fixes: 05c5323b2a34 ("mm: track mapcount of large folios in single value")
Signed-off-by: Shivank Garg <shivankg@amd.com>
Reported-by: syzbot+2b99589e33edbe9475ca@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/all/6828470d.a70a0220.38f255.000c.GAE@google.com
Suggested-by: David Hildenbrand <david@redhat.com>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Dev Jain <dev.jain@arm.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Bharata B Rao <bharata@amd.com>
Cc: Fengwei Yin <fengwei.yin@intel.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Mariano Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |   18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

--- a/mm/khugepaged.c~mm-khugepaged-fix-race-with-folio-split-free-using-temporary-reference
+++ a/mm/khugepaged.c
@@ -2295,6 +2295,17 @@ static int hpage_collapse_scan_file(stru
 			continue;
 		}
 
+		if (!folio_try_get(folio)) {
+			xas_reset(&xas);
+			continue;
+		}
+
+		if (unlikely(folio != xas_reload(&xas))) {
+			folio_put(folio);
+			xas_reset(&xas);
+			continue;
+		}
+
 		if (folio_order(folio) == HPAGE_PMD_ORDER &&
 		    folio->index == start) {
 			/* Maybe PMD-mapped */
@@ -2305,23 +2316,27 @@ static int hpage_collapse_scan_file(stru
 			 * it's safe to skip LRU and refcount checks before
 			 * returning.
 			 */
+			folio_put(folio);
 			break;
 		}
 
 		node = folio_nid(folio);
 		if (hpage_collapse_scan_abort(node, cc)) {
 			result = SCAN_SCAN_ABORT;
+			folio_put(folio);
 			break;
 		}
 		cc->node_load[node]++;
 
 		if (!folio_test_lru(folio)) {
 			result = SCAN_PAGE_LRU;
+			folio_put(folio);
 			break;
 		}
 
-		if (!is_refcount_suitable(folio)) {
+		if (folio_expected_ref_count(folio) + 1 != folio_ref_count(folio)) {
 			result = SCAN_PAGE_COUNT;
+			folio_put(folio);
 			break;
 		}
 
@@ -2333,6 +2348,7 @@ static int hpage_collapse_scan_file(stru
 		 */
 
 		present += folio_nr_pages(folio);
+		folio_put(folio);
 
 		if (need_resched()) {
 			xas_pause(&xas);
_

Patches currently in -mm which might be from shivankg@amd.com are

mm-khugepaged-fix-race-with-folio-split-free-using-temporary-reference.patch
mm-khugepaged-clean-up-refcount-check-using-folio_expected_ref_count.patch

