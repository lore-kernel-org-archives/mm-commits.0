Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9270C64ED6
	for <mm-commits@archiver.kernel.org>; Thu, 23 Feb 2023 22:36:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229487AbjBWWg6 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 23 Feb 2023 17:36:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbjBWWg5 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 23 Feb 2023 17:36:57 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53D634FABD
        for <mm-commits@vger.kernel.org>; Thu, 23 Feb 2023 14:36:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 06CEEB81A93
        for <mm-commits@vger.kernel.org>; Thu, 23 Feb 2023 22:36:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEEC5C433EF;
        Thu, 23 Feb 2023 22:36:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1677191813;
        bh=GywyUmrnCI10DP3Abe5dpB5GH8BqgE/0EgOaz4F1y3A=;
        h=Date:To:From:Subject:From;
        b=WEMeTc4K0Dsq3cq65jhZsOUVrBYKQMUJ1f/r9IQEeiPyAST+LaQvA+SI2WIwki3vU
         lgcCxViLYq8E7hkz9OV3QHn/0jPfmJ4rG638cmEuUR+7Q8K1p+8f3NeCxiDrspqWU/
         gQ0WeOG2s+1EjPbbbKBEfdReCWwGsb9C9qojwZKo=
Date:   Thu, 23 Feb 2023 14:36:53 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org, surenb@google.com,
        shakeelb@google.com, rientjes@google.com,
        quic_pkondeti@quicinc.com, markhemm@googlemail.com,
        hughd@google.com, quic_charante@quicinc.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-fadvise-move-endbyte-calculations-to-helper-function.patch added to mm-unstable branch
Message-Id: <20230223223653.AEEC5C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: fadvise: move 'endbyte' calculations to helper function
has been added to the -mm mm-unstable branch.  Its filename is
     mm-fadvise-move-endbyte-calculations-to-helper-function.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-fadvise-move-endbyte-calculations-to-helper-function.patch

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
@@ -657,6 +657,27 @@ static inline void vunmap_range_noflush(
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
 enum mminit_level {
 	MMINIT_WARNING,
_

Patches currently in -mm which might be from quic_charante@quicinc.com are

mm-fadvise-move-endbyte-calculations-to-helper-function.patch
mm-shmem-implement-posix_fadv_need-for-shmem.patch

