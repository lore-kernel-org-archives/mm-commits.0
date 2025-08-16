Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE7401EC01B
	for <mm-commits@vger.kernel.org>; Sat, 16 Aug 2025 05:26:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755322015; cv=none; b=N27rcP5use0sPRoYHVVyAkOjVNPaa5+xJTGKLnV0QtORBaEo58PcjA/dvlsUtzNVJhZOvI05+BzE9DE/AoAzrehwE0ze41SberbDj8yzB9SwyDtnaHtEK/K20zuDAz+GhGKhr4hL4zUOPCj5bmfy/MA7+IQnVszDQnDhu0hI7mU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755322015; c=relaxed/simple;
	bh=SIzvG5eWtuDxHm1QaaWpONe87kS4O1AlQ7t7G98YSDY=;
	h=Date:To:From:Subject:Message-Id; b=IfGaawenStcZHi6Gx/biGh1OhCHayX9mkMpY07BUOYD/e0f7B/4BpF4MUNlnxhxrAHvNfEh3NTzTE6am564grXNZ9CI/ViFKOZaGFL/TI/bGhEOK1xzAf/klP2TSAyyuayjGd1VH+GWqW1qBkl4KlF/WU2Hnq/bvHRMJyLTrl+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=f7/SSQkp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="f7/SSQkp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76EA9C4CEEF;
	Sat, 16 Aug 2025 05:26:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1755322013;
	bh=SIzvG5eWtuDxHm1QaaWpONe87kS4O1AlQ7t7G98YSDY=;
	h=Date:To:From:Subject:From;
	b=f7/SSQkpLXrojA/jstn4dD3sQ6f5T+ax7W20CI659Emr0R1ZA3zY3pHaWsFjn4Gc9
	 I4eMeUYCq9/4t/REFLpN4SfgkwbSkcj2w4fgjOalccXMiZHXqwm6jNE9TpHTMVycKv
	 9CnNtykHP1/f6M6/Sh0WmocsOYMv3lH2ACvLhWcI=
Date: Fri, 15 Aug 2025 22:26:52 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,shuah@kernel.org,ryan.roberts@arm.com,ritesh.list@gmail.com,richard.weiyang@gmail.com,npache@redhat.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,dev.jain@arm.com,david@redhat.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,aboorvad@linux.ibm.com,donettom@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-selftests-fix-incorrect-pointer-being-passed-to-mark_range.patch added to mm-new branch
Message-Id: <20250816052653.76EA9C4CEEF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/selftests: fix incorrect pointer being passed to mark_range()
has been added to the -mm mm-new branch.  Its filename is
     mm-selftests-fix-incorrect-pointer-being-passed-to-mark_range.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-selftests-fix-incorrect-pointer-being-passed-to-mark_range.patch

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
From: Donet Tom <donettom@linux.ibm.com>
Subject: mm/selftests: fix incorrect pointer being passed to mark_range()
Date: Sat, 16 Aug 2025 09:31:07 +0530

Patch series "selftests/mm: Fix false positives and skip unsupported
tests", v4.

This patch series addresses false positives in the generic mm selftests
and skips tests that cannot run correctly due to missing features or
system limitations.


This patch (of 7):

In main(), the high address is stored in hptr, but for mark_range(), the
address passed is ptr, not hptr.  Fixed this by changing ptr[i] to hptr[i]
in mark_range() function call.

Link: https://lkml.kernel.org/r/20250816040113.760010-1-aboorvad@linux.ibm.com
Link: https://lkml.kernel.org/r/20250816040113.760010-2-aboorvad@linux.ibm.com
Fixes: b2a79f62133a ("selftests/mm: virtual_address_range: unmap chunks after validation")
Co-developed-by: Aboorva Devarajan <aboorvad@linux.ibm.com>
Signed-off-by: Aboorva Devarajan <aboorvad@linux.ibm.com>
Signed-off-by: Donet Tom <donettom@linux.ibm.com>
Reviewed-by: Dev Jain <dev.jain@arm.com>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Mariano Pache <npache@redhat.com>
Cc: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Wei Yang <richard.weiyang@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/virtual_address_range.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/mm/virtual_address_range.c~mm-selftests-fix-incorrect-pointer-being-passed-to-mark_range
+++ a/tools/testing/selftests/mm/virtual_address_range.c
@@ -227,7 +227,7 @@ int main(void)
 		if (hptr[i] == MAP_FAILED)
 			break;
 
-		mark_range(ptr[i], MAP_CHUNK_SIZE);
+		mark_range(hptr[i], MAP_CHUNK_SIZE);
 		validate_addr(hptr[i], 1);
 	}
 	hchunks = i;
_

Patches currently in -mm which might be from donettom@linux.ibm.com are

mm-selftests-fix-incorrect-pointer-being-passed-to-mark_range.patch
selftests-mm-add-support-to-test-4pb-va-on-ppc64.patch
selftest-mm-fix-ksm_funtional_test-failures.patch
mm-selftests-fix-split_huge_page_test-failure-on-systems-with-64kb-page-size.patch

