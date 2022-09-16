Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D687ECAAA1
	for <mm-commits@archiver.kernel.org>; Fri, 16 Sep 2022 20:13:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229581AbiIPUNt (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 16 Sep 2022 16:13:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230054AbiIPUNs (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 16 Sep 2022 16:13:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FD1DB9FB1
        for <mm-commits@vger.kernel.org>; Fri, 16 Sep 2022 13:13:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9AB3C62D70
        for <mm-commits@vger.kernel.org>; Fri, 16 Sep 2022 20:13:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC1F2C433C1;
        Fri, 16 Sep 2022 20:13:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1663359226;
        bh=9UIoqno2SBw9vNZlxfxnNtoyNdLGGofTp11bqLwEm/c=;
        h=Date:To:From:Subject:From;
        b=oNE4KFmqb3QXhwhqvjESZYLCw4xNP4ahKQeyAzmeTmouMxgwOk5IPsKNqUwJ9Tgdl
         YOzIBbKbtFAtg6i0IWoivhRRV4PMpSBbOm2Ua+EByR9ntiorGYaHuFpFI5VLaE77hv
         enZf0iQh2t264Zh4zxY98lrEWwTHV1R3YznPWJiQ=
Date:   Fri, 16 Sep 2022 13:13:45 -0700
To:     mm-commits@vger.kernel.org, yangyicong@hisilicon.com,
        viro@zeniv.linux.org.uk, jonnyc@amazon.com, hhhawa@amazon.com,
        andriy.shevchenko@intel.com, farbere@amazon.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] libfs-fix-error-format-in-simple_attr_write.patch removed from -mm tree
Message-Id: <20220916201345.EC1F2C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: libfs: fix error format in simple_attr_write()
has been removed from the -mm tree.  Its filename was
     libfs-fix-error-format-in-simple_attr_write.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Eliav Farber <farbere@amazon.com>
Subject: libfs: fix error format in simple_attr_write()
Date: Thu, 15 Sep 2022 09:15:44 +0000

In commit 488dac0c9237 ("libfs: fix error cast of negative value in
simple_attr_write()"), simple_attr_write() was changed to use kstrtoull()
instead of simple_strtoll() to convert a string got from a user.  A user
trying to set a negative value will get an error.

This is wrong since it breaks all the places that use
DEFINE_DEBUGFS_ATTRIBUTE() with format of a signed integer.

For the record there are 43 current users of signed integer which are
likely to be effected by this:

$ git grep -n -A1 -w DEFINE_DEBUGFS_ATTRIBUTE | grep ');' |
sed 's,.*\(".*%.*"\).*,\1,' | sort | uniq -c
  1 "%08llx\n"
  5 "0x%016llx\n"
  5 "0x%02llx\n"
  5 "0x%04llx\n"
 13 "0x%08llx\n"
  1 "0x%4.4llx\n"
  3 "0x%.4llx\n"
  4 "0x%llx\n"
  1 "%1lld\n"
 40 "%lld\n"
  2 "%lli\n"
129 "%llu\n"
  1 "%#llx\n"
  2 "%llx\n"

u64 is not an issue for negative numbers.
The %lld and %llu in any case are for 64-bit value, representing it as
unsigned simplifies the generic code, but it doesn't mean we can't keep
their signed value if we know that.

This change uses sscanf() to fix the problem since it does the conversion
based on the supplied format string.

Link: https://lkml.kernel.org/r/20220915091544.42767-1-farbere@amazon.com
Fixes: 488dac0c9237 ("libfs: fix error cast of negative value in simple_attr_write()")
Signed-off-by: Eliav Farber <farbere@amazon.com>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@intel.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Hanna Hawa <hhhawa@amazon.com>
Cc: Jonathan Chocron <jonnyc@amazon.com>
Cc: Yicong Yang <yangyicong@hisilicon.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/libfs.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/fs/libfs.c~libfs-fix-error-format-in-simple_attr_write
+++ a/fs/libfs.c
@@ -1017,9 +1017,12 @@ ssize_t simple_attr_write(struct file *f
 		goto out;
 
 	attr->set_buf[size] = '\0';
-	ret = kstrtoull(attr->set_buf, 0, &val);
-	if (ret)
+	ret = sscanf(attr->set_buf, attr->fmt, &val);
+	if (ret != 1) {
+		ret = -EINVAL;
 		goto out;
+	}
+
 	ret = attr->set(attr->data, val);
 	if (ret == 0)
 		ret = len; /* on success, claim we got the whole input */
_

Patches currently in -mm which might be from farbere@amazon.com are


