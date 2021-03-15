Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 044E7C433DB
	for <mm-commits@archiver.kernel.org>; Mon, 15 Mar 2021 23:04:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B91E764DE2
	for <mm-commits@archiver.kernel.org>; Mon, 15 Mar 2021 23:04:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232125AbhCOXDc (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 15 Mar 2021 19:03:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:46396 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232487AbhCOXD1 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 15 Mar 2021 19:03:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DE9EF64E07;
        Mon, 15 Mar 2021 23:03:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1615849407;
        bh=MKuzsNFiN8W0jO1GlGXw8oLS7rnHTAXS3ZRtxTUGcVc=;
        h=Date:From:To:Subject:From;
        b=1kG9fms9uAYpm4L6vlHhqwauAvd7mIUJY6kwytNOi+XrKHUdil0Br3UaPtbus+Vov
         OHwn8nb/eeze93S85nQb3rGAo4PgKMlMyrlyjLz90jkC1IdMHJOWbGp6OFslmlFpmF
         ABa0YkFkFfgzZIxIxCMA8qKfKYfTRWjs4MOvYyAg=
Date:   Mon, 15 Mar 2021 16:03:26 -0700
From:   akpm@linux-foundation.org
To:     johannes.berg@intel.com, mm-commits@vger.kernel.org,
        oberpar@linux.ibm.com
Subject:  + gcov-simplify-buffer-allocation.patch added to -mm tree
Message-ID: <20210315230326.w3EWMvifO%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: gcov: simplify buffer allocation
has been added to the -mm tree.  Its filename is
     gcov-simplify-buffer-allocation.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/gcov-simplify-buffer-allocation.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/gcov-simplify-buffer-allocation.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Johannes Berg <johannes.berg@intel.com>
Subject: gcov: simplify buffer allocation

Use just a single vmalloc() with struct_size() instead of a separate
kmalloc() for the iter struct.

Link: https://lkml.kernel.org/r/20210315235453.b6de4a92096e.Iac40a5166589cefbff8449e466bd1b38ea7a17af@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Cc: Peter Oberparleiter <oberpar@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/gcov/fs.c |   24 +++++++++---------------
 1 file changed, 9 insertions(+), 15 deletions(-)

--- a/kernel/gcov/fs.c~gcov-simplify-buffer-allocation
+++ a/kernel/gcov/fs.c
@@ -97,9 +97,9 @@ __setup("gcov_persist=", gcov_persist_se
  */
 struct gcov_iterator {
 	struct gcov_info *info;
-	void *buffer;
 	size_t size;
 	loff_t pos;
+	char buffer[];
 };
 
 /**
@@ -111,25 +111,20 @@ struct gcov_iterator {
 static struct gcov_iterator *gcov_iter_new(struct gcov_info *info)
 {
 	struct gcov_iterator *iter;
+	size_t size;
+
+	/* Dry-run to get the actual buffer size. */
+	size = convert_to_gcda(NULL, info);
 
-	iter = kzalloc(sizeof(struct gcov_iterator), GFP_KERNEL);
+	iter = vmalloc(struct_size(iter, buffer, size));
 	if (!iter)
-		goto err_free;
+		return NULL;
 
 	iter->info = info;
-	/* Dry-run to get the actual buffer size. */
-	iter->size = convert_to_gcda(NULL, info);
-	iter->buffer = vmalloc(iter->size);
-	if (!iter->buffer)
-		goto err_free;
-
+	iter->size = size;
 	convert_to_gcda(iter->buffer, info);
 
 	return iter;
-
-err_free:
-	kfree(iter);
-	return NULL;
 }
 
 
@@ -139,8 +134,7 @@ err_free:
  */
 static void gcov_iter_free(struct gcov_iterator *iter)
 {
-	vfree(iter->buffer);
-	kfree(iter);
+	vfree(iter);
 }
 
 /**
_

Patches currently in -mm which might be from johannes.berg@intel.com are

gcov-combine-common-code.patch
gcov-simplify-buffer-allocation.patch
gcov-use-kvmalloc.patch
gdb-lx-symbols-store-the-abspath.patch

