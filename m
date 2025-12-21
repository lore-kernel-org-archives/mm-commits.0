Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93348309DB5
	for <mm-commits@vger.kernel.org>; Sun, 21 Dec 2025 18:57:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766343467; cv=none; b=b9fa/r/Qc4lygq9XV7jIpkfT4unlXEVFJaq+pI3UltYtHAz1ge/MsVHtBpCiJ95pXKhjGAgnbIbK0gTQSOSR6a3BVfT86mYeKvSugelVVHDBKXhXu4oG6+Ah+gkC+74bm94BM6aREFUsJScyFCvBmLcbVVdGybUyuPY4MBNIqLA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766343467; c=relaxed/simple;
	bh=nJ//5PBd0lmScMRiKfBtgjsEFh4dqFr50j7M9fs7bqo=;
	h=Date:To:From:Subject:Message-Id; b=Q6hAQpZA93H+05d8JeXrqSHmyqik9eWJl+7K1BseKNwJTtVJdHJryAXj1JrHdLh45Hb+KyD5ioZPhifNUaX31cRqDTAPkXHxEFl8x1GjEQ74ptx/XgL6NRqJMjRH5kaLy8Fzh3ziqiZGzwJeWQOZ1wzyMvZ4ivaLusYvdPqBKtY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=DLfF9ELg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DLfF9ELg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03066C4CEFB;
	Sun, 21 Dec 2025 18:57:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1766343467;
	bh=nJ//5PBd0lmScMRiKfBtgjsEFh4dqFr50j7M9fs7bqo=;
	h=Date:To:From:Subject:From;
	b=DLfF9ELgN9soQzH79vtdUJP+K0xgOICYL0fS48Rcs9cZad+BeP4VrXrPEiKxoCEew
	 +UFsdFo7hlf7HLF0fa6me3FCW8sxuYDIO6t7D26pnrerVvsXJ5pw1ckVf1bLV8wl+J
	 CKWur6yXCEbCXiZNAgAU1GfVXq580lawRKxIz0lg=
Date: Sun, 21 Dec 2025 10:57:46 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,shuah@kernel.org,rppt@kernel.org,mhocko@suse.com,luizcap@redhat.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,david@kernel.org,chuhu@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-allocate-6-hugepages-in-va_high_addr_switchsh.patch added to mm-new branch
Message-Id: <20251221185747.03066C4CEFB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: allocate 6 hugepages in va_high_addr_switch.sh
has been added to the -mm mm-new branch.  Its filename is
     selftests-mm-allocate-6-hugepages-in-va_high_addr_switchsh.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-allocate-6-hugepages-in-va_high_addr_switchsh.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

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
From: Chunyu Hu <chuhu@redhat.com>
Subject: selftests/mm: allocate 6 hugepages in va_high_addr_switch.sh
Date: Sun, 21 Dec 2025 12:00:22 +0800

The va_high_addr_switch test requires 6 hugepages, not 5. If running the
test directly by: ./va_high_addr_switch.sh, the test will hit a mmap 'FAIL'
caused by not enough hugepages:

  mmap(addr_switch_hint - hugepagesize, 2*hugepagesize, MAP_HUGETLB): 0x7f330f800000 - OK
  mmap(addr_switch_hint , 2*hugepagesize, MAP_FIXED | MAP_HUGETLB): 0xffffffffffffffff - FAILED

The failure can't be hit if run the tests by running 'run_vmtests.sh -t
hugevm' because the nr_hugepages is set to 128 at the beginning of
run_vmtests.sh and va_high_addr_switch.sh skip the setup of nr_hugepages
because already enough.

Link: https://lkml.kernel.org/r/20251221040025.3159990-2-chuhu@redhat.com
Signed-off-by: Chunyu Hu <chuhu@redhat.com>
Fixes: d9d957bd7b61 ("selftests/mm: alloc hugepages in va_high_addr_switch test")
Cc: Luiz Capitulino <luizcap@redhat.com>
Cc: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/va_high_addr_switch.sh |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/tools/testing/selftests/mm/va_high_addr_switch.sh~selftests-mm-allocate-6-hugepages-in-va_high_addr_switchsh
+++ a/tools/testing/selftests/mm/va_high_addr_switch.sh
@@ -111,8 +111,8 @@ setup_nr_hugepages()
 
 check_test_requirements
 save_nr_hugepages
-# 4 keep_mapped pages, and one for tmp usage
-setup_nr_hugepages 5
+# The HugeTLB tests require 6 pages
+setup_nr_hugepages 6
 ./va_high_addr_switch --run-hugetlb
 retcode=$?
 restore_nr_hugepages
_

Patches currently in -mm which might be from chuhu@redhat.com are

selftests-mm-fix-va_high_addr_switchsh-return-value.patch
selftests-mm-allocate-6-hugepages-in-va_high_addr_switchsh.patch
selftests-mm-remove-arm64-nr_hugepages-setup-for-va_high_addr_switch-test.patch
selftests-mm-va_high_addr_switch-return-fail-when-either-test-failed.patch
selftests-mm-fix-comment-for-check_test_requirements.patch

