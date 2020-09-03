Return-Path: <SRS0=UrOV=CM=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B42DC433E9
	for <mm-commits@archiver.kernel.org>; Thu,  3 Sep 2020 19:24:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5880220C09
	for <mm-commits@archiver.kernel.org>; Thu,  3 Sep 2020 19:24:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1599161091;
	bh=+IA4of5IPDU7oIuJFUZbb3wYlivToMtFdz2Vv0m15OU=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=sY5O6/DtCy3cGjd2r+mfOztHVGuCLGgJyRGg0RGF77mpMrOG7g/LcDGeNeWZs7tCC
	 tD6MGchR7/V5lWjQCVSwXufWg8sYuiOCoI8pkAXcCR2YIOb1l73w71zkMbvYLug/rc
	 4f0NO29ANvw25pwLM15bpZqfKEcgrZAdxAfRURZw=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729092AbgICTYu (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 3 Sep 2020 15:24:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:39922 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728719AbgICTYs (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 3 Sep 2020 15:24:48 -0400
Received: from X1 (nat-ab2241.sltdut.senawave.net [162.218.216.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C0DF02098B;
        Thu,  3 Sep 2020 19:24:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599161087;
        bh=+IA4of5IPDU7oIuJFUZbb3wYlivToMtFdz2Vv0m15OU=;
        h=Date:From:To:Subject:From;
        b=u+LHGtTPWBe5xmXcWC1fibggPa92K550C82anbiytXV+iLhZnoiPvl37qhCVwBGCd
         KdY0LWZLxRGN5fbUqmjoJvnmKyzvlHpc8YiOJil1hJ+44LcDtcJdqQnfmb+HVEopnK
         GIQHIk5QvLgCBr1i/MzIRRK6uyB32uOEchlkuJjU=
Date:   Thu, 03 Sep 2020 12:24:47 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, ebiggers@google.com,
        dhowells@redhat.com, willy@infradead.org
Subject:  + mm-readahead-add-define_readahead.patch added to -mm tree
Message-ID: <20200903192447.eUqaJ%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/readahead: add DEFINE_READAHEAD
has been added to the -mm tree.  Its filename is
     mm-readahead-add-define_readahead.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-readahead-add-define_readahead.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-readahead-add-define_readahead.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm/readahead: add DEFINE_READAHEAD

Patch series "Readahead patches for 5.9/5.10".

These are infrastructure for both the THP patchset and for the fscache
rewrite,


This patch (of 8):

Allow for a more concise definition of a struct readahead_control.

Link: https://lkml.kernel.org/r/20200903140844.14194-1-willy@infradead.org
Link: https://lkml.kernel.org/r/20200903140844.14194-3-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Eric Biggers <ebiggers@google.com>
Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pagemap.h |    7 +++++++
 mm/readahead.c          |    6 +-----
 2 files changed, 8 insertions(+), 5 deletions(-)

--- a/include/linux/pagemap.h~mm-readahead-add-define_readahead
+++ a/include/linux/pagemap.h
@@ -749,6 +749,13 @@ struct readahead_control {
 	unsigned int _batch_count;
 };
 
+#define DEFINE_READAHEAD(rac, f, m, i)					\
+	struct readahead_control rac = {				\
+		.file = f,						\
+		.mapping = m,						\
+		._index = i,						\
+	}
+
 /**
  * readahead_page - Get the next page to read.
  * @rac: The current readahead request.
--- a/mm/readahead.c~mm-readahead-add-define_readahead
+++ a/mm/readahead.c
@@ -179,11 +179,7 @@ void page_cache_readahead_unbounded(stru
 {
 	LIST_HEAD(page_pool);
 	gfp_t gfp_mask = readahead_gfp_mask(mapping);
-	struct readahead_control rac = {
-		.mapping = mapping,
-		.file = file,
-		._index = index,
-	};
+	DEFINE_READAHEAD(rac, file, mapping, index);
 	unsigned long i;
 
 	/*
_

Patches currently in -mm which might be from willy@infradead.org are

mm-debug-do-not-dereference-i_ino-blindly.patch
mm-account-pmd-tables-like-pte-tables.patch
mm-move-pagedoublemap-bit.patch
mm-simplify-pagedoublemap-with-pf_second-policy.patch
xarray-add-xa_get_order.patch
xarray-add-xas_split.patch
mm-filemap-fix-storing-to-a-thp-shadow-entry.patch
mm-readahead-add-define_readahead.patch
mm-readahead-make-page_cache_ra_unbounded-take-a-readahead_control.patch
mm-readahead-make-do_page_cache_ra-take-a-readahead_control.patch
mm-readahead-add-page_cache_sync_ra-and-page_cache_async_ra.patch
harden-autofs-ioctl-table.patch

