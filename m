Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E95C13B58B
	for <mm-commits@vger.kernel.org>; Sun, 22 Jun 2025 22:22:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750630939; cv=none; b=RqiqwcNXWThhNsLXea6OmNeOPnL3P8oW4L/+MB+n8qB9YBBAtUyQOEOQgkdfElOUMdLN69fTgFagqwLq1d7RMo4Co6KODVjafSj8NiWo92VWJvullgnzgnHN6DUMY8yqrNa1Bt8tEKoNgYkT/hSrvftj20isXTSUr2jxy8Ln7HE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750630939; c=relaxed/simple;
	bh=4LcW0t1RFUy3ky/ZreYM2qAcnF9V/2hLUdahvtIPLD8=;
	h=Date:To:From:Subject:Message-Id; b=GsDMVPjC5zBXlhw/o45aDCU0ashHi74JuvjBXIUkQvN1Gkz5nVGtr0Ce+g5tLWZfkCpuWbxRc9NU9Tqnu+2csFpipVUEajGdKfBozZUsTTkDeJsWd0+RKxOLCg65uopRZakBsV68+Wp/a3Fj458j0lkUpb7r3s6jsLenYSNPNNM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1lmxgPPp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1lmxgPPp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAF16C4CEE3;
	Sun, 22 Jun 2025 22:22:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1750630938;
	bh=4LcW0t1RFUy3ky/ZreYM2qAcnF9V/2hLUdahvtIPLD8=;
	h=Date:To:From:Subject:From;
	b=1lmxgPPp+Z69az81ioF4L/7qzfJiuv5L202lY/9gIEQPcEFnxMQC6Q6YvH5/0lEq5
	 upWMJwD8tXiArL7JbCgAV2vovhzznm/boENzaNVc/nYgnaQzHPYQ915oUJNiEunHph
	 LtOAN1yRac6XbUIEMSZbu0txWzEVMH/hBWb1XzFA=
Date: Sun, 22 Jun 2025 15:22:18 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,ryan.roberts@arm.com,lorenzo.stoakes@oracle.com,donettom@linux.ibm.com,david@redhat.com,anshuman.khandual@arm.com,dev.jain@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-fix-validate_addr-helper.patch added to mm-hotfixes-unstable branch
Message-Id: <20250622222218.CAF16C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: fix validate_addr() helper
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     selftests-mm-fix-validate_addr-helper.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-fix-validate_addr-helper.patch

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
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: David Hildenbrand <david@redhat.com>
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

selftests-mm-fix-validate_addr-helper.patch
xarray-add-a-bug_on-to-ensure-caller-is-not-sibling.patch
mm-call-pointers-to-ptes-as-ptep.patch
mm-optimize-mremap-by-pte-batching.patch

