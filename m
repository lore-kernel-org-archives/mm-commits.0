From: akpm@linux-foundation.org
Subject: + watchdog-remove-unused-declaration.patch added to -mm tree
Date: Fri, 16 Jun 2017 11:24:50 -0700
Message-ID: <59442272.FTABO6OQ6JcP9z6J%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59314 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753274AbdFPSY4 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 16 Jun 2017 14:24:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: npiggin@gmail.com, babu.moger@oracle.com, benh@kernel.crashing.org, dzickus@redhat.com, mpe@ellerman.id.au, paulus@samba.org, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/watchdog: remove unused declaration
has been added to the -mm tree.  Its filename is
     watchdog-remove-unused-declaration.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/watchdog-remove-unused-declaration.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/watchdog-remove-unused-declaration.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Nicholas Piggin <npiggin@gmail.com>
Subject: kernel/watchdog: remove unused declaration

Patch series "Improve watchdog config for arch watchdogs", v4.

A series to make the hardlockup watchdog more easily replaceable by arch
code.  The last patch provides some justification for why we want to do
this (existing sparc watchdog is another that could benefit).


This patch (of 5):

Remove unused declaration.

Link: http://lkml.kernel.org/r/20170616065715.18390-2-npiggin@gmail.com
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
Reviewed-by: Don Zickus <dzickus@redhat.com>
Reviewed-by: Babu Moger <babu.moger@oracle.com>
Tested-by: Babu Moger <babu.moger@oracle.com>	[sparc]
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/nmi.h |    3 ---
 1 file changed, 3 deletions(-)

diff -puN include/linux/nmi.h~watchdog-remove-unused-declaration include/linux/nmi.h
--- a/include/linux/nmi.h~watchdog-remove-unused-declaration
+++ a/include/linux/nmi.h
@@ -12,9 +12,6 @@ extern void touch_softlockup_watchdog_sc
 extern void touch_softlockup_watchdog(void);
 extern void touch_softlockup_watchdog_sync(void);
 extern void touch_all_softlockup_watchdogs(void);
-extern int proc_dowatchdog_thresh(struct ctl_table *table, int write,
-				  void __user *buffer,
-				  size_t *lenp, loff_t *ppos);
 extern unsigned int  softlockup_panic;
 extern unsigned int  hardlockup_panic;
 void lockup_detector_init(void);
_

Patches currently in -mm which might be from npiggin@gmail.com are

watchdog-remove-unused-declaration.patch
watchdog-introduce-arch_touch_nmi_watchdog.patch
watchdog-split-up-config-options.patch
watchdog-provide-watchdog_reconfigure-for-arch-watchdogs.patch
powerpc-64s-implement-arch-specific-hardlockup-watchdog.patch

