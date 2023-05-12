Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F5A3C77B7F
	for <mm-commits@archiver.kernel.org>; Fri, 12 May 2023 03:41:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239882AbjELDlh (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 11 May 2023 23:41:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239819AbjELDl0 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 11 May 2023 23:41:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 154B84C3F
        for <mm-commits@vger.kernel.org>; Thu, 11 May 2023 20:41:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9B7AA64E97
        for <mm-commits@vger.kernel.org>; Fri, 12 May 2023 03:41:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F205CC433D2;
        Fri, 12 May 2023 03:41:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1683862884;
        bh=jfnOBCKtcUxBIBe5KDfRlF0iHaHZRcrSRoCY5R3+lno=;
        h=Date:To:From:Subject:From;
        b=x427AgQrTmRLYbIFikS6RGuuqkf+SwUGjYqdI6Fy2GvtryFwpgLu4hZg038DKR6cK
         wyaDV5VCZPsOFpBoeA5fb3UKcShqx0gDv/bbQz69cn2BooFIHsvDinH5xH5hMYo2LN
         ukAWcSOy38+7tSZVdtLFO7rm9FOWzTDsbjtDX04M=
Date:   Thu, 11 May 2023 20:41:23 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, nphamcs@gmail.com,
        mtk.manpages@gmail.com, hannes@cmpxchg.org, colin.i.king@gmail.com,
        bfoster@redhat.com, mpe@ellerman.id.au, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-add-selftests-for-cachestat-fix-2.patch added to mm-unstable branch
Message-Id: <20230512034123.F205CC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests-add-selftests-for-cachestat-fix-2
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-add-selftests-for-cachestat-fix-2.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-add-selftests-for-cachestat-fix-2.patch

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
From: Michael Ellerman <mpe@ellerman.id.au>
Subject: selftests-add-selftests-for-cachestat-fix-2
Date: Thu, 11 May 2023 13:21:28 +1000

On kernels with 64K pages (powerpc at least), this tries to allocate
64MB on the stack which segfaults.

Allocating data with malloc avoids the problem and allows the test to
pass.

Link: https://lkml.kernel.org/r/877ctfa6yv.fsf@mail.lhotse
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Cc: Brian Foster <bfoster@redhat.com>
Cc: Colin Ian King <colin.i.king@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/cachestat/test_cachestat.c |   69 ++++++-----
 1 file changed, 40 insertions(+), 29 deletions(-)

--- a/tools/testing/selftests/cachestat/test_cachestat.c~selftests-add-selftests-for-cachestat-fix-2
+++ a/tools/testing/selftests/cachestat/test_cachestat.c
@@ -31,48 +31,59 @@ void print_cachestat(struct cachestat *c
 
 bool write_exactly(int fd, size_t filesize)
 {
-	char data[filesize];
-	bool ret = true;
 	int random_fd = open("/dev/urandom", O_RDONLY);
+	char *cursor, *data;
+	int remained;
+	bool ret;
 
 	if (random_fd < 0) {
 		ksft_print_msg("Unable to access urandom.\n");
 		ret = false;
 		goto out;
-	} else {
-		int remained = filesize;
-		char *cursor = data;
-
-		while (remained) {
-			ssize_t read_len = read(random_fd, cursor, remained);
-
-			if (read_len <= 0) {
-				ksft_print_msg("Unable to read from urandom.\n");
-				ret = false;
-				goto close_random_fd;
-			}
+	}
+
+	data = malloc(filesize);
+	if (!data) {
+		ksft_print_msg("Unable to allocate data.\n");
+		ret = false;
+		goto close_random_fd;
+	}
 
-			remained -= read_len;
-			cursor += read_len;
+	remained = filesize;
+	cursor = data;
+
+	while (remained) {
+		ssize_t read_len = read(random_fd, cursor, remained);
+
+		if (read_len <= 0) {
+			ksft_print_msg("Unable to read from urandom.\n");
+			ret = false;
+			goto out_free_data;
 		}
 
-		/* write random data to fd */
-		remained = filesize;
-		cursor = data;
-		while (remained) {
-			ssize_t write_len = write(fd, cursor, remained);
-
-			if (write_len <= 0) {
-				ksft_print_msg("Unable write random data to file.\n");
-				ret = false;
-				goto close_random_fd;
-			}
+		remained -= read_len;
+		cursor += read_len;
+	}
 
-			remained -= write_len;
-			cursor += write_len;
+	/* write random data to fd */
+	remained = filesize;
+	cursor = data;
+	while (remained) {
+		ssize_t write_len = write(fd, cursor, remained);
+
+		if (write_len <= 0) {
+			ksft_print_msg("Unable write random data to file.\n");
+			ret = false;
+			goto out_free_data;
 		}
+
+		remained -= write_len;
+		cursor += write_len;
 	}
 
+	ret = true;
+out_free_data:
+	free(data);
 close_random_fd:
 	close(random_fd);
 out:
_

Patches currently in -mm which might be from mpe@ellerman.id.au are

mm-kfence-fix-false-positives-on-big-endian.patch
selftests-add-selftests-for-cachestat-fix-2.patch

