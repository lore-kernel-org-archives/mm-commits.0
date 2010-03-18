From: akpm@linux-foundation.org
Subject: + nommu-allow-private-mappings-of-read-only-devices.patch added to -mm tree
Date: Thu, 18 Mar 2010 14:23:59 -0700
Message-ID: <201003182123.o2ILNxrX016417@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35248 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751379Ab0CRVY1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Mar 2010 17:24:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bernds_cb1@t-online.de, davidm@snapgear.com, dhowells@redhat.com, gerg@uclinux.org, hugh.dickins@tiscali.co.uk, lethal@linux-sh.org, vapier@gentoo.org


The patch titled
     nommu: allow private mappings of read-only devices
has been added to the -mm tree.  Its filename is
     nommu-allow-private-mappings-of-read-only-devices.patch

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
Subject: nommu: allow private mappings of read-only devices
From: Bernd Schmidt <bernds_cb1@t-online.de>

Slightly rearrange the logic that determines capabilities and vm_flags. 
Disable BDI_CAP_MAP_DIRECT in all cases if the device can't support the
protections.  Allow private readonly mappings of readonly backing devices.

Signed-off-by: Bernd Schmidt <bernds_cb1@t-online.de>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Cc: David McCullough <davidm@snapgear.com>
Cc: Greg Ungerer <gerg@uclinux.org>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: David Howells <dhowells@redhat.com>
Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/nommu.c |   32 ++++++++++++++++++--------------
 1 file changed, 18 insertions(+), 14 deletions(-)

diff -puN mm/nommu.c~nommu-allow-private-mappings-of-read-only-devices mm/nommu.c
--- a/mm/nommu.c~nommu-allow-private-mappings-of-read-only-devices
+++ a/mm/nommu.c
@@ -918,14 +918,6 @@ static int validate_mmap_request(struct 
 			if (!(capabilities & BDI_CAP_MAP_DIRECT))
 				return -ENODEV;
 
-			if (((prot & PROT_READ)  && !(capabilities & BDI_CAP_READ_MAP))  ||
-			    ((prot & PROT_WRITE) && !(capabilities & BDI_CAP_WRITE_MAP)) ||
-			    ((prot & PROT_EXEC)  && !(capabilities & BDI_CAP_EXEC_MAP))
-			    ) {
-				printk("MAP_SHARED not completely supported on !MMU\n");
-				return -EINVAL;
-			}
-
 			/* we mustn't privatise shared mappings */
 			capabilities &= ~BDI_CAP_MAP_COPY;
 		}
@@ -941,6 +933,20 @@ static int validate_mmap_request(struct 
 				capabilities &= ~BDI_CAP_MAP_DIRECT;
 		}
 
+		if (capabilities & BDI_CAP_MAP_DIRECT) {
+			if (((prot & PROT_READ)  && !(capabilities & BDI_CAP_READ_MAP))  ||
+			    ((prot & PROT_WRITE) && !(capabilities & BDI_CAP_WRITE_MAP)) ||
+			    ((prot & PROT_EXEC)  && !(capabilities & BDI_CAP_EXEC_MAP))
+			    ) {
+				capabilities &= ~BDI_CAP_MAP_DIRECT;
+				if (flags & MAP_SHARED) {
+					printk(KERN_WARNING
+					       "MAP_SHARED not completely supported on !MMU\n");
+					return -EINVAL;
+				}
+			}
+		}
+
 		/* handle executable mappings and implied executable
 		 * mappings */
 		if (file->f_path.mnt->mnt_flags & MNT_NOEXEC) {
@@ -996,22 +1002,20 @@ static unsigned long determine_vm_flags(
 	unsigned long vm_flags;
 
 	vm_flags = calc_vm_prot_bits(prot) | calc_vm_flag_bits(flags);
-	vm_flags |= VM_MAYREAD | VM_MAYWRITE | VM_MAYEXEC;
 	/* vm_flags |= mm->def_flags; */
 
 	if (!(capabilities & BDI_CAP_MAP_DIRECT)) {
 		/* attempt to share read-only copies of mapped file chunks */
+		vm_flags |= VM_MAYREAD | VM_MAYWRITE | VM_MAYEXEC;
 		if (file && !(prot & PROT_WRITE))
 			vm_flags |= VM_MAYSHARE;
-	}
-	else {
+	} else {
 		/* overlay a shareable mapping on the backing device or inode
 		 * if possible - used for chardevs, ramfs/tmpfs/shmfs and
 		 * romfs/cramfs */
+		vm_flags |= VM_MAYSHARE | (capabilities & BDI_CAP_VMFLAGS);
 		if (flags & MAP_SHARED)
-			vm_flags |= VM_MAYSHARE | VM_SHARED;
-		else if ((((vm_flags & capabilities) ^ vm_flags) & BDI_CAP_VMFLAGS) == 0)
-			vm_flags |= VM_MAYSHARE;
+			vm_flags |= VM_SHARED;
 	}
 
 	/* refuse to let anyone share private mappings with this process if
_

Patches currently in -mm which might be from bernds_cb1@t-online.de are

nommu-allow-private-mappings-of-read-only-devices.patch

