Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3BA95C433F5
	for <mm-commits@archiver.kernel.org>; Fri,  4 Mar 2022 23:50:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229981AbiCDXv1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 4 Mar 2022 18:51:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229717AbiCDXv0 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 4 Mar 2022 18:51:26 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48A471520DD
        for <mm-commits@vger.kernel.org>; Fri,  4 Mar 2022 15:50:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D964DB82C75
        for <mm-commits@vger.kernel.org>; Fri,  4 Mar 2022 23:50:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A1A8C340E9;
        Fri,  4 Mar 2022 23:50:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1646437835;
        bh=oyn4fT1+y5QASjFOCdHm4kPe5CgQTqUBucItJvok+Ps=;
        h=Date:To:From:Subject:From;
        b=m/Vm5TlPwIQHJlMJ7UhsesQHC8RX+y36ScpReQ7u1P968pYhNZD5STCAQqtluy3Qn
         5c7SrFr97xH8ng5A4u0bN2udOIzHgHAW+mofFHIu28yiAWp2qU/2o5k0DjNgUWvunD
         C4vzHrun7iCOQGplCWLvd3zKv0R2d4Ihug1UfKCs=
Date:   Fri, 04 Mar 2022 15:50:34 -0800
To:     mm-commits@vger.kernel.org, akpm@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [obsolete] linux-next-git-rejects.patch removed from -mm tree
Message-Id: <20220304235035.7A1A8C340E9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-git-rejects
has been removed from the -mm tree.  Its filename was
     linux-next-git-rejects.patch

This patch was dropped because it is obsolete

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
userfaultfd-provide-unmasked-address-on-page-fault-v3-fix.patch
mm-mempolicy-convert-from-atomic_t-to-refcount_t-on-mempolicy-refcnt-fix.patch
mm-handle-uninitialized-numa-nodes-gracefully-fix.patch
mm-memory_hotplug-remove-obsolete-comment-of-__add_pages-fix.patch
proc-alloc-path_max-bytes-for-proc-pid-fd-symlinks-fix.patch
linux-next-rejects.patch
arch-x86-kernel-resourcec-needs-spinlockh.patch
mm-oom_killc-fix-vm_oom_kill_table-ifdeffery.patch
kasan-improve-vmalloc-tests-fix-3-fix.patch
mutex-subsystem-synchro-test-module-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch

