From: akpm@linux-foundation.org
Subject: + netconsole-remove-bogus-check.patch added to -mm tree
Date: Mon, 30 Jul 2007 17:13:21 -0700
Message-ID: <200707310013.l6V0DLxv005668@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52386 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S937364AbXGaANn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Jul 2007 20:13:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: satyam@infradead.org, k-keiichi@bx.jp.nec.com, mpm@selenic.com


The patch titled
     netconsole: Remove bogus check
has been added to the -mm tree.  Its filename is
     netconsole-remove-bogus-check.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: netconsole: Remove bogus check
From: Satyam Sharma <satyam@infradead.org>

The (!np.dev) check in write_msg() is bogus (always false), because: np.dev is
set by netpoll_setup(), which is called by init_netconsole() before
register_console(), so write_msg() cannot be triggered unless netpoll_setup()
successfully set np.dev.  Also np.dev cannot go away from under us, because
netpoll_setup() grabs us reference on it.  So let's remove the bogus check.

Signed-off-by: Satyam Sharma <satyam@infradead.org>
Acked-by: Keiichi Kii <k-keiichi@bx.jp.nec.com>
Acked-by: Matt Mackall <mpm@selenic.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/netconsole.c |    3 ---
 1 files changed, 3 deletions(-)

diff -puN drivers/net/netconsole.c~netconsole-remove-bogus-check drivers/net/netconsole.c
--- a/drivers/net/netconsole.c~netconsole-remove-bogus-check
+++ a/drivers/net/netconsole.c
@@ -67,9 +67,6 @@ static void write_msg(struct console *co
 	int frag, left;
 	unsigned long flags;
 
-	if (!np.dev)
-		return;
-
 	local_irq_save(flags);
 
 	for (left = len; left;) {
_

Patches currently in -mm which might be from satyam@infradead.org are

use-mutex-instead-of-semaphore-in-the-dvb-frontend-tuning-interface.patch
netconsole-cleanups-codingstyle-prettyfication.patch
netconsole-remove-bogus-check.patch
netconsole-simplify-boot-module-option-setup-logic.patch
netconsole-use-netif_running-in-write_msg.patch
netconsole-add-some-useful-tips-to-documentation.patch
netconsole-introduce-netconsole_target.patch
netconsole-introduce-netconsole_netdev_notifier.patch
netconsole-support-multiple-logging-targets.patch
netconsole-support-dynamic-reconfiguration-using-configfs.patch
use-mutex-instead-of-semaphore-in-the-onstream-scsi-tape-driver.patch
use-mutex-instead-of-semaphore-in-the-scsi-tape-driver.patch
use-mutex-instead-of-semaphore-in-the-host-ap-driver.patch
use-mutex-instead-of-semaphore-in-isdn-subsystem-common-functions.patch
