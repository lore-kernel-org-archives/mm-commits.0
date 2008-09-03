From: akpm@linux-foundation.org
Subject: + sched-fix-init_hrtick-section-mismatch-warning.patch added to -mm tree
Date: Wed, 03 Sep 2008 12:07:56 -0700
Message-ID: <200809031907.m83J7ukl031586@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33767 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754543AbYICTI4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Sep 2008 15:08:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rakib.mullick@gmail.com, mingo@elte.hu, tglx@linutronix.de


The patch titled
     sched: fix init_hrtick() section mismatch warning
has been added to the -mm tree.  Its filename is
     sched-fix-init_hrtick-section-mismatch-warning.patch

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
Subject: sched: fix init_hrtick() section mismatch warning
From: "Rakib Mullick" <rakib.mullick@gmail.com>

   LD      kernel/built-in.o
WARNING: kernel/built-in.o(.text+0x326): Section mismatch in reference
from the function init_hrtick() to the variable
.cpuinit.data:hotplug_hrtick_nb.8
The function init_hrtick() references
the variable __cpuinitdata hotplug_hrtick_nb.8.
This is often because init_hrtick lacks a __cpuinitdata
annotation or the annotation of hotplug_hrtick_nb.8 is wrong.

Signed-off-by: Md.Rakib H. Mullick <rakib.mullick@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sched.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/sched.c~sched-fix-init_hrtick-section-mismatch-warning kernel/sched.c
--- a/kernel/sched.c~sched-fix-init_hrtick-section-mismatch-warning
+++ a/kernel/sched.c
@@ -1097,7 +1097,7 @@ hotplug_hrtick(struct notifier_block *nf
 	return NOTIFY_DONE;
 }
 
-static void init_hrtick(void)
+static __init void init_hrtick(void)
 {
 	hotcpu_notifier(hotplug_hrtick, 0);
 }
_

Patches currently in -mm which might be from rakib.mullick@gmail.com are

sched-fix-init_hrtick-section-mismatch-warning.patch
cpusetc-remove-extra-variable.patch

