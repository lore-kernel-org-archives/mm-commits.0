Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DCFC1C07E95
	for <mm-commits@archiver.kernel.org>; Fri, 16 Jul 2021 04:03:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BF0BA613E5
	for <mm-commits@archiver.kernel.org>; Fri, 16 Jul 2021 04:03:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229578AbhGPEG3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 16 Jul 2021 00:06:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:44242 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229507AbhGPEG2 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 16 Jul 2021 00:06:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9D46D6115B;
        Fri, 16 Jul 2021 04:03:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1626408214;
        bh=mi7BFcxsdhqcpKftEB1p8F/wtgQoMquKc4IIwkLHk3w=;
        h=Date:From:To:Subject:From;
        b=1DXMREZ17ARKKTWUfscSecsFu2IcZQHY9LGrgf5EQmP922HtPHs4OI8fFaVvDT79q
         9hVp3tnc4y8WqfTCT4vsV4MEjGBzcOVDydTQSsE0VGS91AH8nBng66K+TZxGu7ISQw
         RRe5TOEFta9DTev+6l+B16+TfhhFuCQ9M44SC8ks=
Date:   Thu, 15 Jul 2021 21:03:34 -0700
From:   akpm@linux-foundation.org
To:     adobriyan@gmail.com, christian.brauner@ubuntu.com,
        davem@davemloft.net, ebiederm@xmission.com, mingo@kernel.org,
        mm-commits@vger.kernel.org, ohoono.kwon@samsung.com
Subject:  + connector-send-event-on-write-to-proc-comm.patch added
 to -mm tree
Message-ID: <20210716040334.BNrG93r31%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: connector: send event on write to /proc/[pid]/comm
has been added to the -mm tree.  Its filename is
     connector-send-event-on-write-to-proc-comm.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/connector-send-event-on-write-to-proc-comm.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/connector-send-event-on-write-to-proc-comm.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Ohhoon Kwon <ohoono.kwon@samsung.com>
Subject: connector: send event on write to /proc/[pid]/comm

While comm change event via prctl has been reported to proc connector by
'commit f786ecba4158 ("connector: add comm change event report to proc
connector")', connector listeners were missing comm changes by explicit
writes on /proc/[pid]/comm.

Let explicit writes on /proc/[pid]/comm report to proc connector.

Link: https://lkml.kernel.org/r/20210701133458epcms1p68e9eb9bd0eee8903ba26679a37d9d960@epcms1p6
Signed-off-by: Ohhoon Kwon <ohoono.kwon@samsung.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: David S. Miller <davem@davemloft.net>
Cc: Christian Brauner <christian.brauner@ubuntu.com>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/base.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/fs/proc/base.c~connector-send-event-on-write-to-proc-comm
+++ a/fs/proc/base.c
@@ -95,6 +95,7 @@
 #include <linux/posix-timers.h>
 #include <linux/time_namespace.h>
 #include <linux/resctrl.h>
+#include <linux/cn_proc.h>
 #include <trace/events/oom.h>
 #include "internal.h"
 #include "fd.h"
@@ -1674,8 +1675,10 @@ static ssize_t comm_write(struct file *f
 	if (!p)
 		return -ESRCH;
 
-	if (same_thread_group(current, p))
+	if (same_thread_group(current, p)) {
 		set_task_comm(p, buffer);
+		proc_comm_connector(p);
+	}
 	else
 		count = -EINVAL;
 
_

Patches currently in -mm which might be from ohoono.kwon@samsung.com are

mm-sparse-pass-section_nr-to-section_mark_present.patch
mm-sparse-pass-section_nr-to-find_memory_block.patch
mm-sparse-remove-__section_nr-function.patch
connector-send-event-on-write-to-proc-comm.patch

