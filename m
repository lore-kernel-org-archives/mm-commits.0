Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7BCCEC433EF
	for <mm-commits@archiver.kernel.org>; Wed, 15 Sep 2021 03:37:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 61B4561244
	for <mm-commits@archiver.kernel.org>; Wed, 15 Sep 2021 03:37:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229980AbhIODjG (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 14 Sep 2021 23:39:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:60848 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229758AbhIODjG (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 14 Sep 2021 23:39:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B09EB60EB6;
        Wed, 15 Sep 2021 03:37:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1631677068;
        bh=4aeBqUKguKZcZcPVp/H0IEprkpsJU4p/K80IB2vGugw=;
        h=Date:From:To:Subject:From;
        b=s3ZbKpuCFrBVcv+jsAyMa+/JyDspshNCA7R0VJNr7KfP6lXYozYcn7X794ZZqsTuR
         DqpUCW1QG7pDfIQP7aCR67K8TvTn0/RH0/F/W9yYWmkk3qP41NF3ihl56lEbcjkmM7
         kkWI4L0/VVFAk2iquuk0BlRuDWYQHE0AXMVuH98c=
Date:   Tue, 14 Sep 2021 20:37:47 -0700
From:   akpm@linux-foundation.org
To:     davem@davemloft.net, horms@verge.net.au, kuba@kernel.org,
        liumh1@shanghaitech.edu.cn, marcelo.leitner@gmail.com,
        mm-commits@vger.kernel.org, pshelar@ovn.org,
        ulf.hansson@linaro.org, vyasevich@gmail.com, willy@infradead.org
Subject:  +
 include-linux-mmh-move-nr_free_buffer_pages-from-swaph-to-mmh.patch added
 to -mm tree
Message-ID: <20210915033747.w8w89QJxl%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: include/linux/mm.h: move nr_free_buffer_pages from swap.h to mm.h
has been added to the -mm tree.  Its filename is
     include-linux-mmh-move-nr_free_buffer_pages-from-swaph-to-mmh.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/include-linux-mmh-move-nr_free_buffer_pages-from-swaph-to-mmh.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/include-linux-mmh-move-nr_free_buffer_pages-from-swaph-to-mmh.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mianhan Liu <liumh1@shanghaitech.edu.cn>
Subject: include/linux/mm.h: move nr_free_buffer_pages from swap.h to mm.h

nr_free_buffer_pages could be exposed through mm.h instead of swap.h.  The
advantage of this change is that it can reduce the obsolete includes.  For
example, net/ipv4/tcp.c wouldn't need swap.h any more since it has already
included mm.h.  Similarly, after checking all the other files, it comes
that tcp.c, udp.c meter.c ,...  follow the same rule, so these files can
have swap.h removed too.

Moreover, after preprocessing all the files that use nr_free_buffer_pages,
it turns out that those files have already included mm.h.Thus, we can move
nr_free_buffer_pages from swap.h to mm.h safely.  This change will not
affect the compilation of other files.

Link: https://lkml.kernel.org/r/20210912133640.1624-1-liumh1@shanghaitech.edu.cn
Signed-off-by: Mianhan Liu <liumh1@shanghaitech.edu.cn>
Cc: Jakub Kicinski <kuba@kernel.org>
CC: Ulf Hansson <ulf.hansson@linaro.org>
Cc: "David S . Miller" <davem@davemloft.net>
Cc: Simon Horman <horms@verge.net.au>
Cc: Pravin B Shelar <pshelar@ovn.org>
Cc: Vlad Yasevich <vyasevich@gmail.com>
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/core/mmc_test.c    |    1 -
 include/linux/mm.h             |    2 ++
 include/linux/swap.h           |    1 -
 net/ipv4/tcp.c                 |    1 -
 net/ipv4/udp.c                 |    1 -
 net/netfilter/ipvs/ip_vs_ctl.c |    1 -
 net/openvswitch/meter.c        |    1 -
 net/sctp/protocol.c            |    1 -
 8 files changed, 2 insertions(+), 7 deletions(-)

--- a/drivers/mmc/core/mmc_test.c~include-linux-mmh-move-nr_free_buffer_pages-from-swaph-to-mmh
+++ a/drivers/mmc/core/mmc_test.c
@@ -10,7 +10,6 @@
 #include <linux/slab.h>
 
 #include <linux/scatterlist.h>
-#include <linux/swap.h>		/* For nr_free_buffer_pages() */
 #include <linux/list.h>
 
 #include <linux/debugfs.h>
--- a/include/linux/mm.h~include-linux-mmh-move-nr_free_buffer_pages-from-swaph-to-mmh
+++ a/include/linux/mm.h
@@ -875,6 +875,8 @@ void put_pages_list(struct list_head *pa
 void split_page(struct page *page, unsigned int order);
 void copy_huge_page(struct page *dst, struct page *src);
 
+unsigned long nr_free_buffer_pages(void);
+
 /*
  * Compound pages have a destructor function.  Provide a
  * prototype for that function and accessor functions.
--- a/include/linux/swap.h~include-linux-mmh-move-nr_free_buffer_pages-from-swaph-to-mmh
+++ a/include/linux/swap.h
@@ -335,7 +335,6 @@ void workingset_update_node(struct xa_no
 
 /* linux/mm/page_alloc.c */
 extern unsigned long totalreserve_pages;
-extern unsigned long nr_free_buffer_pages(void);
 
 /* Definition of global_zone_page_state not available yet */
 #define nr_free_pages() global_zone_page_state(NR_FREE_PAGES)
--- a/net/ipv4/tcp.c~include-linux-mmh-move-nr_free_buffer_pages-from-swaph-to-mmh
+++ a/net/ipv4/tcp.c
@@ -260,7 +260,6 @@
 #include <linux/random.h>
 #include <linux/memblock.h>
 #include <linux/highmem.h>
-#include <linux/swap.h>
 #include <linux/cache.h>
 #include <linux/err.h>
 #include <linux/time.h>
--- a/net/ipv4/udp.c~include-linux-mmh-move-nr_free_buffer_pages-from-swaph-to-mmh
+++ a/net/ipv4/udp.c
@@ -78,7 +78,6 @@
 #include <asm/ioctls.h>
 #include <linux/memblock.h>
 #include <linux/highmem.h>
-#include <linux/swap.h>
 #include <linux/types.h>
 #include <linux/fcntl.h>
 #include <linux/module.h>
--- a/net/netfilter/ipvs/ip_vs_ctl.c~include-linux-mmh-move-nr_free_buffer_pages-from-swaph-to-mmh
+++ a/net/netfilter/ipvs/ip_vs_ctl.c
@@ -24,7 +24,6 @@
 #include <linux/sysctl.h>
 #include <linux/proc_fs.h>
 #include <linux/workqueue.h>
-#include <linux/swap.h>
 #include <linux/seq_file.h>
 #include <linux/slab.h>
 
--- a/net/openvswitch/meter.c~include-linux-mmh-move-nr_free_buffer_pages-from-swaph-to-mmh
+++ a/net/openvswitch/meter.c
@@ -12,7 +12,6 @@
 #include <linux/openvswitch.h>
 #include <linux/netlink.h>
 #include <linux/rculist.h>
-#include <linux/swap.h>
 
 #include <net/netlink.h>
 #include <net/genetlink.h>
--- a/net/sctp/protocol.c~include-linux-mmh-move-nr_free_buffer_pages-from-swaph-to-mmh
+++ a/net/sctp/protocol.c
@@ -33,7 +33,6 @@
 #include <linux/seq_file.h>
 #include <linux/memblock.h>
 #include <linux/highmem.h>
-#include <linux/swap.h>
 #include <linux/slab.h>
 #include <net/net_namespace.h>
 #include <net/protocol.h>
_

Patches currently in -mm which might be from liumh1@shanghaitech.edu.cn are

include-linux-mmh-move-nr_free_buffer_pages-from-swaph-to-mmh.patch

