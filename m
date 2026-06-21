Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF3E736AB72
	for <mm-commits@vger.kernel.org>; Sun, 21 Jun 2026 18:39:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782067162; cv=none; b=PTEON34euvCJOsveLUl48efzItJc5tY73WtOrvgMIlpGhGuEJKjb2plCHxG0vpSYoIj52PoXMWbFGOGVJwQqnk/1NTwW+6SKb/B5Q1qk+IDL88S0Xde3AqlqgdadJhkUPLN5N3aOVtdDZ16vmBppGM/+TC1V+PbrvJCQcISy8MY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782067162; c=relaxed/simple;
	bh=vjw7Hd+4IVDLlpaw5MSEjYc9pXTvXNNutYqli3DuID8=;
	h=Date:To:From:Subject:Message-Id; b=c1oj+G5QHwm1/JVm6nxdrlI/sQofp3xDLmTLOzTzX3EZd2jCdlbiwxvAFP7Y+lE4c5bgbPTXgrnqRgGdrQWVoWMvkMPCh8gKHlkKVqky47jvSFOWgRTXrmg3ug/CW+dHwPtD4yE2LZXd7VBAKzsamAwOddZDiRYPljt5zG4hkDE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=A/reJqR/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="A/reJqR/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A8E21F000E9;
	Sun, 21 Jun 2026 18:39:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782067161;
	bh=eWycLIKjlE7q/5SU5cP9Qt2SR/zsVuq+ylVozdjTX1s=;
	h=Date:To:From:Subject;
	b=A/reJqR/tF7iDGEXX3HaqPazf2asCAkWAEPpM65qntWslhf3LmcO7ViLtmujoojWT
	 KkJdIqhvqKX33nfT0UxbOt4KqWMPI9A/5merTXSwwCqrGn2CVrVVq88WSrYodyWmP3
	 q4dpWrZX0is7EchIYKFO076J+vSYCYd+PfJYujMI=
Date: Sun, 21 Jun 2026 11:39:21 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,surenb@google.com,shuah@kernel.org,sarthak.sharma@arm.com,ryan.roberts@arm.com,peterx@redhat.com,npache@redhat.com,mhocko@suse.com,luizcap@redhat.com,ljs@kernel.org,li.wang@linux.dev,liam@infradead.org,leon@kernel.org,lance.yang@linux.dev,jhubbard@nvidia.com,jgg@ziepe.ca,donettom@linux.ibm.com,dev.jain@arm.com,david@kernel.org,broonie@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-gup_test-add-setup-of-hugetlb-pages.patch removed from -mm tree
Message-Id: <20260621183921.8A8E21F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: gup_test: add setup of HugeTLB pages
has been removed from the -mm tree.  Its filename was
     selftests-mm-gup_test-add-setup-of-hugetlb-pages.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: selftests/mm: gup_test: add setup of HugeTLB pages
Date: Mon, 11 May 2026 19:28:18 +0300

gup_test fails to run HugeTLB tests if there are no free huge pages
prepared by a wrapper script.

Add setup of HugeTLB pages to the test and make sure that the original
settings are restored on the test exit.

Link: https://lore.kernel.org/20260511162840.375890-35-rppt@kernel.org
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Tested-by: Luiz Capitulino <luizcap@redhat.com>
Tested-by: Sarthak Sharma <sarthak.sharma@arm.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Donet Tom <donettom@linux.ibm.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Leon Romanovsky <leon@kernel.org>
Cc: Liam Howlett <liam@infradead.org>
Cc: Li Wang <li.wang@linux.dev>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Mark Brown <broonie@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Nico Pache <npache@redhat.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/gup_test.c |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

--- a/tools/testing/selftests/mm/gup_test.c~selftests-mm-gup_test-add-setup-of-hugetlb-pages
+++ a/tools/testing/selftests/mm/gup_test.c
@@ -14,6 +14,7 @@
 #include <mm/gup_test.h>
 #include "kselftest.h"
 #include "vm_util.h"
+#include "hugepage_settings.h"
 
 #define MB (1UL << 20)
 
@@ -94,6 +95,7 @@ int main(int argc, char **argv)
 	int filed, i, opt, nr_pages = 1, thp = -1, write = 1, nthreads = 1, ret;
 	int flags = MAP_PRIVATE;
 	char *file = "/dev/zero";
+	bool hugetlb = false;
 	pthread_t *tid;
 	char *p;
 
@@ -168,6 +170,7 @@ int main(int argc, char **argv)
 			break;
 		case 'H':
 			flags |= (MAP_HUGETLB | MAP_ANONYMOUS);
+			hugetlb = true;
 			break;
 		default:
 			ksft_exit_fail_msg("Wrong argument\n");
@@ -199,6 +202,18 @@ int main(int argc, char **argv)
 	}
 
 	ksft_print_header();
+
+	if (hugetlb) {
+		unsigned long hp_size = default_huge_page_size();
+
+		if (!hp_size)
+			ksft_exit_skip("HugeTLB is unavailable\n");
+
+		size = (size + hp_size - 1) & ~(hp_size - 1);
+		if (!hugetlb_setup_default(size / hp_size))
+			ksft_exit_skip("Not enough huge pages\n");
+	}
+
 	ksft_set_plan(nthreads);
 
 	filed = open(file, O_RDWR|O_CREAT, 0664);
_

Patches currently in -mm which might be from rppt@kernel.org are


