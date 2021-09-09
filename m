Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6CA30C4321E
	for <mm-commits@archiver.kernel.org>; Thu,  9 Sep 2021 21:04:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 58F88611C4
	for <mm-commits@archiver.kernel.org>; Thu,  9 Sep 2021 21:04:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344885AbhIIVFi (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 9 Sep 2021 17:05:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:54604 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244755AbhIIVEf (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 9 Sep 2021 17:04:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 69EFB6109F;
        Thu,  9 Sep 2021 21:03:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1631221405;
        bh=AZI2pVmLZXITRDVJclTwS84gXnSQTXsdgoLBGctJ0pA=;
        h=Date:From:To:Subject:From;
        b=rUq9n9jwf9oPZPK8QgvZKV5Uoa97H1j8e5mr/hAwySEojtBUDWEJymT7A6UYzhZ73
         h1D5XgErsQb93ENiVS3msJKwMi9mcKRIrQx68vp4klPvZJWmFLDlDVqIOXGMSi8VQW
         VR3gqOiOWdHNT3ixxQXHc6acPyHO3J8BYQZVruo8=
Date:   Thu, 09 Sep 2021 14:03:25 -0700
From:   akpm@linux-foundation.org
To:     adobriyan@gmail.com, christian.brauner@ubuntu.com,
        davem@davemloft.net, ebiederm@xmission.com, mingo@kernel.org,
        mm-commits@vger.kernel.org, ohoono.kwon@samsung.com
Subject:  [merged] connector-send-event-on-write-to-proc-comm.patch
 removed from -mm tree
Message-ID: <20210909210325.9XOFOkAKo%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: connector: send event on write to /proc/[pid]/comm
has been removed from the -mm tree.  Its filename was
     connector-send-event-on-write-to-proc-comm.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


