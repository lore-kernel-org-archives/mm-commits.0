Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91884EB64D9
	for <mm-commits@archiver.kernel.org>; Sun,  2 Jul 2023 21:12:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229764AbjGBVMR (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 2 Jul 2023 17:12:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229504AbjGBVMR (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 2 Jul 2023 17:12:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09C71E55
        for <mm-commits@vger.kernel.org>; Sun,  2 Jul 2023 14:12:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8A7DA60C8C
        for <mm-commits@vger.kernel.org>; Sun,  2 Jul 2023 21:12:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFD5AC433C7;
        Sun,  2 Jul 2023 21:12:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1688332335;
        bh=NiuQFTdOzcseiPpxsDsGTEBRE3IW48O05jZnFOwXy/4=;
        h=Date:To:From:Subject:From;
        b=Ts9R4pj40qOx0nQ8baOVu0qiXd6/CNUd7v32YouBciD3yPM351TYqANY2XrC3jzBq
         qBcoReO89cW5v8C7cbR7ZIdxN4pDYpCfjDqbIsVdccBzzHQ3Uuaftp1RkCOC7W8vjR
         yDsm774Cq3SlWeoozfL8IfhsMsG2eFBMGKGvWtDU=
Date:   Sun, 02 Jul 2023 14:12:14 -0700
To:     mm-commits@vger.kernel.org, yu.ma@intel.com,
        viro@zeniv.linux.org.uk, tim.c.chen@linux.intel.com,
        brauner@kernel.org, lipeng.zhu@intel.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + fs-address_space-add-alignment-padding-for-i_map-and-i_mmap_rwsem-to-mitigate-a-false-sharing.patch added to mm-unstable branch
Message-Id: <20230702211214.DFD5AC433C7@smtp.kernel.org>
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
Date: Wed, 28 Jun 2023 18:56:25 +0800

When running UnixBench/Shell Scripts, we observed high false sharing for
accessing i_mmap against i_mmap_rwsem.

UnixBench/Shell Scripts are typical load/execute command test scenarios,
the i_mmap will be accessed frequently to insert/remove vma_interval_tree.
Meanwhile, the i_mmap_rwsem is frequently loaded.  Unfortunately, they
are in the same cacheline.

The patch places the i_mmap and i_mmap_rwsem in separate cache lines to
avoid this false sharing problem.

With this patch, on Intel Sapphire Rapids 2 sockets 112c/224t platform,
based on kernel v6.4-rc4, the 224 parallel score is improved ~2.5% for
UnixBench/Shell Scripts case.  And perf c2c tool shows the false sharing
is resolved as expected, the symbol vma_interval_tree_remove disappeared
in cache line 0 after this change.

Baseline:
=================================================
      Shared Cache Line Distribution Pareto
=================================================
  -------------------------------------------------------------
      0    13642    19392     9012       63  0xff1ddd3f0c8a3b00
  -------------------------------------------------------------
    9.22%    7.37%    0.00%    0.00%    0x0     0       1  0xffffffffab344052       518       334       354     5490       160  [k] vma_interval_tree_remove    [kernel.kallsyms]  vma_interval_tree_remove+18      0  1
    0.71%    0.73%    0.00%    0.00%    0x8     0       1  0xffffffffabb9a21f       574       338       458     1991       160  [k] rwsem_down_write_slowpath   [kernel.kallsyms]  rwsem_down_write_slowpath+655    0  1
    0.52%    0.71%    5.34%    6.35%    0x8     0       1  0xffffffffabb9a236      1080       597       390     4848       160  [k] rwsem_down_write_slowpath   [kernel.kallsyms]  rwsem_down_write_slowpath+678    0  1
    0.56%    0.47%   26.39%    6.35%    0x8     0       1  0xffffffffabb9a5ec      1327      1037       587     8537       160  [k] down_write                  [kernel.kallsyms]  down_write+28                    0  1
    0.11%    0.08%   15.72%    1.59%    0x8     0       1  0xffffffffab17082b      1618      1077       735     7303       160  [k] up_write                    [kernel.kallsyms]  up_write+27                      0  1
    0.01%    0.02%    0.08%    0.00%    0x8     0       1  0xffffffffabb9a27d      1594       593       512       53        43  [k] rwsem_down_write_slowpath   [kernel.kallsyms]  rwsem_down_write_slowpath+749    0  1
    0.00%    0.01%    0.00%    0.00%    0x8     0       1  0xffffffffabb9a0c4         0       323       518       97        74  [k] rwsem_down_write_slowpath   [kernel.kallsyms]  rwsem_down_write_slowpath+308    0  1
   44.74%   49.78%    0.00%    0.00%   0x10     0       1  0xffffffffab170995       609       344       430    26841       160  [k] rwsem_spin_on_owner         [kernel.kallsyms]  rwsem_spin_on_owner+53           0  1
   26.62%   22.39%    0.00%    0.00%   0x10     0       1  0xffffffffab170965       514       347       437    13364       160  [k] rwsem_spin_on_owner         [kernel.kallsyms]  rwsem_spin_on_owner+5            0  1

With this change:
  -------------------------------------------------------------
      0    12726    18554     9039       49  0xff157a0f25b90c40
  -------------------------------------------------------------
    0.90%    0.72%    0.00%    0.00%    0x0     1       1  0xffffffffa5f9a21f       532       353       461     2200       160  [k] rwsem_down_write_slowpath   [kernel.kallsyms]  rwsem_down_write_slowpath+655    0  1
    0.53%    0.70%    5.16%    6.12%    0x0     1       1  0xffffffffa5f9a236      1196       670       403     4774       160  [k] rwsem_down_write_slowpath   [kernel.kallsyms]  rwsem_down_write_slowpath+678    0  1
    0.68%    0.51%   25.91%    6.12%    0x0     1       1  0xffffffffa5f9a5ec      1049       807       540     8552       160  [k] down_write                  [kernel.kallsyms]  down_write+28                    0  1
    0.09%    0.06%   16.50%    2.04%    0x0     1       1  0xffffffffa557082b      1693      1351       758     7317       160  [k] up_write                    [kernel.kallsyms]  up_write+27                      0  1
    0.01%    0.00%    0.00%    0.00%    0x0     1       1  0xffffffffa5f9a0c4       543         0       491       89        68  [k] rwsem_down_write_slowpath   [kernel.kallsyms]  rwsem_down_write_slowpath+308    0  1
    0.00%    0.01%    0.02%    0.00%    0x0     1       1  0xffffffffa5f9a27d         0       597       742       45        40  [k] rwsem_down_write_slowpath   [kernel.kallsyms]  rwsem_down_write_slowpath+749    0  1
   49.29%   53.01%    0.00%    0.00%    0x8     1       1  0xffffffffa5570995       580       310       413    27106       160  [k] rwsem_spin_on_owner         [kernel.kallsyms]  rwsem_spin_on_owner+53           0  1
   28.60%   24.12%    0.00%    0.00%    0x8     1       1  0xffffffffa5570965       490       321       419    13244       160  [k] rwsem_spin_on_owner         [kernel.kallsyms]  rwsem_spin_on_owner+5            0  1

Link: https://lkml.kernel.org/r/20230628105624.150352-1-lipeng.zhu@intel.com
Signed-off-by: Lipeng Zhu <lipeng.zhu@intel.com>
Reviewed-by: Tim Chen <tim.c.chen@linux.intel.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Yu Ma <yu.ma@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/fs.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/fs.h~fs-address_space-add-alignment-padding-for-i_map-and-i_mmap_rwsem-to-mitigate-a-false-sharing
+++ a/include/linux/fs.h
@@ -447,7 +447,7 @@ struct address_space {
 	atomic_t		nr_thps;
 #endif
 	struct rb_root_cached	i_mmap;
-	struct rw_semaphore	i_mmap_rwsem;
+	struct rw_semaphore	i_mmap_rwsem ____cacheline_aligned_in_smp;
 	unsigned long		nrpages;
 	pgoff_t			writeback_index;
 	const struct address_space_operations *a_ops;
_

Patches currently in -mm which might be from lipeng.zhu@intel.com are

fs-address_space-add-alignment-padding-for-i_map-and-i_mmap_rwsem-to-mitigate-a-false-sharing.patch

