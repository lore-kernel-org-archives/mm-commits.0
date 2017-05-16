From: akpm@linux-foundation.org
Subject: + exit-dont-include-unused-userfaultfd_kh.patch added to -mm tree
Date: Tue, 16 May 2017 12:55:10 -0700
Message-ID: <591b591e.IAL7fkcN0oaBya1m%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41096 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750949AbdEPTzL (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 16 May 2017 15:55:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rppt@linux.vnet.ibm.com, aarcange@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/exit.c: don't include unused userfaultfd_k.h
has been added to the -mm tree.  Its filename is
     exit-dont-include-unused-userfaultfd_kh.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/exit-dont-include-unused-userfaultfd_kh.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/exit-dont-include-unused-userfaultfd_kh.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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

Patches currently in -mm which might be from rppt@linux.vnet.ibm.com are

exit-dont-include-unused-userfaultfd_kh.patch
userfaultfd-drop-dead-code.patch

