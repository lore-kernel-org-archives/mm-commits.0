Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9387413E229
	for <mm-commits@vger.kernel.org>; Fri,  2 Feb 2024 12:13:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706875981; cv=none; b=tvcQuy3+omjeVAOxOQBrDSTfp7HusEHxVvkDTBjzJUxBbbv1kye6f1Yiu+YjOD7+1q9ZiDuqDwbSnp/Fl/NKBKCnvapEmZliTK3/D5xawGNhXOuCFEjsGFAellPT0kkJl0LQxOYOmG8BZNLk6SGszP+rQ0qoP6aV7UWiuHzZKLI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706875981; c=relaxed/simple;
	bh=hmfoocFo4YB2SvVU9EkRGmLBICw2iJfpl+M5zspcWRY=;
	h=Date:To:From:Subject:Message-Id; b=I0WSY7gTUo0MK3G5yXUJr18E4wvr14vgwlUeZ+ExIQ+NDHnM94Fr8yLvpTURFQfTmoOnVM+GAeXdBLNiiKg78aNn6hCNYObsNs9PylRSTJ2O9nTd/zQRr8IJ2i9Fpgr1NZ2C0G9nsX+rum72jLwP5Po4Y9CatLxmgGDMw9lLuMU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=TyPszXag; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="TyPszXag"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16E2FC433C7;
	Fri,  2 Feb 2024 12:13:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1706875981;
	bh=hmfoocFo4YB2SvVU9EkRGmLBICw2iJfpl+M5zspcWRY=;
	h=Date:To:From:Subject:From;
	b=TyPszXagoksLlcwN5RhUI3WypGrtwNjelRltACfYtemkzdGYP0FAVhwOcIlrCWbAX
	 LvWFGQi0ECzVeqIlbu7VOV5TwrDulhRI4PT2zuV8AjXizflcq91d1iJKu2moSFna+8
	 xJuODAre2KBIfp/V6U2x33RdfcTbyUH++e1XDVYY=
Date: Fri, 02 Feb 2024 04:12:59 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,p.raghav@samsung.com,mcgrof@kernel.org,hare@suse.com,djwong@kernel.org,david@fromorbit.com,da.gomez@samsung.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + xarray-add-cmpxchg-order-test.patch added to mm-unstable branch
Message-Id: <20240202121301.16E2FC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: XArray: add cmpxchg order test
has been added to the -mm mm-unstable branch.  Its filename is
     xarray-add-cmpxchg-order-test.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/xarray-add-cmpxchg-order-test.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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
@@ -1964,6 +2017,7 @@ static int xarray_checks(void)
 	check_xas_erase(&array);
 	check_insert(&array);
 	check_cmpxchg(&array);
+	check_cmpxchg_order(&array);
 	check_reserve(&array);
 	check_reserve(&xa0);
 	check_multi_store(&array);
_

Patches currently in -mm which might be from da.gomez@samsung.com are

xarray-add-cmpxchg-order-test.patch

