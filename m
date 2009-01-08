From: akpm@linux-foundation.org
Subject: - vmcore-remove-saved_max_pfn-check.patch removed from -mm tree
Date: Thu, 08 Jan 2009 14:51:02 -0800
Message-ID: <200901082251.n08Mp2hd030195@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34309 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759805AbZAHWwE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 Jan 2009 17:52:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: damm@igel.co.jp, ebiederm@xmission.com, horms@verge.net.au, vgoyal@redhat.com, mm-commits@vger.kernel.org


The patch titled
     vmcore: remove saved_max_pfn check
has been removed from the -mm tree.  Its filename was
     vmcore-remove-saved_max_pfn-check.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vmcore: remove saved_max_pfn check
From: Magnus Damm <damm@igel.co.jp>

Remove the saved_max_pfn check from the /proc/vmcore function
read_from_oldmem().  No need to verify, we should be able to just trust
that "elfcorehdr=" is correctly passed to the crash kernel on the kernel
command line like we do with other parameters.

The read_from_oldmem() function in fs/proc/vmcore.c is quite similar to
read_from_oldmem() in drivers/char/mem.c, but only in the latter it makes
sense to use saved_max_pfn.  For oldmem it is used to determine when to
stop reading.  For vmcore we already have the elf header info pointing out
the physical memory regions, no need to pass the end-of- old-memory twice.

Removing the saved_max_pfn check from vmcore makes it possible for
architectures to skip oldmem but still support crash dump through vmcore -
without the need for the old saved_max_pfn cruft.

Architectures that want to play safe can do the saved_max_pfn check in
copy_oldmem_page().  Not sure why anyone would want to do that, but that's
even safer than today - the saved_max_pfn check in vmcore removed by this
patch only checks the first page.

Signed-off-by: Magnus Damm <damm@igel.co.jp>
Acked-by: Vivek Goyal <vgoyal@redhat.com>
Acked-by: Simon Horman <horms@verge.net.au>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/vmcore.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN fs/proc/vmcore.c~vmcore-remove-saved_max_pfn-check fs/proc/vmcore.c
--- a/fs/proc/vmcore.c~vmcore-remove-saved_max_pfn-check
+++ a/fs/proc/vmcore.c
@@ -47,8 +47,6 @@ static ssize_t read_from_oldmem(char *bu
 
 	offset = (unsigned long)(*ppos % PAGE_SIZE);
 	pfn = (unsigned long)(*ppos / PAGE_SIZE);
-	if (pfn > saved_max_pfn)
-		return -EINVAL;
 
 	do {
 		if (count > (PAGE_SIZE - offset))
_

Patches currently in -mm which might be from damm@igel.co.jp are

origin.patch
linux-next.patch
clocksource-pass-clocksource-to-read-callback.patch
clocksource-pass-clocksource-to-read-callback-sparc-cleanup.patch
clocksource-add-enable-and-disable-callbacks.patch
irq-free-setup_irq-interrupt-using-free_irq.patch

