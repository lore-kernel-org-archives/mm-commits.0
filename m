Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0794C7EE43
	for <mm-commits@archiver.kernel.org>; Fri,  9 Jun 2023 23:14:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229486AbjFIXOA (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Jun 2023 19:14:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230056AbjFIXOA (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 9 Jun 2023 19:14:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EC012D52
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 16:13:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B8A8165CC3
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 23:13:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C96AC433D2;
        Fri,  9 Jun 2023 23:13:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686352438;
        bh=NLezKwth3y957YE7Gt2TNjEkBLvpcQDX1kRJ/hd11HM=;
        h=Date:To:From:Subject:From;
        b=mbfWYs5nYU2jeVneML119Eh6OwbqJwMvWs3ZXVIYt7nMtIkCjon6AacnP771AjabZ
         XcEvFH8XxWlVg0N7wgfpw2smH7IGjOvKe262IfS76T+qPW7TEiBR7gEaitnXyMyePI
         b9/s0gz6Mct9Vs6ujr+ZiLxpeqRu3GjjsbjQKHYI=
Date:   Fri, 09 Jun 2023 16:13:57 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, nphamcs@gmail.com,
        mtk.manpages@gmail.com, hannes@cmpxchg.org, colin.i.king@gmail.com,
        bfoster@redhat.com, mpe@ellerman.id.au, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] selftests-add-selftests-for-cachestat-fix-2.patch removed from -mm tree
Message-Id: <20230609231358.1C96AC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: selftests-add-selftests-for-cachestat-fix-2
has been removed from the -mm tree.  Its filename was
     selftests-add-selftests-for-cachestat-fix-2.patch

This patch was dropped because it was folded into selftests-add-selftests-for-cachestat.patch

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

selftests-add-selftests-for-cachestat.patch

