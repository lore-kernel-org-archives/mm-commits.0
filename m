From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 06/35] mm/page_alloc: make pcpu_drain_mutex and
 pcpu_drain static
Date: Fri, 10 Apr 2020 14:32:32 -0700
Message-ID: <20200410213232.hoECoQN6w%akpm@linux-foundation.org>
References: <20200410143047.bf34a933ce1affdc042c7c80@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:46378 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726582AbgDJVce (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 10 Apr 2020 17:32:34 -0400
In-Reply-To: <20200410143047.bf34a933ce1affdc042c7c80@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, hulkci@huawei.com, linux-mm@kvack.org, mm-commits@vger.kernel.org, torvalds@linux-foundation.org, yanaijie@huawei.com

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
