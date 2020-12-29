Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 647F7C433E6
	for <mm-commits@archiver.kernel.org>; Tue, 29 Dec 2020 21:12:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2D58B22209
	for <mm-commits@archiver.kernel.org>; Tue, 29 Dec 2020 21:12:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726138AbgL2VMp (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 29 Dec 2020 16:12:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:32768 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726111AbgL2VMp (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 29 Dec 2020 16:12:45 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 82F3721D94;
        Tue, 29 Dec 2020 21:12:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1609276324;
        bh=682E/N+Z2wxy1vi+ZmjcDZZMYgJM+gtP+1Jm9Qkhec4=;
        h=Date:From:To:Subject:From;
        b=cGJJsKBn5PRWUGdpSSJAR6sa0LadFdSympOczklr+ff4pEUeW26BAHJsgOhDdw7sw
         KAi4eHhnKvfvbDyp274q4FjeDHP43AMxfEqt8eW5hI2PN2BJRlnWx91uNi/caZVsXB
         kx/DC7W1msEBb4KuD40/H3JFmz6epEKg/BA0pwLM=
Date:   Tue, 29 Dec 2020 13:12:04 -0800
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, cl@linux.com, guro@fb.com,
        hannes@cmpxchg.org, mhocko@kernel.org, mm-commits@vger.kernel.org,
        shakeelb@google.com
Subject:  +
 mm-slub-call-account_slab_page-after-slab-page-initialization-fix.patch
 added to -mm tree
Message-ID: <20201229211204.sVDUtICpp%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-slub-call-account_slab_page-after-slab-page-initialization-fix
has been added to the -mm tree.  Its filename is
     mm-slub-call-account_slab_page-after-slab-page-initialization-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-slub-call-account_slab_page-after-slab-page-initialization-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-slub-call-account_slab_page-after-slab-page-initialization-fix.patch

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

mm-slub-call-account_slab_page-after-slab-page-initialization-fix.patch
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

