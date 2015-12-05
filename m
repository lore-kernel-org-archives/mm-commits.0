From: akpm@linux-foundation.org
Subject: + kernel-printk-specify-alignment-for-struct-printk_log.patch
 added to -mm tree
Date: Fri, 04 Dec 2015 16:40:29 -0800
Message-ID: <5662327d.tsf5NjTmKqXpJ54X%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48777 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932176AbbLEAka (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Dec 2015 19:40:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aryabinin@virtuozzo.com, corbet@lwn.net, dvyukov@google.com, hpa@zytor.com, kcc@google.com, koct9i@gmail.com, linux@rasmusvillemoes.dk, mingo@redhat.com, mmarek@suse.cz, peterz@infradead.org, rdunlap@infradead.org, sasha.levin@oracle.com, tglx@linutronix.de, y.gribov@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel: printk: specify alignment for struct printk_log
has been added to the -mm tree.  Its filename is
     kernel-printk-specify-alignment-for-struct-printk_log.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kernel-printk-specify-alignment-for-struct-printk_log.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kernel-printk-specify-alignment-for-struct-printk_log.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrey Ryabinin <aryabinin@virtuozzo.com>
Subject: kernel: printk: specify alignment for struct printk_log

On architectures that have support for efficient unaligned access struct
printk_log has 4-byte alignment.  Specify alignment attribute in type
declaration.

The whole point of this patch is to fix deadlock which happening when
UBSAN detects unaligned access in printk() thus UBSAN recursively calls
printk() with logbuf_lock held by top printk() call.

Signed-off-by: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Sasha Levin <sasha.levin@oracle.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Michal Marek <mmarek@suse.cz>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Yury Gribov <y.gribov@samsung.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Konstantin Khlebnikov <koct9i@gmail.com>
Cc: Kostya Serebryany <kcc@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/printk/printk.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN kernel/printk/printk.c~kernel-printk-specify-alignment-for-struct-printk_log kernel/printk/printk.c
--- a/kernel/printk/printk.c~kernel-printk-specify-alignment-for-struct-printk_log
+++ a/kernel/printk/printk.c
@@ -233,7 +233,11 @@ struct printk_log {
 	u8 facility;		/* syslog facility */
 	u8 flags:5;		/* internal record flags */
 	u8 level:3;		/* syslog level */
-};
+}
+#ifdef CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS
+__packed __aligned(4)
+#endif
+;
 
 /*
  * The logbuf_lock protects kmsg buffer, indices, counters.  This can be taken
@@ -274,11 +278,7 @@ static u32 clear_idx;
 #define LOG_FACILITY(v)		((v) >> 3 & 0xff)
 
 /* record buffer */
-#if defined(CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS)
-#define LOG_ALIGN 4
-#else
 #define LOG_ALIGN __alignof__(struct printk_log)
-#endif
 #define __LOG_BUF_LEN (1 << CONFIG_LOG_BUF_SHIFT)
 static char __log_buf[__LOG_BUF_LEN] __aligned(LOG_ALIGN);
 static char *log_buf = __log_buf;
_

Patches currently in -mm which might be from aryabinin@virtuozzo.com are

kernel-printk-specify-alignment-for-struct-printk_log.patch
mac80211-prevent-build-failure-with-config_ubsan=y.patch
ubsan-run-time-undefined-behavior-sanity-checker.patch

