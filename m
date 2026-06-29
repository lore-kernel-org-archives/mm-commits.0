Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8D9737B417;
	Mon, 29 Jun 2026 17:41:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782754908; cv=none; b=Cu4vhfta/ymUhAz79UgyuXoubJrWBGtCSByd2iARmyH07wjfrfvMQxh+65SA8AlKrHevluH1WZcJUolKejTxYRcgOn70wviYL/l5curxnJD/tD0J96+4iJUCVmfuoMR81h6lciO924GVfcofTTCmtVuFZE2hFMVu0DFZGpVyw38=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782754908; c=relaxed/simple;
	bh=umCHY0WzhRo9BnV9a4Rue5Pb9esGaLf2ekRSTfsrgUg=;
	h=Date:To:From:Subject:Message-Id; b=QMEliudPhOTBl+IwcjQDmko4zQ/rYvzy+YefZUrIHMz8+2wDy7pJXbkt94n7UFr6tGlaTAiZ3xISPEesEDT5TLIPaP9uPN2bPNl7hP1Cde/kS2ASvryJBpI0lt6Lok1AFjCi87Xf+zAFJzCnmHjQVbWPpZhM5rP4ZeFQfmwwCAo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=RDRWYMEA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="RDRWYMEA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 425081F00A3A;
	Mon, 29 Jun 2026 17:41:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782754904;
	bh=mon0FP5pD7CxKi+sn0r1+EpOnERjsocTWpwnXmAnPI8=;
	h=Date:To:From:Subject;
	b=RDRWYMEAV7bqH1etaXbD6Tc5oPw5YnEa2+0lhYBqjftznK1hhZ54kN0DrSiLOyxo8
	 HELTaBFsStKZeL8Lf2aY23+/FwRD/eCqW2BQjFNkCmYrkVdCUDqse3ljSeoYaFRem+
	 fMJVCSx+dIENi0a+s7wTUFK3i34l0App+BSbNgbo=
Date: Mon, 29 Jun 2026 10:41:43 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,sj@kernel.org,yuzenghui@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + samples-damon-mtier-fail-early-if-address-range-parameters-are-invalid.patch added to mm-hotfixes-unstable branch
Message-Id: <20260629174144.425081F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: samples/damon/mtier: fail early if address range parameters are invalid
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     samples-damon-mtier-fail-early-if-address-range-parameters-are-invalid.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/samples-damon-mtier-fail-early-if-address-range-parameters-are-invalid.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

samples-damon-mtier-fail-early-if-address-range-parameters-are-invalid.patch

