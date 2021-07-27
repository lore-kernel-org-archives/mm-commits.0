Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1AF74C4338F
	for <mm-commits@archiver.kernel.org>; Tue, 27 Jul 2021 19:35:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 038CE60FC4
	for <mm-commits@archiver.kernel.org>; Tue, 27 Jul 2021 19:35:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230454AbhG0TfY (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 27 Jul 2021 15:35:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:33720 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231932AbhG0TfY (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 27 Jul 2021 15:35:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B778060FA0;
        Tue, 27 Jul 2021 19:35:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1627414524;
        bh=ZzjoD0DDYbTejIRFkhtFlftnpLDLS3/nffrhVn81zOw=;
        h=Date:From:To:Subject:From;
        b=D8/uvrZNMkliYRuUePEQ0MihoH7YGtkRXDGpVauH/FWdVx968euyxOSJgr0PDYEpb
         qEZ7SHATNWoMK/FRH3R5GSH6qbT6AGuhwrT3YJI+5SCvWyMMLiAe2kU/6PpY1OYMo5
         QThPyr/tEqkf60tINlRbP7L1vc/XrJXzbgyHF7cM=
Date:   Tue, 27 Jul 2021 12:35:23 -0700
From:   akpm@linux-foundation.org
To:     bxue@redhat.com, dchinner@redhat.com, djwong@kernel.org,
        guro@fb.com, jack@suse.cz, jencce.kernel@gmail.com,
        mm-commits@vger.kernel.org, will@kernel.org
Subject:  [merged]
 writeback-cgroup-remove-wb-from-offline-list-before-releasing-refcnt.patch
 removed from -mm tree
Message-ID: <20210727193523.pToceBh45%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: writeback, cgroup: remove wb from offline list before releasing refcnt
has been removed from the -mm tree.  Its filename was
     writeback-cgroup-remove-wb-from-offline-list-before-releasing-refcnt.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Roman Gushchin <guro@fb.com>
Subject: writeback, cgroup: remove wb from offline list before releasing refcnt

Boyang reported that the commit c22d70a162d3 ("writeback, cgroup: release
dying cgwbs by switching attached inodes") causes the kernel to crash
while running xfstests generic/256 on ext4 on aarch64 and ppc64le.

  [ 4366.380974] run fstests generic/256 at 2021-07-12 05:41:40
  [ 4368.337078] EXT4-fs (vda3): mounted filesystem with ordered data
  mode. Opts: . Quota mode: none.
  [ 4371.275986] Unable to handle kernel NULL pointer dereference at
  virtual address 0000000000000000
  [ 4371.278210] Mem abort info:
  [ 4371.278880]   ESR = 0x96000005
  [ 4371.279603]   EC = 0x25: DABT (current EL), IL = 32 bits
  [ 4371.280878]   SET = 0, FnV = 0
  [ 4371.281621]   EA = 0, S1PTW = 0
  [ 4371.282396]   FSC = 0x05: level 1 translation fault
  [ 4371.283635] Data abort info:
  [ 4371.284333]   ISV = 0, ISS = 0x00000005
  [ 4371.285246]   CM = 0, WnR = 0
  [ 4371.285975] user pgtable: 64k pages, 48-bit VAs, pgdp=00000000b0502000
  [ 4371.287640] [0000000000000000] pgd=0000000000000000,
  p4d=0000000000000000, pud=0000000000000000
  [ 4371.290016] Internal error: Oops: 96000005 [#1] SMP
  [ 4371.291251] Modules linked in: dm_flakey dm_snapshot dm_bufio
  dm_zero dm_mod loop tls rpcsec_gss_krb5 auth_rpcgss nfsv4 dns_resolver
  nfs lockd grace fscache netfs rfkill sunrpc ext4 vfat fat mbcache jbd2
  drm fuse xfs libcrc32c crct10dif_ce ghash_ce sha2_ce sha256_arm64
  sha1_ce virtio_blk virtio_net net_failover virtio_console failover
  virtio_mmio aes_neon_bs [last unloaded: scsi_debug]
  [ 4371.300059] CPU: 0 PID: 408468 Comm: kworker/u8:5 Tainted: G
         X --------- ---  5.14.0-0.rc1.15.bx.el9.aarch64 #1
  [ 4371.303009] Hardware name: QEMU KVM Virtual Machine, BIOS 0.0.0 02/06/2015
  [ 4371.304685] Workqueue: events_unbound cleanup_offline_cgwbs_workfn
  [ 4371.306329] pstate: 004000c5 (nzcv daIF +PAN -UAO -TCO BTYPE=--)
  [ 4371.307867] pc : cleanup_offline_cgwbs_workfn+0x320/0x394
  [ 4371.309254] lr : cleanup_offline_cgwbs_workfn+0xe0/0x394
  [ 4371.310597] sp : ffff80001554fd10
  [ 4371.311443] x29: ffff80001554fd10 x28: 0000000000000000 x27: 0000000000000001
  [ 4371.313320] x26: 0000000000000000 x25: 00000000000000e0 x24: ffffd2a2fbe671a8
  [ 4371.315159] x23: ffff80001554fd88 x22: ffffd2a2fbe67198 x21: ffffd2a2fc25a730
  [ 4371.316945] x20: ffff210412bc3000 x19: ffff210412bc3280 x18: 0000000000000000
  [ 4371.318690] x17: 0000000000000000 x16: 0000000000000000 x15: 0000000000000000
  [ 4371.320437] x14: 0000000000000000 x13: 0000000000000030 x12: 0000000000000040
  [ 4371.322444] x11: ffff210481572238 x10: ffff21048157223a x9 : ffffd2a2fa276c60
  [ 4371.324243] x8 : ffff210484106b60 x7 : 0000000000000000 x6 : 000000000007d18a
  [ 4371.326049] x5 : ffff210416a86400 x4 : ffff210412bc0280 x3 : 0000000000000000
  [ 4371.327898] x2 : ffff80001554fd88 x1 : ffff210412bc0280 x0 : 0000000000000003
  [ 4371.329748] Call trace:
  [ 4371.330372]  cleanup_offline_cgwbs_workfn+0x320/0x394
  [ 4371.331694]  process_one_work+0x1f4/0x4b0
  [ 4371.332767]  worker_thread+0x184/0x540
  [ 4371.333732]  kthread+0x114/0x120
  [ 4371.334535]  ret_from_fork+0x10/0x18
  [ 4371.335440] Code: d63f0020 97f99963 17ffffa6 f8588263 (f9400061)
  [ 4371.337174] ---[ end trace e250fe289272792a ]---
  [ 4371.338365] Kernel panic - not syncing: Oops: Fatal exception
  [ 4371.339884] SMP: stopping secondary CPUs
  [ 4372.424137] SMP: failed to stop secondary CPUs 0-2
  [ 4372.436894] Kernel Offset: 0x52a2e9fa0000 from 0xffff800010000000
  [ 4372.438408] PHYS_OFFSET: 0xfff0defca0000000
  [ 4372.439496] CPU features: 0x00200251,23200840
  [ 4372.440603] Memory Limit: none
  [ 4372.441374] ---[ end Kernel panic - not syncing: Oops: Fatal exception ]---

The problem happens when cgwb_release_workfn() races with
cleanup_offline_cgwbs_workfn(): wb_tryget() in
cleanup_offline_cgwbs_workfn() can be called after percpu_ref_exit() is
cgwb_release_workfn(), which is basically a use-after-free error.

Fix the problem by making removing the writeback structure from the
offline list before releasing the percpu reference counter.  It will
guarantee that cleanup_offline_cgwbs_workfn() will not see and not access
writeback structures which are about to be released.

Link: https://lkml.kernel.org/r/20210716201039.3762203-1-guro@fb.com
Fixes: c22d70a162d3 ("writeback, cgroup: release dying cgwbs by switching attached inodes")
Signed-off-by: Roman Gushchin <guro@fb.com>
Reported-by: Boyang Xue <bxue@redhat.com>
Suggested-by: Jan Kara <jack@suse.cz>
Tested-by: Darrick J. Wong <djwong@kernel.org>
Cc: Will Deacon <will@kernel.org>
Cc: Dave Chinner <dchinner@redhat.com>
Cc: Murphy Zhou <jencce.kernel@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/backing-dev.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/backing-dev.c~writeback-cgroup-remove-wb-from-offline-list-before-releasing-refcnt
+++ a/mm/backing-dev.c
@@ -398,12 +398,12 @@ static void cgwb_release_workfn(struct w
 	blkcg_unpin_online(blkcg);
 
 	fprop_local_destroy_percpu(&wb->memcg_completions);
-	percpu_ref_exit(&wb->refcnt);
 
 	spin_lock_irq(&cgwb_lock);
 	list_del(&wb->offline_node);
 	spin_unlock_irq(&cgwb_lock);
 
+	percpu_ref_exit(&wb->refcnt);
 	wb_exit(wb);
 	WARN_ON_ONCE(!list_empty(&wb->b_attached));
 	kfree_rcu(wb, rcu);
_

Patches currently in -mm which might be from guro@fb.com are


