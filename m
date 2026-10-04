Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 492774A8A24
	for <mm-commits@vger.kernel.org>; Sun,  4 Oct 2026 20:59:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791147569; cv=none; b=NOeWYhnQSOaTZFdx8Fb7RwOEqYoXsB5iDb9yRKke1wGjJHZ2MQz9wJ2Lw8VA/q5HOE+Z4fRqdhg1JX3yHTUqNYQ2V+UkfwrK2d1Rw+iDdjd/9aA9JYN4G5aKq1j1LY4Y5lhElUuaJvouaw3wIeRV/Pa0CiA0r8ABZnsr/qoc/aA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791147569; c=relaxed/simple;
	bh=ysBxquxNEk2sHnwHAHUSDtXi/NsMTnu7DHUbeYRKVTk=;
	h=Date:To:From:Subject:Message-Id; b=qx8falNY71KSBnUzi5N5dC78pXMrcz1Otr1EBNsVy0Oeh399wYYeFW9K/MlXs7bzbWk0N+qBOMAkkY6+i9zUgur63x6IGdORa5ZXbV24AVpCwtmJv2JbwDjwWR814Z+A3e8asaH55i4FSHzuRT8xAO2+PmPSu6TeWS+crSFNQvQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=MZ17RUO9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="MZ17RUO9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B20841F000FF;
	Sun,  4 Oct 2026 20:59:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791147567;
	bh=23NpjaNFnDQMTErInEENjEogziD5Y+40anK/8FqgmXM=;
	h=Date:To:From:Subject;
	b=MZ17RUO9VsgS6EkUUFULVRGiI3+1sq09MJzBjkYuP2QD6syT4ZgJj5Ab0f/j9yEE1
	 sLj6GvLIguN7kksHrKOc7ZfPEIRclloOqlkEVAZ4UX5WXn9wP2WFWZjN2iRJMvqp1B
	 bVvbkn4p3arHw7mwQXAlbGPGe0JXf979UgvttqzU=
Date: Sun, 04 Oct 2026 13:59:27 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,shuah@kernel.org,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,david@kernel.org,jaeyeon.lee.dev@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-hugetlb-read-hwpoison-add-setup-of-hugetlb-pages.patch added to mm-new branch
Message-Id: <20261004205927.B20841F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: hugetlb-read-hwpoison: add setup of HugeTLB pages
has been added to the -mm mm-new branch.  Its filename is
     selftests-mm-hugetlb-read-hwpoison-add-setup-of-hugetlb-pages.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-hugetlb-read-hwpoison-add-setup-of-hugetlb-pages.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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
From: Jaeyeon Lee <jaeyeon.lee.dev@gmail.com>
Subject: selftests/mm: hugetlb-read-hwpoison: add setup of HugeTLB pages
Date: Sun,  4 Oct 2026 22:54:58 +0200

Every test is expected to reserve the HugeTLB pages it needs. 
hugetlb-read-hwpoison was not converted, so on a system without
pre-reserved huge pages the MAP_POPULATE mmap() fails with ENOMEM and
every test case is skipped.

Reserve the pages with hugetlb_setup_default().  Each chunk size runs two
HWPOISON tests and a poisoned huge page can't be reused, so reserve two
pages per chunk size.  The pool size is restored on exit.  The poisoned
pages remain allocated until reboot.

With the patch, all 12 cases pass on a system with no huge pages
reserved (tested on Fedora, x86_64, CONFIG_MEMORY_FAILURE=y).

Link: https://lore.kernel.org/20261004205458.119608-1-jaeyeon.lee.dev@gmail.com
Signed-off-by: Jaeyeon Lee <jaeyeon.lee.dev@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Assisted-by: LLM
Cc: David Hildenbrand <david@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
---

 tools/testing/selftests/mm/hugetlb-read-hwpoison.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/tools/testing/selftests/mm/hugetlb-read-hwpoison.c~selftests-mm-hugetlb-read-hwpoison-add-setup-of-hugetlb-pages
+++ a/tools/testing/selftests/mm/hugetlb-read-hwpoison.c
@@ -13,6 +13,7 @@
 #include <signal.h>
 
 #include "kselftest.h"
+#include "vm_util.h"
 
 #define MAX_WRITE_READ_CHUNK_SIZE (getpagesize() * 16)
 #define MAX(a, b) (((a) > (b)) ? (a) : (b))
@@ -281,6 +282,13 @@ int main(void)
 	size_t i;
 
 	ksft_print_header();
+
+	if (!hugetlb_available())
+		ksft_exit_skip("HugeTLB is not available\n");
+
+	if (!hugetlb_setup_default(ARRAY_SIZE(wr_chunk_sizes) * 2))
+		ksft_exit_skip("Not enough free huge pages\n");
+
 	ksft_set_plan(ARRAY_SIZE(wr_chunk_sizes) * 3);
 
 	signal(SIGBUS, sigbus_handler);
_

Patches currently in -mm which might be from jaeyeon.lee.dev@gmail.com are

mm-damon-tests-use-scoped_guard-for-damon_test_ops_registration.patch
selftests-mm-skip-khugepaged-file-tests-if-mkfsxfs-is-unavailable.patch
selftests-mm-hugetlb-read-hwpoison-add-setup-of-hugetlb-pages.patch

