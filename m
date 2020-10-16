Return-Path: <SRS0=zz/k=DX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC5DEC433E7
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 20:48:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 800EA216C4
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 20:48:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602881282;
	bh=EQJV0VbgZ/k1ws1c+WDaSAZW5uK91JZFsTrgs+/a/U0=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=YvdCfMyOD/e94RfN4qvbv5MQ4k6wnK/dy/uGdeiXMiNPLg1o+WRh+txF92jyvyDsV
	 cZmRiBdXfJeee23Dm38FSlO5KfM69iQlTlYWDKUUQoa1hK7ess/ulb3utqmlMXCzWr
	 LclnqtTZkP1vMe1KtQ/Fzn+80N9kFQt5aDYtSZ6c=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391117AbgJPUsC (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 16 Oct 2020 16:48:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:37632 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392676AbgJPUsB (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 16 Oct 2020 16:48:01 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D398421655;
        Fri, 16 Oct 2020 20:48:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602881281;
        bh=EQJV0VbgZ/k1ws1c+WDaSAZW5uK91JZFsTrgs+/a/U0=;
        h=Date:From:To:Subject:From;
        b=UQ6A7GC+eORyhjyXjLwUCUCVMDLjR9lu3aEUO4Kkt6BP3d9oBbl2HTm8A7Fd7SO1g
         W2XoM9tP+js9/z44JYmel8uwHjf1OIyyZgPFmM1MidMWd4jmgiEYo2VZDQ7+DG+byc
         6yU7rTLuv91/aYqIEEMkrPDHJK9Kt702t4YCanhU=
Date:   Fri, 16 Oct 2020 13:48:00 -0700
From:   akpm@linux-foundation.org
To:     cai@lca.pw, kirill@shutemov.name, mm-commits@vger.kernel.org,
        songliubraving@fb.com, willy@infradead.org
Subject:  [merged] xarray-add-xa_get_order.patch removed from -mm
 tree
Message-ID: <20201016204800.hkiVIaTFc%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: XArray: add xa_get_order
has been removed from the -mm tree.  Its filename was
     xarray-add-xa_get_order.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: XArray: add xa_get_order

Patch series "Fix read-only THP for non-tmpfs filesystems".

As described more verbosely in the [3/3] changelog, we can inadvertently
put an order-0 page in the page cache which occupies 512 consecutive
entries.  Users are running into this if they enable the
READ_ONLY_THP_FOR_FS config option; see
https://bugzilla.kernel.org/show_bug.cgi?id=206569 and Qian Cai has also
reported it here:
https://lore.kernel.org/lkml/20200616013309.GB815@lca.pw/

This is a rather intrusive way of fixing the problem, but has the
advantage that I've actually been testing it with the THP patches, which
means that it sees far more use than it does upstream -- indeed, Song has
been entirely unable to reproduce it.  It also has the advantage that it
removes a few patches from my gargantuan backlog of THP patches.


This patch (of 3):

This function returns the order of the entry at the index.  We need this
because there isn't space in the shadow entry to encode its order.

[akpm@linux-foundation.org: export xa_get_order to modules]
Link: https://lkml.kernel.org/r/20200903183029.14930-1-willy@infradead.org
Link: https://lkml.kernel.org/r/20200903183029.14930-2-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: "Kirill A . Shutemov" <kirill@shutemov.name>
Cc: Qian Cai <cai@lca.pw>
Cc: Song Liu <songliubraving@fb.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/xarray.h |    9 ++++++++
 lib/test_xarray.c      |   21 ++++++++++++++++++++
 lib/xarray.c           |   40 +++++++++++++++++++++++++++++++++++++++
 3 files changed, 70 insertions(+)

--- a/include/linux/xarray.h~xarray-add-xa_get_order
+++ a/include/linux/xarray.h
@@ -1505,6 +1505,15 @@ void xas_pause(struct xa_state *);
 
 void xas_create_range(struct xa_state *);
 
+#ifdef CONFIG_XARRAY_MULTI
+int xa_get_order(struct xarray *, unsigned long index);
+#else
+static inline int xa_get_order(struct xarray *xa, unsigned long index)
+{
+	return 0;
+}
+#endif
+
 /**
  * xas_reload() - Refetch an entry from the xarray.
  * @xas: XArray operation state.
--- a/lib/test_xarray.c~xarray-add-xa_get_order
+++ a/lib/test_xarray.c
@@ -1649,6 +1649,26 @@ static noinline void check_account(struc
 #endif
 }
 
+static noinline void check_get_order(struct xarray *xa)
+{
+	unsigned int max_order = IS_ENABLED(CONFIG_XARRAY_MULTI) ? 20 : 1;
+	unsigned int order;
+	unsigned long i, j;
+
+	for (i = 0; i < 3; i++)
+		XA_BUG_ON(xa, xa_get_order(xa, i) != 0);
+
+	for (order = 0; order < max_order; order++) {
+		for (i = 0; i < 10; i++) {
+			xa_store_order(xa, i << order, order,
+					xa_mk_index(i << order), GFP_KERNEL);
+			for (j = i << order; j < (i + 1) << order; j++)
+				XA_BUG_ON(xa, xa_get_order(xa, j) != order);
+			xa_erase(xa, i << order);
+		}
+	}
+}
+
 static noinline void check_destroy(struct xarray *xa)
 {
 	unsigned long index;
@@ -1697,6 +1717,7 @@ static int xarray_checks(void)
 	check_reserve(&array);
 	check_reserve(&xa0);
 	check_multi_store(&array);
+	check_get_order(&array);
 	check_xa_alloc();
 	check_find(&array);
 	check_find_entry(&array);
--- a/lib/xarray.c~xarray-add-xa_get_order
+++ a/lib/xarray.c
@@ -1592,6 +1592,46 @@ unlock:
 	return xas_result(&xas, NULL);
 }
 EXPORT_SYMBOL(xa_store_range);
+
+/**
+ * xa_get_order() - Get the order of an entry.
+ * @xa: XArray.
+ * @index: Index of the entry.
+ *
+ * Return: A number between 0 and 63 indicating the order of the entry.
+ */
+int xa_get_order(struct xarray *xa, unsigned long index)
+{
+	XA_STATE(xas, xa, index);
+	void *entry;
+	int order = 0;
+
+	rcu_read_lock();
+	entry = xas_load(&xas);
+
+	if (!entry)
+		goto unlock;
+
+	if (!xas.xa_node)
+		goto unlock;
+
+	for (;;) {
+		unsigned int slot = xas.xa_offset + (1 << order);
+
+		if (slot >= XA_CHUNK_SIZE)
+			break;
+		if (!xa_is_sibling(xas.xa_node->slots[slot]))
+			break;
+		order++;
+	}
+
+	order += xas.xa_node->shift;
+unlock:
+	rcu_read_unlock();
+
+	return order;
+}
+EXPORT_SYMBOL(xa_get_order);
 #endif /* CONFIG_XARRAY_MULTI */
 
 /**
_

Patches currently in -mm which might be from willy@infradead.org are

mm-update-the-documentation-for-vfree.patch

