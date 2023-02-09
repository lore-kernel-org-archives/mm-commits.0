Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5430AC61DA4
	for <mm-commits@archiver.kernel.org>; Thu,  9 Feb 2023 23:57:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229873AbjBIX5Z (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 9 Feb 2023 18:57:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229889AbjBIX5Y (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 9 Feb 2023 18:57:24 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCD723E082
        for <mm-commits@vger.kernel.org>; Thu,  9 Feb 2023 15:57:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 66D6261C2E
        for <mm-commits@vger.kernel.org>; Thu,  9 Feb 2023 23:57:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB5E1C433EF;
        Thu,  9 Feb 2023 23:57:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675987041;
        bh=fh69wEb/uuVmTYR6NtAHUAmFQAOXBBvG4UTV4xFyFVY=;
        h=Date:To:From:Subject:From;
        b=QjLjNBhNn28AKUNIwJOik2MNV/FV9CKL4kGxmy91nR/t34pztzlY4DlhkD1qnMVkO
         SdO3dpO0hUm9EMjlIGAeOL3sfnybWPHOzbNufPXIgZAhbV76t4gC+meQVQL5aFfHmV
         m0CS3CZ2bnESJQOmf3cn7CUdlB+WZ3xIxzJtFPEs=
Date:   Thu, 09 Feb 2023 15:57:21 -0800
To:     mm-commits@vger.kernel.org, yukuai1@huaweicloud.com,
        yi.zhang@huawei.com, yangerkun@huawei.com, tj@kernel.org,
        james.smart@broadcom.com, jack@suse.cz, houtao1@huawei.com,
        ebiggers@google.com, bingjingc@synology.com, axboe@kernel.dk,
        lilingfeng3@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] lib-parser-optimize-match_number-apis-to-use-local-array.patch removed from -mm tree
Message-Id: <20230209235721.BB5E1C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: lib: parser: optimize match_NUMBER apis to use local array
has been removed from the -mm tree.  Its filename was
     lib-parser-optimize-match_number-apis-to-use-local-array.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Li Lingfeng <lilingfeng3@huawei.com>
Subject: lib: parser: optimize match_NUMBER apis to use local array
Date: Fri, 20 Jan 2023 11:23:52 +0800

Memory will be allocated to store substring_t in match_strdup(), which
means the caller of match_strdup() may need to be scheduled out to wait
for reclaiming memory.  smatch complains that this can cuase sleeping in
an atoic context.

Using local array to store substring_t to remove the restriction.

Link: https://lkml.kernel.org/r/20230120032352.242767-1-lilingfeng3@huawei.com
Link: https://lore.kernel.org/all/20221104023938.2346986-5-yukuai1@huaweicloud.com/
Link: https://lkml.kernel.org/r/20230120032352.242767-1-lilingfeng3@huawei.com
Fixes: 2c0647988433 ("blk-iocost: don't release 'ioc->lock' while updating params")
Signed-off-by: Li Lingfeng <lilingfeng3@huawei.com>
Reported-by: Yu Kuai <yukuai1@huaweicloud.com>
Acked-by: Tejun Heo <tj@kernel.org>
Cc: BingJing Chang <bingjingc@synology.com>
Cc: Eric Biggers <ebiggers@google.com>
Cc: Hou Tao <houtao1@huawei.com>
Cc: James Smart <james.smart@broadcom.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: yangerkun <yangerkun@huawei.com>
Cc: Zhang Yi <yi.zhang@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/parser.c |   39 ++++++++++++++++++++-------------------
 1 file changed, 20 insertions(+), 19 deletions(-)

--- a/lib/parser.c~lib-parser-optimize-match_number-apis-to-use-local-array
+++ a/lib/parser.c
@@ -11,6 +11,15 @@
 #include <linux/slab.h>
 #include <linux/string.h>
 
+/*
+ * max size needed by different bases to express U64
+ * HEX: "0xFFFFFFFFFFFFFFFF" --> 18
+ * DEC: "18446744073709551615" --> 20
+ * OCT: "01777777777777777777777" --> 23
+ * pick the max one to define NUMBER_BUF_LEN
+ */
+#define NUMBER_BUF_LEN 24
+
 /**
  * match_one - Determines if a string matches a simple pattern
  * @s: the string to examine for presence of the pattern
@@ -129,14 +138,12 @@ EXPORT_SYMBOL(match_token);
 static int match_number(substring_t *s, int *result, int base)
 {
 	char *endp;
-	char *buf;
+	char buf[NUMBER_BUF_LEN];
 	int ret;
 	long val;
 
-	buf = match_strdup(s);
-	if (!buf)
-		return -ENOMEM;
-
+	if (match_strlcpy(buf, s, NUMBER_BUF_LEN) >= NUMBER_BUF_LEN)
+		return -ERANGE;
 	ret = 0;
 	val = simple_strtol(buf, &endp, base);
 	if (endp == buf)
@@ -145,7 +152,6 @@ static int match_number(substring_t *s,
 		ret = -ERANGE;
 	else
 		*result = (int) val;
-	kfree(buf);
 	return ret;
 }
 
@@ -163,18 +169,15 @@ static int match_number(substring_t *s,
  */
 static int match_u64int(substring_t *s, u64 *result, int base)
 {
-	char *buf;
+	char buf[NUMBER_BUF_LEN];
 	int ret;
 	u64 val;
 
-	buf = match_strdup(s);
-	if (!buf)
-		return -ENOMEM;
-
+	if (match_strlcpy(buf, s, NUMBER_BUF_LEN) >= NUMBER_BUF_LEN)
+		return -ERANGE;
 	ret = kstrtoull(buf, base, &val);
 	if (!ret)
 		*result = val;
-	kfree(buf);
 	return ret;
 }
 
@@ -206,14 +209,12 @@ EXPORT_SYMBOL(match_int);
  */
 int match_uint(substring_t *s, unsigned int *result)
 {
-	int err = -ENOMEM;
-	char *buf = match_strdup(s);
+	char buf[NUMBER_BUF_LEN];
 
-	if (buf) {
-		err = kstrtouint(buf, 10, result);
-		kfree(buf);
-	}
-	return err;
+	if (match_strlcpy(buf, s, NUMBER_BUF_LEN) >= NUMBER_BUF_LEN)
+		return -ERANGE;
+
+	return kstrtouint(buf, 10, result);
 }
 EXPORT_SYMBOL(match_uint);
 
_

Patches currently in -mm which might be from lilingfeng3@huawei.com are


