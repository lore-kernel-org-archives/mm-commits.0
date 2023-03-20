Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 637EEC6FD1D
	for <mm-commits@archiver.kernel.org>; Mon, 20 Mar 2023 22:29:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229494AbjCTW36 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 20 Mar 2023 18:29:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229892AbjCTW3x (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 20 Mar 2023 18:29:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0C5BC64F
        for <mm-commits@vger.kernel.org>; Mon, 20 Mar 2023 15:29:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 845AD616B5
        for <mm-commits@vger.kernel.org>; Mon, 20 Mar 2023 22:29:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D87F4C433D2;
        Mon, 20 Mar 2023 22:29:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1679351391;
        bh=2rKherBIAud05GX8IjkV1Y7dAm7rKvTsCUV6h2brCwI=;
        h=Date:To:From:Subject:From;
        b=XzrMQGWdCT4/kTl1zxQNzUa/f7n53xrgPhDFl87LUsN6P4NczihV13NDdbHMBJVpj
         N/B0vo9cPZRf2wtNczQl/mq24b5mWdriO0Jnyd0cjKQL2vd9mvvpL4AOoAqRHhHTk4
         NNAMcIvEBfsIWHHrcICbtkP6mlI3CCA4BRjkOfHw=
Date:   Mon, 20 Mar 2023 15:29:51 -0700
To:     mm-commits@vger.kernel.org, mtosatti@redhat.com,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + vmstat-add-pcp-remote-node-draining-via-cpu_vm_stats_fold-fix.patch added to mm-unstable branch
Message-Id: <20230320222951.D87F4C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: vmstat-add-pcp-remote-node-draining-via-cpu_vm_stats_fold-fix
has been added to the -mm mm-unstable branch.  Its filename is
     vmstat-add-pcp-remote-node-draining-via-cpu_vm_stats_fold-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/vmstat-add-pcp-remote-node-draining-via-cpu_vm_stats_fold-fix.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: vmstat-add-pcp-remote-node-draining-via-cpu_vm_stats_fold-fix
Date: Mon Mar 20 03:28:50 PM PDT 2023

fix cpu_vm_stats_fold() stub

Cc: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/include/linux/vmstat.h~vmstat-add-pcp-remote-node-draining-via-cpu_vm_stats_fold-fix
+++ a/include/linux/vmstat.h
@@ -408,7 +408,7 @@ static inline void __dec_node_page_state
 #define set_pgdat_percpu_threshold(pgdat, callback) { }
 
 static inline void refresh_zone_stat_thresholds(void) { }
-static inline void cpu_vm_stats_fold(int cpu) { }
+static inline void cpu_vm_stats_fold(int cpu, bool do_pagesets) { }
 static inline void quiet_vmstat(void) { }
 
 static inline void drain_zonestat(struct zone *zone,
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-page_alloc-reduce-page-alloc-free-sanity-checks-checkpatch-fixes.patch
mm-page_alloc-reduce-page-alloc-free-sanity-checks-fix.patch
mm-userfaultfd-support-wp-on-multiple-vmas-fix.patch
mm-add-new-api-to-enable-ksm-per-process-fix.patch
mm-treewide-redefine-max_order-sanely-fix-2.patch
mm-treewide-redefine-max_order-sanely-fix-3-fix.patch
memcg-do-not-drain-charge-pcp-caches-on-remote-isolated-cpus-fix.patch
vmstat-add-pcp-remote-node-draining-via-cpu_vm_stats_fold-fix.patch
scripts-link-vmlinuxsh-fix-error-message-presentation.patch
notifiers-add-tracepoints-to-the-notifiers-infrastructure-checkpatch-fixes.patch

