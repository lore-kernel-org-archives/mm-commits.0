Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 375CD1426A
	for <mm-commits@vger.kernel.org>; Fri,  2 Feb 2024 12:12:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706875979; cv=none; b=ZkuIpxfp2t9hK6MVD9DSUGO3mKY/HW48Uw/O/TheZiP1QRmUPjcGqcfYfnEky0JLeJEdxdHW3aJiAimSktxRZLGwUoDzKzGLPYF0aE+P8lzILvmT6b5yqWKTfvo+8CRYCab6hoqnll8vv4EpdzYHrNtRPspNfxKyDQlhTcjtMGg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706875979; c=relaxed/simple;
	bh=0/YuQUkkW1uvp0Iv/lOxcFpynYfMNrUfelvR0Pyw830=;
	h=Date:To:From:Subject:Message-Id; b=rL5MlISFt6ZX6Q26mN85i08d7Ob4eRD7AyGQQFbWVUEioNkLbhBPjsIKGZ8xTkcD/7vXTtWHONeKIpBc1PngH6n58WI1OGkeVkzSqpMYgwiVQNuoRFutZjBi968QSfvtIe9GtXZIiKQCLg/uO2UB1Hb6J7UGjK9hskMAjcVGl+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=J4mtd/II; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="J4mtd/II"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4396EC433F1;
	Fri,  2 Feb 2024 12:12:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1706875978;
	bh=0/YuQUkkW1uvp0Iv/lOxcFpynYfMNrUfelvR0Pyw830=;
	h=Date:To:From:Subject:From;
	b=J4mtd/IIHL/UD3ERSFWWDSAuNoVinqztGqSBG9nillm9Mm9D1P+iNKHJokad05UFh
	 v604JxtSIdDOZHbOTkWdn50reZtRIGU8RtPwFY+n/8g7Cb4jlgI8lyEQ8pKRKfrRNO
	 97VEv+pLbWLkx+YwzffIeg/MZAHYpN67epCKfRhE=
Date: Fri, 02 Feb 2024 04:12:55 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,p.raghav@samsung.com,hare@suse.com,djwong@kernel.org,david@fromorbit.com,da.gomez@samsung.com,mcgrof@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + test_xarray-add-tests-for-advanced-multi-index-use.patch added to mm-unstable branch
Message-Id: <20240202121258.4396EC433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: test_xarray: add tests for advanced multi-index use
has been added to the -mm mm-unstable branch.  Its filename is
     test_xarray-add-tests-for-advanced-multi-index-use.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/test_xarray-add-tests-for-advanced-multi-index-use.patch

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
From: Luis Chamberlain <mcgrof@kernel.org>
Subject: test_xarray: add tests for advanced multi-index use
Date: Wed, 31 Jan 2024 14:51:24 -0800

Patch series "test_xarray: advanced API multi-index tests", v2.

This is a respin of the test_xarray multi-index tests [0] which use and
demonstrate the advanced API which is used by the page cache.  This should
let folks more easily follow how we use multi-index to support for example
a min order later in the page cache.  It also lets us grow the selftests
to mimic more of what we do in the page cache.


This patch (of 2):

The multi index selftests are great but they don't replicate how we deal
with the page cache exactly, which makes it a bit hard to follow as the
page cache uses the advanced API.

Add tests which use the advanced API, mimicking what we do in the page
cache, while at it, extend the example to do what is needed for min order
support.

Link: https://lkml.kernel.org/r/20240131225125.1370598-1-mcgrof@kernel.org
Link: https://lkml.kernel.org/r/20240131225125.1370598-2-mcgrof@kernel.org
Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
Tested-by: Daniel Gomez <da.gomez@samsung.com>
Cc: Darrick J. Wong <djwong@kernel.org>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Hannes Reinecke <hare@suse.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Pankaj Raghav <p.raghav@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_xarray.c |  164 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 164 insertions(+)

--- a/lib/test_xarray.c~test_xarray-add-tests-for-advanced-multi-index-use
+++ a/lib/test_xarray.c
@@ -674,6 +674,169 @@ static noinline void check_multi_store(s
 #endif
 }
 
