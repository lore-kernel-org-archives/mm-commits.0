Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF48BC433DB
	for <mm-commits@archiver.kernel.org>; Tue, 29 Dec 2020 23:05:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BCC7321D1B
	for <mm-commits@archiver.kernel.org>; Tue, 29 Dec 2020 23:05:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726158AbgL2XFz (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 29 Dec 2020 18:05:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:33186 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726144AbgL2XFz (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 29 Dec 2020 18:05:55 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7A0FB21D1B;
        Tue, 29 Dec 2020 23:05:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1609283114;
        bh=kcHXtZK+oVxHAJPSFiWMMuZgWxop2efDBDXLgp4dwLk=;
        h=Date:From:To:Subject:From;
        b=HffiD8RNQxVrux8sIjBOOEOdlNNCMcQGYQ7xFowiH9SdO7+yXuQXyfZDtbYP3odak
         IscZkVxFWK1bU3+6HECK7dwLpJ6wXx5/OzjA2hXbLyOH6vBCEIp3bgRb7EVC5+R+U9
         GoH2Wg4QUvV8BtjiCmUisqojQCUnZvq/FBd/ztdk=
Date:   Tue, 29 Dec 2020 15:05:14 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, shakeelb@google.com, mhocko@kernel.org,
        hannes@cmpxchg.org, guro@fb.com, cl@linux.com,
        akpm@linux-foundation.org
Subject:  [folded-merged]
 mm-slub-call-account_slab_page-after-slab-page-initialization-fix.patch
 removed from -mm tree
Message-ID: <20201229230514.8211b%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-slub-call-account_slab_page-after-slab-page-initialization-fix
has been removed from the -mm tree.  Its filename was
     mm-slub-call-account_slab_page-after-slab-page-initialization-fix.patch

This patch was dropped because it was folded into mm-slub-call-account_slab_page-after-slab-page-initialization.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-slub-call-account_slab_page-after-slab-page-initialization-fix

undo changes needed by forthcoming
mm-memcg-slab-pre-allocate-obj_cgroups-for-slab-caches-with-slab_account.patch

Cc: Christoph Lameter <cl@linux.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Roman Gushchin <guro@fb.com>
Cc: Shakeel Butt <shakeelb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/slub.c~mm-slub-call-account_slab_page-after-slab-page-initialization-fix
+++ a/mm/slub.c
@@ -1771,7 +1771,7 @@ static struct page *allocate_slab(struct
 
 	page->objects = oo_objects(oo);
 
-	account_slab_page(page, oo_order(oo), s, flags);
+	account_slab_page(page, oo_order(oo), s);
 
 	page->slab_cache = s;
 	__SetPageSlab(page);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-slub-call-account_slab_page-after-slab-page-initialization.patch
mm-page_alloc-add-a-missing-mm_page_alloc_zone_locked-tracepoint-fix.patch
mm.patch
mm-memcg-slab-pre-allocate-obj_cgroups-for-slab-caches-with-slab_account-fix.patch
mm-memcontrol-optimize-per-lruvec-stats-counter-memory-usage-checkpatch-fixes.patch
mm-fix-initialization-of-struct-page-for-holes-in-memory-layout-checkpatch-fixes.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings-fix-2.patch
kfence-kasan-make-kfence-compatible-with-kasan-fix.patch
linux-next-git-rejects.patch
set_memory-allow-set_direct_map__noflush-for-multiple-pages-fix.patch
arch-mm-wire-up-memfd_secret-system-call-were-relevant-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch

