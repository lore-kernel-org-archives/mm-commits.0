Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 588BBC433EF
	for <mm-commits@archiver.kernel.org>; Wed,  8 Jun 2022 19:22:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233934AbiFHTWC (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 8 Jun 2022 15:22:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231183AbiFHTWA (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 8 Jun 2022 15:22:00 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B89011BC7AF
        for <mm-commits@vger.kernel.org>; Wed,  8 Jun 2022 12:21:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6B718B829B3
        for <mm-commits@vger.kernel.org>; Wed,  8 Jun 2022 19:21:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 205A5C34116;
        Wed,  8 Jun 2022 19:21:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1654716116;
        bh=0irTnOfXBtaus6G6bKI+hiH0ohN8bCIwtv1xFtIRDEE=;
        h=Date:To:From:Subject:From;
        b=F5PUFRJ4X57ITB1/5GEGlUogHxGMQGcI7+Y7enIQnmhSnZ/wl0qxQ9lHbK2tjwxT8
         OakGStfLGUKpU3sHpO0ADgRCRVIkppAjvPszp8NSDs9AIlOA3bk/zivh1IXH8DdqFH
         SF3Xh5vw1zqmBMIqZQoBsry+CvzNtgF7kEfSuQSg=
Date:   Wed, 08 Jun 2022 12:21:55 -0700
To:     mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk,
        sashal@kernel.org, gthelen@google.com, ebiederm@xmission.com,
        bhe@redhat.com, pasha.tatashin@soleen.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + kexec_file-increase-maximum-file-size-to-4g.patch added to mm-nonmm-unstable branch
Message-Id: <20220608192156.205A5C34116@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kexec_file: increase maximum file size to 4G
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     kexec_file-increase-maximum-file-size-to-4g.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kexec_file-increase-maximum-file-size-to-4g.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Subject: kexec_file: increase maximum file size to 4G
Date: Fri, 27 May 2022 02:55:35 +0000

In some case initrd can be large.  For example, it could be a netboot
image loaded by u-root, that is kexec'ing into it.

The maximum size of initrd is arbitrary set to 2G.  Also, the limit is not
very obvious because it is hidden behind a generic INT_MAX macro.

Theoretically, we could make it LONG_MAX, but it is safer to keep it sane,
and just increase it to 4G.

Increase the size to 4G, and make it obvious by having a new macro that
specifies the maximum file size supported by kexec_file_load() syscall:
KEXEC_FILE_SIZE_MAX.

Link: https://lkml.kernel.org/r/20220527025535.3953665-3-pasha.tatashin@soleen.com
Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Sasha Levin <sashal@kernel.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Greg Thelen <gthelen@google.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Baoquan He <bhe@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kexec_file.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

--- a/kernel/kexec_file.c~kexec_file-increase-maximum-file-size-to-4g
+++ a/kernel/kexec_file.c
@@ -31,6 +31,9 @@
 
 static int kexec_calculate_store_digests(struct kimage *image);
 
+/* Maximum size in bytes for kernel/initrd files. */
+#define KEXEC_FILE_SIZE_MAX	min_t(s64, 4LL << 30, SSIZE_MAX)
+
 /*
  * Currently this is the only default function that is exported as some
  * architectures need it to do additional handlings.
@@ -189,11 +192,12 @@ kimage_file_prepare_segments(struct kima
 			     const char __user *cmdline_ptr,
 			     unsigned long cmdline_len, unsigned flags)
 {
-	int ret;
+	ssize_t ret;
 	void *ldata;
 
 	ret = kernel_read_file_from_fd(kernel_fd, 0, &image->kernel_buf,
-				       INT_MAX, NULL, READING_KEXEC_IMAGE);
+				       KEXEC_FILE_SIZE_MAX, NULL,
+				       READING_KEXEC_IMAGE);
 	if (ret < 0)
 		return ret;
 	image->kernel_buf_len = ret;
@@ -213,7 +217,7 @@ kimage_file_prepare_segments(struct kima
 	/* It is possible that there no initramfs is being loaded */
 	if (!(flags & KEXEC_FILE_NO_INITRAMFS)) {
 		ret = kernel_read_file_from_fd(initrd_fd, 0, &image->initrd_buf,
-					       INT_MAX, NULL,
+					       KEXEC_FILE_SIZE_MAX, NULL,
 					       READING_KEXEC_INITRAMFS);
 		if (ret < 0)
 			goto out;
_

Patches currently in -mm which might be from pasha.tatashin@soleen.com are

fs-kernel_read_file-allow-to-read-files-up-to-ssize_t.patch
kexec_file-increase-maximum-file-size-to-4g.patch

