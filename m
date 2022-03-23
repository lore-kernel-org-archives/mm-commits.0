Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 987FCC433EF
	for <mm-commits@archiver.kernel.org>; Wed, 23 Mar 2022 22:42:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345311AbiCWWoX (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 23 Mar 2022 18:44:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240626AbiCWWoX (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 23 Mar 2022 18:44:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F080F7CB23
        for <mm-commits@vger.kernel.org>; Wed, 23 Mar 2022 15:42:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A3214B8212B
        for <mm-commits@vger.kernel.org>; Wed, 23 Mar 2022 22:42:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3880DC340E9;
        Wed, 23 Mar 2022 22:42:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648075370;
        bh=dYOrxq+YjzpAt5niQgOQNERm0NGEGaBzrWiGhDw2LAI=;
        h=Date:To:From:Subject:From;
        b=vrABcFgntbxeynTROYNiG8AgmlbyasoaDO4kYER0vBLr1r9DHUwcTpbdmDdzQZxTQ
         Duvurcn19LnjQSO6egAlzm0U1XPxRavs3jSCe0zRrEUyaAo3oKWyPk5kdh7yj+zyv+
         9OGGkaIogmC5Dt23FVkf88thryjvGY22LIxyFA78=
Date:   Wed, 23 Mar 2022 15:42:49 -0700
To:     mm-commits@vger.kernel.org, ndesaulniers@google.com,
        nathan@kernel.org, mst@redhat.com, corbet@lwn.net,
        bhelgaas@google.com, akpm@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] linux-typesh-remove-unnecessary-__bitwise__-fix.patch removed from -mm tree
Message-Id: <20220323224250.3880DC340E9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: linux-typesh-remove-unnecessary-__bitwise__-fix
has been removed from the -mm tree.  Its filename was
     linux-typesh-remove-unnecessary-__bitwise__-fix.patch

This patch was dropped because it was folded into linux-typesh-remove-unnecessary-__bitwise__.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-typesh-remove-unnecessary-__bitwise__-fix

change the tools/include/linux/types.h definition also

Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Michael S. Tsirkin <mst@redhat.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/include/linux/types.h |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/tools/include/linux/types.h~linux-typesh-remove-unnecessary-__bitwise__-fix
+++ a/tools/include/linux/types.h
@@ -43,11 +43,10 @@ typedef __u8  u8;
 typedef __s8  s8;
 
 #ifdef __CHECKER__
-#define __bitwise__ __attribute__((bitwise))
+#define __bitwise	__attribute__((bitwise))
 #else
-#define __bitwise__
+#define __bitwise
 #endif
-#define __bitwise __bitwise__
 
 #define __force
 #define __user
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

linux-typesh-remove-unnecessary-__bitwise__.patch
taskstats-remove-unneeded-dead-assignment-fix.patch
memcg-sync-flush-only-if-periodic-flush-is-delayed-fix.patch
mm.patch
documentation-vm-page_ownerrst-update-the-documentation-fix.patch
mm-mempolicy-convert-from-atomic_t-to-refcount_t-on-mempolicy-refcnt-fix.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
mm-oom_killc-fix-vm_oom_kill_table-ifdeffery.patch
kasan-improve-vmalloc-tests-fix-3-fix.patch
mm-slightly-clarify-ksm-logic-in-do_swap_page-fix.patch
mm-huge_memory-remove-stale-locking-logic-from-__split_huge_pmd-fix.patch
mutex-subsystem-synchro-test-module-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch

