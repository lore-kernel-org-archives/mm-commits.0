Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F7E6C433EF
	for <mm-commits@archiver.kernel.org>; Thu,  3 Mar 2022 21:56:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231628AbiCCV5I (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 3 Mar 2022 16:57:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231622AbiCCV5H (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 3 Mar 2022 16:57:07 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9F273EA9B
        for <mm-commits@vger.kernel.org>; Thu,  3 Mar 2022 13:56:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3997CB826D7
        for <mm-commits@vger.kernel.org>; Thu,  3 Mar 2022 21:56:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C47CBC004E1;
        Thu,  3 Mar 2022 21:56:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1646344577;
        bh=A7kGP10y5AO/BDxC/4L1xjQp+dodjIGT1LzR99gG+kw=;
        h=Date:To:From:Subject:From;
        b=JFCa5BOYOaqM1Hb8D2ITs+BgliCgEg3IJuzsUeoFDArrJG0lGjbCviDQCvK5mh3po
         wcR17Da6qOQs6fvA96JUzvYmlUG6EkKcs4AEqo5n8NMX/1df4J+X9swXQJM3X0xECu
         0Kdn9YaSlI5nvwzFpQep5eUqq+54x2uE7+t5rkrg=
Date:   Thu, 03 Mar 2022 13:56:17 -0800
To:     mm-commits@vger.kernel.org, akpm@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + linux-next-git-rejects.patch added to -mm tree
Message-Id: <20220303215617.C47CBC004E1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-git-rejects
has been added to the -mm tree.  Its filename is
     linux-next-git-rejects.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/linux-next-git-rejects.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/linux-next-git-rejects.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-git-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/dcb/dcbnl.c  |    8 --------
 net/dsa/dsa2.c   |    4 ----
 net/smc/af_smc.c |    6 ------
 3 files changed, 18 deletions(-)

--- a/net/dcb/dcbnl.c~linux-next-git-rejects
+++ a/net/dcb/dcbnl.c
@@ -2077,11 +2077,7 @@ static void dcbnl_flush_dev(struct net_d
 {
 	struct dcb_app_type *itr, *tmp;
 
-<<<<<<< HEAD
-	spin_lock_bh(&dcb_lock);
-=======
 	spin_lock(&dcb_lock);
->>>>>>> linux-next/akpm-base
 
 	list_for_each_entry_safe(itr, tmp, &dcb_app_list, list) {
 		if (itr->ifindex == dev->ifindex) {
@@ -2090,11 +2086,7 @@ static void dcbnl_flush_dev(struct net_d
 		}
 	}
 
-<<<<<<< HEAD
-	spin_unlock_bh(&dcb_lock);
-=======
 	spin_unlock(&dcb_lock);
->>>>>>> linux-next/akpm-base
 }
 
 static int dcbnl_netdevice_event(struct notifier_block *nb,
--- a/net/dsa/dsa2.c~linux-next-git-rejects
+++ a/net/dsa/dsa2.c
@@ -1294,11 +1294,7 @@ int dsa_tree_change_tag_proto(struct dsa
 	info.tag_ops = tag_ops;
 	err = dsa_tree_notify(dst, DSA_NOTIFIER_TAG_PROTO, &info);
 	if (err)
-<<<<<<< HEAD
-		goto out_unwind_tagger;
-=======
 		goto out_unlock;
->>>>>>> linux-next/akpm-base
 
 	err = dsa_tree_bind_tag_proto(dst, tag_ops);
 	if (err)
--- a/net/smc/af_smc.c~linux-next-git-rejects
+++ a/net/smc/af_smc.c
@@ -3294,25 +3294,19 @@ static int __init smc_init(void)
 	if (rc) {
 		pr_err("%s: tcp_ulp_register fails with %d\n", __func__, rc);
 		goto out_ib;
-<<<<<<< HEAD
-=======
 	}
 
 	rc = smc_sysctl_init();
 	if (rc) {
 		pr_err("%s: sysctl_init fails with %d\n", __func__, rc);
 		goto out_ulp;
->>>>>>> linux-next/akpm-base
 	}
 
 	static_branch_enable(&tcp_have_smc);
 	return 0;
 
-<<<<<<< HEAD
-=======
 out_ulp:
 	tcp_unregister_ulp(&smc_ulp_ops);
->>>>>>> linux-next/akpm-base
 out_ib:
 	smc_ib_unregister_client();
 out_sock:
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

remove-bdi_congested-and-wb_congested-and-related-functions-fix.patch
mm.patch
documentation-vm-page_ownerrst-update-the-documentation-fix.patch
mm-list_lru-replace-linear-array-with-xarray-fix.patch
mm-hwpoison-inject-support-injecting-hwpoison-to-free-page-fix.patch
mm-export-pageheadhuge-fix.patch
mm-mempolicy-convert-from-atomic_t-to-refcount_t-on-mempolicy-refcnt-fix.patch
mm-handle-uninitialized-numa-nodes-gracefully-fix.patch
mm-memory_hotplug-remove-obsolete-comment-of-__add_pages-fix.patch
proc-alloc-path_max-bytes-for-proc-pid-fd-symlinks-fix.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
drivers-gpu-drm-dp-drm_dpc-fix-build.patch
arch-x86-kernel-resourcec-needs-spinlockh.patch
mm-oom_killc-fix-vm_oom_kill_table-ifdeffery.patch
kasan-improve-vmalloc-tests-fix-3-fix.patch
mutex-subsystem-synchro-test-module-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch

