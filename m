Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEB9D23D7FF
	for <mm-commits@vger.kernel.org>; Fri, 31 Jul 2026 02:42:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785465749; cv=none; b=G2qmUQ0pMy1popSGaIcIWD0+qyMaT6A3uHwNVhdi2DdV1brJZswnzg5+M/BJLUUNwZIvvNMnpFBaky7FsNDLH2GHcd2eExZwSQxteK677PIsOK9AvXBT3gBPeIoGvukYZJHv46l+2xIThL2UKV2edLDc+T3Ikn/bo4LSdzu546U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785465749; c=relaxed/simple;
	bh=q4nT4/dAvSWJN4TnkIZFMtaiJYPzqzrymgOhgpCGmP0=;
	h=Date:To:From:Subject:Message-Id; b=poZxw3cr4nTwS9NVDSe//rxpfHP7yJIdEsNTvwpM2/tCajaX2Z8Kbr3/2fU4RQzXSTsin8r78liSCpez+UyZQbxAxHfdqIJ1/Fr/aboscBAAeaXWrRNK8ZK/amy7pPjMscL2ftKF5Qw3eZ5cwhe1ahIz79OYOGYxz+QGh0+BFFA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Fw9p/rWx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Fw9p/rWx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5461B1F000E9;
	Fri, 31 Jul 2026 02:42:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785465747;
	bh=DGRtg8ZHha8PkgE3hyeAhZSE5t83xgcEPu2ML3yyh/8=;
	h=Date:To:From:Subject;
	b=Fw9p/rWxsh1P+yCOsu096dt45T/JV7hE1Q1tLLQTIkZqEO8L+3JIeb8NoBCWkliqV
	 JG3xuKG/J8FH8Dm8YB2B/HFE4wPrF5WtYmG4ueh9e47ja39DbJGSlh+j8BtZkgjpRU
	 5sPrBsnb2OHClfEXfVWtFvQyrnnWACwhfAwLWzCQ=
Date: Thu, 30 Jul 2026 19:42:26 -0700
To: mm-commits@vger.kernel.org,zwisler@google.com,yury.khrustalev@arm.com,vbabka@kernel.org,usama.anjum@collabora.com,surenb@google.com,shuah@kernel.org,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,kevin.brodsky@arm.com,keith.lucas@oracle.com,joey.gouly@arm.com,jhubbard@nvidia.com,david@kernel.org,lihongfu@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-add-missing-pthread_create-return-checks-in-pkey-tests.patch removed from -mm tree
Message-Id: <20260731024227.5461B1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: add missing pthread_create() return checks in pkey tests
has been removed from the -mm tree.  Its filename was
     selftests-mm-add-missing-pthread_create-return-checks-in-pkey-tests.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Hongfu Li <lihongfu@kylinos.cn>
Subject: selftests/mm: add missing pthread_create() return checks in pkey tests
Date: Mon, 6 Jul 2026 16:15:59 +0800

Add missing pthread_create() return checks in pkey sighandler tests to
avoid hanging in pthread_cond_wait() when thread creation fails.

Link: https://lore.kernel.org/20260706081600.3570203-6-lihongfu@kylinos.cn
Signed-off-by: Hongfu Li <lihongfu@kylinos.cn>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Acked-by: Liam R. Howlett (Oracle) <liam@infradead.org>
Reviewed-by: Kevin Brodsky <kevin.brodsky@arm.com>
Tested-by: Kevin Brodsky <kevin.brodsky@arm.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Joey Gouly <joey.gouly@arm.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Keith Lucas <keith.lucas@oracle.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Muhammad Usama Anjum <usama.anjum@collabora.com>
Cc: Ross Zwisler <zwisler@google.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Yury Khrustalev <yury.khrustalev@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/pkey_sighandler_tests.c |   12 +++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

--- a/tools/testing/selftests/mm/pkey_sighandler_tests.c~selftests-mm-add-missing-pthread_create-return-checks-in-pkey-tests
+++ a/tools/testing/selftests/mm/pkey_sighandler_tests.c
@@ -220,7 +220,11 @@ static void test_sigsegv_handler_with_pk
 	pthread_attr_init(&attr);
 	pthread_attr_setdetachstate(&attr, PTHREAD_CREATE_DETACHED);
 
-	pthread_create(&thr, &attr, thread_segv_with_pkey0_disabled, NULL);
+	ret = pthread_create(&thr, &attr, thread_segv_with_pkey0_disabled, NULL);
+	if (ret) {
+		errno = ret;
+		pkey_assert(0);
+	}
 
 	pthread_mutex_lock(&mutex);
 	while (siginfo.si_signo == 0)
@@ -259,7 +263,11 @@ static void test_sigsegv_handler_cannot_
 	pthread_attr_init(&attr);
 	pthread_attr_setdetachstate(&attr, PTHREAD_CREATE_DETACHED);
 
-	pthread_create(&thr, &attr, thread_segv_pkuerr_stack, NULL);
+	ret = pthread_create(&thr, &attr, thread_segv_pkuerr_stack, NULL);
+	if (ret) {
+		errno = ret;
+		pkey_assert(0);
+	}
 
 	pthread_mutex_lock(&mutex);
 	while (siginfo.si_signo == 0)
_

Patches currently in -mm which might be from lihongfu@kylinos.cn are

selftests-mm-fix-memleak-in-migration-benchmark.patch
selftests-mm-factor-out-hmm_buffer_alloc-to-consolidate-buffer-setup.patch
selftests-mm-fix-bug_on-checking-wrong-variable-in-mremap_dontunmap.patch
mm-swap-fix-swap_cluster_lock-config_swap-stub-signature-mismatch.patch

