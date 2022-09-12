Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E202DECAAD3
	for <mm-commits@archiver.kernel.org>; Mon, 12 Sep 2022 03:30:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229799AbiILDa1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 11 Sep 2022 23:30:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229610AbiILD24 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 11 Sep 2022 23:28:56 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8017126541
        for <mm-commits@vger.kernel.org>; Sun, 11 Sep 2022 20:28:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 36311B80C6E
        for <mm-commits@vger.kernel.org>; Mon, 12 Sep 2022 03:28:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0AE4C433D6;
        Mon, 12 Sep 2022 03:28:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662953331;
        bh=v2LZClGjWTwYU7ergJQl5arIGmU6gHN1jr86N3C/eSg=;
        h=Date:To:From:Subject:From;
        b=YekMgod+CtffnTlice2YXDlYA+T+P47hQRdzwwSE4y72rPPJc0/4fo+1rwZ9e8vbi
         2gOL0uw3a8DdpMB16xvNQPApfohDVs0diEckLeQ3/OdtdZwLS4gU8ui7T0HPIsNgH/
         8XJ9TvPLbHKsOvdzdU69TBbbtR/kLgXX3/xjkDhY=
Date:   Sun, 11 Sep 2022 20:28:51 -0700
To:     mm-commits@vger.kernel.org, vbabka@suse.cz,
        roman.gushchin@linux.dev, rientjes@google.com, penberg@kernel.org,
        iamjoonsoo.kim@lge.com, glider@google.com, elver@google.com,
        dvyukov@google.com, cl@linux.com, 42.hyeyoo@gmail.com,
        imran.f.khan@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] kfence-add-sysfs-interface-to-disable-kfence-for-selected-slabs.patch removed from -mm tree
Message-Id: <20220912032851.D0AE4C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: kfence: add sysfs interface to disable kfence for selected slabs.
has been removed from the -mm tree.  Its filename was
     kfence-add-sysfs-interface-to-disable-kfence-for-selected-slabs.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Imran Khan <imran.f.khan@oracle.com>
Subject: kfence: add sysfs interface to disable kfence for selected slabs.
Date: Mon, 15 Aug 2022 05:53:53 +1000

By default kfence allocation can happen for any slab object, whose size is
up to PAGE_SIZE, as long as that allocation is the first allocation after
expiration of kfence sample interval.  But in certain debugging scenarios
we may be interested in debugging corruptions involving some specific slub
objects like dentry or ext4_* etc.  In such cases limiting kfence for
allocations involving only specific slub objects will increase the
probablity of catching the issue since kfence pool will not be consumed by
other slab objects.

This patch introduces a sysfs interface
'/sys/kernel/slab/<name>/skip_kfence' to disable kfence for specific
slabs.  Having the interface work in this way does not impact
current/default behavior of kfence and allows us to use kfence for
specific slabs (when needed) as well.  The decision to skip/use kfence is
taken depending on whether kmem_cache.flags has (newly introduced)
SLAB_SKIP_KFENCE flag set or not.

Link: https://lkml.kernel.org/r/20220814195353.2540848-1-imran.f.khan@oracle.com
Signed-off-by: Imran Khan <imran.f.khan@oracle.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Marco Elver <elver@google.com>
Reviewed-by: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/slab.h |    6 ++++++
 mm/kfence/core.c     |    7 +++++++
 mm/slub.c            |   26 ++++++++++++++++++++++++++
 3 files changed, 39 insertions(+)

--- a/include/linux/slab.h~kfence-add-sysfs-interface-to-disable-kfence-for-selected-slabs
+++ a/include/linux/slab.h
@@ -119,6 +119,12 @@
  */
 #define SLAB_NO_USER_FLAGS	((slab_flags_t __force)0x10000000U)
 
+#ifdef CONFIG_KFENCE
+#define SLAB_SKIP_KFENCE	((slab_flags_t __force)0x20000000U)
+#else
+#define SLAB_SKIP_KFENCE	0
+#endif
+
 /* The following flags affect the page allocator grouping pages by mobility */
 /* Objects are reclaimable */
 #define SLAB_RECLAIM_ACCOUNT	((slab_flags_t __force)0x00020000U)
--- a/mm/kfence/core.c~kfence-add-sysfs-interface-to-disable-kfence-for-selected-slabs
+++ a/mm/kfence/core.c
@@ -1003,6 +1003,13 @@ void *__kfence_alloc(struct kmem_cache *
 		return NULL;
 	}
 
+	/*
+	 * Skip allocations for this slab, if KFENCE has been disabled for
+	 * this slab.
+	 */
+	if (s->flags & SLAB_SKIP_KFENCE)
+		return NULL;
+
 	if (atomic_inc_return(&kfence_allocation_gate) > 1)
 		return NULL;
 #ifdef CONFIG_KFENCE_STATIC_KEYS
--- a/mm/slub.c~kfence-add-sysfs-interface-to-disable-kfence-for-selected-slabs
+++ a/mm/slub.c
@@ -5745,6 +5745,29 @@ STAT_ATTR(CPU_PARTIAL_NODE, cpu_partial_
 STAT_ATTR(CPU_PARTIAL_DRAIN, cpu_partial_drain);
 #endif	/* CONFIG_SLUB_STATS */
 
+#ifdef CONFIG_KFENCE
+static ssize_t skip_kfence_show(struct kmem_cache *s, char *buf)
+{
+	return sysfs_emit(buf, "%d\n", !!(s->flags & SLAB_SKIP_KFENCE));
+}
+
+static ssize_t skip_kfence_store(struct kmem_cache *s,
+			const char *buf, size_t length)
+{
+	int ret = length;
+
+	if (buf[0] == '0')
+		s->flags &= ~SLAB_SKIP_KFENCE;
+	else if (buf[0] == '1')
+		s->flags |= SLAB_SKIP_KFENCE;
+	else
+		ret = -EINVAL;
+
+	return ret;
+}
+SLAB_ATTR(skip_kfence);
+#endif
+
 static struct attribute *slab_attrs[] = {
 	&slab_size_attr.attr,
 	&object_size_attr.attr,
@@ -5812,6 +5835,9 @@ static struct attribute *slab_attrs[] =
 	&failslab_attr.attr,
 #endif
 	&usersize_attr.attr,
+#ifdef CONFIG_KFENCE
+	&skip_kfence_attr.attr,
+#endif
 
 	NULL
 };
_

Patches currently in -mm which might be from imran.f.khan@oracle.com are


