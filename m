From: akpm@linux-foundation.org
Subject: + x86-fix-ghost-entries-under-sys-firmware-edd.patch added to -mm tree
Date: Thu, 02 Oct 2008 23:34:31 -0700
Message-ID: <200810030634.m936YVDC014640@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60244 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753288AbYJCGfD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 3 Oct 2008 02:35:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: arvidjaar@newmail.ru, Matt_Domsch@dell.com, hpa@zytor.com, mingo@elte.hu, tglx@linutronix.de


The patch titled
     x86: fix ghost entries under /sys/firmware/edd
has been added to the -mm tree.  Its filename is
     x86-fix-ghost-entries-under-sys-firmware-edd.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: x86: fix ghost entries under /sys/firmware/edd
From: Andrey Borzenkov <arvidjaar@newmail.ru>

Some BIOSes do not indicate error when trying to read from non- existing
device.  Zero buffer before reading and check that we actually got some
data.

This was fixed in different way for edd.S in
http://marc.info/?l=linux-kernel&m=114087765422490&w=2, but lost again
when edd.S was rewritten in C.

hpa:

   Right, I think that's a much better patch.

   The really Right Thing[TM] to do is probably to pre-clear the buffer
   and then look for the 0xaa55 signature at offset 510; it is required
   for sector 0 to be a valid MBR-format partition table and hence for the
   MBR *signature* to be valid.

   I'll write that up tomorrow (I'm travelling today), or you can send
   me a patch.

akpm:

   A patch in hand is worth...

Signed-off-by: Andrey Borzenkov < arvidjaar@mail.ru>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Matt Domsch <Matt_Domsch@dell.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/boot/edd.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN arch/x86/boot/edd.c~x86-fix-ghost-entries-under-sys-firmware-edd arch/x86/boot/edd.c
--- a/arch/x86/boot/edd.c~x86-fix-ghost-entries-under-sys-firmware-edd
+++ a/arch/x86/boot/edd.c
@@ -60,11 +60,12 @@ static u32 read_mbr_sig(u8 devno, struct
 	if (mbrbuf_end > (char *)(size_t)boot_params.hdr.heap_end_ptr)
 		return -1;
 
+	memset(mbrbuf_ptr, 0, sector_size);
 	if (read_mbr(devno, mbrbuf_ptr))
 		return -1;
 
 	*mbrsig = *(u32 *)&mbrbuf_ptr[EDD_MBR_SIG_OFFSET];
-	return 0;
+	return -!*mbrsig;	/* treat zero signature as no sig */
 }
 
 static int get_edd_info(u8 devno, struct edd_info *ei)
_

Patches currently in -mm which might be from arvidjaar@newmail.ru are

git-x86.patch
x86-fix-ghost-entries-under-sys-firmware-edd.patch

