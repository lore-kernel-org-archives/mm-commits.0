From: akpm@linux-foundation.org
Subject: [merged]
 panic-release-stale-console-lock-to-always-get-the-logbuf-printed-out.patch removed from -mm tree
Date: Mon, 09 Nov 2015 12:13:52 -0800
Message-ID: <5640fe80.nduHxs8bRrpY/sEH%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57714 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752125AbbKIUNx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Nov 2015 15:13:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vkuznets@redhat.com, bhe@redhat.com, d.hatayama@jp.fujitsu.com, jack@suse.cz, jkosina@suse.cz, kys@microsoft.com, masami.hiramatsu.pt@hitachi.com, prarit@redhat.com, sjenning@redhat.com, xiexiuqi@huawei.com, mm-commits@vger.kernel.org


The patch titled
     Subject: panic: release stale console lock to always get the logbuf printed out
has been removed from the -mm tree.  Its filename was
     panic-release-stale-console-lock-to-always-get-the-logbuf-printed-out.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

[akpm@linux-foundation.org: tweak comment text]
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
+	 * We may have ended up stopping the CPU holding the lock (in
+	 * smp_send_stop()) while still having some valuable data in the console
+	 * buffer.  Try to acquire the lock then release it regardless of the
+	 * result.  The release will also print the buffers out.
+	 */
+	console_trylock();
+	console_unlock();
+
 	if (!panic_blink)
 		panic_blink = no_blink;
 
_

Patches currently in -mm which might be from vkuznets@redhat.com are


