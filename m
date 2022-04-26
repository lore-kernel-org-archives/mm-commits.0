Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65E66C433F5
	for <mm-commits@archiver.kernel.org>; Tue, 26 Apr 2022 19:11:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234098AbiDZTO0 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 26 Apr 2022 15:14:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354323AbiDZTOU (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 26 Apr 2022 15:14:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C15D425C4E
        for <mm-commits@vger.kernel.org>; Tue, 26 Apr 2022 12:11:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 508D061A77
        for <mm-commits@vger.kernel.org>; Tue, 26 Apr 2022 19:11:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DBCEC385A0;
        Tue, 26 Apr 2022 19:11:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1651000268;
        bh=VdJpCulIvtMiacpK5qPBli8TXJwF+7WS6bwX1q8hAJ0=;
        h=Date:To:From:Subject:From;
        b=HX+HFKkoWIOZ5kpHo02rtdxOJgz1YOJ+gt94ayH1gk+wu6Ece9PnVCS/ZsEQ81oO4
         Fb1JuJKxpYbu0FSA2fEgh814VVcJBsW9IG6OTfr8TJrHHIRDNG07RmbptUiAGW5Of0
         j6SIKDpqAVdVi4/hAdhXIANWaAoYIgG+pMCctfIc=
Date:   Tue, 26 Apr 2022 12:11:07 -0700
To:     mm-commits@vger.kernel.org, ying.huang@intel.com,
        willy@infradead.org, rf@opensource.cirrus.com, pmladek@suse.com,
        Jonathan.Cameron@huawei.com, dave.hansen@intel.com,
        andriy.shevchenko@linux.intel.com, adobriyan@gmail.com,
        jvgediya@linux.ibm.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-kstrtoxc-add-false-true-support-to-kstrtobool.patch added to -mm tree
Message-Id: <20220426191108.9DBCEC385A0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib/kstrtox.c: add "false"/"true" support to kstrtobool()
has been added to the -mm tree.  Its filename is
     lib-kstrtoxc-add-false-true-support-to-kstrtobool.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/lib-kstrtoxc-add-false-true-support-to-kstrtobool.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/lib-kstrtoxc-add-false-true-support-to-kstrtobool.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jagdish Gediya <jvgediya@linux.ibm.com>
Subject: lib/kstrtox.c: add "false"/"true" support to kstrtobool()

At many places in kernel, It is necessary to convert sysfs input to
corrosponding bool value e.g.  "false" or "0" need to be converted to bool
false, "true" or "1" need to be converted to bool true, places where such
conversion is needed currently check the input string manually,
kstrtobool() can be utilized at such places but currently it doesn't have
support to accept "false"/"true".

Add support to accept "false"/"true" as valid string in kstrtobool().

Link: https://lkml.kernel.org/r/20220426180203.70782-1-jvgediya@linux.ibm.com
Signed-off-by: Jagdish Gediya <jvgediya@linux.ibm.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Richard Fitzgerald <rf@opensource.cirrus.com>
Cc: Petr Mladek <pmladek@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/kstrtox.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/lib/kstrtox.c~lib-kstrtoxc-add-false-true-support-to-kstrtobool
+++ a/lib/kstrtox.c
@@ -340,7 +340,7 @@ EXPORT_SYMBOL(kstrtos8);
  * @s: input string
  * @res: result
  *
- * This routine returns 0 iff the first character is one of 'Yy1Nn0', or
+ * This routine returns 0 if the first character is one of 'YyTt1NnFf0', or
  * [oO][NnFf] for "on" and "off". Otherwise it will return -EINVAL.  Value
  * pointed to by res is updated upon finding a match.
  */
@@ -353,11 +353,15 @@ int kstrtobool(const char *s, bool *res)
 	switch (s[0]) {
 	case 'y':
 	case 'Y':
+	case 't':
+	case 'T':
 	case '1':
 		*res = true;
 		return 0;
 	case 'n':
 	case 'N':
+	case 'f':
+	case 'F':
 	case '0':
 		*res = false;
 		return 0;
_

Patches currently in -mm which might be from jvgediya@linux.ibm.com are

lib-kstrtoxc-add-false-true-support-to-kstrtobool.patch
mm-convert-sysfs-input-to-bool-using-kstrtobool.patch

