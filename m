From: akpm@linux-foundation.org
Subject: + sound-use-non-racy-method-for-proc-driver-snd-page-alloc-creation.patch added to -mm tree
Date: Tue, 15 Apr 2008 16:56:13 -0700
Message-ID: <200804152356.m3FNuDow022515@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40179 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752810AbYDOX4Z (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Apr 2008 19:56:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: den@openvz.org, adobriyan@gmail.com, ebiederm@xmission.com, perex@suse.cz, tiwai@suse.de


The patch titled
     sound: use non-racy method for /proc/driver/snd-page-alloc creation
has been added to the -mm tree.  Its filename is
     sound-use-non-racy-method-for-proc-driver-snd-page-alloc-creation.patch

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
Subject: sound: use non-racy method for /proc/driver/snd-page-alloc creation
From: "Denis V. Lunev" <den@openvz.org>

Use proc_create() to make sure that ->proc_fops be setup before gluing PDE to
main tree.

Signed-off-by: Denis V. Lunev <den@openvz.org>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Jaroslav Kysela <perex@suse.cz>
Cc: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 sound/core/memalloc.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN sound/core/memalloc.c~sound-use-non-racy-method-for-proc-driver-snd-page-alloc-creation sound/core/memalloc.c
--- a/sound/core/memalloc.c~sound-use-non-racy-method-for-proc-driver-snd-page-alloc-creation
+++ a/sound/core/memalloc.c
@@ -629,9 +629,8 @@ static const struct file_operations snd_
 static int __init snd_mem_init(void)
 {
 #ifdef CONFIG_PROC_FS
-	snd_mem_proc = create_proc_entry(SND_MEM_PROC_FILE, 0644, NULL);
-	if (snd_mem_proc)
-		snd_mem_proc->proc_fops = &snd_mem_proc_fops;
+	snd_mem_proc = proc_create(SND_MEM_PROC_FILE, 0644, NULL,
+				   &snd_mem_proc_fops);
 #endif
 	return 0;
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

