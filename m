Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22838C11F66
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 01:05:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 070CB61469
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 01:05:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238295AbhGABIL (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Jun 2021 21:08:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:60088 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238272AbhGABIL (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 30 Jun 2021 21:08:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EC72761424;
        Thu,  1 Jul 2021 01:05:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625101541;
        bh=Wikd86VfV+BTBClbbIdOigAnaH6OR4Usz1D18dyMgxg=;
        h=Date:From:To:Subject:From;
        b=cpT82A3b4dMoeq3oIgnJs2Efgljf0IXNhNR2rj3CO/3f6aGOhuGq5ZV1yj8vk5dBb
         rYY0w75EGsRV9WFxc2SzUUGNiJlck6I1Lox6HyjxyLItQu0yY0qgBXkMrXbu5MncTB
         Ib9fnP/KnX1eu+FCGzuIK+JUqIPn5BDHVAAwhIVA=
Date:   Wed, 30 Jun 2021 18:05:40 -0700
From:   akpm@linux-foundation.org
To:     1vier1@web.de, akpm@linux-foundation.org, dbueso@suse.de,
        manfred@colorfullife.com, mm-commits@vger.kernel.org
Subject:  [folded-merged]
 ipc-utilc-use-binary-search-for-max_idx-fix.patch removed from -mm tree
Message-ID: <20210701010540.BR23cOaV-%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ipc-utilc-use-binary-search-for-max_idx-fix
has been removed from the -mm tree.  Its filename was
     ipc-utilc-use-binary-search-for-max_idx-fix.patch

This patch was dropped because it was folded into ipc-utilc-use-binary-search-for-max_idx.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: ipc-utilc-use-binary-search-for-max_idx-fix

tweak comment, fix typo

Cc: <1vier1@web.de>
Cc: Davidlohr Bueso <dbueso@suse.de>
Cc: Manfred Spraul <manfred@colorfullife.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/util.c |    4 ++--
 ipc/util.h |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

--- a/ipc/util.c~ipc-utilc-use-binary-search-for-max_idx-fix
+++ a/ipc/util.c
@@ -452,7 +452,7 @@ static void ipc_kht_remove(struct ipc_id
 }
 
 /**
- * ipc_search_maxidx - search the highest assigned index
+ * ipc_search_maxidx - search for the highest assigned index
  * @ids: ipc identifier set
  * @limit: known upper limit for highest assigned index
  *
@@ -462,7 +462,7 @@ static void ipc_kht_remove(struct ipc_id
  * object is deleted.
  * If no ipc object is allocated, then -1 is returned.
  *
- * ipc_ids.rwsem needs to be owned by the caller.
+ * ipc_ids.rwsem needs to be held by the caller.
  */
 static int ipc_search_maxidx(struct ipc_ids *ids, int limit)
 {
--- a/ipc/util.h~ipc-utilc-use-binary-search-for-max_idx-fix
+++ a/ipc/util.h
@@ -145,7 +145,7 @@ int ipcperms(struct ipc_namespace *ns, s
  * ipc_get_maxidx - get the highest assigned index
  * @ids: ipc identifier set
  *
- * The function returns the highest assinged index for @ids. The function
+ * The function returns the highest assigned index for @ids. The function
  * doesn't scan the idr tree, it uses a cached value.
  *
  * Called with ipc_ids.rwsem held for reading.
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

ipc-utilc-use-binary-search-for-max_idx.patch
mm.patch
lazy-tlb-allow-lazy-tlb-mm-refcounting-to-be-configurable-fix.patch
linux-next-pre.patch
linux-next-post.patch
linux-next-rejects.patch
kernel-cgroup-cgroupc-dont-export-cgroup_get_e_css-twice.patch
mm-introduce-memfd_secret-system-call-to-create-secret-memory-areas-fix.patch
module-add-printk-formats-to-add-module-build-id-to-stacktraces-fix.patch
module-add-printk-formats-to-add-module-build-id-to-stacktraces-fix-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch

