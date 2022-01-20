Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60A96C433F5
	for <mm-commits@archiver.kernel.org>; Thu, 20 Jan 2022 21:29:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377916AbiATV3u (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 20 Jan 2022 16:29:50 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:39270 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347984AbiATV3u (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 20 Jan 2022 16:29:50 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 469246188C
        for <mm-commits@vger.kernel.org>; Thu, 20 Jan 2022 21:29:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A185C340E0;
        Thu, 20 Jan 2022 21:29:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642714189;
        bh=+h7R8jMNHODyH+8DaF45Lo+S/6ZuC31eu+6GMqiEi0E=;
        h=Date:From:To:Subject:From;
        b=hBVwU6jknGNXyB6TDtSBc7d4RoQwQkIuGX4+oAQ2wEw4/OFvxdARbEpyBYjPeJMsx
         jr/Q9MUuXuKFxjH4aQGIps/22QocLYOU3SJg/6L4shuPU1HZIxYy+LI9J8WKKEsIIe
         vNM+2rgXd0dhuUxbXflZtHaHV2VXRhfk0ODDApY0=
Date:   Thu, 20 Jan 2022 13:29:49 -0800
From:   akpm@linux-foundation.org
To:     andriy.shevchenko@linux.intel.com, mm-commits@vger.kernel.org
Subject:  [merged]
 =?US-ASCII?Q?kernelh-include-a-note-to-discourage-people-from-including?=
 =?US-ASCII?Q?-it-in-headers.patch?= removed from -mm tree
Message-ID: <20220120212949.IMwN2g8Vv%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kernel.h: include a note to discourage people from including it in headers
has been removed from the -mm tree.  Its filename was
     kernelh-include-a-note-to-discourage-people-from-including-it-in-headers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


