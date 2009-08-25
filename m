From: akpm@linux-foundation.org
Subject: [to-be-updated] kcore-use-registerd-physmem-information-fix2.patch removed from -mm tree
Date: Tue, 25 Aug 2009 12:56:43 -0700
Message-ID: <200908251956.n7PJuh9m011970@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44549 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755714AbZHYT4o (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 25 Aug 2009 15:56:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, kamezawa.hiroyu@jp.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     kcore-use-registerd-physmem-information-fix2
has been removed from the -mm tree.  Its filename was
     kcore-use-registerd-physmem-information-fix2.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kcore-use-registerd-physmem-information-fix2
From: Jiri Slaby <jirislaby@gmail.com>

Fix this compilation warning on x86_64:
fs/proc/kcore.c: In function `kclist_add_private':
fs/proc/kcore.c:175: warning: comparison between pointer and integer

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/kcore.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/proc/kcore.c~kcore-use-registerd-physmem-information-fix2 fs/proc/kcore.c
--- a/fs/proc/kcore.c~kcore-use-registerd-physmem-information-fix2
+++ a/fs/proc/kcore.c
@@ -172,7 +172,7 @@ kclist_add_private(unsigned long pfn, un
 		ent->size = ULONG_MAX - ent->addr;
 
 	/* cut when vmalloc() area is higher than direct-map area */
-	if (VMALLOC_START > __va(0)) {
+	if (VMALLOC_START > (unsigned long)__va(0)) {
 		if (ent->addr > VMALLOC_START)
 			goto free_out;
 		if (VMALLOC_START - ent->addr < ent->size)
_

Patches currently in -mm which might be from jirislaby@gmail.com are

origin.patch
md-dm-log-fix-cn_ulog_callback-declaration.patch
linux-next.patch
toshiba_acpi-return-on-a-fail-path.patch
gpu-vgaarb-use-%p-in-pointers-prints.patch
mtd-sst25l-fix-lock-imbalance.patch
isdn-hisax-fix-lock-imbalance.patch
isdn-eicon-use-offsetof.patch
isdn-eicon-return-on-error.patch
icom-converting-space-to-tabs.patch
cyclades-read-buffer-overflow.patch
serial167-fix-read-buffer-overflow.patch
usb-make-usb_buffer_map_sg-consistent-with-doc.patch
char-riscom8-fix-shutdown-declaration.patch
kcore-use-registerd-physmem-information-fix2.patch
video-console-use-div_round_up.patch
memory-controller-soft-limit-organize-cgroups-v9-fix.patch
cyclades-allow-overriding-isa-defaults-also-when-the-driver-is-built-in.patch
drivers-char-rio-rioctrlc-off-by-one-error-in-rioctrlc.patch
memstick-move-dev_dbg.patch
reiser4.patch
fs-reiser4-add-parenths-around-x-y.patch

