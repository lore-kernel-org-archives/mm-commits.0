From: akpm@linux-foundation.org
Subject: - tty-use-null-for-ptrs.patch removed from -mm tree
Date: Wed, 21 Feb 2007 02:45:54 -0800
Message-ID: <200702211045.l1LAjsDR006407@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:46937 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932564AbXBUKq0 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 21 Feb 2007 05:46:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, mm-commits@vger.kernel.org


The patch titled
     tty: use NULL for ptrs
has been removed from the -mm tree.  Its filename was
     tty-use-null-for-ptrs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: tty: use NULL for ptrs
From: Randy Dunlap <randy.dunlap@oracle.com>

Fix sparse warning in tty_io:
drivers/char/tty_io.c:1536:34: warning: Using plain integer as NULL pointer

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/tty_io.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/char/tty_io.c~tty-use-null-for-ptrs drivers/char/tty_io.c
--- a/drivers/char/tty_io.c~tty-use-null-for-ptrs
+++ a/drivers/char/tty_io.c
@@ -1533,7 +1533,7 @@ void disassociate_ctty(int on_exit)
 
 	spin_lock_irq(&current->sighand->siglock);
 	tty_pgrp = current->signal->tty_old_pgrp;
-	current->signal->tty_old_pgrp = 0;
+	current->signal->tty_old_pgrp = NULL;
 	spin_unlock_irq(&current->sighand->siglock);
 	put_pid(tty_pgrp);
 
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

git-drm.patch
git-libata-all.patch
phy-layer-add-kernel-doc-docbook.patch
git-parisc.patch
x86-dont-probe-for-ddc-on-vbe12.patch
extend-notifier_call_chain-to-count-nr_calls-made-fixes.patch
reiser4-use-null-for-pointers.patch
profile_likely-export-do_check_likely.patch
