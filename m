Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48DE3284693
	for <mm-commits@vger.kernel.org>; Sat, 21 Mar 2026 02:58:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774061903; cv=none; b=DmXCpURy+qErGaG4nq31oLvdk1eeDQnjHxbD/i7h5A/2lnq4ALXe7m+sp7XHXywSnxHMcYi7I5tGb9ysXwtKitMxUJmKhkZBfAk29OHMIetaw3uYxCI7y6C06YxbX0zMwje+983Gty76oJxXKt19ReLQ3H95cm4CZGkmHopJE88=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774061903; c=relaxed/simple;
	bh=3X4rtgbcvRAwPoujYnVCUnYPo8cMakTYHb37kgExTRw=;
	h=Date:To:From:Subject:Message-Id; b=gc8M/y83b4cg0FTUSgznAf2TTei9uI0j6YaE9PT2BzYqWeWX0Hlk6EgQuU+EtEPKJ26+D8utco3fg1bnXsUXJfSlhl+7NnUTlLPwZkRxn1UG4MlFI86K7ubqA3hy3YCpKSSkSEOp7ISUWondTfybvvYKqdzcXxooiZoggZbJ6h8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=bwEcrOlV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="bwEcrOlV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E989DC4CEF7;
	Sat, 21 Mar 2026 02:58:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774061903;
	bh=3X4rtgbcvRAwPoujYnVCUnYPo8cMakTYHb37kgExTRw=;
	h=Date:To:From:Subject:From;
	b=bwEcrOlVWW5dhD/cVrvh7eg8WtMNwOQMTUHd+8uTRR3eSWgnSj28QzeA1ha0/lAtW
	 J2p6XuzRZ6aUIAdC3Ri7i1p8Y6LUPgA4LmRY9uCtB4MKcLfF/Nt47UKVsVJ4iYP8V+
	 IfA8rpJxehP90SFQOr1YflwhZJyvsPi4jP4QeMT0=
Date: Fri, 20 Mar 2026 19:58:22 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@kernel.org,surenb@google.com,shuah@kernel.org,rppt@kernel.org,peterx@redhat.com,mhocko@suse.com,lkp@intel.com,ljs@kernel.org,liam.howlett@oracle.com,david@kernel.org,chris@chrisdown.name,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-add-uffdio_move-huge-zeropage-pmd-regression-test-fix.patch added to mm-unstable branch
Message-Id: <20260321025822.E989DC4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests-mm-add-uffdio_move-huge-zeropage-pmd-regression-test-fix
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-mm-add-uffdio_move-huge-zeropage-pmd-regression-test-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-add-uffdio_move-huge-zeropage-pmd-regression-test-fix.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: selftests-mm-add-uffdio_move-huge-zeropage-pmd-regression-test-fix
Date: Fri Mar 20 07:55:26 PM PDT 2026

fix build

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202603210319.P5MPyTEf-lkp@intel.com/
Cc: Chris Down <chris@chrisdown.name>
Cc: David Hildenbrand <david@kernel.org>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Peter Xu <peterx@redhat.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/vm_util.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/mm/vm_util.c~selftests-mm-add-uffdio_move-huge-zeropage-pmd-regression-test-fix
+++ a/tools/testing/selftests/mm/vm_util.c
@@ -130,7 +130,7 @@ bool pagemap_is_huge_zero(int fd, char *
 {
 	uint64_t categories;
 
-	if (!pagemap_scan_supported(fd, start))
+	if (!pagemap_scan_supported(fd))
 		return false;
 
 	categories = pagemap_scan_get_categories(fd, start);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

maple_tree-start-using-maple-copy-node-for-destination-checkpatch-fixes.patch
maple_tree-add-cp_is_new_root-helper-fix-fix.patch
mm-centralizefix-comments-about-compound_mapcount-in-new-sync_with_folio_pmd_zap-fix.patch
mm-rename-zap_page_range_single-to-zap_vma_range-fix.patch
mm-memcontrol-convert-objcg-to-be-per-memcg-per-node-type-fix-fix.patch
mm-page_reporting-add-page_reporting_order_unspecified-fix.patch
mm-rename-zone-lock-to-zone-_lock-fix.patch
selftests-mm-add-uffdio_move-huge-zeropage-pmd-regression-test-fix.patch
kernel-panic-increase-buffer-size-for-verbose-taint-logging-fix.patch
decode_stacktrace-decode-caller-address-checkpatch-fixes.patch
lib-list_sort-remove-dummy-cmp-calls-to-speed-up-merge_final-fix.patch

