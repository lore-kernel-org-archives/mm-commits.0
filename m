From: akpm@linux-foundation.org
Subject: + git-scsi-misc-gdth-fix.patch added to -mm tree
Date: Sun, 14 Oct 2007 17:53:46 -0700
Message-ID: <200710150053.l9F0rkOl010306@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45382 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751396AbXJOAyX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 14 Oct 2007 20:54:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: James.Bottomley@SteelEye.com, davemilter@gmail.com


The patch titled
     git-scsi-misc gdth fix
has been added to the -mm tree.  Its filename is
     git-scsi-misc-gdth-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: git-scsi-misc gdth fix
From: James Bottomley <James.Bottomley@SteelEye.com>

On Sun, 2007-10-14 at 12:21 -0700, Andrew Morton wrote:
> On Sun, 14 Oct 2007 22:45:47 +0400 "Dave Milter" <davemilter@gmail.com> wrote:
>
> > I build linux-2.6.23-mm1 and try to boot it using qemu,
> > and it crashed with trace like this:
> > do_page_fault
> > error_code
> > lock_acquire
> > _spin_lock_irqsave
> > gdth_timeout
> > run_timer_softirq
> > __do_softirq
> > do_softirq
> >
> > I have screenshot, but have no idea, is it legal to include it, if I
> > sent copy to lkml.
> > config of kernel in attachment,
> > I apply all three patches from hot-fixes.
> >
>
> The screenshot is here:  http://userweb.kernel.org/~akpm/crash.png
>
> It would appear that gdth_timeout() is passing a bad pointer into
> spin_lock_irqsave().

There's a bug in the gdth rework in that the instance can be deleted
from the list before the actual timer is stopped.  This can be worked
around I think by the following patch; although we really should be
stopping the timer from firing when the list goes empty.



Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/gdth.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN drivers/scsi/gdth.c~git-scsi-misc-gdth-fix drivers/scsi/gdth.c
--- a/drivers/scsi/gdth.c~git-scsi-misc-gdth-fix
+++ a/drivers/scsi/gdth.c
@@ -3793,6 +3793,9 @@ static void gdth_timeout(ulong data)
     gdth_ha_str *ha;
     ulong flags;
 
+    if (list_empty(&gdth_instances))
+	return;
+
     ha = list_first_entry(&gdth_instances, gdth_ha_str, list);
     spin_lock_irqsave(&ha->smp_lock, flags);
 
_

Patches currently in -mm which might be from James.Bottomley@SteelEye.com are

git-libata-all.patch
introduce-dma_mask_none-as-a-signal-for-unable-to-do.patch
pcmcia-use-dma_mask_none-for-the-default-for-all.patch
git-scsi-misc.patch
git-scsi-misc-gdth-fix.patch
change-struct-marker-users.patch
