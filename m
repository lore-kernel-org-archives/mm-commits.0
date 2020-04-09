From: Andrew Morton <akpm@linux-foundation.org>
Subject: +
 mm-page_alloc-make-pcpu_drain_mutex-and-pcpu_drain-static.patch added to
 -mm tree
Date: Wed, 08 Apr 2020 18:30:49 -0700
Message-ID: <20200409013049.3qfl_dT4E%akpm@linux-foundation.org>
References: <20200406200254.a69ebd9e08c4074e41ddebaf@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:48644 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726523AbgDIBat (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 8 Apr 2020 21:30:49 -0400
In-Reply-To: <20200406200254.a69ebd9e08c4074e41ddebaf@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hulkci@huawei.com, mm-commits@vger.kernel.org, yanaijie@huawei.com


The patch titled
     Subject: mm/page_alloc: make pcpu_drain_mutex and pcpu_drain static
has been added to the -mm tree.  Its filename is
     mm-page_alloc-make-pcpu_drain_mutex-and-pcpu_drain-static.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-page_alloc-make-pcpu_drain_mutex-and-pcpu_drain-static.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-page_alloc-make-pcpu_drain_mutex-and-pcpu_drain-static.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-page_alloc-make-pcpu_drain_mutex-and-pcpu_drain-static.patch
