From: akpm@linux-foundation.org
Subject: + kcov-do-not-instrument-lib-stackdepotc.patch added to -mm tree
Date: Mon, 26 Sep 2016 16:34:02 -0700
Message-ID: <57e9b06a.eXI0LQIXr10qK5Fw%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47296 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753549AbcIZXeD (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 26 Sep 2016 19:34:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: glider@google.com, andreyknvl@google.com, dvyukov@google.com, kcc@google.com, syzkaller@googlegroups.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kcov: do not instrument lib/stackdepot.c
has been added to the -mm tree.  Its filename is
     kcov-do-not-instrument-lib-stackdepotc.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kcov-do-not-instrument-lib-stackdepotc.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kcov-do-not-instrument-lib-stackdepotc.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Alexander Potapenko <glider@google.com>
Subject: kcov: do not instrument lib/stackdepot.c

There's no point in collecting coverage from lib/stackdepot.c, as it is
not a function of syscall inputs.  Disabling kcov instrumentation for that
file will reduce the coverage noise level.

Link: http://lkml.kernel.org/r/1474640972-104131-1-git-send-email-glider@google.com
Signed-off-by: Alexander Potapenko <glider@google.com>
Acked-by: Dmitry Vyukov <dvyukov@google.com>
Cc: Kostya Serebryany <kcc@google.com>
Cc: Andrey Konovalov <andreyknvl@google.com>
Cc: syzkaller <syzkaller@googlegroups.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Makefile |    1 +
 1 file changed, 1 insertion(+)

diff -puN lib/Makefile~kcov-do-not-instrument-lib-stackdepotc lib/Makefile
--- a/lib/Makefile~kcov-do-not-instrument-lib-stackdepotc
+++ a/lib/Makefile
@@ -181,6 +181,7 @@ obj-$(CONFIG_IRQ_POLL) += irq_poll.o
 
 obj-$(CONFIG_STACKDEPOT) += stackdepot.o
 KASAN_SANITIZE_stackdepot.o := n
+KCOV_INSTRUMENT_stackdepot.o := n
 
 libfdt_files = fdt.o fdt_ro.o fdt_wip.o fdt_rw.o fdt_sw.o fdt_strerror.o \
 	       fdt_empty_tree.o
_

Patches currently in -mm which might be from glider@google.com are

kcov-do-not-instrument-lib-stackdepotc.patch

