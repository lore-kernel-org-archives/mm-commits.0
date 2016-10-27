From: akpm@linux-foundation.org
Subject: + kernel-smp-define-pr_fmt-for-smpc.patch added to -mm tree
Date: Wed, 26 Oct 2016 17:02:58 -0700
Message-ID: <58114432.b3G1jYf5P2cZDGaW%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41579 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932987AbcJ0ADZ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 26 Oct 2016 20:03:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mpe@ellerman.id.au, ak@linux.intel.com, boris.ostrovsky@oracle.com, bp@suse.de, hpa@zytor.com, jgross@suse.com, jolsa@redhat.com, len.brown@intel.com, mgorman@techsingularity.net, mingo@redhat.com, peterz@infradead.org, richard@nod.at, tglx@linutronix.de, tim.c.chen@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/smp.c: define pr_fmt() for smp.c
has been added to the -mm tree.  Its filename is
     kernel-smp-define-pr_fmt-for-smpc.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kernel-smp-define-pr_fmt-for-smpc.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kernel-smp-define-pr_fmt-for-smpc.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Michael Ellerman <mpe@ellerman.id.au>
Subject: kernel/smp.c: define pr_fmt() for smp.c

This makes all our pr_xxx()'s start with "smp: ", which helps pin down
where they come from and generally looks nice.  There is actually only one
pr_xxx() use in smp.c at the moment, but we will add some more in the next
commit.

Link: http://lkml.kernel.org/r/1477460275-8266-1-git-send-email-mpe@ellerman.id.au
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Suggested-by: Borislav Petkov <bp@suse.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Juergen Gross <jgross@suse.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Richard Weinberger <richard@nod.at>
Cc: Len Brown <len.brown@intel.com>
Cc: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Cc: Tim Chen <tim.c.chen@linux.intel.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/smp.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN kernel/smp.c~kernel-smp-define-pr_fmt-for-smpc kernel/smp.c
--- a/kernel/smp.c~kernel-smp-define-pr_fmt-for-smpc
+++ a/kernel/smp.c
@@ -3,6 +3,9 @@
  *
  * (C) Jens Axboe <jens.axboe@oracle.com> 2008
  */
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/irq_work.h>
 #include <linux/rcupdate.h>
 #include <linux/rculist.h>
_

Patches currently in -mm which might be from mpe@ellerman.id.au are

kernel-smp-define-pr_fmt-for-smpc.patch
kernel-smp-make-the-smp-boot-message-common-on-all-arches.patch
kernel-smp-tell-the-user-were-bringing-up-secondary-cpus.patch

