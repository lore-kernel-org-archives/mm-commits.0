From: akpm@linux-foundation.org
Subject: + drivers-idle-intel_idlec-remove-redundant-local_irq_disable-call.patch added to -mm tree
Date: Tue, 27 Dec 2011 16:08:57 -0800
Message-ID: <20111228000858.041EE5C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:46067 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751011Ab1L1AJA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 27 Dec 2011 19:09:00 -0500
Received: by eekc1 with SMTP id c1so404015eek.1
        for <mm-commits@vger.kernel.org>; Tue, 27 Dec 2011 16:08:59 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: yanmin_zhang@linux.intel.com, len.brown@intel.com, mingmingx.zhang@intel.com, shaohua.li@intel.com


The patch titled
     Subject: drivers/idle/intel_idle.c: remove redundant local_irq_disable() call
has been added to the -mm tree.  Its filename is
     drivers-idle-intel_idlec-remove-redundant-local_irq_disable-call.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Yanmin Zhang <yanmin_zhang@linux.intel.com>
Subject: drivers/idle/intel_idle.c: remove redundant local_irq_disable() call

irq disabling happens earlier in process_32.c:cpu_idle.  Basically,
cpuidle_state->enter is called, cpu irq is disabled.  cpuidle_state->enter
would turn on irq when exiting.

intel_idle doesn't follow this assumption.  Although it doesn't cause real
issue, it misleads developers.  Remove the call to local_irq_disable() at
entry.

Signed-off-by: mzha38X <mingmingx.zhang@intel.com>
Cc: "Li, Shaohua" <shaohua.li@intel.com>
Cc: "Brown, Len" <len.brown@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/idle/intel_idle.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN drivers/idle/intel_idle.c~drivers-idle-intel_idlec-remove-redundant-local_irq_disable-call drivers/idle/intel_idle.c
--- a/drivers/idle/intel_idle.c~drivers-idle-intel_idlec-remove-redundant-local_irq_disable-call
+++ a/drivers/idle/intel_idle.c
@@ -247,8 +247,6 @@ static int intel_idle(struct cpuidle_dev
 
 	cstate = (((eax) >> MWAIT_SUBSTATE_SIZE) & MWAIT_CSTATE_MASK) + 1;
 
-	local_irq_disable();
