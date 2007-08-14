From: akpm@linux-foundation.org
Subject: - netconsole-remove-bogus-check.patch removed from -mm tree
Date: Tue, 14 Aug 2007 12:13:02 -0700
Message-ID: <200708141913.l7EJD2a3016466@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60510 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932884AbXHNTVA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 14 Aug 2007 15:21:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: satyam@infradead.org, k-keiichi@bx.jp.nec.com, mpm@selenic.com, mm-commits@vger.kernel.org


The patch titled
     netconsole: Remove bogus check
has been removed from the -mm tree.  Its filename was
     netconsole-remove-bogus-check.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: netconsole: Remove bogus check
From: Satyam Sharma <satyam@infradead.org>

Based upon initial work by Keiichi Kii <k-keiichi@bx.jp.nec.com>.

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

git-netdev-all.patch
git-net.patch
introduce-u16_max-and-u32_max.patch
introduce-strtol_check_range.patch
use-mutex-instead-of-semaphore-in-the-onstream-scsi-tape-driver.patch
argv_split-allow-argv_split-to-handle-null-pointer-in-argcp-parameter-gracefully.patch
