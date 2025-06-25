Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4747C1EA7EC
	for <mm-commits@vger.kernel.org>; Wed, 25 Jun 2025 22:56:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750892164; cv=none; b=SB9KoT7luAltgkgnrg5hO8C/SdHqh1nXzMYHakGua3Ca9QE+x8aCHdtgyWe3ixwqiXelWt/grXkQws2EYFvyCmP1eTyMePMEIdFEIwyRToZVUrBrKRwYJnDk+94GPd3QoBSwJuMxltjHruSg14VQie000N7gmIqcvWDpjOC/jlg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750892164; c=relaxed/simple;
	bh=3xLTnd9CH6ztYcz0UMPZqwZqsUifO1ETg/EtgM1I9tA=;
	h=Date:To:From:Subject:Message-Id; b=Dz9b9fJhZZ7HDcYkHxXKwFrFQWubjHzRXmE7rZUczqhjIbHvASF8cnC/s1QHrwxsTiBGGfrwFxTavPhoTcSaq5AgC4GS42MZ97zlAkSPRbpIko0XVJ/PsGZqzVhK0eYrfugBDI8pPUPR35Utr2dHrEIB/yvbZlEl6eO5ofcNlQI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qEF96idu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qEF96idu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DADDC4CEEA;
	Wed, 25 Jun 2025 22:56:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1750892164;
	bh=3xLTnd9CH6ztYcz0UMPZqwZqsUifO1ETg/EtgM1I9tA=;
	h=Date:To:From:Subject:From;
	b=qEF96iduQnzyZ5l9QLZRTV6WGFnSQTCV8Xx5zRgX8rbjcDOf42yVYzzQY7HspQvoo
	 GwEjVt/oHdOabKL5cYEwlMLKVCJfgWRtDjEPdkcT/XI2uNEFBcgfVQ/YUSTpy/e3tw
	 AyIQ6g74PIDEajtKpjWpo/blflyvg2RhnEakRohM=
Date: Wed, 25 Jun 2025 15:56:03 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,ryan.roberts@arm.com,lorenzo.stoakes@oracle.com,donettom@linux.ibm.com,david@redhat.com,anshuman.khandual@arm.com,dev.jain@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] selftests-mm-fix-validate_addr-helper.patch removed from -mm tree
Message-Id: <20250625225604.1DADDC4CEEA@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: fix validate_addr() helper
has been removed from the -mm tree.  Its filename was
     selftests-mm-fix-validate_addr-helper.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Dev Jain <dev.jain@arm.com>
Subject: selftests/mm: fix validate_addr() helper
Date: Fri, 20 Jun 2025 16:41:50 +0530

validate_addr() checks whether the address returned by mmap() lies in the
low or high VA space, according to whether a high addr hint was passed or
not.  The fix commit mentioned below changed the code in such a way that
this function will always return failure when passed high_addr == 1; addr
will be >= HIGH_ADDR_MARK always, we will fall down to "if (addr >
HIGH_ADDR_MARK)" and return failure.  Fix this.

Link: https://lkml.kernel.org/r/20250620111150.50344-1-dev.jain@arm.com
Fixes: d1d86ce28d0f ("selftests/mm: virtual_address_range: conform to TAP format output")
Signed-off-by: Dev Jain <dev.jain@arm.com>
Reviewed-by: Donet Tom <donettom@linux.ibm.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/virtual_address_range.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/tools/testing/selftests/mm/virtual_address_range.c~selftests-mm-fix-validate_addr-helper
+++ a/tools/testing/selftests/mm/virtual_address_range.c
@@ -77,8 +77,11 @@ static void validate_addr(char *ptr, int
 {
 	unsigned long addr = (unsigned long) ptr;
 
-	if (high_addr && addr < HIGH_ADDR_MARK)
-		ksft_exit_fail_msg("Bad address %lx\n", addr);
+	if (high_addr) {
+		if (addr < HIGH_ADDR_MARK)
+			ksft_exit_fail_msg("Bad address %lx\n", addr);
+		return;
+	}
 
 	if (addr > HIGH_ADDR_MARK)
 		ksft_exit_fail_msg("Bad address %lx\n", addr);
_

Patches currently in -mm which might be from dev.jain@arm.com are

xarray-add-a-bug_on-to-ensure-caller-is-not-sibling.patch
mm-call-pointers-to-ptes-as-ptep.patch
mm-optimize-mremap-by-pte-batching.patch
maple-tree-use-goto-label-to-simplify-code.patch

