From: akpm@linux-foundation.org
Subject: + vmcore-remove-saved_max_pfn-check.patch added to -mm tree
Date: Tue, 21 Oct 2008 15:24:32 -0700
Message-ID: <200810212224.m9LMOWSL001972@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34991 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751179AbYJUWZj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 21 Oct 2008 18:25:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: damm@igel.co.jp, ebiederm@xmission.com, horms@verge.net.au, vgoyal@redhat.com


The patch titled
     vmcore: remove saved_max_pfn check
has been added to the -mm tree.  Its filename is
     vmcore-remove-saved_max_pfn-check.patch

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
@@ -49,8 +49,6 @@ static ssize_t read_from_oldmem(char *bu
 
 	offset = (unsigned long)(*ppos % PAGE_SIZE);
 	pfn = (unsigned long)(*ppos / PAGE_SIZE);
-	if (pfn > saved_max_pfn)
-		return -EINVAL;
 
 	do {
 		if (count > (PAGE_SIZE - offset))
_

Patches currently in -mm which might be from damm@igel.co.jp are

origin.patch
spi_gpio-driver.patch
spi_gpio-driver-cleanups.patch
vmcore-remove-saved_max_pfn-check.patch

