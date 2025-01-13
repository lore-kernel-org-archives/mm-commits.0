Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 245182AF09
	for <mm-commits@vger.kernel.org>; Mon, 13 Jan 2025 04:13:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736741614; cv=none; b=gSs/+V8P95Ex372QWRP5kJS843ggqOSwQgj1qlnfCRfMsF41DJghePl4UrDH82FQemVyaJRoF/w+tuNfcUdYG4I3IoQs+dQJsmmf+T8H/lT8ea6x+Nb+FeNlC/7pYlvHlEo9L+lmzpBFZREmBbGXBUYP/8yBH4CueWTLDiqabXk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736741614; c=relaxed/simple;
	bh=OBE+VMX6dFfC2jf1XIi+x+dLe+ftL22D8E/+RUZ4+KE=;
	h=Date:To:From:Subject:Message-Id; b=Y6RjN1nx+afEbDla7VxpuhM9TblJellsuKm50o3WY2vc0COZlgMt+MW24KKErFuNOBmDsUXUXRMMdhTYRTiD2M4QLyv3cvSYyxmefqR+yyMxOw0j1ZnZwC2MQG7HU6vGiMWTQjk7RwNR7wTL292N092sxtIXrI74FIhSYeVKUfM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=z97WGtIw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="z97WGtIw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C381C4CED6;
	Mon, 13 Jan 2025 04:13:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736741613;
	bh=OBE+VMX6dFfC2jf1XIi+x+dLe+ftL22D8E/+RUZ4+KE=;
	h=Date:To:From:Subject:From;
	b=z97WGtIwZK80RGlsUg2I/CPeua4KAcWzDrotHHcd+AIDGdmDWqMqS5W2fxH8pnLJD
	 Dz7TWYNmfNPclrjMb2NfuSCEQJiSERX251dGk6DRRvyz+16kDiQ0K6YiW9R4gOeaBq
	 zCofG6PINvBjZI9lgPQiUEU4KbPTcdp5tzWk/i2c=
Date: Sun, 12 Jan 2025 20:13:33 -0800
To: mm-commits@vger.kernel.org,tamird@gmail.com,lkp@intel.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] xarray-port-tests-to-kunit-fix.patch removed from -mm tree
Message-Id: <20250113041333.9C381C4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: xarray-port-tests-to-kunit-fix
has been removed from the -mm tree.  Its filename was
     xarray-port-tests-to-kunit-fix.patch

This patch was dropped because it was folded into xarray-port-tests-to-kunit.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: xarray-port-tests-to-kunit-fix
Date: Mon Dec  9 07:06:54 PM PST 2024

Fix cocci warning:

lib/test_xarray.c:1019:52-53: WARNING comparing pointer to 0

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202412081700.YXB3vBbg-lkp@intel.com/
Cc: Tamir Duberstein <tamird@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_xarray.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/test_xarray.c~xarray-port-tests-to-kunit-fix
+++ a/lib/test_xarray.c
@@ -1016,7 +1016,7 @@ static noinline void check_xa_alloc_1(st
 
 	XA_BUG_ON(xa, xa_alloc(xa, &id, xa_mk_index(10), XA_LIMIT(10, 5),
 				GFP_KERNEL) != -EBUSY);
-	XA_BUG_ON(xa, xa_store_index(xa, 3, GFP_KERNEL) != 0);
+	XA_BUG_ON(xa, xa_store_index(xa, 3, GFP_KERNEL) != NULL);
 	XA_BUG_ON(xa, xa_alloc(xa, &id, xa_mk_index(10), XA_LIMIT(10, 5),
 				GFP_KERNEL) != -EBUSY);
 	xa_erase_index(test, xa, 3);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-swap_cgroup-allocate-swap_cgroup-map-using-vcalloc-fix.patch
mm-page_alloc-add-some-detailed-comments-in-can_steal_fallback-fix.patch
mm-introduce-mmap_lock_speculate_try_beginretry-fix.patch
mm-damon-tests-vaddr-kunith-reduce-stack-consumption.patch
mm-damon-tests-vaddr-kunith-reduce-stack-consumption-fix.patch
mm-fix-outdated-incorrect-code-comments-for-handle_mm_fault-fix.patch
mm-huge_memoryc-rename-shadowed-local.patch
mm-shmem-skip-swapcache-for-swapin-of-synchronous-swap-device-fix.patch
mm-hugetlb-rename-isolate_hugetlb-to-folio_isolate_hugetlb-fix.patch
documentation-filesystems-procrst-fix-possessive-form-of-process.patch
xarray-port-tests-to-kunit.patch
checkpatch-check-return-of-git_commit_info-fix.patch
fault-inject-use-prandom-where-cryptographically-secure-randomness-is-not-needed-fix.patch
hung_task-add-task-flags-blocked-by-coredump-to-log-fix.patch

