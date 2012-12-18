From: akpm@linux-foundation.org
Subject: [merged] binfmt_elf-fix-corner-case-kfree-of-uninitialized-data.patch removed from -mm tree
Date: Tue, 18 Dec 2012 12:07:15 -0800
Message-ID: <20121218200715.98C78820050@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:55596 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755053Ab2LRUHR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Dec 2012 15:07:17 -0500
Received: by mail-qa0-f74.google.com with SMTP id r4so158336qaq.3
        for <mm-commits@vger.kernel.org>; Tue, 18 Dec 2012 12:07:15 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: binfmt_elf: fix corner case kfree of uninitialized data
has been removed from the -mm tree.  Its filename was
     binfmt_elf-fix-corner-case-kfree-of-uninitialized-data.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Alan Cox <alan@linux.intel.com>
Subject: binfmt_elf: fix corner case kfree of uninitialized data

If elf_core_dump() is called and fill_note_info() fails in the kmalloc()
then it returns 0 but has not yet initialised all the needed fields.  As a
result we do a kfree(randomness) after correctly skipping the thread data.

[akpm@linux-foundation.org: checkpatch fixes]
Signed-off-by: Alan Cox <alan@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/binfmt_elf.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN fs/binfmt_elf.c~binfmt_elf-fix-corner-case-kfree-of-uninitialized-data fs/binfmt_elf.c
--- a/fs/binfmt_elf.c~binfmt_elf-fix-corner-case-kfree-of-uninitialized-data
+++ a/fs/binfmt_elf.c
@@ -1601,8 +1601,10 @@ static int fill_note_info(struct elfhdr 
 	info->thread = NULL;
 
 	psinfo = kmalloc(sizeof(*psinfo), GFP_KERNEL);
-	if (psinfo == NULL)
+	if (psinfo == NULL) {
+		info->psinfo.data = NULL; /* So we don't free this wrongly */
 		return 0;
+	}
 
 	fill_note(&info->psinfo, "CORE", NT_PRPSINFO, sizeof(*psinfo), psinfo);
 
_

Patches currently in -mm which might be from alan@linux.intel.com are

origin.patch
linux-next.patch
fb-rework-locking-to-fix-lock-ordering-on-takeover.patch
fb-rework-locking-to-fix-lock-ordering-on-takeover-fix.patch
fb-rework-locking-to-fix-lock-ordering-on-takeover-fix-2.patch
irq-tsk-comm-is-an-array.patch
drivers-message-fusion-mptscsihc-missing-break.patch
sendfile-allows-bypassing-of-notifier-events.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
hfsplus-avoid-crash-on-failed-block-map-free.patch
fork-unshare-remove-dead-code.patch

