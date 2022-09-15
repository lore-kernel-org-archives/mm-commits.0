Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DCE08C32771
	for <mm-commits@archiver.kernel.org>; Thu, 15 Sep 2022 21:34:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229627AbiIOVec (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 15 Sep 2022 17:34:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229510AbiIOVeb (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 15 Sep 2022 17:34:31 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1584B08
        for <mm-commits@vger.kernel.org>; Thu, 15 Sep 2022 14:34:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7FCE6B8163C
        for <mm-commits@vger.kernel.org>; Thu, 15 Sep 2022 21:34:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BC15C433D6;
        Thu, 15 Sep 2022 21:34:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1663277666;
        bh=7wKcvhry+ltH4bAr2gYfxAaNzKPhY1PZMCo5CZHSfnA=;
        h=Date:To:From:Subject:From;
        b=zNInS47fEKwGmBB6YUgh+IxiMgL3xqVxY0b0UwzWmnHbwsfPwHSYR2IF99i4VtGkd
         +Xr1s9asG88wd5FSbM40X+DIFj6RIvdTzbG4OY6/VKQ+E9lId9tdDFn0wJRxaoUT2E
         lALm9Gofapk+CWM5Ea5n6hUjPas1k8oAnWTkBHRE=
Date:   Thu, 15 Sep 2022 14:34:25 -0700
To:     mm-commits@vger.kernel.org, yangyicong@hisilicon.com,
        viro@zeniv.linux.org.uk, jonnyc@amazon.com, hhhawa@amazon.com,
        andriy.shevchenko@intel.com, farbere@amazon.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + libfs-fix-error-format-in-simple_attr_write.patch added to mm-nonmm-unstable branch
Message-Id: <20220915213426.3BC15C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: libfs: fix error format in simple_attr_write()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     libfs-fix-error-format-in-simple_attr_write.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/libfs-fix-error-format-in-simple_attr_write.patch

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

libfs-fix-error-format-in-simple_attr_write.patch

