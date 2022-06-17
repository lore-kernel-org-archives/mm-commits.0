Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E8D4C433EF
	for <mm-commits@archiver.kernel.org>; Fri, 17 Jun 2022 02:59:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379887AbiFQC7G (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 16 Jun 2022 22:59:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379880AbiFQC7C (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 16 Jun 2022 22:59:02 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2F3D65D10
        for <mm-commits@vger.kernel.org>; Thu, 16 Jun 2022 19:59:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6DD63B826EF
        for <mm-commits@vger.kernel.org>; Fri, 17 Jun 2022 02:59:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11503C3411A;
        Fri, 17 Jun 2022 02:58:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1655434739;
        bh=DSTzZyrquKDT5XGiBe5PuCrkkTprNedeO+Tsv8E58jQ=;
        h=Date:To:From:Subject:From;
        b=x6Tc3BgXTtIDPLaKiJbXnbqIS3/g65FBiK/SVd2mlbp7EAHARC3vXSss3ovzov+jE
         Qlk24DLkiwSk72Mp++4EJYoKuQvx50Cbirrh6UuAlttQRkRHynbIlBcmF6a+BQMOS1
         RKFC23e7HNTCZTIiRMQKfO23UO95DXHfVyC7aHb4=
Date:   Thu, 16 Jun 2022 19:58:58 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        andriy.shevchenko@linux.intel.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] rbtree-replace-kernelh-with-the-necessary-inclusions.patch removed from -mm tree
Message-Id: <20220617025859.11503C3411A@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: include/linux/rbtree.h: replace kernel.h with the necessary inclusions
has been removed from the -mm tree.  Its filename was
     rbtree-replace-kernelh-with-the-necessary-inclusions.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: include/linux/rbtree.h: replace kernel.h with the necessary inclusions
Date: Fri, 3 Jun 2022 20:10:12 +0300

When kernel.h is used in the headers it adds a lot into dependency hell,
especially when there are circular dependencies are involved.

Replace kernel.h inclusion with the list of what is really being used.

Link: https://lkml.kernel.org/r/20220603171012.48880-1-andriy.shevchenko@linux.intel.com
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/rbtree.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/rbtree.h~rbtree-replace-kernelh-with-the-necessary-inclusions
+++ a/include/linux/rbtree.h
@@ -17,9 +17,9 @@
 #ifndef	_LINUX_RBTREE_H
 #define	_LINUX_RBTREE_H
 
+#include <linux/container_of.h>
 #include <linux/rbtree_types.h>
 
-#include <linux/kernel.h>
 #include <linux/stddef.h>
 #include <linux/rcupdate.h>
 
_

Patches currently in -mm which might be from andriy.shevchenko@linux.intel.com are


