From: akpm@linux-foundation.org
Subject: [merged]
 mm-page_alloc-make-pcpu_drain_mutex-and-pcpu_drain-static.patch removed
 from -mm tree
Date: Sat, 11 Apr 2020 23:44:41 -0700
Message-ID: <20200412064441.LGH35WjLa%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:58966 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725832AbgDLGol (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 12 Apr 2020 02:44:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hulkci@huawei.com, mm-commits@vger.kernel.org, yanaijie@huawei.com


The patch titled
     Subject: mm/page_alloc: make pcpu_drain_mutex and pcpu_drain static
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-make-pcpu_drain_mutex-and-pcpu_drain-static.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jason Yan <yanaijie@huawei.com>
Subject: mm/page_alloc: make pcpu_drain_mutex and pcpu_drain static

Fix the following sparse warning:

mm/page_alloc.c:106:1: warning: symbol 'pcpu_drain_mutex' was not
declared. Should it be static?
mm/page_alloc.c:107:1: warning: symbol '__pcpu_scope_pcpu_drain' was not
declared. Should it be static?

Link: http://lkml.kernel.org/r/20200407023925.46438-1-yanaijie@huawei.com
Signed-off-by: Jason Yan <yanaijie@huawei.com>
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-make-pcpu_drain_mutex-and-pcpu_drain-static
+++ a/mm/page_alloc.c
@@ -103,8 +103,8 @@ struct pcpu_drain {
 	struct zone *zone;
 	struct work_struct work;
 };
-DEFINE_MUTEX(pcpu_drain_mutex);
-DEFINE_PER_CPU(struct pcpu_drain, pcpu_drain);
+static DEFINE_MUTEX(pcpu_drain_mutex);
+static DEFINE_PER_CPU(struct pcpu_drain, pcpu_drain);
 
 #ifdef CONFIG_GCC_PLUGIN_LATENT_ENTROPY
 volatile unsigned long latent_entropy __latent_entropy;
_

Patches currently in -mm which might be from yanaijie@huawei.com are
