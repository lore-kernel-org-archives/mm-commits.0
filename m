From: akpm@linux-foundation.org
Subject: + usb-storage-mystery-fix.patch added to -mm tree
Date: Fri, 16 Nov 2007 13:54:06 -0800
Message-ID: <200711162154.lAGLs7QC005506@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49707 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754704AbXKPV4l (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 16 Nov 2007 16:56:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bharrosh@panasas.com, greg@kroah.com, mdharm-kernel@one-eyed-alien.net, nix.or.die@googlemail.com, oliver@neukum.org, stern@rowland.harvard.edu


The patch titled
     usb-storage: mystery fix
has been added to the -mm tree.  Its filename is
     usb-storage-mystery-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: usb-storage: mystery fix
From: Boaz Harrosh <bharrosh@panasas.com>

needs a sane changelog.

On Thu, Nov 15 2007 at 19:15 +0200, Matthew Dharm <mdharm-kernel@one-eyed-alien.net> wrote:
> On Wed, Nov 14, 2007 at 10:23:09AM +0100, Gabriel C wrote:
>> Matthew Dharm wrote:
>>> On Wed, Nov 14, 2007 at 06:33:39AM +0100, Gabriel C wrote:
>>>> Matthew Dharm wrote:
>>>>> On Tue, Nov 13, 2007 at 07:49:24PM -0800, Greg KH wrote:
>>>>>> Matt, are these the errors you were worried about with the patch we were
>>>>>> just talking about tha tis in my tree?
>>>>> I can't tell from these logs.
>>>> There is the dmesg with CONFIG_USB_STORAGE_DEBUG :
>>>>
>>>> http://194.231.229.228/dmesg-2.6.24-rc2-mm1
>>> Good news: This isn't the bug Greg was worried about.
>>>
>>> Bad news: Something is seriously strange here.  Note the following from the
>>> logs:
>>>
>>> Nov 14 06:07:43 lara [   41.890614] usb-storage: Bulk Status S 0x53425355 T 0xd R 0 Stat 0x0
>>> Nov 14 06:07:43 lara [   41.890616] usb-storage: -- unexpectedly short transfer
>>>
>>> Note the 'R' value of zero -- this is the residue value.  It indicates a
>>> complete transfer, and that matches the log lines immediately previous
>>> which indicate a 4K transfer which completed properly.
>>>
>>> If residue is zero, then srb->resid should be zero.  Take a look in
>>> linux/usb/storage/transport.c in usb_stor_Bulk_transport()
>>>
>>> If srb->resid is zero, then you should NEVER get the "unexpectedly short
>>> transfer" message.  Look at usb_stor_invoke_transport() in the same file.
>> That code got replaced recently but I have no idea about it.
>>
>> ( http://git.kernel.org/?p=linux/kernel/git/jejb/scsi-misc-2.6.git;a=shortlog  see the patches from Boaz Harrosh)
>>
>> srb->resid got replaced by scsi_get_resid() it I see that right.
>>
>> I'm CC'ing the author , he will know I think.
>
> The replacement looks, to my eye, to be logically correct.  The patch was
> pretty clean.
>
> Then again, I haven't looked at what is "under the hood" of the accessor
> functions.  Perhaps there is a side-effect somewhere in there?
>
> Perhaps a quick debugging test -- print the value of scsi_get_resid(srb)
> just after it's initialized to zero at the top of
> usb_stor_invoke_transport(), and then just after the call to
> us->transport().
>

I have found the bug. My bad sorry about that. Patch below
It is because I switched from use of usb_stor_bulk_transfer_sg()
to usb_stor_bulk_transfer_sglist, but forgot the residual handling.

(Please send scsi bugs to scsi list. My lkml mental filters are
much higher, Sorry for not seeing this yesterday)

----
Date: Thu, 15 Nov 2007 20:07:56 +0200
Subject: [PATCH] Fix bug in last usb accessor patch

>>> Bad news: Something is seriously strange here.  Note the following from the
>>> logs:
>>>
>>> Nov 14 06:07:43 lara [   41.890614] usb-storage: Bulk Status S 0x53425355 T 0xd R 0 Stat 0x0
>>> Nov 14 06:07:43 lara [   41.890616] usb-storage: -- unexpectedly short transfer
>>>
>>> Note the 'R' value of zero -- this is the residue value.  It indicates a
>>> complete transfer, and that matches the log lines immediately previous
>>> which indicate a 4K transfer which completed properly.
>>>
>>> If residue is zero, then srb->resid should be zero.  Take a look in
>>> linux/usb/storage/transport.c in usb_stor_Bulk_transport()
>>>
>>> If srb->resid is zero, then you should NEVER get the "unexpectedly short
>>> transfer" message.  Look at usb_stor_invoke_transport() in the same file.
>> That code got replaced recently but I have no idea about it.

  wrong resid handling fixed

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
Tested-by: Gabriel C <nix.or.die@googlemail.com>
Cc: Greg KH <greg@kroah.com>
Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: Oliver Neukum <oliver@neukum.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/storage/transport.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff -puN drivers/usb/storage/transport.c~usb-storage-mystery-fix drivers/usb/storage/transport.c
--- a/drivers/usb/storage/transport.c~usb-storage-mystery-fix
+++ a/drivers/usb/storage/transport.c
@@ -465,11 +465,12 @@ static int usb_stor_bulk_transfer_sglist
 int usb_stor_bulk_srb(struct us_data* us, unsigned int pipe,
 		      struct scsi_cmnd* srb)
 {
-	int resid = scsi_get_resid(srb);
+	unsigned int partial;
 	int result = usb_stor_bulk_transfer_sglist(us, pipe, scsi_sglist(srb),
 				      scsi_sg_count(srb), scsi_bufflen(srb),
-				      &resid);
-	scsi_set_resid(srb, resid);
+				      &partial);
+
+	scsi_set_resid(srb, scsi_bufflen(srb) - partial);
 	return result;
 }
 
_

Patches currently in -mm which might be from bharrosh@panasas.com are

git-scsi-misc.patch
scsi-gdth-kill-unneeded-irq-argument.patch
scsi-gdth-kill-unneeded-irq-argument-checkpatch-fixes.patch
bidi-support-sr-sd-remove-dead-code.patch
bidi-support-tgt-use-scsi_init_io-instead-of-scsi_alloc_sgtable.patch
bidi-support-scsi_data_buffer.patch
bidi-support-scsi_data_buffer-broke-qla1280.patch
bidi-support-scsi_data_buffer-broke-lots-of-stuff.patch
scsi-bidi-support.patch
usb-storage-mystery-fix.patch
