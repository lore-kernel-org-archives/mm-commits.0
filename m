From: akpm@linux-foundation.org
Subject: + vcs-invoke-the-vt-update-callback-when-dev-vcs-is-written-to.patch added to -mm tree
Date: Mon, 04 Oct 2010 15:55:38 -0700
Message-ID: <201010042255.o94MtcYN020617@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49498 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756072Ab0JDW4K (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 Oct 2010 18:56:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: nico@fluxnic.net, alan@linux.intel.com, greg@kroah.com, nicolas.pitre@canonical.com


The patch titled
     vcs: invoke the vt update callback when /dev/vcs* is written to
has been added to the -mm tree.  Its filename is
     vcs-invoke-the-vt-update-callback-when-dev-vcs-is-written-to.patch

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
Subject: vcs: invoke the vt update callback when /dev/vcs* is written to
From: Nicolas Pitre <nico@fluxnic.net>

A notifier chain is called whenever the vt code modifies a terminal
content, except for one case which is when the modification comes through
writes to /dev/vcs* devices.  Let's add the missing notifier invocation at
the end of vcs_write() for that case too.

Signed-off-by: Nicolas Pitre <nicolas.pitre@canonical.com>
Cc: Alan Cox <alan@linux.intel.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/vc_screen.c  |    2 ++
 drivers/char/vt.c         |    5 +++++
 include/linux/selection.h |    1 +
 3 files changed, 8 insertions(+)

diff -puN drivers/char/vc_screen.c~vcs-invoke-the-vt-update-callback-when-dev-vcs-is-written-to drivers/char/vc_screen.c
--- a/drivers/char/vc_screen.c~vcs-invoke-the-vt-update-callback-when-dev-vcs-is-written-to
+++ a/drivers/char/vc_screen.c
@@ -530,6 +530,8 @@ vcs_write(struct file *file, const char 
 	}
 	*ppos += written;
 	ret = written;
+	if (written)
+		vcs_scr_updated(vc);
 
 unlock_out:
 	release_console_sem();
diff -puN drivers/char/vt.c~vcs-invoke-the-vt-update-callback-when-dev-vcs-is-written-to drivers/char/vt.c
--- a/drivers/char/vt.c~vcs-invoke-the-vt-update-callback-when-dev-vcs-is-written-to
+++ a/drivers/char/vt.c
@@ -4182,6 +4182,11 @@ void vcs_scr_writew(struct vc_data *vc, 
 	}
 }
 
+void vcs_scr_updated(struct vc_data *vc)
+{
+	notify_update(vc);
+}
+
 /*
  *	Visible symbols for modules
  */
diff -puN include/linux/selection.h~vcs-invoke-the-vt-update-callback-when-dev-vcs-is-written-to include/linux/selection.h
--- a/include/linux/selection.h~vcs-invoke-the-vt-update-callback-when-dev-vcs-is-written-to
+++ a/include/linux/selection.h
@@ -39,5 +39,6 @@ extern void putconsxy(struct vc_data *vc
 
 extern u16 vcs_scr_readw(struct vc_data *vc, const u16 *org);
 extern void vcs_scr_writew(struct vc_data *vc, u16 val, u16 *org);
+extern void vcs_scr_updated(struct vc_data *vc);
 
 #endif
_

Patches currently in -mm which might be from nico@fluxnic.net are

linux-next.patch
vcs-add-poll-fasync-support.patch
vcs-add-poll-fasync-support-fix.patch
vcs-add-poll-fasync-support-fix-fix.patch
vcs-invoke-the-vt-update-callback-when-dev-vcs-is-written-to.patch

