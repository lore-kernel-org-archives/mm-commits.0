From: akpm@linux-foundation.org
Subject: [patch 077/102] kcov: do not instrument lib/stackdepot.c
Date: Tue, 11 Oct 2016 13:54:47 -0700
Message-ID: <57fd5197.4aqGcrpUoiAn19wW%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39293 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753186AbcJKVFz (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 11 Oct 2016 17:05:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, glider@google.com, andreyknvl@google.com, dvyukov@google.com, kcc@google.com, syzkaller@googlegroups.com

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
@@ -180,6 +180,7 @@ obj-$(CONFIG_IRQ_POLL) += irq_poll.o
 
 obj-$(CONFIG_STACKDEPOT) += stackdepot.o
 KASAN_SANITIZE_stackdepot.o := n
+KCOV_INSTRUMENT_stackdepot.o := n
 
 libfdt_files = fdt.o fdt_ro.o fdt_wip.o fdt_rw.o fdt_sw.o fdt_strerror.o \
 	       fdt_empty_tree.o
_
