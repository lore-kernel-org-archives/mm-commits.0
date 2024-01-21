Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38452383B8;
	Sun, 21 Jan 2024 22:13:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705875218; cv=none; b=icF1TsdlunEJaKzds+hbcCKjneb7I1t/bTBI3vbJcTYCivHS4il5d+4mip+/q11sMLeWxcYPXJd96GFMkffyGJ1KASXNnlJPB69mh43lZPlHduATnxQAxzLCgUDqk5Ak2iiknZlvzpLg/sCXBXt6Jl3pp73i0Rd1HDqmexqfzYg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705875218; c=relaxed/simple;
	bh=PPD5jVGSQWh+IhDVPJgImKWTq2oOvO9L/Jc9kOb/B3o=;
	h=Date:To:From:Subject:Message-Id; b=t+SIowOOkl1CXRWXihMg9R8GuvBoS6axpNLIv+PAKbHjK3ySJXQ9nEwGw3jIwDCpXiuQy+Vr3WJ0woIcedYeb/7zNdx59nH/H02moiRW3rCyZ1JYn3HGFUD9KGs8s8oOeAZga49Noxyobl01WwYO4f7oiX247lWgH27Zhd98xZ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=mrH+lyD8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="mrH+lyD8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F26AC433C7;
	Sun, 21 Jan 2024 22:13:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1705875217;
	bh=PPD5jVGSQWh+IhDVPJgImKWTq2oOvO9L/Jc9kOb/B3o=;
	h=Date:To:From:Subject:From;
	b=mrH+lyD8MKzkh6sezYVuzFFsyeEJYXWdSiBu9Wt8+C/3NqthX6MsIcHGcoaq1UYbf
	 Rrr5AXajdBa2ClntMhacTagn4es+7RgwTgBDXg97hUFunBFdbuUoKSbscDAYHUQh+H
	 eL/gcdKgbf/IUOQ/Vy5RYrtCtD4LgZE0qT6LZv9M=
Date: Sun, 21 Jan 2024 14:13:34 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,shuah@kernel.org,mpe@ellerman.id.au,donettom@linux.vnet.ibm.com,christophe.leroy@c-s.fr,npache@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-fix-map_hugetlb-failure-on-64k-page-size-systems.patch added to mm-hotfixes-unstable branch
Message-Id: <20240121221337.1F26AC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests: mm: fix map_hugetlb failure on 64K page size systems
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     selftests-mm-fix-map_hugetlb-failure-on-64k-page-size-systems.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-fix-map_hugetlb-failure-on-64k-page-size-systems.patch

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
From: Nico Pache <npache@redhat.com>
Subject: selftests: mm: fix map_hugetlb failure on 64K page size systems
Date: Fri, 19 Jan 2024 06:14:29 -0700

On systems with 64k page size and 512M huge page sizes, the allocation and
test succeeds but errors out at the munmap.  As the comment states, munmap
will failure if its not HUGEPAGE aligned.  This is due to the length of
the mapping being 1/2 the size of the hugepage causing the munmap to not
be hugepage aligned.  Fix this by making the mapping length the full
hugepage if the hugepage is larger than the length of the mapping.

Link: https://lkml.kernel.org/r/20240119131429.172448-1-npache@redhat.com
Fixes: fa7b9a805c79 ("tools/selftest/vm: allow choosing mem size and page size in map_hugetlb")
Signed-off-by: Nico Pache <npache@redhat.com>
Cc: Donet Tom <donettom@linux.vnet.ibm.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Christophe Leroy <christophe.leroy@c-s.fr>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/map_hugetlb.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/tools/testing/selftests/mm/map_hugetlb.c~selftests-mm-fix-map_hugetlb-failure-on-64k-page-size-systems
+++ a/tools/testing/selftests/mm/map_hugetlb.c
@@ -15,6 +15,7 @@
 #include <unistd.h>
 #include <sys/mman.h>
 #include <fcntl.h>
+#include "vm_util.h"
 
 #define LENGTH (256UL*1024*1024)
 #define PROTECTION (PROT_READ | PROT_WRITE)
@@ -58,10 +59,16 @@ int main(int argc, char **argv)
 {
 	void *addr;
 	int ret;
+	size_t hugepage_size;
 	size_t length = LENGTH;
 	int flags = FLAGS;
 	int shift = 0;
 
+	hugepage_size = default_huge_page_size();
+	/* munmap with fail if the length is not page aligned */
+	if (hugepage_size > length)
+		length = hugepage_size;
+
 	if (argc > 1)
 		length = atol(argv[1]) << 20;
 	if (argc > 2) {
_

Patches currently in -mm which might be from npache@redhat.com are

selftests-mm-fix-map_hugetlb-failure-on-64k-page-size-systems.patch
selftests-mm-perform-some-system-cleanup-before-using-hugepages.patch

