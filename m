From: akpm@linux-foundation.org
Subject: + kernel-printkc-document-possible-deadlock-against-scheduler.patch added to -mm tree
Date: Thu, 05 Jul 2007 13:52:57 -0700
Message-ID: <200707052052.l65Kqvjw018718@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40888 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759280AbXGEUxG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jul 2007 16:53:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jkosina@suse.cz


The patch titled
     kernel/printk.c: document possible deadlock against scheduler
has been added to the -mm tree.  Its filename is
     kernel-printkc-document-possible-deadlock-against-scheduler.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: kernel/printk.c: document possible deadlock against scheduler
From: Jiri Kosina <jkosina@suse.cz>

kernel/printk.c: document possible deadlock against scheduler

The printk's comment states that it can be called from every context,
which might lead to false illusion that it could be called from everywhere
without any restrictions.

This is however not true - a call to printk() could deadlock if called from
scheduler code (namely from schedule(), wake_up(), etc) on runqueue lock
when it tries to wake up klogd. Document this.

Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/printk.c |    3 +++
 1 files changed, 3 insertions(+)

diff -puN kernel/printk.c~kernel-printkc-document-possible-deadlock-against-scheduler kernel/printk.c
--- a/kernel/printk.c~kernel-printkc-document-possible-deadlock-against-scheduler
+++ a/kernel/printk.c
@@ -486,6 +486,9 @@ static int have_callable_console(void)
  * @fmt: format string
  *
  * This is printk().  It can be called from any context.  We want it to work.
+ * Be aware of the fact that if oops_in_progress is not set, we might try to
+ * wake klogd up which could deadlock on runqueue lock if printk() is called
+ * from scheduler code.
  *
  * We try to grab the console_sem.  If we succeed, it's easy - we log the output and
  * call the console drivers.  If we fail to get the semaphore we place the output
_

Patches currently in -mm which might be from jkosina@suse.cz are

git-hid.patch
irtouchsystems-support-for-usbtouchscreen.patch
git-ipwireless_cs.patch
pie-randomization.patch
kernel-printkc-document-possible-deadlock-against-scheduler.patch
