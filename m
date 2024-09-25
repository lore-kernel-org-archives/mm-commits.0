Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F864360
	for <mm-commits@vger.kernel.org>; Wed, 25 Sep 2024 00:04:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727222692; cv=none; b=PkcwK5e+wb5fP+Tmyl88rZg5U9jmTRBioE5WRwVc3vlnifPYipdA3+/Or5hcnFeicf9MTxcF/T2zszX2xH9PmWhdDYEEY7AxsdtY+Kv2A6retVHpBWmJ/ON8rA0jXmOUoms7ZOTy/6z09Mv/djpTYfYpFCPcgieWbP9WON4FazE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727222692; c=relaxed/simple;
	bh=RSWnmRw6BPf0FxUQAvW9NFFk1w3+aFTTkgUzRY4FvkA=;
	h=Date:To:From:Subject:Message-Id; b=BHin9iDv+jg1RbdgcM3RMZrreEebXvzL48fgknzf3uH45raEy/SnOcalHw3VC2bI1CQAxD3I54hieBpkBhqKjy2pYjGOP3krFGrqMsnaJDk2xb1PmciFLD1kjCITe232wiWKM3f1kPs2KKlBYlS0CJYlK3wWoPkimD2+HQmq/dE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Z5mhMnOR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Z5mhMnOR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECF4CC4CEC4;
	Wed, 25 Sep 2024 00:04:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1727222692;
	bh=RSWnmRw6BPf0FxUQAvW9NFFk1w3+aFTTkgUzRY4FvkA=;
	h=Date:To:From:Subject:From;
	b=Z5mhMnORBYnU/eucf7nrf+MAkr4mHTvnNguiefoV8b/gF28F4m8rFgMRn2ZGCZ99g
	 aO1z2N5ATPZrbn8iMZBXP78ONMt402QhavsleYWJLzeBjMpv7WcoSgLu08C73BLR6Z
	 MacWOpOP54zXdIKBLyaqFpGCBSJoNT7mLrr7pY/g=
Date: Tue, 24 Sep 2024 17:04:51 -0700
To: mm-commits@vger.kernel.org,longman@redhat.com,dave.jiang@intel.com,apopple@nvidia.com,ying.huang@intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + memory-tiers-use-default_dram_perf_ref_source-in-log-message.patch added to mm-hotfixes-unstable branch
Message-Id: <20240925000451.ECF4CC4CEC4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: memory tiers: use default_dram_perf_ref_source in log message
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     memory-tiers-use-default_dram_perf_ref_source-in-log-message.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/memory-tiers-use-default_dram_perf_ref_source-in-log-message.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Huang Ying <ying.huang@intel.com>
Subject: memory tiers: use default_dram_perf_ref_source in log message
Date: Fri, 20 Sep 2024 09:47:40 +0800

Commit 3718c02dbd4c ("acpi, hmat: calculate abstract distance with HMAT")
added a default_dram_perf_ref_source variable that was initialized but
never used.  This causes kmemleak to report the following memory leak:

unreferenced object 0xff11000225a47b60 (size 16):
  comm "swapper/0", pid 1, jiffies 4294761654
  hex dump (first 16 bytes):
    41 43 50 49 20 48 4d 41 54 00 c1 4b 7d b7 75 7c  ACPI HMAT..K}.u|
  backtrace (crc e6d0e7b2):
    [<ffffffff95d5afdb>] __kmalloc_node_track_caller_noprof+0x36b/0x440
    [<ffffffff95c276d6>] kstrdup+0x36/0x60
    [<ffffffff95dfabfa>] mt_set_default_dram_perf+0x23a/0x2c0
    [<ffffffff9ad64733>] hmat_init+0x2b3/0x660
    [<ffffffff95203cec>] do_one_initcall+0x11c/0x5c0
    [<ffffffff9ac9cfc4>] do_initcalls+0x1b4/0x1f0
    [<ffffffff9ac9d52e>] kernel_init_freeable+0x4ae/0x520
    [<ffffffff97c789cc>] kernel_init+0x1c/0x150
    [<ffffffff952aecd1>] ret_from_fork+0x31/0x70
    [<ffffffff9520b18a>] ret_from_fork_asm+0x1a/0x30

This reminds us that we forget to use the performance data source
information.  So, use the variable in the error log message to help
identify the root cause of inconsistent performance number.

Link: https://lkml.kernel.org/r/87y13mvo0n.fsf@yhuang6-desk2.ccr.corp.intel.com
Fixes: 3718c02dbd4c ("acpi, hmat: calculate abstract distance with HMAT")
Signed-off-by: "Huang, Ying" <ying.huang@intel.com>
Reported-by: Waiman Long <longman@redhat.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-tiers.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/memory-tiers.c~memory-tiers-use-default_dram_perf_ref_source-in-log-message
+++ a/mm/memory-tiers.c
@@ -768,10 +768,10 @@ int mt_set_default_dram_perf(int nid, st
 		pr_info(
 "memory-tiers: the performance of DRAM node %d mismatches that of the reference\n"
 "DRAM node %d.\n", nid, default_dram_perf_ref_nid);
-		pr_info("  performance of reference DRAM node %d:\n",
-			default_dram_perf_ref_nid);
+		pr_info("  performance of reference DRAM node %d from %s:\n",
+			default_dram_perf_ref_nid, default_dram_perf_ref_source);
 		dump_hmem_attrs(&default_dram_perf, "    ");
-		pr_info("  performance of DRAM node %d:\n", nid);
+		pr_info("  performance of DRAM node %d from %s:\n", nid, source);
 		dump_hmem_attrs(perf, "    ");
 		pr_info(
 "  disable default DRAM node performance based abstract distance algorithm.\n");
_

Patches currently in -mm which might be from ying.huang@intel.com are

memory-tiers-use-default_dram_perf_ref_source-in-log-message.patch

