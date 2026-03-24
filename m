Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6E7626A0A7
	for <mm-commits@vger.kernel.org>; Tue, 24 Mar 2026 19:18:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774379912; cv=none; b=R9CutO7bfEcPcN56RyLGH+ACAnCGOsY255Y9zBo+g5Oj02J9zqzIk4y9WQclZKeZ1yvV9V55m6/+d7fpI42YG/peiWik6bKgURKucVBUTXxAFMHxfTqMjdNnvyNBKKFkkBzGR7XVa+vi9n3mqAJklgPzyn6pMKNqbYHW11OO0ZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774379912; c=relaxed/simple;
	bh=WUp49gWcLzu/dIGxzwNKBfpM4vsSf4pMbCCk/h5AJB8=;
	h=Date:To:From:Subject:Message-Id; b=kYdsFRRcUMrRj1bt+CX5422CfCoEXOer6kYhHC/eFEo93yOCYTrNzAMOlW4Gmb2lNVgG+lRunPWjyIYbt0oDpy6tgxouQ3oWBfJkYHC1sn+/43mnQI6oN4Cr8f4ImTWPQeM1Ut7EW7UVs0AYHKDKswAE2OoR8/kWUmiumpuAzQc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=E5o7OW76; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="E5o7OW76"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 235CDC19424;
	Tue, 24 Mar 2026 19:18:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774379912;
	bh=WUp49gWcLzu/dIGxzwNKBfpM4vsSf4pMbCCk/h5AJB8=;
	h=Date:To:From:Subject:From;
	b=E5o7OW76fjinIdEo/3RiAFcWkv+YhNEwIi61vsbscjE+Sxe8HBWb3ZVh/YlHwF8Xt
	 vMtzLawcwhEGpvBemAdFAw6a3l2zgkEadgrNB4QzjQCXBPH1PvW7ED08BlpG2NhxFe
	 njZRMLlG2r4A5BY1xraEhUP/cGgm43eM53IMW/Rk=
Date: Tue, 24 Mar 2026 12:18:31 -0700
To: mm-commits@vger.kernel.org,pmladek@suse.com,objecting@objecting.org,kees@kernel.org,dhowells@redhat.com,davidgow@google.com,lk@c--e.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-kunit_iov_iter-add-tests-for-extract_iter_to_sg.patch added to mm-nonmm-unstable branch
Message-Id: <20260324191832.235CDC19424@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib: kunit_iov_iter: add tests for extract_iter_to_sg
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-kunit_iov_iter-add-tests-for-extract_iter_to_sg.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-kunit_iov_iter-add-tests-for-extract_iter_to_sg.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: "Christian A. Ehrhardt" <lk@c--e.de>
Subject: lib: kunit_iov_iter: add tests for extract_iter_to_sg
Date: Mon, 23 Mar 2026 22:23:49 +0100

Add test cases that test extract_iter_to_sg.

For each iterator type an iterator is loaded with a kernel buffer.  The
iterator is then extracted to a scatterlist and the scatterlist is copied
into a scratch buffer.

The test passes if the scratch buffer compares equal to the original
buffer.

The new tests demostrate a bug in extract_iter_to_sg for kvec iterators
and one of the tests will fail.  This is fixed in the next commit.

Link: https://lkml.kernel.org/r/20260323212350.807118-3-lk@c--e.de
Signed-off-by: Christian A. Ehrhardt <lk@c--e.de>
Reviewed-by: Josh Law <objecting@objecting.org>
Tested-by: Josh Law <objecting@objecting.org>
Cc: David Howells <dhowells@redhat.com>
Cc: David Gow <davidgow@google.com>
Cc: Kees Cook <kees@kernel.org>
Cc: Petr Mladek <pmladek@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/tests/kunit_iov_iter.c |  140 +++++++++++++++++++++++++++++++++++
 1 file changed, 140 insertions(+)

--- a/lib/tests/kunit_iov_iter.c~lib-kunit_iov_iter-add-tests-for-extract_iter_to_sg
+++ a/lib/tests/kunit_iov_iter.c
@@ -13,6 +13,7 @@
 #include <linux/uio.h>
 #include <linux/bvec.h>
 #include <linux/folio_queue.h>
+#include <linux/scatterlist.h>
 #include <linux/minmax.h>
 #include <kunit/test.h>
 
@@ -1014,6 +1015,141 @@ stop:
 	KUNIT_SUCCEED(test);
 }
 
