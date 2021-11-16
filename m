Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D1B7C433EF
	for <mm-commits@archiver.kernel.org>; Tue, 16 Nov 2021 04:06:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 716DC63211
	for <mm-commits@archiver.kernel.org>; Tue, 16 Nov 2021 04:06:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240304AbhKPEJR (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 15 Nov 2021 23:09:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:52036 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241682AbhKPEIv (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 15 Nov 2021 23:08:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A282F61A58;
        Tue, 16 Nov 2021 04:05:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1637035551;
        bh=ZrYEVeDTteoN4mv2ey158amN98IKqqlnH8x98xMxG04=;
        h=Date:From:To:Subject:From;
        b=Sma6HwDTjoqnhe4CEUcfQWUOIzlUpuD1BermE8QqcPlgahoei7OnJgPdk8lzzlZFQ
         ZeU1jZCl2uYjP3zz61/ly+6plL1OfepTlqIZe7qyhm0oQGyEqUfZ3HAwulQzizOL2i
         9gevF18tO2kg2Pw7TivJzJNQCMYr+sdN9VifuNDU=
Date:   Mon, 15 Nov 2021 20:05:51 -0800
From:   akpm@linux-foundation.org
To:     cl@linux.com, iamjoonsoo.kim@lge.com, mm-commits@vger.kernel.org,
        penberg@kernel.org, rientjes@google.com, songmuchun@bytedance.com,
        vbabka@suse.cz
Subject:  + mm-slab-make-slab-iterator-functions-static.patch added
 to -mm tree
Message-ID: <20211116040551.DGmQfiUo_%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: slab: make slab iterator functions static
has been added to the -mm tree.  Its filename is
     mm-slab-make-slab-iterator-functions-static.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-slab-make-slab-iterator-functions-static.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-slab-make-slab-iterator-functions-static.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Muchun Song <songmuchun@bytedance.com>
Subject: mm: slab: make slab iterator functions static

There is no external users of slab_start/next/stop(), so make them static.
And the memory.kmem.slabinfo is deprecated, which outputs nothing now, so
move memcg_slab_show() into mm/memcontrol.c and rename it to
mem_cgroup_slab_show to be consistent with other function names.

Link: https://lkml.kernel.org/r/20211109133359.32881-1-songmuchun@bytedance.com
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c  |   13 ++++++++++++-
 mm/slab.h        |    5 -----
 mm/slab_common.c |   17 +++--------------
 3 files changed, 15 insertions(+), 20 deletions(-)

--- a/mm/memcontrol.c~mm-slab-make-slab-iterator-functions-static
+++ a/mm/memcontrol.c
@@ -4845,6 +4845,17 @@ out_kfree:
 	return ret;
 }
 
+#if defined(CONFIG_MEMCG_KMEM) && (defined(CONFIG_SLAB) || defined(CONFIG_SLUB_DEBUG))
+static int mem_cgroup_slab_show(struct seq_file *m, void *p)
+{
+	/*
+	 * Deprecated.
+	 * Please, take a look at tools/cgroup/slabinfo.py .
+	 */
+	return 0;
+}
+#endif
+
 static struct cftype mem_cgroup_legacy_files[] = {
 	{
 		.name = "usage_in_bytes",
@@ -4945,7 +4956,7 @@ static struct cftype mem_cgroup_legacy_f
 	(defined(CONFIG_SLAB) || defined(CONFIG_SLUB_DEBUG))
 	{
 		.name = "kmem.slabinfo",
-		.seq_show = memcg_slab_show,
+		.seq_show = mem_cgroup_slab_show,
 	},
 #endif
 	{
--- a/mm/slab_common.c~mm-slab-make-slab-iterator-functions-static
+++ a/mm/slab_common.c
@@ -1044,18 +1044,18 @@ static void print_slabinfo_header(struct
 	seq_putc(m, '\n');
 }
 
-void *slab_start(struct seq_file *m, loff_t *pos)
+static void *slab_start(struct seq_file *m, loff_t *pos)
 {
 	mutex_lock(&slab_mutex);
 	return seq_list_start(&slab_caches, *pos);
 }
 
-void *slab_next(struct seq_file *m, void *p, loff_t *pos)
+static void *slab_next(struct seq_file *m, void *p, loff_t *pos)
 {
 	return seq_list_next(p, &slab_caches, pos);
 }
 
-void slab_stop(struct seq_file *m, void *p)
+static void slab_stop(struct seq_file *m, void *p)
 {
 	mutex_unlock(&slab_mutex);
 }
@@ -1123,17 +1123,6 @@ void dump_unreclaimable_slab(void)
 	mutex_unlock(&slab_mutex);
 }
 
-#if defined(CONFIG_MEMCG_KMEM)
-int memcg_slab_show(struct seq_file *m, void *p)
-{
-	/*
-	 * Deprecated.
-	 * Please, take a look at tools/cgroup/slabinfo.py .
-	 */
-	return 0;
-}
-#endif
-
 /*
  * slabinfo_op - iterator that generates /proc/slabinfo
  *
--- a/mm/slab.h~mm-slab-make-slab-iterator-functions-static
+++ a/mm/slab.h
@@ -575,11 +575,6 @@ static inline struct kmem_cache_node *ge
 
 #endif
 
-void *slab_start(struct seq_file *m, loff_t *pos);
-void *slab_next(struct seq_file *m, void *p, loff_t *pos);
-void slab_stop(struct seq_file *m, void *p);
-int memcg_slab_show(struct seq_file *m, void *p);
-
 #if defined(CONFIG_SLAB) || defined(CONFIG_SLUB_DEBUG)
 void dump_unreclaimable_slab(void);
 #else
_

Patches currently in -mm which might be from songmuchun@bytedance.com are

mm-slab-make-slab-iterator-functions-static.patch

