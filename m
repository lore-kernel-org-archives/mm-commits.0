From: akpm@linux-foundation.org
Subject: +
 panic-release-stale-console-lock-to-always-get-the-logbuf-printed-out.patch added to -mm tree
Date: Wed, 07 Oct 2015 15:34:27 -0700
Message-ID: <56159df3.3N2m4/YW0/vw5o31%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42666 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752770AbbJGWe2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Oct 2015 18:34:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vkuznets@redhat.com, bhe@redhat.com, d.hatayama@jp.fujitsu.com, jack@suse.cz, jkosina@suse.cz, kys@microsoft.com, masami.hiramatsu.pt@hitachi.com, prarit@redhat.com, sjenning@redhat.com, xiexiuqi@huawei.com, mm-commits@vger.kernel.org


The patch titled
     Subject: panic: release stale console lock to always get the logbuf printed out
has been added to the -mm tree.  Its filename is
     panic-release-stale-console-lock-to-always-get-the-logbuf-printed-out.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/panic-release-stale-console-lock-to-always-get-the-logbuf-printed-out.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/panic-release-stale-console-lock-to-always-get-the-logbuf-printed-out.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: panic: release stale console lock to always get the logbuf printed out

In some cases we may end up killing the CPU holding the console lock
while still having valuable data in logbuf. E.g. I'm observing the
following:

- A crash is happening on one CPU and console_unlock() is being called on
  some other.

- console_unlock() tries to print out the buffer before releasing the lock
  and on slow console it takes time.

- in the meanwhile crashing CPU does lots of printk()-s with valuable data
  (which go to the logbuf) and sends IPIs to all other CPUs.

- console_unlock() finishes printing previous chunk and enables interrupts
  before trying to print out the rest, the CPU catches the IPI and never
  releases console lock.

This is not the only possible case: in VT/fb subsystems we have many other
console_lock()/console_unlock() users.  Non-masked interrupts (or
receiving NMI in case of extreme slowness) will have the same result. 
Getting the whole console buffer printed out on crash should be top
priority.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Jiri Kosina <jkosina@suse.cz>
Cc: Baoquan He <bhe@redhat.com>
Cc: Prarit Bhargava <prarit@redhat.com>
Cc: Xie XiuQi <xiexiuqi@huawei.com>
Cc: Seth Jennings <sjenning@redhat.com>
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/panic.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff -puN kernel/panic.c~panic-release-stale-console-lock-to-always-get-the-logbuf-printed-out kernel/panic.c
--- a/kernel/panic.c~panic-release-stale-console-lock-to-always-get-the-logbuf-printed-out
+++ a/kernel/panic.c
@@ -23,6 +23,7 @@
 #include <linux/sysrq.h>
 #include <linux/init.h>
 #include <linux/nmi.h>
+#include <linux/console.h>
 
 #define PANIC_TIMER_STEP 100
 #define PANIC_BLINK_SPD 18
@@ -147,6 +148,15 @@ void panic(const char *fmt, ...)
 
 	bust_spinlocks(0);
 
+	/*
+	 * We may have ended up killing the CPU holding the lock and still have
+	 * some valuable data in console buffer. Try to acquire the lock and
+	 * release it regardless of the result. The release will also print the
+	 * buffers out.
+	 */
+	console_trylock();
+	console_unlock();
+
 	if (!panic_blink)
 		panic_blink = no_blink;
 
_

Patches currently in -mm which might be from vkuznets@redhat.com are

lib-test-string_helpersc-add-string_get_size-tests.patch
lib-test-string_helpersc-add-string_get_size-tests-v5.patch
panic-release-stale-console-lock-to-always-get-the-logbuf-printed-out.patch

