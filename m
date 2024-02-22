Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1ACEA320B
	for <mm-commits@vger.kernel.org>; Thu, 22 Feb 2024 00:02:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708560151; cv=none; b=cVR2+noFd68+fINZRrYvs8s1XAY6DdEVs9wbEbkWrt10PGVwOmE1wQMen4/6RP+sBIoqBPQdqXwIiiJW/I5Foe+oIl1kxFCJPD39bi7i2/A8odvjg3EW+hIpACgb01qMVAD2PhjmEly4H1oKjo4DXRzArPGtMwjPH8+8Hp1iYTY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708560151; c=relaxed/simple;
	bh=ENyUS9NXugJbqVz+n9pQPeGgaAE5AOcp95Ptz0iPt0c=;
	h=Date:To:From:Subject:Message-Id; b=mt4n65TiLUSX1pAlsVzst180H+2REmhiJLvYVb6a85az/wqkWBk8oaXHlvgVlfZSWOM+5jf2aQk66sZoVgqe6gTgEFdVxqI1UGkOygsgx5G4UxgIDgzo2NdcIPgvSp7D6N5hT32Psb5U0yXo2KZz4obE8owi40Fwv0/Qz+LRaSI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=lN/CuTWQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="lN/CuTWQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB38FC433F1;
	Thu, 22 Feb 2024 00:02:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708560151;
	bh=ENyUS9NXugJbqVz+n9pQPeGgaAE5AOcp95Ptz0iPt0c=;
	h=Date:To:From:Subject:From;
	b=lN/CuTWQmvVTPBUNMXQix7x+jnTgm5ZdJKkNJnZ6i/Y9EyA1xlwegedBOF8hbbqiC
	 dkOGA5tn33nVmkKoJA1MkTWpylMEyA5RmFCCVNf0PsvgiccYR34f0yORKuy9iU2qTK
	 +wDp4pY79+PcHX2X/Ww8cJeTPs8kHq066OvJlNDg=
Date: Wed, 21 Feb 2024 16:02:30 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,p.raghav@samsung.com,mcgrof@kernel.org,hare@suse.com,djwong@kernel.org,david@fromorbit.com,da.gomez@samsung.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] xarray-add-cmpxchg-order-test.patch removed from -mm tree
Message-Id: <20240222000230.DB38FC433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: XArray: add cmpxchg order test
has been removed from the -mm tree.  Its filename was
     xarray-add-cmpxchg-order-test.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Daniel Gomez <da.gomez@samsung.com>
Subject: XArray: add cmpxchg order test
Date: Wed, 31 Jan 2024 14:51:25 -0800

XArray multi-index entries do not keep track of the order stored once the
entry is being marked as used with cmpxchg (conditionally replaced with
NULL).  Add a test to check the order is actually lost.  The test also
verifies the order and entries for all the tied indexes before and after
the NULL replacement with xa_cmpxchg.

Add another entry at 1 << order that keeps the node around and the order
information for the NULL-entry after xa_cmpxchg.

Link: https://lkml.kernel.org/r/20240131225125.1370598-3-mcgrof@kernel.org
Signed-off-by: Daniel Gomez <da.gomez@samsung.com>
Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
Cc: Darrick J. Wong <djwong@kernel.org>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Hannes Reinecke <hare@suse.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Pankaj Raghav <p.raghav@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_xarray.c |   54 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 54 insertions(+)

--- a/lib/test_xarray.c~xarray-add-cmpxchg-order-test
+++ a/lib/test_xarray.c
@@ -423,6 +423,59 @@ static noinline void check_cmpxchg(struc
 	XA_BUG_ON(xa, !xa_empty(xa));
 }
 
+static noinline void check_cmpxchg_order(struct xarray *xa)
+{
+#ifdef CONFIG_XARRAY_MULTI
+	void *FIVE = xa_mk_value(5);
+	unsigned int i, order = 3;
+
+	XA_BUG_ON(xa, xa_store_order(xa, 0, order, FIVE, GFP_KERNEL));
+
+	/* Check entry FIVE has the order saved */
+	XA_BUG_ON(xa, xa_get_order(xa, xa_to_value(FIVE)) != order);
+
+	/* Check all the tied indexes have the same entry and order */
+	for (i = 0; i < (1 << order); i++) {
+		XA_BUG_ON(xa, xa_load(xa, i) != FIVE);
+		XA_BUG_ON(xa, xa_get_order(xa, i) != order);
+	}
+
+	/* Ensure that nothing is stored at index '1 << order' */
+	XA_BUG_ON(xa, xa_load(xa, 1 << order) != NULL);
+
+	/*
+	 * Additionally, keep the node information and the order at
+	 * '1 << order'
+	 */
+	XA_BUG_ON(xa, xa_store_order(xa, 1 << order, order, FIVE, GFP_KERNEL));
+	for (i = (1 << order); i < (1 << order) + (1 << order) - 1; i++) {
+		XA_BUG_ON(xa, xa_load(xa, i) != FIVE);
+		XA_BUG_ON(xa, xa_get_order(xa, i) != order);
+	}
+
+	/* Conditionally replace FIVE entry at index '0' with NULL */
+	XA_BUG_ON(xa, xa_cmpxchg(xa, 0, FIVE, NULL, GFP_KERNEL) != FIVE);
+
+	/* Verify the order is lost at FIVE (and old) entries */
+	XA_BUG_ON(xa, xa_get_order(xa, xa_to_value(FIVE)) != 0);
+
+	/* Verify the order and entries are lost in all the tied indexes */
+	for (i = 0; i < (1 << order); i++) {
+		XA_BUG_ON(xa, xa_load(xa, i) != NULL);
+		XA_BUG_ON(xa, xa_get_order(xa, i) != 0);
+	}
+
+	/* Verify node and order are kept at '1 << order' */
+	for (i = (1 << order); i < (1 << order) + (1 << order) - 1; i++) {
+		XA_BUG_ON(xa, xa_load(xa, i) != FIVE);
+		XA_BUG_ON(xa, xa_get_order(xa, i) != order);
+	}
+
+	xa_store_order(xa, 0, BITS_PER_LONG - 1, NULL, GFP_KERNEL);
+	XA_BUG_ON(xa, !xa_empty(xa));
+#endif
+}
+
 static noinline void check_reserve(struct xarray *xa)
 {
 	void *entry;
@@ -1976,6 +2029,7 @@ static int xarray_checks(void)
 	check_xas_erase(&array);
 	check_insert(&array);
 	check_cmpxchg(&array);
+	check_cmpxchg_order(&array);
 	check_reserve(&array);
 	check_reserve(&xa0);
 	check_multi_store(&array);
_

Patches currently in -mm which might be from da.gomez@samsung.com are


