Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 638811755B
	for <mm-commits@vger.kernel.org>; Thu,  4 Jul 2024 23:47:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720136828; cv=none; b=Kut53nXsts22KKdkW0v4Aema/rfN9HhKC7ZxM9H2NhXOtmC0/a/lBBJ6be2p1m1g8ftMApYjnRM0hEiHuTRe4fYs5e7BH2AxsIU0w6HknCuL9+46s+FttKLfJj36gLj6wIuGN6+xtLxICEED1EdTt7aoFboPWTLS+lVeVKza2a8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720136828; c=relaxed/simple;
	bh=u6VjxvB/ZQRvUUdwFmp34zQBv/7AUZyzH5A8D+V57zg=;
	h=Date:To:From:Subject:Message-Id; b=VqkmFFJmbMjngMQTXovM10+Q8ou8PgpoiXezXVae2jIwLAkGdSagiFcsJ9M0DSCrubhlldqLSsGTA91nlEGXkEcWQeuY6o94FMSodfVynS1jOacA3W/MNyMGa1pTVv44XuK8T+YI+fnykMnbzymdqFGgXowqsqYWaothVM1VGM4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=S0Imud7/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="S0Imud7/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 244F4C3277B;
	Thu,  4 Jul 2024 23:47:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1720136828;
	bh=u6VjxvB/ZQRvUUdwFmp34zQBv/7AUZyzH5A8D+V57zg=;
	h=Date:To:From:Subject:From;
	b=S0Imud7/6ABiVmcBWBAUnQKmkvbbqmrS0F2ihuDYddCIDu66rsHJ+wDn7JW2WKen+
	 egaligalV/4S0QvgocfQbd6oP7xf4edABA4/aty3XzobxtW8jBnctfzxhE2IQ8qhKC
	 X7rFYyipGo+av+kJY/qn6eLVrbqPMaN4yH9KNf6M=
Date: Thu, 04 Jul 2024 16:47:07 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,rientjes@google.com,rdunlap@infradead.org,osalvador@suse.de,nao.horiguchi@gmail.com,muchun.song@linux.dev,linmiaohe@huawei.com,jane.chu@oracle.com,ioworker0@gmail.com,fvdl@google.com,corbet@lwn.net,jiaqiyan@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] selftest-mm-test-enable_soft_offline-behaviors-v7.patch removed from -mm tree
Message-Id: <20240704234708.244F4C3277B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftest-mm-test-enable_soft_offline-behaviors-v7
has been removed from the -mm tree.  Its filename was
     selftest-mm-test-enable_soft_offline-behaviors-v7.patch

This patch was dropped because it was folded into selftest-mm-test-enable_soft_offline-behaviors.patch

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

mm-memory-failure-refactor-log-format-in-soft-offline-code.patch
mm-memory-failure-userspace-controls-soft-offlining-pages.patch
selftest-mm-test-enable_soft_offline-behaviors.patch
docs-mm-add-enable_soft_offline-sysctl.patch
docs-mm-add-enable_soft_offline-sysctl-fix.patch
docs-mm-add-enable_soft_offline-sysctl-fix-fix.patch