+#ifdef CONFIG_XARRAY_MULTI
+/* mimics page cache __filemap_add_folio() */
+static noinline void check_xa_multi_store_adv_add(struct xarray *xa,
+						  unsigned long index,
+						  unsigned int order,
+						  void *p)
+{
+	XA_STATE(xas, xa, index);
+	unsigned int nrpages = 1UL << order;
+
+	/* users are responsible for index alignemnt to the order when adding */
+	XA_BUG_ON(xa, index & (nrpages - 1));
+
+	xas_set_order(&xas, index, order);
+
+	do {
+		xas_lock_irq(&xas);
+
+		xas_store(&xas, p);
+		XA_BUG_ON(xa, xas_error(&xas));
+		XA_BUG_ON(xa, xa_load(xa, index) != p);
+
+		xas_unlock_irq(&xas);
+	} while (xas_nomem(&xas, GFP_KERNEL));
+
+	XA_BUG_ON(xa, xas_error(&xas));
+}
+
+/* mimics page_cache_delete() */
+static noinline void check_xa_multi_store_adv_del_entry(struct xarray *xa,
+							unsigned long index,
+							unsigned int order)
+{
+	XA_STATE(xas, xa, index);
+
+	xas_set_order(&xas, index, order);
+	xas_store(&xas, NULL);
+	xas_init_marks(&xas);
+}
+
+static noinline void check_xa_multi_store_adv_delete(struct xarray *xa,
+						     unsigned long index,
+						     unsigned int order)
+{
+	xa_lock_irq(xa);
+	check_xa_multi_store_adv_del_entry(xa, index, order);
+	xa_unlock_irq(xa);
+}
+
+/* mimics page cache filemap_get_entry() */
+static noinline void *test_get_entry(struct xarray *xa, unsigned long index)
+{
+	XA_STATE(xas, xa, index);
+	void *p;
+
+	rcu_read_lock();
+repeat:
+	xas_reset(&xas);
+	p = xas_load(&xas);
+	if (xas_retry(&xas, p))
+		goto repeat;
+	rcu_read_unlock();
+
+	return p;
+}
+
+static unsigned long some_val = 0xdeadbeef;
+static unsigned long some_val_2 = 0xdeaddead;
+
+/* mimics the page cache usage */
+static noinline void check_xa_multi_store_adv(struct xarray *xa,
+					      unsigned long pos,
+					      unsigned int order)
+{
+	unsigned int nrpages = 1UL << order;
+	unsigned long index, base, next_index, next_next_index;
+	unsigned int i;
+
+	index = pos >> PAGE_SHIFT;
+	base = round_down(index, nrpages);
+	next_index = round_down(base + nrpages, nrpages);
+	next_next_index = round_down(next_index + nrpages, nrpages);
+
+	check_xa_multi_store_adv_add(xa, base, order, &some_val);
+
+	for (i = 0; i < nrpages; i++)
+		XA_BUG_ON(xa, test_get_entry(xa, base + i) != &some_val);
+
+	XA_BUG_ON(xa, test_get_entry(xa, next_index) != NULL);
+
+	/* Use order 0 for the next item */
+	check_xa_multi_store_adv_add(xa, next_index, 0, &some_val_2);
+	XA_BUG_ON(xa, test_get_entry(xa, next_index) != &some_val_2);
+
+	/* Remove the next item */
+	check_xa_multi_store_adv_delete(xa, next_index, 0);
+
+	/* Now use order for a new pointer */
+	check_xa_multi_store_adv_add(xa, next_index, order, &some_val_2);
+
+	for (i = 0; i < nrpages; i++)
+		XA_BUG_ON(xa, test_get_entry(xa, next_index + i) != &some_val_2);
+
+	check_xa_multi_store_adv_delete(xa, next_index, order);
+	check_xa_multi_store_adv_delete(xa, base, order);
+	XA_BUG_ON(xa, !xa_empty(xa));
+
+	/* starting fresh again */
+
+	/* let's test some holes now */
+
+	/* hole at base and next_next */
+	check_xa_multi_store_adv_add(xa, next_index, order, &some_val_2);
+
+	for (i = 0; i < nrpages; i++)
+		XA_BUG_ON(xa, test_get_entry(xa, base + i) != NULL);
+
+	for (i = 0; i < nrpages; i++)
+		XA_BUG_ON(xa, test_get_entry(xa, next_index + i) != &some_val_2);
+
+	for (i = 0; i < nrpages; i++)
+		XA_BUG_ON(xa, test_get_entry(xa, next_next_index + i) != NULL);
+
+	check_xa_multi_store_adv_delete(xa, next_index, order);
+	XA_BUG_ON(xa, !xa_empty(xa));
+
+	/* hole at base and next */
+
+	check_xa_multi_store_adv_add(xa, next_next_index, order, &some_val_2);
+
+	for (i = 0; i < nrpages; i++)
+		XA_BUG_ON(xa, test_get_entry(xa, base + i) != NULL);
+
+	for (i = 0; i < nrpages; i++)
+		XA_BUG_ON(xa, test_get_entry(xa, next_index + i) != NULL);
+
+	for (i = 0; i < nrpages; i++)
+		XA_BUG_ON(xa, test_get_entry(xa, next_next_index + i) != &some_val_2);
+
+	check_xa_multi_store_adv_delete(xa, next_next_index, order);
+	XA_BUG_ON(xa, !xa_empty(xa));
+}
+#endif
+
+static noinline void check_multi_store_advanced(struct xarray *xa)
+{
+#ifdef CONFIG_XARRAY_MULTI
+	unsigned int max_order = IS_ENABLED(CONFIG_XARRAY_MULTI) ? 20 : 1;
+	unsigned long end = ULONG_MAX/2;
+	unsigned long pos, i;
+
+	/*
+	 * About 117 million tests below.
+	 */
+	for (pos = 7; pos < end; pos = (pos * pos) + 564) {
+		for (i = 0; i < max_order; i++) {
+			check_xa_multi_store_adv(xa, pos, i);
+			check_xa_multi_store_adv(xa, pos + 157, i);
+		}
+	}
+#endif
+}
+
 static noinline void check_xa_alloc_1(struct xarray *xa, unsigned int base)
 {
 	int i;
@@ -1804,6 +1967,7 @@ static int xarray_checks(void)
 	check_reserve(&array);
 	check_reserve(&xa0);
 	check_multi_store(&array);
+	check_multi_store_advanced(&array);
 	check_get_order(&array);
 	check_xa_alloc();
 	check_find(&array);
_

Patches currently in -mm which might be from mcgrof@kernel.org are

test_xarray-add-tests-for-advanced-multi-index-use.patch

