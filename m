From: akpm@linux-foundation.org
Subject: [patch 05/13] fault-inject: automatically detect the number base
 for fail-nth write interface
Date: Fri, 14 Jul 2017 14:49:49 -0700
Message-ID: <59693c7d.COkZWqgpeSKLuol1%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55752 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751187AbdGNVtu (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 14 Jul 2017 17:49:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, akinobu.mita@gmail.com, dvyukov@google.com

From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: fault-inject: automatically detect the number base for fail-nth write interface

Automatically detect the number base to use when writing to fail-nth file
instead of always parsing as a decimal number.

Link: http://lkml.kernel.org/r/1491490561-10485-2-git-send-email-akinobu.mita@gmail.com
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/base.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/proc/base.c~fault-inject-automatically-detect-the-number-base-for-fail-nth-write-interface fs/proc/base.c
--- a/fs/proc/base.c~fault-inject-automatically-detect-the-number-base-for-fail-nth-write-interface
+++ a/fs/proc/base.c
@@ -1368,7 +1368,7 @@ static ssize_t proc_fail_nth_write(struc
 	put_task_struct(task);
 	if (task != current)
 		return -EPERM;
-	err = kstrtoint_from_user(buf, count, 10, &n);
+	err = kstrtoint_from_user(buf, count, 0, &n);
 	if (err)
 		return err;
 	if (n < 0 || n == INT_MAX)
_
