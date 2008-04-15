From: akpm@linux-foundation.org
Subject: + sysvipc-use-non-racy-method-for-proc-entries-creation.patch added to -mm tree
Date: Tue, 15 Apr 2008 16:56:09 -0700
Message-ID: <200804152356.m3FNu9MM022509@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41854 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753521AbYDOX4p (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Apr 2008 19:56:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: den@openvz.org, Nadia.Derbey@bull.net, adobriyan@gmail.com, ebiederm@xmission.com, peifferp@gmail.com


The patch titled
     sysvipc: use non-racy method for proc entries creation
has been added to the -mm tree.  Its filename is
     sysvipc-use-non-racy-method-for-proc-entries-creation.patch

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
Subject: sysvipc: use non-racy method for proc entries creation
From: "Denis V. Lunev" <den@openvz.org>

Use proc_create_data() to make sure that ->proc_fops and ->data be setup
before gluing PDE to main tree.

Signed-off-by: Denis V. Lunev <den@openvz.org>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Nadia Derbey <Nadia.Derbey@bull.net>
Cc: Pierre Peiffer <peifferp@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/util.c |   13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff -puN ipc/util.c~sysvipc-use-non-racy-method-for-proc-entries-creation ipc/util.c
--- a/ipc/util.c~sysvipc-use-non-racy-method-for-proc-entries-creation
+++ a/ipc/util.c
@@ -165,13 +165,12 @@ void __init ipc_init_proc_interface(cons
 	iface->ids	= ids;
 	iface->show	= show;
 
-	pde = create_proc_entry(path,
-				S_IRUGO,        /* world readable */
-				NULL            /* parent dir */);
-	if (pde) {
-		pde->data = iface;
-		pde->proc_fops = &sysvipc_proc_fops;
-	} else {
+	pde = proc_create_data(path,
+			       S_IRUGO,        /* world readable */
+			       NULL,           /* parent dir */
+			       &sysvipc_proc_fops,
+			       iface);
+	if (!pde) {
 		kfree(iface);
 	}
 }
_

Patches currently in -mm which might be from den@openvz.org are

git-net.patch
proc-introduce-proc_create_data-to-setup-de-data.patch
nfsd-use-proc_create-to-setup-de-proc_fops.patch
nfs-use-proc_create-to-setup-de-proc_fops.patch
afs-use-non-racy-method-for-proc-entries-creation.patch
ext4-use-non-racy-method-for-proc-entries-creation.patch
reiserfs-use-non-racy-method-for-proc-entries-creation.patch
jbd2-use-non-racy-method-for-proc-entries-creation.patch
sysvipc-use-non-racy-method-for-proc-entries-creation.patch
mm-use-non-racy-method-for-proc-swaps-creation.patch
sound-use-non-racy-method-for-proc-driver-snd-page-alloc-creation.patch
zorro-use-non-racy-method-for-proc-entries-creation.patch
samples-use-non-racy-method-for-proc-marker-example-creation.patch
scsi-use-non-racy-method-for-proc-entries-creation.patch
usb-use-non-racy-method-for-proc-entries-creation.patch
s390-use-non-racy-method-for-proc-entries-creation.patch
arm-use-non-racy-method-for-proc-davinci_clocks-creation.patch
avr32-proc-use-non-racy-method-for-proc-tlb-creation.patch
cris-use-non-racy-method-for-proc-system_profile-creation.patch
ia64-use-non-racy-method-for-proc-entries-creation.patch
parisc-use-non-racy-method-for-proc-pcxl_dma-creation.patch
powerpc-use-non-racy-method-for-proc-entries-creation.patch
acpi-use-non-racy-method-for-proc-entries-creation.patch
netdev-use-non-racy-method-for-proc-entries-creation.patch
isdn-use-non-racy-method-for-proc-entries-creation.patch
kernel-use-non-racy-method-for-proc-entries-creation.patch
parisc-use-non-racy-method-for-proc-entries-creation.patch
drivers-use-non-racy-method-for-proc-entries-creation.patch
drivers-use-non-racy-method-for-proc-entries-creation-2.patch
sysctl-merge-equal-proc_sys_read-and-proc_sys_write.patch
sysctl-clean-from-unneeded-extern-and-forward-declarations.patch
sysctl-add-the-permissions-callback-on-the-ctl_table_root.patch
proc-use-non-racy-method-for-proc-page_owner-creation-page_owner.patch

