Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0AB72C07E95
	for <mm-commits@archiver.kernel.org>; Tue, 20 Jul 2021 22:06:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E118C61186
	for <mm-commits@archiver.kernel.org>; Tue, 20 Jul 2021 22:06:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229651AbhGTVZY (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 20 Jul 2021 17:25:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:45474 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229635AbhGTVZX (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 20 Jul 2021 17:25:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 55D5361009;
        Tue, 20 Jul 2021 22:06:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1626818760;
        bh=gN/jPS848FU2ENarCTc/le/7931JdQt2pul19coH61s=;
        h=Date:From:To:Subject:From;
        b=xAW77IRuK9aFUL3UOi0D+Fj8JI+mtteyTNe8jODqIR7Bw2dv28MgNhJjRSWF90bS6
         7gCAm9FT2l8DXAWe/IoUZaTIJQBDCtewG+VUnwuwhR/0G9IhOyx3NCRXmcIFF0W2iS
         2L9xRwzTZTdEiGFYJWTCFxEOT/HVChZcemDaJ22k=
Date:   Tue, 20 Jul 2021 15:05:59 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        jencce.kernel@gmail.com, jack@suse.cz, djwong@kernel.org,
        dchinner@redhat.com, guro@fb.com
Subject:  + writeback-cgroup-do-not-reparent-dax-inodes.patch added
 to -mm tree
Message-ID: <20210720220559.olBSC%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: writeback, cgroup: do not reparent dax inodes
has been added to the -mm tree.  Its filename is
     writeback-cgroup-do-not-reparent-dax-inodes.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/writeback-cgroup-do-not-reparent-dax-inodes.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/writeback-cgroup-do-not-reparent-dax-inodes.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Roman Gushchin <guro@fb.com>
Subject: writeback, cgroup: do not reparent dax inodes

The inode switching code is not suited for dax inodes.  An attempt to
switch a dax inode to a parent writeback structure (as a part of a
writeback cleanup procedure) results in a panic like this:

  [  987.071651] run fstests generic/270 at 2021-07-15 05:54:02
  [  988.704940] XFS (pmem0p2): EXPERIMENTAL big timestamp feature in
  use.  Use at your own risk!
  [  988.746847] XFS (pmem0p2): DAX enabled. Warning: EXPERIMENTAL, use
  at your own risk
  [  988.786070] XFS (pmem0p2): EXPERIMENTAL inode btree counters
  feature in use. Use at your own risk!
  [  988.828639] XFS (pmem0p2): Mounting V5 Filesystem
  [  988.854019] XFS (pmem0p2): Ending clean mount
  [  988.874550] XFS (pmem0p2): Quotacheck needed: Please wait.
  [  988.900618] XFS (pmem0p2): Quotacheck: Done.
  [  989.090783] XFS (pmem0p2): xlog_verify_grant_tail: space > BBTOB(tail_blocks)
  [  989.092751] XFS (pmem0p2): xlog_verify_grant_tail: space > BBTOB(tail_blocks)
  [  989.092962] XFS (pmem0p2): xlog_verify_grant_tail: space > BBTOB(tail_blocks)
  [ 1010.105586] BUG: unable to handle page fault for address: 0000000005b0f669
  [ 1010.141817] #PF: supervisor read access in kernel mode
  [ 1010.167824] #PF: error_code(0x0000) - not-present page
  [ 1010.191499] PGD 0 P4D 0
  [ 1010.203346] Oops: 0000 [#1] SMP PTI
  [ 1010.219596] CPU: 13 PID: 10479 Comm: kworker/13:16 Not tainted
  5.14.0-rc1-master-8096acd7442e+ #8
  [ 1010.260441] Hardware name: HP ProLiant DL360 Gen9/ProLiant DL360
  Gen9, BIOS P89 09/13/2016
  [ 1010.297792] Workqueue: inode_switch_wbs inode_switch_wbs_work_fn
  [ 1010.324832] RIP: 0010:inode_do_switch_wbs+0xaf/0x470
  [ 1010.347261] Code: 00 30 0f 85 c1 03 00 00 0f 1f 44 00 00 31 d2 48
  c7 c6 ff ff ff ff 48 8d 7c 24 08 e8 eb 49 1a 00 48 85 c0 74 4a bb ff
  ff ff ff <48> 8b 50 08 48 8d 4a ff 83 e2 01 48 0f 45 c1 48 8b 00 a8 08
  0f 85
  [ 1010.434307] RSP: 0018:ffff9c66691abdc8 EFLAGS: 00010002
  [ 1010.457795] RAX: 0000000005b0f661 RBX: 00000000ffffffff RCX: ffff89e6a21382b0
  [ 1010.489922] RDX: 0000000000000001 RSI: ffff89e350230248 RDI: ffffffffffffffff
  [ 1010.522085] RBP: ffff89e681d19400 R08: 0000000000000000 R09: 0000000000000228
  [ 1010.554234] R10: ffffffffffffffff R11: ffffffffffffffc0 R12: ffff89e6a2138130
  [ 1010.586414] R13: ffff89e316af7400 R14: ffff89e316af6e78 R15: ffff89e6a21382b0
  [ 1010.619394] FS:  0000000000000000(0000) GS:ffff89ee5fb40000(0000)
  knlGS:0000000000000000
  [ 1010.658874] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  [ 1010.688085] CR2: 0000000005b0f669 CR3: 0000000cb2410004 CR4: 00000000001706e0
  [ 1010.722129] Call Trace:
  [ 1010.733132]  inode_switch_wbs_work_fn+0xb6/0x2a0
  [ 1010.754121]  process_one_work+0x1e6/0x380
  [ 1010.772512]  worker_thread+0x53/0x3d0
  [ 1010.789221]  ? process_one_work+0x380/0x380
  [ 1010.807964]  kthread+0x10f/0x130
  [ 1010.822043]  ? set_kthread_struct+0x40/0x40
  [ 1010.840818]  ret_from_fork+0x22/0x30
  [ 1010.856851] Modules linked in: xt_CHECKSUM xt_MASQUERADE
  xt_conntrack ipt_REJECT nf_reject_ipv4 nft_compat nft_chain_nat nf_nat
  nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 nft_counter nf_tables
  nfnetlink bridge stp llc rfkill sunrpc intel_rapl_msr
  intel_rapl_common sb_edac x86_pkg_temp_thermal intel_powerclamp
  coretemp kvm_intel ipmi_ssif kvm mgag200 i2c_algo_bit iTCO_wdt
  irqbypass drm_kms_helper iTCO_vendor_support acpi_ipmi rapl
  syscopyarea sysfillrect intel_cstate ipmi_si sysimgblt ioatdma
  dax_pmem_compat fb_sys_fops ipmi_devintf device_dax i2c_i801 pcspkr
  intel_uncore hpilo nd_pmem cec dax_pmem_core dca i2c_smbus acpi_tad
  lpc_ich ipmi_msghandler acpi_power_meter drm fuse xfs libcrc32c sd_mod
  t10_pi crct10dif_pclmul crc32_pclmul crc32c_intel tg3
  ghash_clmulni_intel serio_raw hpsa hpwdt scsi_transport_sas wmi
  dm_mirror dm_region_hash dm_log dm_mod
  [ 1011.200864] CR2: 0000000005b0f669
  [ 1011.215700] ---[ end trace ed2105faff8384f3 ]---
  [ 1011.241727] RIP: 0010:inode_do_switch_wbs+0xaf/0x470
  [ 1011.264306] Code: 00 30 0f 85 c1 03 00 00 0f 1f 44 00 00 31 d2 48
  c7 c6 ff ff ff ff 48 8d 7c 24 08 e8 eb 49 1a 00 48 85 c0 74 4a bb ff
  ff ff ff <48> 8b 50 08 48 8d 4a ff 83 e2 01 48 0f 45 c1 48 8b 00 a8 08
  0f 85
  [ 1011.348821] RSP: 0018:ffff9c66691abdc8 EFLAGS: 00010002
  [ 1011.372734] RAX: 0000000005b0f661 RBX: 00000000ffffffff RCX: ffff89e6a21382b0
  [ 1011.405826] RDX: 0000000000000001 RSI: ffff89e350230248 RDI: ffffffffffffffff
  [ 1011.437852] RBP: ffff89e681d19400 R08: 0000000000000000 R09: 0000000000000228
  [ 1011.469926] R10: ffffffffffffffff R11: ffffffffffffffc0 R12: ffff89e6a2138130
  [ 1011.502179] R13: ffff89e316af7400 R14: ffff89e316af6e78 R15: ffff89e6a21382b0
  [ 1011.534233] FS:  0000000000000000(0000) GS:ffff89ee5fb40000(0000)
  knlGS:0000000000000000
  [ 1011.571247] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  [ 1011.597063] CR2: 0000000005b0f669 CR3: 0000000cb2410004 CR4: 00000000001706e0
  [ 1011.629160] Kernel panic - not syncing: Fatal exception
  [ 1011.653802] Kernel Offset: 0x15200000 from 0xffffffff81000000
  (relocation range: 0xffffffff80000000-0xffffffffbfffffff)
  [ 1011.713723] ---[ end Kernel panic - not syncing: Fatal exception ]---

The crash happens on an attempt to iterate over attached pagecache pages
and check the dirty flag: a dax inode's xarray contains pfn's instead of
generic struct page pointers.

This happens for DAX and not for other kinds of non-page entries in the
inodes because it's a tagged iteration, and shadow/swap entries are never
tagged; only DAX entries get tagged.

Fix the problem by bailing out (with the false return value) of
inode_prepare_sbs_switch() if a dax inode is passed.

[willy@infradead.org: changelog addition]
Link: https://lkml.kernel.org/r/20210719171350.3876830-1-guro@fb.com
Fixes: c22d70a162d3 ("writeback, cgroup: release dying cgwbs by switching attached inodes")
Signed-off-by: Roman Gushchin <guro@fb.com>
Reported-by: Murphy Zhou <jencce.kernel@gmail.com>
Reported-by: Darrick J. Wong <djwong@kernel.org>
Tested-by: Darrick J. Wong <djwong@kernel.org>
Tested-by: Murphy Zhou <jencce.kernel@gmail.com>
Acked-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fs-writeback.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/fs/fs-writeback.c~writeback-cgroup-do-not-reparent-dax-inodes
+++ a/fs/fs-writeback.c
@@ -521,6 +521,9 @@ static bool inode_prepare_wbs_switch(str
 	 */
 	smp_mb();
 
+	if (IS_DAX(inode))
+		return false;
+
 	/* while holding I_WB_SWITCH, no one else can update the association */
 	spin_lock(&inode->i_lock);
 	if (!(inode->i_sb->s_flags & SB_ACTIVE) ||
_

Patches currently in -mm which might be from guro@fb.com are

writeback-cgroup-remove-wb-from-offline-list-before-releasing-refcnt.patch
writeback-cgroup-do-not-reparent-dax-inodes.patch

