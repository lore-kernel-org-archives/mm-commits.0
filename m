From: akpm@linux-foundation.org
Subject: + cdc-acm-dont-unlock-acm-mutex-on-error-path.patch added to -mm tree
Date: Wed, 23 Jul 2008 12:55:11 -0700
Message-ID: <200807231955.m6NJtBMo008976@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49723 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752768AbYGWTz2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Jul 2008 15:55:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adobriyan@gmail.com, andrei.popa@i-neo.ro, greg@kroah.com, stable@kernel.org


The patch titled
     cdc-acm: don't unlock acm->mutex on error path
has been added to the -mm tree.  Its filename is
     cdc-acm-dont-unlock-acm-mutex-on-error-path.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cdc-acm: don't unlock acm->mutex on error path
From: Alexey Dobriyan <adobriyan@gmail.com>

On Wed, Jul 23, 2008 at 03:52:36PM +0300, Andrei Popa wrote:
> I installed gnokii-0.6.22-r2 and gave the command "gnokii --identify"
> and the kernel oopsed:
>
> BUG: unable to handle kernel NULL pointer dereference at 00000458
> IP: [<c0444b52>] mutex_unlock+0x0/0xb
>  [<c03830ae>] acm_tty_open+0x4c/0x214

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Tested-by: Andrei Popa <andrei.popa@i-neo.ro>
Cc: Greg KH <greg@kroah.com>
Cc: <stable@kernel.org>		[2.6.25.x, 2.6.26.x]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/class/cdc-acm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/usb/class/cdc-acm.c~cdc-acm-dont-unlock-acm-mutex-on-error-path drivers/usb/class/cdc-acm.c
--- a/drivers/usb/class/cdc-acm.c~cdc-acm-dont-unlock-acm-mutex-on-error-path
+++ a/drivers/usb/class/cdc-acm.c
@@ -595,8 +595,8 @@ static int acm_tty_open(struct tty_struc
 	tasklet_schedule(&acm->urb_task);
 
 done:
-err_out:
 	mutex_unlock(&acm->mutex);
+err_out:
 	mutex_unlock(&open_mutex);
 	return rv;
 
_

Patches currently in -mm which might be from adobriyan@gmail.com are

origin.patch
linux-next.patch
cifs-switch-to-seq_files.patch
mpt-remove-unused-struct-mpt_proc_entry_t.patch
move-proc_kmsg_operations-to-fs-proc-internalh.patch
proc-always-do-release.patch
proc-always-do-release-fix.patch
proc-remove-pathetic-remount-code.patch
proc-move-kconfig-to-fs-proc-kconfig.patch
sysctl-allow-override-of-proc-sys-net-with-cap_net_admin.patch
slb-drop-kmem-cache-argument-from-constructor.patch
slb-drop-kmem-cache-argument-from-constructor-fix.patch
slb-drop-kmem-cache-argument-from-constructor-fix-fix.patch
slb-drop-kmem-cache-argument-from-constructor-fix-fix-logfs.patch
slb-drop-kmem-cache-argument-from-constructor-ubifs.patch
use-warn-in-fs-proc.patch
proc-use-non-racy-method-for-proc-page_owner-creation-page_owner.patch
likely_prof-changed-to-use-proc_create.patch
proc-remove-proc_root-from-drivers-likelyprof.patch
cdc-acm-dont-unlock-acm-mutex-on-error-path.patch

