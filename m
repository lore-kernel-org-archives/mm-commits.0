Return-Path: <SRS0=iiPm=C7=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E69CAC2D0E2
	for <mm-commits@archiver.kernel.org>; Tue, 22 Sep 2020 19:48:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9FF28221E8
	for <mm-commits@archiver.kernel.org>; Tue, 22 Sep 2020 19:48:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1600804118;
	bh=jyFE/dph6rmjNACiAqd9/yB95oLQWrH7QcnUhU/TqOU=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=w1HyfkBdmfEsel3vM3PRqs0fjvpkSDEWDKvs1bITYbHiFh03ITCKaJtYsgGY/S3eC
	 ndgh+E5mTB52FeTuXfiYAniEP7j1A+AVnakkJcmLn8c59D3heQzFhT6M8TQO2Q0OIE
	 04Mwp692kkbUov9BrMXrCNErcIMdjBmsm5sNOfnU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726685AbgIVTsi (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 22 Sep 2020 15:48:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:35094 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726448AbgIVTsi (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 22 Sep 2020 15:48:38 -0400
Received: from X1 (unknown [216.241.194.61])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0B96420888;
        Tue, 22 Sep 2020 19:48:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600804117;
        bh=jyFE/dph6rmjNACiAqd9/yB95oLQWrH7QcnUhU/TqOU=;
        h=Date:From:To:Subject:From;
        b=1Fq3R/s3teMq8Ia3plkSqVyWaPXOHE0KcsPPeVWYzFKg9bD/TBXeXITPlgAvRcjbn
         XjNoGmK4BIzZj90WMpZ3FVeF0TPzTQDNAmZ/RtAlxT4u8FK4FUqJ+PivCNtM6ESPr9
         CHp7EGEoz+aRJmbMEnEvnbYg0ufk+vb6XoopifL8=
Date:   Tue, 22 Sep 2020 12:48:36 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, ying.huang@intel.com,
        dave.hansen@linux.intel.com, daniel.m.jordan@oracle.com,
        aquini@redhat.com
Subject:  +
 mm-swapfile-avoid-split_swap_cluster-null-pointer-dereference.patch added to
 -mm tree
Message-ID: <20200922194836.ZE2CH%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: swapfile: avoid split_swap_cluster() NULL pointer dereference
has been added to the -mm tree.  Its filename is
     mm-swapfile-avoid-split_swap_cluster-null-pointer-dereference.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-swapfile-avoid-split_swap_cluster-null-pointer-dereference.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-swapfile-avoid-split_swap_cluster-null-pointer-dereference.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Rafael Aquini <aquini@redhat.com>
Subject: mm: swapfile: avoid split_swap_cluster() NULL pointer dereference

The swap area descriptor only gets struct swap_cluster_info *cluster_info
allocated if the swapfile is backed by non-rotational storage.  When the
swap area is laid on top of ordinary disk spindles, lock_cluster() will
naturally return NULL.

CONFIG_THP_SWAP exposes cluster_info infrastructure to a broader number of
use cases, and split_swap_cluster(), which is the counterpart of
split_huge_page() for the THPs in the swapcache, misses checking the
return of lock_cluster before operating on the cluster_info pointer.

This patch addresses that issue by adding a proper check for the pointer
not being NULL in the wrappers cluster_{is,clear}_huge(), in order to
avoid crashes similar to the one below:

[ 5758.157556] BUG: kernel NULL pointer dereference, address: 0000000000000007
[ 5758.165331] #PF: supervisor write access in kernel mode
[ 5758.171161] #PF: error_code(0x0002) - not-present page
[ 5758.176894] PGD 0 P4D 0
[ 5758.179721] Oops: 0002 [#1] SMP PTI
[ 5758.183614] CPU: 10 PID: 316 Comm: kswapd1 Kdump: loaded Tainted: G S               --------- ---  5.9.0-0.rc3.1.tst.el8.x86_64 #1
[ 5758.196717] Hardware name: Intel Corporation S2600CP/S2600CP, BIOS SE5C600.86B.02.01.0002.082220131453 08/22/2013
[ 5758.208176] RIP: 0010:split_swap_cluster+0x47/0x60
[ 5758.213522] Code: c1 e3 06 48 c1 eb 0f 48 8d 1c d8 48 89 df e8 d0 20 6a 00 80 63 07 fb 48 85 db 74 16 48 89 df c6 07 00 66 66 66 90 31 c0 5b c3 <80> 24 25 07 00 00 00 fb 31 c0 5b c3 b8 f0 ff ff ff 5b c3 66 0f 1f
[ 5758.234478] RSP: 0018:ffffb147442d7af0 EFLAGS: 00010246
[ 5758.240309] RAX: 0000000000000000 RBX: 000000000014b217 RCX: ffffb14779fd9000
[ 5758.248281] RDX: 000000000014b217 RSI: ffff9c52f2ab1400 RDI: 000000000014b217
[ 5758.256246] RBP: ffffe00c51168080 R08: ffffe00c5116fe08 R09: ffff9c52fffd3000
[ 5758.264208] R10: ffffe00c511537c8 R11: ffff9c52fffd3c90 R12: 0000000000000000
[ 5758.272172] R13: ffffe00c51170000 R14: ffffe00c51170000 R15: ffffe00c51168040
[ 5758.280134] FS:  0000000000000000(0000) GS:ffff9c52f2a80000(0000) knlGS:0000000000000000
[ 5758.289163] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 5758.295575] CR2: 0000000000000007 CR3: 0000000022a0e003 CR4: 00000000000606e0
[ 5758.303538] Call Trace:
[ 5758.306273]  split_huge_page_to_list+0x88b/0x950
[ 5758.311433]  deferred_split_scan+0x1ca/0x310
[ 5758.316202]  do_shrink_slab+0x12c/0x2a0
[ 5758.320491]  shrink_slab+0x20f/0x2c0
[ 5758.324482]  shrink_node+0x240/0x6c0
[ 5758.328469]  balance_pgdat+0x2d1/0x550
[ 5758.332652]  kswapd+0x201/0x3c0
[ 5758.336157]  ? finish_wait+0x80/0x80
[ 5758.340147]  ? balance_pgdat+0x550/0x550
[ 5758.344525]  kthread+0x114/0x130
[ 5758.348126]  ? kthread_park+0x80/0x80
[ 5758.352214]  ret_from_fork+0x22/0x30
[ 5758.356203] Modules linked in: fuse zram rfkill sunrpc intel_rapl_msr intel_rapl_common sb_edac x86_pkg_temp_thermal intel_powerclamp coretemp mgag200 iTCO_wdt crct10dif_pclmul iTCO_vendor_support drm_kms_helper crc32_pclmul ghash_clmulni_intel syscopyarea sysfillrect sysimgblt fb_sys_fops cec rapl joydev intel_cstate ipmi_si ipmi_devintf drm intel_uncore i2c_i801 ipmi_msghandler pcspkr lpc_ich mei_me i2c_smbus mei ioatdma ip_tables xfs libcrc32c sr_mod sd_mod cdrom t10_pi sg igb ahci libahci i2c_algo_bit crc32c_intel libata dca wmi dm_mirror dm_region_hash dm_log dm_mod
[ 5758.412673] CR2: 0000000000000007
[    0.000000] Linux version 5.9.0-0.rc3.1.tst.el8.x86_64 (mockbuild@x86-vm-15.build.eng.bos.redhat.com) (gcc (GCC) 8.3.1 20191121 (Red Hat 8.3.1-5), GNU ld version 2.30-79.el8) #1 SMP Wed Sep 9 16:03:34 EDT 2020

Link: https://lkml.kernel.org/r/20200922184838.978540-1-aquini@redhat.com
Fixes: 59807685a7e77 ("mm, THP, swap: support splitting THP for THP swap out")
Signed-off-by: Rafael Aquini <aquini@redhat.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Daniel Jordan <daniel.m.jordan@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/mm/swapfile.c~mm-swapfile-avoid-split_swap_cluster-null-pointer-dereference
+++ a/mm/swapfile.c
@@ -324,14 +324,15 @@ static inline void cluster_set_null(stru
 
 static inline bool cluster_is_huge(struct swap_cluster_info *info)
 {
-	if (IS_ENABLED(CONFIG_THP_SWAP))
+	if (IS_ENABLED(CONFIG_THP_SWAP) && info)
 		return info->flags & CLUSTER_FLAG_HUGE;
 	return false;
 }
 
 static inline void cluster_clear_huge(struct swap_cluster_info *info)
 {
-	info->flags &= ~CLUSTER_FLAG_HUGE;
+	if (IS_ENABLED(CONFIG_THP_SWAP) && info)
+		info->flags &= ~CLUSTER_FLAG_HUGE;
 }
 
 static inline struct swap_cluster_info *lock_cluster(struct swap_info_struct *si,
_

Patches currently in -mm which might be from aquini@redhat.com are

mm-swapfile-avoid-split_swap_cluster-null-pointer-dereference.patch

