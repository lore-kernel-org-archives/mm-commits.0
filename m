From: akpm@linux-foundation.org
Subject: + tty-fix-switching-consoles-during-suspend.patch added to -mm tree
Date: Wed, 23 Jun 2010 12:30:44 -0700
Message-ID: <201006231930.o5NJUirL027169@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35435 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753405Ab0FWTbU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Jun 2010 15:31:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: arnd@arndb.de, greg@kroah.com


The patch titled
     tty: fix switching consoles during suspend
has been added to the -mm tree.  Its filename is
     tty-fix-switching-consoles-during-suspend.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: tty: fix switching consoles during suspend
From: Arnd Bergmann <arnd@arndb.de>

vt_waitactive now expects to be called with the big tty mutex, which
it tries to release before going to sleep.

This fixes the only caller that does not hold the BTM already.

Greg, please apply to the tty series or fold into
"tty: introduce wait_event_interruptible_tty", which introduces
the problem.

Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/vt_ioctl.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN drivers/char/vt_ioctl.c~tty-fix-switching-consoles-during-suspend drivers/char/vt_ioctl.c
--- a/drivers/char/vt_ioctl.c~tty-fix-switching-consoles-during-suspend
+++ a/drivers/char/vt_ioctl.c
@@ -1761,10 +1761,13 @@ int vt_move_to_console(unsigned int vt, 
 		return -EIO;
 	}
 	release_console_sem();
+	tty_lock();
 	if (vt_waitactive(vt + 1)) {
 		pr_debug("Suspend: Can't switch VCs.");
+		tty_unlock();
 		return -EINTR;
 	}
+	tty_unlock();
 	return prev;
 }
 
_

Patches currently in -mm which might be from arnd@arndb.de are

linux-next.patch
score-fix-dereference-of-null-pointer-in-local_flush_tlb_page.patch
vfs-clarify-that-nonseekable_open-will-never-fail.patch
tty-fix-switching-consoles-during-suspend.patch
kmap_atomic-make-kunmap_atomic-harder-to-misuse.patch
asm-generic-ioh-add-big-endian-versions-of-ioreadwrite1632.patch
alpha-h8300-m68k-remove-obsolete-asm-mdh-files.patch

