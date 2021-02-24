Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A2ACC433E0
	for <mm-commits@archiver.kernel.org>; Wed, 24 Feb 2021 19:09:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CF31564E90
	for <mm-commits@archiver.kernel.org>; Wed, 24 Feb 2021 19:08:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235957AbhBXTI5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 24 Feb 2021 14:08:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:39686 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235928AbhBXTIw (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 24 Feb 2021 14:08:52 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id EEFFF64E90;
        Wed, 24 Feb 2021 18:59:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614193147;
        bh=KCZ2BZornCqcYwx7wYYln82cUQ5B5g+Dnfj8njGJWpY=;
        h=Date:From:To:Subject:From;
        b=jS7qyDS9L1dOd22oK3/2OuP0WeBQXd6XA7u/FKOxytY1A5GpCXbOeBeZL4xCdEcj1
         zW9Q9jpKMMlvRu+SbReA5cBujuo1+tZhOa6nr8ZU2+0VCvA3HMM2+EBy159YNuKn2c
         zmvdfPvie46rEKqFbNvpWRGXx94tnx4715/NFVUU=
Date:   Wed, 24 Feb 2021 10:59:06 -0800
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, cl@linux.com, guro@fb.com,
        hannes@cmpxchg.org, mhocko@kernel.org, mm-commits@vger.kernel.org,
        shakeelb@google.com
Subject:  [folded-merged]
 =?US-ASCII?Q?mm-memcg-slab-pre-allocate-obj=5Fcgroups-for-slab-caches-wit?=
 =?US-ASCII?Q?h-slab=5Faccount-fix.patch?= removed from -mm tree
Message-ID: <20210224185906.KXmEOz7Ag%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-memcg-slab-pre-allocate-obj_cgroups-for-slab-caches-with-slab_account-fix
has been removed from the -mm tree.  Its filename was
     mm-memcg-slab-pre-allocate-obj_cgroups-for-slab-caches-with-slab_account-fix.patch

This patch was dropped because it was folded into mm-memcg-slab-pre-allocate-obj_cgroups-for-slab-caches-with-slab_account.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-memcg-slab-pre-allocate-obj_cgroups-for-slab-caches-with-slab_account-fix

fix it for
mm-slub-call-account_slab_page-after-slab-page-initialization-fix.patch

Cc: Christoph Lameter <cl@linux.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Roman Gushchin <guro@fb.com>
Cc: Shakeel Butt <shakeelb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/slub.c~mm-memcg-slab-pre-allocate-obj_cgroups-for-slab-caches-with-slab_account-fix
+++ a/mm/slub.c
@@ -1785,7 +1785,7 @@ static struct page *allocate_slab(struct
 
 	page->objects = oo_objects(oo);
 
-	account_slab_page(page, oo_order(oo), s);
+	account_slab_page(page, oo_order(oo), s, flags);
 
 	page->slab_cache = s;
 	__SetPageSlab(page);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-memcg-slab-pre-allocate-obj_cgroups-for-slab-caches-with-slab_account.patch
mm-memcontrol-optimize-per-lruvec-stats-counter-memory-usage-checkpatch-fixes.patch
mm-memcg-add-swapcache-stat-for-memcg-v2-fix.patch
kasan-add-match-all-tag-tests-fix-fix.patch
mm.patch
mm-cma-allocate-cma-areas-bottom-up-fix-3-fix.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings-fix-2.patch
mm-memory_hotplug-prevalidate-the-address-range-being-added-with-platform-fix.patch
bdi-use-might_alloc-fix.patch
kfence-kasan-make-kfence-compatible-with-kasan-fix.patch
lib-stackdepot-add-support-to-disable-stack-depot-fix.patch
seq_file-document-how-per-entry-resources-are-managed-fix.patch
initramfs-panic-with-memory-information-fix.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
kernel-forkc-export-kernel_thread-to-modules.patch

