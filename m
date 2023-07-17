Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD8EDEB64DC
	for <mm-commits@archiver.kernel.org>; Mon, 17 Jul 2023 18:23:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229566AbjGQSXP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 17 Jul 2023 14:23:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231684AbjGQSWi (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 17 Jul 2023 14:22:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3563CAF
        for <mm-commits@vger.kernel.org>; Mon, 17 Jul 2023 11:22:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 35AC7611E7
        for <mm-commits@vger.kernel.org>; Mon, 17 Jul 2023 18:22:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AEBCC433C7;
        Mon, 17 Jul 2023 18:21:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1689618119;
        bh=IKyHIygOXd4q+R/VUrzbNnHIoi9o4HNLYXvf/OjJdow=;
        h=Date:To:From:Subject:From;
        b=mj0megv0YgWJrACzwmkh5jOA23jX3kg7kVYEjUO9I9Romlz+cpNDDHt+VOuUWJYYx
         fcOk9YBqPqClJoKR82ZAr1ZJPN5fvIV6ud664pNAAFQuZ8dl3MOJVd4TR70sfExLWo
         YzVDR8KWz71rcIG32Gx218diR/3pmgc7R9dSiuYE=
Date:   Mon, 17 Jul 2023 11:21:58 -0700
To:     mm-commits@vger.kernel.org, yu.ma@intel.com,
        viro@zeniv.linux.org.uk, tim.c.chen@linux.intel.com,
        brauner@kernel.org, lipeng.zhu@intel.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + fs-address_space-add-alignment-padding-for-i_map-and-i_mmap_rwsem-to-mitigate-a-false-sharing.patch added to mm-unstable branch
Message-Id: <20230717182159.8AEBCC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fs/address_space: add alignment padding for i_map and i_mmap_rwsem to mitigate a false sharing.
has been added to the -mm mm-unstable branch.  Its filename is
     fs-address_space-add-alignment-padding-for-i_map-and-i_mmap_rwsem-to-mitigate-a-false-sharing.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fs-address_space-add-alignment-padding-for-i_map-and-i_mmap_rwsem-to-mitigate-a-false-sharing.patch

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
From: "Zhu, Lipeng" <lipeng.zhu@intel.com>
Subject: fs/address_space: add alignment padding for i_map and i_mmap_rwsem to mitigate a false sharing.
Date: Sun, 16 Jul 2023 22:56:54 +0800

When running UnixBench/Shell Scripts, we observed high false sharing for
accessing i_mmap against i_mmap_rwsem.

UnixBench/Shell Scripts are typical load/execute command test scenarios,
which concurrently launch->execute->exit a lot of shell commands.  A lot
of processes invoke vma_interval_tree_remove which touch "i_mmap", the
call stack:

----vma_interval_tree_remove
    |----unlink_file_vma
    |    free_pgtables
    |    |----exit_mmap
    |    |    mmput
    |    |    |----begin_new_exec
    |    |    |    load_elf_binary
    |    |    |    bprm_execve

Meanwhile, there are a lot of processes touch 'i_mmap_rwsem' to acquire
the semaphore in order to access 'i_mmap'.  In existing 'address_space'
layout, 'i_mmap' and 'i_mmap_rwsem' are in the same cacheline.

The patch places the i_mmap and i_mmap_rwsem in separate cache lines to
avoid this false sharing problem.

With this patch, based on kernel v6.4.0, on Intel Sapphire Rapids
112C/224T platform, the score improves by ~5.3%.  And perf c2c tool shows
the false sharing is resolved as expected, the symbol
vma_interval_tree_remove disappeared in cache line 0 after this change.

Baseline:
=================================================
      Shared Cache Line Distribution Pareto
=================================================
-------------------------------------------------------------
    0    3729     5791        0        0  0xff19b3818445c740
-------------------------------------------------------------
   3.27%    3.02%    0.00%    0.00%   0x18     0       1  0xffffffffa194403b       604       483       389      692       203  [k] vma_interval_tree_insert    [kernel.kallsyms]  vma_interval_tree_insert+75      0  1
   4.13%    3.63%    0.00%    0.00%   0x20     0       1  0xffffffffa19440a2       553       413       415      962       215  [k] vma_interval_tree_remove    [kernel.kallsyms]  vma_interval_tree_remove+18      0  1
   2.04%    1.35%    0.00%    0.00%   0x28     0       1  0xffffffffa219a1d6      1210       855       460     1229       222  [k] rwsem_down_write_slowpath   [kernel.kallsyms]  rwsem_down_write_slowpath+678    0  1
   0.62%    1.85%    0.00%    0.00%   0x28     0       1  0xffffffffa219a1bf       762       329       577      527       198  [k] rwsem_down_write_slowpath   [kernel.kallsyms]  rwsem_down_write_slowpath+655    0  1
   0.48%    0.31%    0.00%    0.00%   0x28     0       1  0xffffffffa219a58c      1677      1476       733     1544       224  [k] down_write                  [kernel.kallsyms]  down_write+28                    0  1
   0.05%    0.07%    0.00%    0.00%   0x28     0       1  0xffffffffa219a21d      1040       819       689       33        27  [k] rwsem_down_write_slowpath   [kernel.kallsyms]  rwsem_down_write_slowpath+749    0  1
   0.00%    0.05%    0.00%    0.00%   0x28     0       1  0xffffffffa17707db         0      1005       786     1373       223  [k] up_write                    [kernel.kallsyms]  up_write+27                      0  1
   0.00%    0.02%    0.00%    0.00%   0x28     0       1  0xffffffffa219a064         0       233       778       32        30  [k] rwsem_down_write_slowpath   [kernel.kallsyms]  rwsem_down_write_slowpath+308    0  1
  33.82%   34.10%    0.00%    0.00%   0x30     0       1  0xffffffffa1770945       779       495       534     6011       224  [k] rwsem_spin_on_owner         [kernel.kallsyms]  rwsem_spin_on_owner+53           0  1
  17.06%   15.28%    0.00%    0.00%   0x30     0       1  0xffffffffa1770915       593       438       468     2715       224  [k] rwsem_spin_on_owner         [kernel.kallsyms]  rwsem_spin_on_owner+5            0  1
   3.54%    3.52%    0.00%    0.00%   0x30     0       1  0xffffffffa2199f84       881       601       583     1421       223  [k] rwsem_down_write_slowpath   [kernel.kallsyms]  rwsem_down_write_slowpath+84     0  1

With this change:
-------------------------------------------------------------
   0      556      838        0        0  0xff2780d7965d2780
-------------------------------------------------------------
    0.18%    0.60%    0.00%    0.00%    0x8     0       1  0xffffffffafff27b8       503       453       569       14        13  [k] do_dentry_open              [kernel.kallsyms]  do_dentry_open+456               0  1
    0.54%    0.12%    0.00%    0.00%    0x8     0       1  0xffffffffaffc51ac       510       199       428       15        12  [k] hugepage_vma_check          [kernel.kallsyms]  hugepage_vma_check+252           0  1
    1.80%    2.15%    0.00%    0.00%   0x18     0       1  0xffffffffb079a1d6      1778       799       343      215       136  [k] rwsem_down_write_slowpath   [kernel.kallsyms]  rwsem_down_write_slowpath+678    0  1
    0.54%    1.31%    0.00%    0.00%   0x18     0       1  0xffffffffb079a1bf       547       296       528       91        71  [k] rwsem_down_write_slowpath   [kernel.kallsyms]  rwsem_down_write_slowpath+655    0  1
    0.72%    0.72%    0.00%    0.00%   0x18     0       1  0xffffffffb079a58c      1479      1534       676      288       163  [k] down_write                  [kernel.kallsyms]  down_write+28                    0  1
    0.00%    0.12%    0.00%    0.00%   0x18     0       1  0xffffffffafd707db         0      2381       744      282       158  [k] up_write                    [kernel.kallsyms]  up_write+27                      0  1
    0.00%    0.12%    0.00%    0.00%   0x18     0       1  0xffffffffb079a064         0       239       518        6         6  [k] rwsem_down_write_slowpath   [kernel.kallsyms]  rwsem_down_write_slowpath+308    0  1
   46.58%   47.02%    0.00%    0.00%   0x20     0       1  0xffffffffafd70945       704       403       499     1137       219  [k] rwsem_spin_on_owner         [kernel.kallsyms]  rwsem_spin_on_owner+53           0  1
   23.92%   25.78%    0.00%    0.00%   0x20     0       1  0xffffffffafd70915       558       413       500      542       185  [k] rwsem_spin_on_owner         [kernel.kallsyms]  rwsem_spin_on_owner+5            0  1

v1->v2: change padding to exchange fields.

Link: https://lkml.kernel.org/r/20230716145653.20122-1-lipeng.zhu@intel.com
Signed-off-by: Lipeng Zhu <lipeng.zhu@intel.com>
Reviewed-by: Tim Chen <tim.c.chen@linux.intel.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Yu Ma <yu.ma@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/fs.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/fs.h~fs-address_space-add-alignment-padding-for-i_map-and-i_mmap_rwsem-to-mitigate-a-false-sharing
+++ a/include/linux/fs.h
@@ -447,11 +447,11 @@ struct address_space {
 	atomic_t		nr_thps;
 #endif
 	struct rb_root_cached	i_mmap;
-	struct rw_semaphore	i_mmap_rwsem;
 	unsigned long		nrpages;
 	pgoff_t			writeback_index;
 	const struct address_space_operations *a_ops;
 	unsigned long		flags;
+	struct rw_semaphore	i_mmap_rwsem;
 	errseq_t		wb_err;
 	spinlock_t		private_lock;
 	struct list_head	private_list;
_

Patches currently in -mm which might be from lipeng.zhu@intel.com are

fs-address_space-add-alignment-padding-for-i_map-and-i_mmap_rwsem-to-mitigate-a-false-sharing.patch

