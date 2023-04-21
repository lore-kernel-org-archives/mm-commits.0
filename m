Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8FB1EC7618E
	for <mm-commits@archiver.kernel.org>; Fri, 21 Apr 2023 00:28:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233065AbjDUA2G (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 20 Apr 2023 20:28:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229521AbjDUA2F (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 20 Apr 2023 20:28:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F20D549F6
        for <mm-commits@vger.kernel.org>; Thu, 20 Apr 2023 17:28:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6D46564856
        for <mm-commits@vger.kernel.org>; Fri, 21 Apr 2023 00:28:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C04E3C433EF;
        Fri, 21 Apr 2023 00:27:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1682036879;
        bh=NR3m6LQXN3BxV8t24CS9OVMciizSV3fQLZPr/24Ujqo=;
        h=Date:To:From:Subject:From;
        b=SuMJxBtRWM+CMYI9rDZQ2EXrJzUHxAwDaKEfoYKzoRrdF5Rp2VIODr3Xq3o1FeP1Q
         GxDAgCFG9orgs3uVyp+nw5cuTEulbinx8vjI/TVARGmZjaeu/hQM1BC9XvjTvSv1rS
         ctsDz/J5VMCImRBwYzTFmuv0FLDep0V3Hwg8HlAE=
Date:   Thu, 20 Apr 2023 17:27:59 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, surenb@google.com,
        shakeelb@google.com, rientjes@google.com,
        quic_pkondeti@quicinc.com, markhemm@googlemail.com,
        hughd@google.com, quic_charante@quicinc.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-fadvise-move-endbyte-calculations-to-helper-function.patch removed from -mm tree
Message-Id: <20230421002759.C04E3C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: fadvise: move 'endbyte' calculations to helper function
has been removed from the -mm tree.  Its filename was
     mm-fadvise-move-endbyte-calculations-to-helper-function.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Charan Teja Kalla <quic_charante@quicinc.com>
Subject: mm: fadvise: move 'endbyte' calculations to helper function
Date: Tue, 14 Feb 2023 18:21:49 +0530

Patch series "mm: shmem: support POSIX_FADV_[WILL|DONT]NEED for shmem
files", v7.

This patchset aims to implement POSIX_FADV_WILLNEED and
POSIX_FADV_DONTNEED advices to shmem files which can be helpful for the
drivers who may want to manage the pages of shmem files on their own,
like, that are created through shmem_file_setup[_with_mnt]().


This patch (of 2):

Move the 'endbyte' calculations that determines last byte that fadvise can
to a helper function.  This is a preparatory change made for
shmem_fadvise() functionality in the next patch.  No functional changes in
this patch.

Link: https://lkml.kernel.org/r/cover.1676378702.git.quic_charante@quicinc.com
Link: https://lkml.kernel.org/r/22de7e716051abbafc01fab9f479f4d5b03745ca.1676378702.git.quic_charante@quicinc.com
Signed-off-by: Charan Teja Kalla <quic_charante@quicinc.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Mark Hemment <markhemm@googlemail.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Pavankumar Kondeti <quic_pkondeti@quicinc.com>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/fadvise.c  |   11 +----------
 mm/internal.h |   21 +++++++++++++++++++++
 2 files changed, 22 insertions(+), 10 deletions(-)

--- a/mm/fadvise.c~mm-fadvise-move-endbyte-calculations-to-helper-function
+++ a/mm/fadvise.c
@@ -65,16 +65,7 @@ int generic_fadvise(struct file *file, l
 		return 0;
 	}
 
-	/*
-	 * Careful about overflows. Len == 0 means "as much as possible".  Use
-	 * unsigned math because signed overflows are undefined and UBSan
-	 * complains.
-	 */
-	endbyte = (u64)offset + (u64)len;
-	if (!len || endbyte < len)
-		endbyte = LLONG_MAX;
-	else
-		endbyte--;		/* inclusive */
+	endbyte = fadvise_calc_endbyte(offset, len);
 
 	switch (advice) {
 	case POSIX_FADV_NORMAL:
--- a/mm/internal.h~mm-fadvise-move-endbyte-calculations-to-helper-function
+++ a/mm/internal.h
@@ -701,6 +701,27 @@ static inline void vunmap_range_noflush(
 }
 #endif /* !CONFIG_MMU */
 
+/*
+ * Helper function to get the endbyte of a file that fadvise can operate on.
+ */
+static inline loff_t fadvise_calc_endbyte(loff_t offset, loff_t len)
+{
+	loff_t endbyte;
+
+	/*
+	 * Careful about overflows. Len == 0 means "as much as possible".  Use
+	 * unsigned math because signed overflows are undefined and UBSan
+	 * complains.
+	 */
+	endbyte = (u64)offset + (u64)len;
+	if (!len || endbyte < len)
+		endbyte = LLONG_MAX;
+	else
+		endbyte--;		/* inclusive */
+
+	return endbyte;
+}
+
 /* Memory initialisation debug and verification */
 #ifdef CONFIG_DEFERRED_STRUCT_PAGE_INIT
 DECLARE_STATIC_KEY_TRUE(deferred_pages);
_

Patches currently in -mm which might be from quic_charante@quicinc.com are

mm-shmem-implement-posix_fadv_need-for-shmem.patch

