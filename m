Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F9502C0F91;
	Thu,  2 Jul 2026 02:03:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782957829; cv=none; b=p0uuWnkWFtt8OZk1rBa6VsBcyqaFmxq2iPqUt2xiQ+woi8wuY7mcXVNN0CxwydbPS1sfihstg2CeS8O6O4CRSraLrcH6spAwKq/CNZ8KwfAWK9CQoZaFAmafKTGxbCS6l/49HYAb+YILEqWNJTojBWlkW40F7k1Fw7Enaoao9ZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782957829; c=relaxed/simple;
	bh=C+653xDK7uy+qIC6MlfyWsEPspxKyUOujjQ8DfQvVjQ=;
	h=Date:To:From:Subject:Message-Id; b=Vq1IsqR5Vcy+rLB9Ocwpsxy8m53594coQFb1TB0wQ6yFsIB0ywMVQYgCB7GiZoZrPkjNRTkLZ0D9YKKBs0BWBvd1gZq8zma6kgwV6moi34rRxUFKd3rdyTKjJS7a6cN+Gff17/9jjIStmDhf22CrWmOxNx7FJf65Zb/DWvUXUFs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=n2H6GLM2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="n2H6GLM2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC3F61F000E9;
	Thu,  2 Jul 2026 02:03:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782957827;
	bh=VZ1ljxfbwKzdzF2wQ2ZEj/ZZikrZb1Mhzqj0yOF1r+c=;
	h=Date:To:From:Subject;
	b=n2H6GLM2DepUKWkyg2uhDDMC5t/yFnmsZZ79Yr6JxxIgA0CsWES+D7gjafW/0iLc9
	 vxcJEMv+GBH8tBsOQCTgMp32Rto6O3RQSrl48eU4ZRJJhaTp1c+ByjE64SrGE/0tvW
	 8YidjasGHd6rWnvDcyPIjQNXL6UYcZ7Q6wW6mKeU=
Date: Wed, 01 Jul 2026 19:03:47 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,sj@kernel.org,yuzenghui@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] samples-damon-mtier-fail-early-if-address-range-parameters-are-invalid.patch removed from -mm tree
Message-Id: <20260702020347.AC3F61F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: samples/damon/mtier: fail early if address range parameters are invalid
has been removed from the -mm tree.  Its filename was
     samples-damon-mtier-fail-early-if-address-range-parameters-are-invalid.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Zenghui Yu <yuzenghui@huawei.com>
Subject: samples/damon/mtier: fail early if address range parameters are invalid
Date: Mon, 29 Jun 2026 07:44:31 -0700

The comment on top of `struct damon_region` clearly says that

    For any use case, @ar should be non-zero positive size.

which is now verified in damon_verify_new_region() if the kernel is built
with DAMON_DEBUG_SANITY.

The WARN_ONCE() can be triggered if the mtier sample module is enabled
before node{0,1}_{start,end}_addr have been properly initialized, which is
obviously not good.

 ------------[ cut here ]------------
 start 0 >= end 0
 WARNING: mm/damon/core.c:217 at damon_new_region+0xf4/0x118, CPU#59: bash/341468
 Call trace:
  damon_new_region+0xf4/0x118 (P)
  damon_set_regions+0xfc/0x3c0
  damon_sample_mtier_build_ctx+0xe8/0x3a8
  damon_sample_mtier_start+0x1c/0x90
  damon_sample_mtier_enable_store+0x98/0xb0
  param_attr_store+0xb4/0x128
  module_attr_store+0x2c/0x50
  sysfs_kf_write+0x58/0x90
  kernfs_fop_write_iter+0x16c/0x238
  vfs_write+0x2c0/0x370
  ksys_write+0x74/0x118
  __arm64_sys_write+0x24/0x38
  invoke_syscall+0xa8/0x118
  el0_svc_common.constprop.0+0x48/0xf0
  do_el0_svc+0x24/0x38
  el0_svc+0x54/0x370
  el0t_64_sync_handler+0xa0/0xe8
  el0t_64_sync+0x1ac/0x1b0
 ---[ end trace 0000000000000000 ]---

Note that the same issue can happen if detect_node_addresses is true, and
node 0 or 1 is memoryless.  Fix it together by checking the validity of
parameters right before damon_new_region() and fail early if they're
invalid.

Link: https://lore.kernel.org/20260629144432.133962-1-sj@kernel.org
Fixes: 82a08bde3cf7 ("samples/damon: implement a DAMON module for memory tiering")
Signed-off-by: Zenghui Yu <yuzenghui@huawei.com>
Signed-off-by: SJ Park <sj@kernel.org>
Reviewed-by: SJ Park <sj@kernel.org>
Cc: <stable@vger.kernel.org> # 6.16.x
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 samples/damon/mtier.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/samples/damon/mtier.c~samples-damon-mtier-fail-early-if-address-range-parameters-are-invalid
+++ a/samples/damon/mtier.c
@@ -120,6 +120,9 @@ static struct damon_ctx *damon_sample_mt
 		addr.end = promote ? node1_end_addr : node0_end_addr;
 	}
 
+	if (addr.start >= addr.end)
+		goto free_out;
+
 	range.start = addr.start;
 	range.end = addr.end;
 
_

Patches currently in -mm which might be from yuzenghui@huawei.com are


