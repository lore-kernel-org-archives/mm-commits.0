Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87C4278F2E;
	Sat, 23 Aug 2025 00:57:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755910643; cv=none; b=e9SrU1nnufYUTgi4Hx+b0EF71n0y5jS0A4MbReaSuxf5pQjfLSRO/QBI83qHYKmwxdjSSP1y9O0Jjo6irjQvOS1xrlcnAz/2w/lzp8MjECyIGvDElNbxh4p2mKfKgbjCG4ZQYzo++TmNLmKMs8dIbkHt4+z7wyI3Ws4k+5B0nMo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755910643; c=relaxed/simple;
	bh=nSDVIkmCX5MSWoVrHx+N/vP9bqC4kl+3LaAFjmZMerU=;
	h=Date:To:From:Subject:Message-Id; b=k3YsUMvzN+sy3ca4w0ssdEOcViNMYY79Kmssbjcdll8ZMIxUn/teRBFD+wnYQ2vnuZq5dtV3uij3zX6j/2NeXV2Zj0YjSD2FC/Ck5xdWLfg6uhdULzTBBr/QcchzFAZlNo1NjpvuviqOHs39kyBMy19FcTzKGA2HjFmxOLn/7VY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=I/73VkpB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="I/73VkpB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0027EC4CEED;
	Sat, 23 Aug 2025 00:57:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1755910643;
	bh=nSDVIkmCX5MSWoVrHx+N/vP9bqC4kl+3LaAFjmZMerU=;
	h=Date:To:From:Subject:From;
	b=I/73VkpBRj7jXdzxrG1dyfCOGVtaCF9N3Iy6DC3su4la2ult2DCq35gviqHkq+42d
	 Cu7GUX9AB7r71C41tQzUoXBPjcSWAxFlD3lejGJelgmM+ryfCvJMjUA4A77wiE+qc9
	 PBSeIQ+zo2V3n1d8kWXLbkZ6XRz9MXQgZ2lEqsFI=
Date: Fri, 22 Aug 2025 17:57:22 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,stable@vger.kernel.org,ryan.roberts@arm.com,npache@redhat.com,lorenzo.stoakes@oracle.com,Liam.Howlett@oracle.com,dev.jain@arm.com,david@redhat.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,richard.weiyang@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-khugepaged-fix-the-address-passed-to-notifier-on-testing-young.patch added to mm-hotfixes-unstable branch
Message-Id: <20250823005723.0027EC4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/khugepaged: fix the address passed to notifier on testing young
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-khugepaged-fix-the-address-passed-to-notifier-on-testing-young.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-khugepaged-fix-the-address-passed-to-notifier-on-testing-young.patch

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
From: Wei Yang <richard.weiyang@gmail.com>
Subject: mm/khugepaged: fix the address passed to notifier on testing young
Date: Fri, 22 Aug 2025 06:33:18 +0000

Commit 8ee53820edfd ("thp: mmu_notifier_test_young") introduced
mmu_notifier_test_young(), but we should pass the address need to test. 
In xxx_scan_pmd(), the actual iteration address is "_address" not
"address".  We seem to misuse the variable on the very beginning.

Change it to the right one.

Link: https://lkml.kernel.org/r/20250822063318.11644-1-richard.weiyang@gmail.com
Fixes: 8ee53820edfd ("thp: mmu_notifier_test_young")
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Reviewed-by: Dev Jain <dev.jain@arm.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Nico Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Barry Song <baohua@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/khugepaged.c~mm-khugepaged-fix-the-address-passed-to-notifier-on-testing-young
+++ a/mm/khugepaged.c
@@ -1418,7 +1418,7 @@ static int hpage_collapse_scan_pmd(struc
 		if (cc->is_khugepaged &&
 		    (pte_young(pteval) || folio_test_young(folio) ||
 		     folio_test_referenced(folio) || mmu_notifier_test_young(vma->vm_mm,
-								     address)))
+								     _address)))
 			referenced++;
 	}
 	if (!writable) {
_

Patches currently in -mm which might be from richard.weiyang@gmail.com are

mm-khugepaged-fix-the-address-passed-to-notifier-on-testing-young.patch
mm-rmap-do-__folio_mod_stat-in-__folio_add_rmap.patch
selftests-mm-do-check_huge_anon-with-a-number-been-passed-in.patch
mm-rmap-not-necessary-to-mask-off-folio_pages_mapped.patch
mm-rmap-use-folio_large_nr_pages-when-we-are-sure-it-is-a-large-folio.patch
selftests-mm-put-general-ksm-operation-into-vm_util.patch
selftests-mm-test-that-rmap-behave-as-expected.patch
mm-khugepaged-use-list_xxx-helper-to-improve-readability.patch

