From: akpm@linux-foundation.org
Subject: [patch 04/13] kernel/watchdog.c: use better pr_fmt prefix
Date: Fri, 14 Jul 2017 14:49:46 -0700
Message-ID: <59693c7a.zu4F9TfSzQ/S1ZAt%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55744 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751180AbdGNVtr (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 14 Jul 2017 17:49:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, wangkefeng.wang@huawei.com, babu.moger@oracle.com, mingo@kernel.org

From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: kernel/watchdog.c: use better pr_fmt prefix

After 73ce0511c436 ("kernel/watchdog.c: move hardlockup detector to
separate file"), 'NMI watchdog' is inappropriate in kernel/watchdog.c,
using 'watchdog' only.

Link: http://lkml.kernel.org/r/1499928642-48983-1-git-send-email-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Babu Moger <babu.moger@oracle.com>
Cc: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/watchdog.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/watchdog.c~kernel-watchdog-use-better-pr_fmt-prefix kernel/watchdog.c
--- a/kernel/watchdog.c~kernel-watchdog-use-better-pr_fmt-prefix
+++ a/kernel/watchdog.c
@@ -9,7 +9,7 @@
  * to those contributors as well.
  */
 
-#define pr_fmt(fmt) "NMI watchdog: " fmt
+#define pr_fmt(fmt) "watchdog: " fmt
 
 #include <linux/mm.h>
 #include <linux/cpu.h>
_
