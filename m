From: akpm@linux-foundation.org
Subject: - cdc-acm-dont-unlock-acm-mutex-on-error-path.patch removed from -mm tree
Date: Thu, 21 Aug 2008 11:47:18 -0700
Message-ID: <200808211847.m7LIlI8E020185@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41031 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754766AbYHUSrg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 21 Aug 2008 14:47:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, andrei.popa@i-neo.ro, greg@kroah.com, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     cdc-acm: don't unlock acm->mutex on error path
has been removed from the -mm tree.  Its filename was
     cdc-acm-dont-unlock-acm-mutex-on-error-path.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -589,8 +589,8 @@ static int acm_tty_open(struct tty_struc
 	tasklet_schedule(&acm->urb_task);
 
 done:
-err_out:
 	mutex_unlock(&acm->mutex);
+err_out:
 	mutex_unlock(&open_mutex);
 	return rv;
 
_

Patches currently in -mm which might be from adobriyan@gmail.com are

linux-next.patch
x86_64-remove-empty-lines-from-stack-traces-oopses.patch
mpt-remove-unused-struct-mpt_proc_entry_t.patch
cpuset-use-seq_cpumask-seq_nodemask.patch
proc-use-non-racy-method-for-proc-page_owner-creation-page_owner.patch
likely_prof-changed-to-use-proc_create.patch
proc-remove-proc_root-from-drivers-likelyprof.patch

