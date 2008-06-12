From: akpm@linux-foundation.org
Subject: + tracer-fix-printout.patch added to -mm tree
Date: Thu, 12 Jun 2008 02:34:32 -0700
Message-ID: <200806120934.m5C9YWR6012333@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57069 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754617AbYFLJfV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 12 Jun 2008 05:35:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jirislaby@gmail.com, mingo@redhat.com, srostedt@redhat.com


The patch titled
     tracer: fix printout
has been added to the -mm tree.  Its filename is
     tracer-fix-printout.patch

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
Subject: tracer: fix printout
From: Jiri Slaby <jirislaby@gmail.com>

Do not print loglevel before "entries of %ld bytes". Move it to the previous
pr_info.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Steven Rostedt <srostedt@redhat.com>
Cc: Ingo Molnar <mingo@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/trace/trace.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN kernel/trace/trace.c~tracer-fix-printout kernel/trace/trace.c
--- a/kernel/trace/trace.c~tracer-fix-printout
+++ a/kernel/trace/trace.c
@@ -3084,9 +3084,8 @@ __init static int tracer_alloc_buffers(v
 	}
 	max_tr.entries = global_trace.entries;
 
-	pr_info("tracer: %d pages allocated for %ld",
-		pages, trace_nr_entries);
-	pr_info(" entries of %ld bytes\n", (long)TRACE_ENTRY_SIZE);
+	pr_info("tracer: %d pages allocated for %ld entries of %ld bytes\n",
+		pages, trace_nr_entries, (long)TRACE_ENTRY_SIZE);
 	pr_info("   actual entries %ld\n", global_trace.entries);
 
 	tracer_init_debugfs();
_

Patches currently in -mm which might be from jirislaby@gmail.com are

origin.patch
linux-next.patch
tracer-fix-printout.patch
driver-video-cirrusfb-fix-ram-address-printk.patch
driver-video-cirrusfb-fix-ram-address-printk-fix.patch
driver-video-cirrusfb-fix-ram-address-printk-fix-fix.patch
add-a-warn-macro-this-is-warn_on-printk-arguments-fix.patch
vt-hold-console_sem-across-sysfs-operations.patch
ip2-push-bkl-down-for-the-firmware-interface.patch
rio-push-down-the-bkl-into-the-firmware-ioctl-handler.patch
sx-push-bkl-down-into-the-firmware-ioctl-handler.patch
ppdev-wrap-ioctl-handler-in-driver-and-push-lock-down.patch
dsp56k-bkl-pushdown.patch
reiser4.patch
shrink_slab-handle-bad-shrinkers.patch

