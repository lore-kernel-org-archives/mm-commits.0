Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11DC4C433F5
	for <mm-commits@archiver.kernel.org>; Fri, 13 May 2022 19:22:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383761AbiEMTWW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 13 May 2022 15:22:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383607AbiEMTVe (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 13 May 2022 15:21:34 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92D6E36337
        for <mm-commits@vger.kernel.org>; Fri, 13 May 2022 12:21:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 462CEB8310B
        for <mm-commits@vger.kernel.org>; Fri, 13 May 2022 19:21:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02B72C34100;
        Fri, 13 May 2022 19:21:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652469690;
        bh=BmXiusHF1oGFkHnYnjgn8XAEI4z9oyXivqwl0xe3q08=;
        h=Date:To:From:Subject:From;
        b=13dNL5FnPsAjVRE48FPApMbZbS0lqIGf0QA82E7xy/ChZ3opsKt0Fhhl2qtkSQIHL
         Mc2Zu1c/U46DdrGedvunkt7dzP+TSaTinxuYhtziD/ZoU8HGk8f24L47TVrcbvEcu5
         hpAahlevdfSvFNnzGNfIHieNHOxaVaQh5p5kULvI=
Date:   Fri, 13 May 2022 12:21:29 -0700
To:     mm-commits@vger.kernel.org, ying.huang@intel.com,
        willy@infradead.org, rf@opensource.cirrus.com, pmladek@suse.com,
        Jonathan.Cameron@huawei.com, dave.hansen@intel.com,
        andy.shevchenko@gmail.com, adobriyan@gmail.com,
        jvgediya@linux.ibm.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] lib-kstrtoxc-add-false-true-support-to-kstrtobool.patch removed from -mm tree
Message-Id: <20220513192130.02B72C34100@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: lib/kstrtox.c: add "false"/"true" support to kstrtobool()
has been removed from the -mm tree.  Its filename was
     lib-kstrtoxc-add-false-true-support-to-kstrtobool.patch

This patch was dropped because it was merged into the mm-stable branch\nof git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Jagdish Gediya <jvgediya@linux.ibm.com>
Subject: lib/kstrtox.c: add "false"/"true" support to kstrtobool()

At many places in kernel, It is necessary to convert sysfs input to
corresponding bool value e.g.  "false" or "0" need to be converted to bool
false, "true" or "1" need to be converted to bool true, places where such
conversion is needed currently check the input string manually,
kstrtobool() can be utilized at such places but currently it doesn't have
support to accept "false"/"true".

Add support to accept "false"/"true" as valid string in kstrtobool().

[akpm@linux-foundation.org: undo s/iff/if/, per Matthew]
Link: https://lkml.kernel.org/r/20220426180203.70782-1-jvgediya@linux.ibm.com
Signed-off-by: Jagdish Gediya <jvgediya@linux.ibm.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
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
+ * This routine returns 0 iff the first character is one of 'YyTt1NnFf0', or
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


