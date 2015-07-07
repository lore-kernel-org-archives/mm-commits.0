From: akpm@linux-foundation.org
Subject: + kmod-remove-unecessary-explicit-wide-cpu-affinity-setting.patch added to -mm tree
Date: Tue, 07 Jul 2015 16:09:43 -0700
Message-ID: <559c5c37.S4vYB5A6NQhb8Yx5%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60975 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757374AbbGGXJo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Jul 2015 19:09:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fweisbec@gmail.com, cl@linux.com, oleg@redhat.com, riel@redhat.com, rusty@rustcorp.com.au, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: kmod: remove unecessary explicit wide CPU affinity setting
has been added to the -mm tree.  Its filename is
     kmod-remove-unecessary-explicit-wide-cpu-affinity-setting.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kmod-remove-unecessary-explicit-wide-cpu-affinity-setting.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kmod-remove-unecessary-explicit-wide-cpu-affinity-setting.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Frederic Weisbecker <fweisbec@gmail.com>
Subject: kmod: remove unecessary explicit wide CPU affinity setting

The call_usermodehelper_exec_[a]sync() kernel threads are created by
khelper precisely because we want them to be affine to all CPUs,
irrespective of any call_usermodehelper() caller with reduced CPU
affinity.  So this explicit all-CPUs wide affinity forcing is useless.

Not only useless it even breaks nohz full.  The housekeeping work (general
kernel internal code that user doesn't care much about) is handled by a
reduced set of CPUs in nohz full, precisely those that are not included by
nohz_full= kernel parameters.  For example unbound workqueues are handled
by housekeeping CPUs.  And we want the usermodehelper tasks to be handled
by housekeeping CPUs because they are kernel internals that user critical
nohz full work don't want to be disturbed by.

In nohz full configurations, khelper will naturally be affine to
housekeeping CPUs and this housekeeping affinity is then inherited by
usermodehelper kernel threads.  But the explicit call to
set_cpus_allowed_ptr() breaks that.

Simply remove it.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kmod.c |    3 ---
 1 file changed, 3 deletions(-)

diff -puN kernel/kmod.c~kmod-remove-unecessary-explicit-wide-cpu-affinity-setting kernel/kmod.c
--- a/kernel/kmod.c~kmod-remove-unecessary-explicit-wide-cpu-affinity-setting
+++ a/kernel/kmod.c
@@ -223,9 +223,6 @@ static int call_usermodehelper_exec_asyn
 	flush_signal_handlers(current, 1);
 	spin_unlock_irq(&current->sighand->siglock);
 
-	/* We can run anywhere, unlike our parent keventd(). */
-	set_cpus_allowed_ptr(current, cpu_all_mask);
