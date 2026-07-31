Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12BEB33556D
	for <mm-commits@vger.kernel.org>; Fri, 31 Jul 2026 02:42:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785465745; cv=none; b=UCDwzx2kMvR0GbhneHmWOHqB/2t/AcnlhS9lj4cPuEqPMNZieZHt7gfJXfIUTcsOmnmwNNqLv9oF0o2Xz5wBEbfDFhlnXVMyR7XFyYU5PcElR2upNdawFdNSLKOZSSsT4zQFdFX4DJ5e/WDXdEMcoaSRHoAh0uIqz55AamF61IM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785465745; c=relaxed/simple;
	bh=eOiHcqkugX90hZVgfr8wHoNBgV5RY8um13OV9cc8WvQ=;
	h=Date:To:From:Subject:Message-Id; b=Gvc1/HfZ/gUjHbU1dzaRW2WKdS0L+osgyAJXIyRERtBjGvQdKu9GlZQpuzhVJNpIvNhxfrhtWK2j3fZ8d6U03UPQ4Ap6yHhVOrYqLebCaqSmY4/itLItrg+dmQepo2sATzE4xuo04Q5sj3zBZF61ktgaracgaFXD0Ss8Ft+PXFs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=NXb31TVf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="NXb31TVf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E28441F00A3A;
	Fri, 31 Jul 2026 02:42:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785465744;
	bh=P6Dmp+BS3qd1E7L3ndjlXOi/+qH55WS/71Gohe3LjTw=;
	h=Date:To:From:Subject;
	b=NXb31TVfOnychz1wh6Fqo4g+XF1OKMh7VF9NmvoNTG2UfxZxMay9zmbcVwLB5tT6T
	 BYpxKtkcb9x8juCdcY8X5rs18MqIPCDOMqCJEjiB9J0wYns3IzNmXzv2XDuiQc8QB6
	 DhikVRG4OGctHYhNH1BNBkUOdVrlT7gRt+opadiA=
Date: Thu, 30 Jul 2026 19:42:23 -0700
To: mm-commits@vger.kernel.org,zwisler@google.com,yury.khrustalev@arm.com,vbabka@kernel.org,usama.anjum@collabora.com,surenb@google.com,shuah@kernel.org,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,kevin.brodsky@arm.com,keith.lucas@oracle.com,joey.gouly@arm.com,jhubbard@nvidia.com,david@kernel.org,lihongfu@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-use-pkey_assert-on-clone_raw-failure-in-pkey-test.patch removed from -mm tree
Message-Id: <20260731024223.E28441F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: use pkey_assert on clone_raw failure in pkey test
has been removed from the -mm tree.  Its filename was
     selftests-mm-use-pkey_assert-on-clone_raw-failure-in-pkey-test.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Hongfu Li <lihongfu@kylinos.cn>
Subject: selftests/mm: use pkey_assert on clone_raw failure in pkey test
Date: Mon, 6 Jul 2026 16:15:57 +0800

Use pkey_assert(0) instead of perror("clone") when clone_raw() fails.  The
old path only printed an error and continued; the test now exits via
pkey_assert() on failure so it does not hang or proceed with an invalid
child.

Link: https://lore.kernel.org/20260706081600.3570203-4-lihongfu@kylinos.cn
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

 tools/testing/selftests/mm/pkey_sighandler_tests.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/tools/testing/selftests/mm/pkey_sighandler_tests.c~selftests-mm-use-pkey_assert-on-clone_raw-failure-in-pkey-test
+++ a/tools/testing/selftests/mm/pkey_sighandler_tests.c
@@ -329,7 +329,7 @@ static void test_sigsegv_handler_with_di
 
 	if (ret < 0) {
 		errno = -ret;
-		perror("clone");
+		pkey_assert(0);
 	} else if (ret == 0) {
 		thread_segv_maperr_ptr(&sigstack);
 		syscall_raw(SYS_exit, 0, 0, 0, 0, 0, 0);
@@ -502,7 +502,7 @@ static void test_pkru_sigreturn(void)
 
 	if (ret < 0) {
 		errno = -ret;
-		perror("clone");
+		pkey_assert(0);
 	}  else if (ret == 0) {
 		thread_sigusr2_self(&sigstack);
 		syscall_raw(SYS_exit, 0, 0, 0, 0, 0, 0);
_

Patches currently in -mm which might be from lihongfu@kylinos.cn are

selftests-mm-fix-memleak-in-migration-benchmark.patch
selftests-mm-factor-out-hmm_buffer_alloc-to-consolidate-buffer-setup.patch
selftests-mm-fix-bug_on-checking-wrong-variable-in-mremap_dontunmap.patch
mm-swap-fix-swap_cluster_lock-config_swap-stub-signature-mismatch.patch

