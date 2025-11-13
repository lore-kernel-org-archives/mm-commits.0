Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C700B329E61;
	Thu, 13 Nov 2025 23:33:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763076805; cv=none; b=p3vCUwQlGLFAdWJzXZUaqIdNiLcMsbHvYhjzUIEZDDjOqrLFynfJYHzWsiWMjDNgk0yc/LFdIesBa6I3PL/J3XvterDdv52n629mKsf9K/46U1urYQusMgZT+ND6H6dMkJfHA5X7bUoc9VoeEYz13D0a3uruUhClmtyTbxiNmK8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763076805; c=relaxed/simple;
	bh=xVIezJELpedxiEREds/HsFfnOF1ieaw0tZnBuCExW74=;
	h=Date:To:From:Subject:Message-Id; b=cPZnNhKSO9ZDx8lC17nFWEybu29UGeAu7Lfqaiyg3vpKxWbXVLhcrbgnNZMvhVi52SJ/wjT7zDQgxw7gl9Q66ggi/Vw2jpcCLhRJgeCSiVk17tkj/njZR3SSX+9JFPEqauViK7ffuECp9rHIeWNOj3VALtybmXKXRAR+8IBYIFg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=pZkNd9Fy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="pZkNd9Fy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51071C19424;
	Thu, 13 Nov 2025 23:33:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763076805;
	bh=xVIezJELpedxiEREds/HsFfnOF1ieaw0tZnBuCExW74=;
	h=Date:To:From:Subject:From;
	b=pZkNd9Fy4acA82LWCrwx0Cg0LsI6s8WnbLtuU9tLJqmltpxCXG3fTR6R9+I5En9hO
	 +2x4SB/Hu2jZRJ5EZVxU47sSmx5/XN8aeJcHJDpHmYmwUGNtO0a8IrP2qrmU0Eh2TX
	 O9ZyOXFg4PRUYzEiLhByvzbslg3vJkJE103V2EuU=
Date: Thu, 13 Nov 2025 15:33:24 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,stable@vger.kernel.org,shuah@kernel.org,rppt@kernel.org,peterx@redhat.com,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,jackmanb@google.com,david@kernel.org,cmllamas@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-fix-division-by-zero-in-uffd-unit-tests.patch added to mm-hotfixes-unstable branch
Message-Id: <20251113233325.51071C19424@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: fix division-by-zero in uffd-unit-tests
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     selftests-mm-fix-division-by-zero-in-uffd-unit-tests.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-fix-division-by-zero-in-uffd-unit-tests.patch

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
From: Carlos Llamas <cmllamas@google.com>
Subject: selftests/mm: fix division-by-zero in uffd-unit-tests
Date: Thu, 13 Nov 2025 03:46:22 +0000

Commit 4dfd4bba8578 ("selftests/mm/uffd: refactor non-composite global
vars into struct") moved some of the operations previously implemented in
uffd_setup_environment() earlier in the main test loop.

The calculation of nr_pages, which involves a division by page_size, now
occurs before checking that default_huge_page_size() returns a non-zero
This leads to a division-by-zero error on systems with !CONFIG_HUGETLB.

Fix this by relocating the non-zero page_size check before the nr_pages
calculation, as it was originally implemented.

Link: https://lkml.kernel.org/r/20251113034623.3127012-1-cmllamas@google.com
Fixes: 4dfd4bba8578 ("selftests/mm/uffd: refactor non-composite global vars into struct")
Signed-off-by: Carlos Llamas <cmllamas@google.com>
Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/uffd-unit-tests.c |   15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

--- a/tools/testing/selftests/mm/uffd-unit-tests.c~selftests-mm-fix-division-by-zero-in-uffd-unit-tests
+++ a/tools/testing/selftests/mm/uffd-unit-tests.c
@@ -1758,10 +1758,15 @@ int main(int argc, char *argv[])
 			uffd_test_ops = mem_type->mem_ops;
 			uffd_test_case_ops = test->test_case_ops;
 
-			if (mem_type->mem_flag & (MEM_HUGETLB_PRIVATE | MEM_HUGETLB))
+			if (mem_type->mem_flag & (MEM_HUGETLB_PRIVATE | MEM_HUGETLB)) {
 				gopts.page_size = default_huge_page_size();
-			else
+				if (gopts.page_size == 0) {
+					uffd_test_skip("huge page size is 0, feature missing?");
+					continue;
+				}
+			} else {
 				gopts.page_size = psize();
+			}
 
 			/* Ensure we have at least 2 pages */
 			gopts.nr_pages = MAX(UFFD_TEST_MEM_SIZE, gopts.page_size * 2)
@@ -1776,12 +1781,6 @@ int main(int argc, char *argv[])
 				continue;
 
 			uffd_test_start("%s on %s", test->name, mem_type->name);
-			if ((mem_type->mem_flag == MEM_HUGETLB ||
-			    mem_type->mem_flag == MEM_HUGETLB_PRIVATE) &&
-			    (default_huge_page_size() == 0)) {
-				uffd_test_skip("huge page size is 0, feature missing?");
-				continue;
-			}
 			if (!uffd_feature_supported(test)) {
 				uffd_test_skip("feature missing");
 				continue;
_

Patches currently in -mm which might be from cmllamas@google.com are

selftests-mm-fix-division-by-zero-in-uffd-unit-tests.patch

