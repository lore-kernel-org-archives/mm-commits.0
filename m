Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 465C57FBA1
	for <mm-commits@vger.kernel.org>; Fri, 28 Jun 2024 21:43:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719611013; cv=none; b=QUQ3I7pCY5JYU2Q0qsTD+yTc5ksniNnY5MEvkQtOAQM90ZXG4Irbd88bcVjp0YKTL+tI9OrIeDhIauiMZMuR6BqbOjs8ZQuk/MUBwnRh2agX7+PhDmyhCr7YF61R+z/nMBLpZ95U9De3RgzCIvUH+rHOYvbRLuniGF6PpjNchaQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719611013; c=relaxed/simple;
	bh=dUq3dl5exXU7IRPAjxK82ZoVNV+5BwPb7ej4BzmoBn8=;
	h=Date:To:From:Subject:Message-Id; b=qQD7LVe+0RIZ6MPOjwS0eq1YKvvFVeLlygtDL9mmnNYLYr/FwhWwigcD/SIZ9TEatSMpSqCkL+CH18nU80T3k6e9mQaGxwr3hW1oOUyU46fKo0eXyQW6uCEUg907mfxWJKgyEAAIEORifv6Ite3dtAFgPrg8ZbajiKheIheVNTw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=S0pTnHH6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="S0pTnHH6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 614A9C2BD10;
	Fri, 28 Jun 2024 21:43:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719611012;
	bh=dUq3dl5exXU7IRPAjxK82ZoVNV+5BwPb7ej4BzmoBn8=;
	h=Date:To:From:Subject:From;
	b=S0pTnHH6+K+aOJja1XJqGYQXu6Fq5M20hJ/WNTivoJdjUEK88PPu32N5pEkX7GhR0
	 ogFEw6k3Kc79Xq2nTibhjEnh/ORowPQVDGiJG5HkXuVxVaOajPRhay1sS7zJFJybKh
	 NQCTi1N8P7tPa+iBDvo9yOrNpDQaEl3Ypltg1cSk=
Date: Fri, 28 Jun 2024 14:43:31 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,rientjes@google.com,rdunlap@infradead.org,osalvador@suse.de,nao.horiguchi@gmail.com,muchun.song@linux.dev,linmiaohe@huawei.com,jane.chu@oracle.com,ioworker0@gmail.com,fvdl@google.com,corbet@lwn.net,jiaqiyan@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftest-mm-test-enable_soft_offline-behaviors-v7.patch added to mm-unstable branch
Message-Id: <20240628214332.614A9C2BD10@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftest-mm-test-enable_soft_offline-behaviors-v7
has been added to the -mm mm-unstable branch.  Its filename is
     selftest-mm-test-enable_soft_offline-behaviors-v7.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftest-mm-test-enable_soft_offline-behaviors-v7.patch

This patch will later appear in the mm-unstable branch at
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
From: Jiaqi Yan <jiaqiyan@google.com>
Subject: selftest-mm-test-enable_soft_offline-behaviors-v7
Date: Fri, 28 Jun 2024 20:59:57 +0000

Link: https://lkml.kernel.org/r/20240628205958.2845610-4-jiaqiyan@google.com
Signed-off-by: Jiaqi Yan <jiaqiyan@google.com>
Acked-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Frank van der Linden <fvdl@google.com>
Cc: Jane Chu <jane.chu@oracle.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Lance Yang <ioworker0@gmail.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/hugetlb-soft-offline.c |    2 +-
 tools/testing/selftests/mm/run_vmtests.sh         |    2 ++
 2 files changed, 3 insertions(+), 1 deletion(-)

--- a/tools/testing/selftests/mm/hugetlb-soft-offline.c~selftest-mm-test-enable_soft_offline-behaviors-v7
+++ a/tools/testing/selftests/mm/hugetlb-soft-offline.c
@@ -172,7 +172,7 @@ static void test_soft_offline_common(int
 	hugepagesize_kb = file_stat.f_bsize / 1024;
 	ksft_print_msg("Hugepagesize is %ldkB\n", hugepagesize_kb);
 
-	if (set_enable_soft_offline(enable_soft_offline)) {
+	if (set_enable_soft_offline(enable_soft_offline) != 0) {
 		close(fd);
 		ksft_exit_fail_msg("Failed to set enable_soft_offline\n");
 	}
--- a/tools/testing/selftests/mm/run_vmtests.sh~selftest-mm-test-enable_soft_offline-behaviors-v7
+++ a/tools/testing/selftests/mm/run_vmtests.sh
@@ -333,9 +333,11 @@ CATEGORY="hugetlb" run_test ./charge_res
 CATEGORY="hugetlb" run_test ./hugetlb_reparenting_test.sh -cgroup-v2
 if $RUN_DESTRUCTIVE; then
 nr_hugepages_tmp=$(cat /proc/sys/vm/nr_hugepages)
+enable_soft_offline=$(cat /proc/sys/vm/enable_soft_offline)
 echo 8 > /proc/sys/vm/nr_hugepages
 CATEGORY="hugetlb" run_test ./hugetlb-soft-offline
 echo "$nr_hugepages_tmp" > /proc/sys/vm/nr_hugepages
+echo "$enable_soft_offline" > /proc/sys/vm/enable_soft_offline
 CATEGORY="hugetlb" run_test ./hugetlb-read-hwpoison
 fi
 
_

Patches currently in -mm which might be from jiaqiyan@google.com are

mm-memory-failure-refactor-log-format-in-unpoison_memory.patch
mm-memory-failure-refactor-log-format-in-soft-offline-code.patch
mm-memory-failure-userspace-controls-soft-offlining-pages.patch
mm-memory-failure-userspace-controls-soft-offlining-pages-v7.patch
selftest-mm-test-enable_soft_offline-behaviors.patch
selftest-mm-test-enable_soft_offline-behaviors-v7.patch
docs-mm-add-enable_soft_offline-sysctl.patch