+struct iov_kunit_iter_to_sg_data {
+	struct sg_table sgt;
+	u8 *buffer, *scratch;
+	struct page **pages;
+	size_t npages;
+};
+
+static void __init
+iov_kunit_iter_to_sg_init(struct kunit *test, size_t bufsize,
+			  struct iov_kunit_iter_to_sg_data *data)
+{
+	struct page **spages;
+	struct scatterlist *sg;
+	size_t i;
+
+	data->npages = bufsize / PAGE_SIZE;
+	sg = kunit_kmalloc_array(test, data->npages, sizeof(*sg), GFP_KERNEL);
+	sg_init_table(sg, data->npages);
+	memset(&data->sgt, 0, sizeof(data->sgt));
+	data->sgt.orig_nents = data->npages;
+	data->sgt.sgl = sg;
+
+	data->buffer = iov_kunit_create_buffer(test, &data->pages,
+					       data->npages);
+	data->scratch = iov_kunit_create_buffer(test, &spages, data->npages);
+	for (i = 0; i < bufsize; ++i)
+		data->buffer[i] = pattern(i);
+	memset(data->scratch, 0, bufsize);
+}
+
+static void __init
+iov_kunit_iter_to_sg_check(struct kunit *test, struct iov_iter *iter,
+			   size_t bufsize,
+			   struct iov_kunit_iter_to_sg_data *data)
+{
+	size_t i;
+
+	i = extract_iter_to_sg(iter, bufsize, &data->sgt,
+			       data->npages, 0);
+
+	KUNIT_EXPECT_EQ(test, i, bufsize);
+	KUNIT_EXPECT_LE(test, data->sgt.nents, data->npages);
+
+	i = sg_copy_to_buffer(data->sgt.sgl, data->sgt.nents,
+			      data->scratch, bufsize);
+	KUNIT_EXPECT_EQ(test, i, bufsize);
+
+	for (i = 0; i < bufsize; ++i) {
+		KUNIT_EXPECT_EQ_MSG(test, data->buffer[i], data->scratch[i],
+				    "at i=%zx", i);
+		if (data->buffer[i] != data->scratch[i])
+			break;
+	}
+
+	KUNIT_EXPECT_EQ(test, i, bufsize);
+}
+
+static void __init iov_kunit_iter_to_sg_kvec(struct kunit *test)
+{
+	struct iov_kunit_iter_to_sg_data data;
+	struct iov_iter iter;
+	struct kvec kvec;
+	size_t bufsize;
+
+	bufsize = 0x100000;
+	iov_kunit_iter_to_sg_init(test, bufsize, &data);
+
+	kvec.iov_base = data.buffer;
+	kvec.iov_len = bufsize;
+	iov_iter_kvec(&iter, READ, &kvec, 1, bufsize);
+
+	iov_kunit_iter_to_sg_check(test, &iter, bufsize, &data);
+}
+
+static void __init iov_kunit_iter_to_sg_bvec(struct kunit *test)
+{
+	struct iov_kunit_iter_to_sg_data data;
+	struct page *p, *can_merge = NULL;
+	size_t i, k, bufsize;
+	struct bio_vec *bvec;
+	struct iov_iter iter;
+
+	bufsize = 0x100000;
+	iov_kunit_iter_to_sg_init(test, bufsize, &data);
+
+	bvec = kunit_kmalloc_array(test, data.npages, sizeof(*bvec),
+				   GFP_KERNEL);
+	k = 0;
+	for (i = 0; i < data.npages; ++i) {
+		p = data.pages[i];
+		if (p == can_merge)
+			bvec[k-1].bv_len += PAGE_SIZE;
+		else
+			bvec_set_page(&bvec[k++], p, PAGE_SIZE, 0);
+		can_merge = p + 1;
+	}
+	iov_iter_bvec(&iter, READ, bvec, k, bufsize);
+
+	iov_kunit_iter_to_sg_check(test, &iter, bufsize, &data);
+}
+
+static void __init iov_kunit_iter_to_sg_folioq(struct kunit *test)
+{
+	struct iov_kunit_iter_to_sg_data data;
+	struct folio_queue *folioq;
+	struct iov_iter iter;
+	size_t bufsize;
+
+	bufsize = 0x100000;
+	iov_kunit_iter_to_sg_init(test, bufsize, &data);
+
+	folioq = iov_kunit_create_folioq(test);
+	iov_kunit_load_folioq(test, &iter, READ, folioq, data.pages,
+			      data.npages);
+
+	iov_kunit_iter_to_sg_check(test, &iter, bufsize, &data);
+}
+
+static void __init iov_kunit_iter_to_sg_xarray(struct kunit *test)
+{
+	struct iov_kunit_iter_to_sg_data data;
+	struct xarray *xarray;
+	struct iov_iter iter;
+	size_t bufsize;
+
+	bufsize = 0x100000;
+	iov_kunit_iter_to_sg_init(test, bufsize, &data);
+
+	xarray = iov_kunit_create_xarray(test);
+	iov_kunit_load_xarray(test, &iter, READ, xarray, data.pages,
+			      data.npages);
+
+	iov_kunit_iter_to_sg_check(test, &iter, bufsize, &data);
+}
+
 static struct kunit_case __refdata iov_kunit_cases[] = {
 	KUNIT_CASE(iov_kunit_copy_to_kvec),
 	KUNIT_CASE(iov_kunit_copy_from_kvec),
@@ -1027,6 +1163,10 @@ static struct kunit_case __refdata iov_k
 	KUNIT_CASE(iov_kunit_extract_pages_bvec),
 	KUNIT_CASE(iov_kunit_extract_pages_folioq),
 	KUNIT_CASE(iov_kunit_extract_pages_xarray),
+	KUNIT_CASE(iov_kunit_iter_to_sg_kvec),
+	KUNIT_CASE(iov_kunit_iter_to_sg_bvec),
+	KUNIT_CASE(iov_kunit_iter_to_sg_folioq),
+	KUNIT_CASE(iov_kunit_iter_to_sg_xarray),
 	{}
 };
 
_

Patches currently in -mm which might be from lk@c--e.de are

lib-kunit_iov_iter-improve-error-detection.patch
lib-kunit_iov_iter-add-tests-for-extract_iter_to_sg.patch
lib-fix-length-calculation-in-extract_kvec_to_sg.patch

