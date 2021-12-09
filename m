Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E98EC433EF
	for <mm-commits@archiver.kernel.org>; Thu,  9 Dec 2021 20:29:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231529AbhLIUdV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 9 Dec 2021 15:33:21 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:32922 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229850AbhLIUdV (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 9 Dec 2021 15:33:21 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0AAB8B82410
        for <mm-commits@vger.kernel.org>; Thu,  9 Dec 2021 20:29:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1E88C004DD;
        Thu,  9 Dec 2021 20:29:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1639081785;
        bh=wQe7mnjgwwfXujsLgGoBCkFiXqvDmjOOe1/rpblp6Ro=;
        h=Date:From:To:Subject:From;
        b=hDV9RCr0CzOdKdKxk/COodUe7ZPfvU4ZBfDvhMEbux8DThIFuFN1bIoX1yRLRctB/
         xVcDLj/71kuxreyUMZt2Bbka9pBO2Umig/nqLsDNRike5bjMSNMEhff7qfU6YZtB2P
         eDBo22liDwfcrb3/ej3gNcFYMGu5OxAjN75ex+P4=
Date:   Thu, 09 Dec 2021 12:29:45 -0800
From:   akpm@linux-foundation.org
To:     andriy.shevchenko@linux.intel.com, mm-commits@vger.kernel.org
Subject:  +
 =?US-ASCII?Q?kernelh-include-a-note-to-discourage-people-from-including?=
 =?US-ASCII?Q?-it-in-headers.patch?= added to -mm tree
Message-ID: <20211209202945.hhyFHi0cq%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kernel.h: include a note to discourage people from including it in headers
has been added to the -mm tree.  Its filename is
     kernelh-include-a-note-to-discourage-people-from-including-it-in-headers.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/kernelh-include-a-note-to-discourage-people-from-including-it-in-headers.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/kernelh-include-a-note-to-discourage-people-from-including-it-in-headers.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: kernel.h: include a note to discourage people from including it in headers

Include a note at the top to discourage people from including it in
headers.

Link: https://lkml.kernel.org/r/20211209150803.4473-1-andriy.shevchenko@linux.intel.com
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kernel.h |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/include/linux/kernel.h~kernelh-include-a-note-to-discourage-people-from-including-it-in-headers
+++ a/include/linux/kernel.h
@@ -1,4 +1,13 @@
 /* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * NOTE:
+ *
+ * This header has combined a lot of unrelated to each other stuff.
+ * The process of splitting its content is in progress while keeping
+ * backward compatibility. That's why it's highly recommended NOT to
+ * include this header inside another header file, especially under
+ * generic or architectural include/ directory.
+ */
 #ifndef _LINUX_KERNEL_H
 #define _LINUX_KERNEL_H
 
_

Patches currently in -mm which might be from andriy.shevchenko@linux.intel.com are

kernelh-include-a-note-to-discourage-people-from-including-it-in-headers.patch
list-introduce-list_is_head-helper-and-re-use-it-in-listh.patch

