From: akpm@linux-foundation.org
Subject: + kdump-fix-exported-size-of-vmcoreinfo-note.patch added to -mm
 tree
Date: Tue, 14 Jan 2014 15:37:19 -0800
Message-ID: <52d5ca2f.3fDa14J6lBOGitLX%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34863 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751841AbaANXhU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 14 Jan 2014 18:37:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, oomichi@mxs.nes.nec.co.jp, greg@kroah.com, da-x@monatomic.org, vgoyal@redhat.com

Subject: + kdump-fix-exported-size-of-vmcoreinfo-note.patch added to -mm tree
To: vgoyal@redhat.com,da-x@monatomic.org,greg@kroah.com,oomichi@mxs.nes.nec.co.jp
From: akpm@linux-foundation.org
Date: Tue, 14 Jan 2014 15:37:19 -0800


The patch titled
     Subject: kdump: fix exported size of vmcoreinfo note
has been added to the -mm tree.  Its filename is
     kdump-fix-exported-size-of-vmcoreinfo-note.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kdump-fix-exported-size-of-vmcoreinfo-note.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kdump-fix-exported-size-of-vmcoreinfo-note.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Vivek Goyal <vgoyal@redhat.com>
Subject: kdump: fix exported size of vmcoreinfo note

Right now we seem to be exporting the max data size contained inside
vmcoreinfo note.  But this does not include the size of meta data around
vmcore info data.  Like name of the note and starting and ending elf_note.

I think user space expects total size and that size is put in PT_NOTE elf
header.  Things seem to be fine so far because we are not using vmcoreinfo
note to the maximum capacity.  But as it starts filling up, to capacity,
at some point of time, problem will be visible.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
Cc: Ken'ichi Ohmichi <oomichi@mxs.nes.nec.co.jp>
Cc: Dan Aloni <da-x@monatomic.org>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/ksysfs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/ksysfs.c~kdump-fix-exported-size-of-vmcoreinfo-note kernel/ksysfs.c
--- a/kernel/ksysfs.c~kdump-fix-exported-size-of-vmcoreinfo-note
+++ a/kernel/ksysfs.c
@@ -126,7 +126,7 @@ static ssize_t vmcoreinfo_show(struct ko
 {
 	return sprintf(buf, "%lx %x\n",
 		       paddr_vmcoreinfo_note(),
-		       (unsigned int)vmcoreinfo_max_size);
+		       (unsigned int)sizeof(vmcoreinfo_note));
 }
 KERNEL_ATTR_RO(vmcoreinfo);
 
_

Patches currently in -mm which might be from vgoyal@redhat.com are

crash_dump-fix-compilation-error-on-mips-at-least.patch
kexec-add-sysctl-to-disable-kexec_load.patch
kdump-fix-exported-size-of-vmcoreinfo-note.patch
linux-next.patch

