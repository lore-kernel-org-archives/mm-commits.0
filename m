From: akpm@linux-foundation.org
Subject: + kernel-smp-tell-the-user-were-bringing-up-secondary-cpus.patch
 added to -mm tree
Date: Wed, 26 Oct 2016 17:03:03 -0700
Message-ID: <58114437.ou6sEmDAOuMnzRf0%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41606 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933268AbcJ0ADZ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 26 Oct 2016 20:03:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mpe@ellerman.id.au, ak@linux.intel.com, boris.ostrovsky@oracle.com, bp@suse.de, hpa@zytor.com, jgross@suse.com, jolsa@redhat.com, len.brown@intel.com, mgorman@techsingularity.net, mingo@redhat.com, peterz@infradead.org, richard@nod.at, tglx@linutronix.de, tim.c.chen@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/smp.c: tell the user we're bringing up secondary CPUs
has been added to the -mm tree.  Its filename is
     kernel-smp-tell-the-user-were-bringing-up-secondary-cpus.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kernel-smp-tell-the-user-were-bringing-up-secondary-cpus.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kernel-smp-tell-the-user-were-bringing-up-secondary-cpus.patch

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
Subject: kernel/smp.c: tell the user we're bringing up secondary CPUs

Currently we don't print anything before starting to bring up secondary
CPUs.  This can be confusing if it takes a long time to bring up the
secondaries, or if the kernel crashes while doing so and produces no
further output.

On x86 they work around this by detecting when the first secondary CPU
comes up and printing a message (see announce_cpu()).  But doing it in
smp_init() is simpler and works for all arches.

Link: http://lkml.kernel.org/r/1477460275-8266-3-git-send-email-mpe@ellerman.id.au
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Reviewed-by: Borislav Petkov <bp@suse.de>
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

 kernel/smp.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN kernel/smp.c~kernel-smp-tell-the-user-were-bringing-up-secondary-cpus kernel/smp.c
--- a/kernel/smp.c~kernel-smp-tell-the-user-were-bringing-up-secondary-cpus
+++ a/kernel/smp.c
@@ -555,6 +555,8 @@ void __init smp_init(void)
 	idle_threads_init();
 	cpuhp_threads_init();
 
+	pr_info("Bringing up secondary CPUs ...\n");
+
 	/* FIXME: This should be done in userspace --RR */
 	for_each_present_cpu(cpu) {
 		if (num_online_cpus() >= setup_max_cpus)
_

Patches currently in -mm which might be from mpe@ellerman.id.au are

kernel-smp-define-pr_fmt-for-smpc.patch
kernel-smp-make-the-smp-boot-message-common-on-all-arches.patch
kernel-smp-tell-the-user-were-bringing-up-secondary-cpus.patch

