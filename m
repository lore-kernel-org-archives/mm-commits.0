From: akpm@linux-foundation.org
Subject: [patch 059/108] kernel/exit.c: don't include unused
 userfaultfd_k.h
Date: Thu, 06 Jul 2017 15:38:32 -0700
Message-ID: <20170706223832.zy9ujpWOl%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36260 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751723AbdGFWid (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 6 Jul 2017 18:38:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, akpm@linux-foundation.org, mm-commits@vger.kernel.org, rppt@linux.vnet.ibm.com, torvalds@linux-foundation.org

From: "Mike Rapoport" <rppt@linux.vnet.ibm.com>
Subject: kernel/exit.c: don't include unused userfaultfd_k.h

dd0db88d8094 ("userfaultfd: non-cooperative: rollback userfaultfd_exit")
removed userfaultfd callback from exit() which makes include of
<linux/userfaultfd_k.h> unnecessary.

Link: http://lkml.kernel.org/r/1494930907-3060-1-git-send-email-rppt@linux.vnet.ibm.com
Signed-off-by: Mike Rapoport <rppt@linux.vnet.ibm.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/exit.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN kernel/exit.c~exit-dont-include-unused-userfaultfd_kh kernel/exit.c
--- a/kernel/exit.c~exit-dont-include-unused-userfaultfd_kh
+++ a/kernel/exit.c
@@ -51,7 +51,6 @@
 #include <linux/task_io_accounting_ops.h>
 #include <linux/tracehook.h>
 #include <linux/fs_struct.h>
-#include <linux/userfaultfd_k.h>
 #include <linux/init_task.h>
 #include <linux/perf_event.h>
 #include <trace/events/sched.h>
_
