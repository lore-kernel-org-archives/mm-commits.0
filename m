From: akpm@linux-foundation.org
Subject: + uml-deal-with-host-time-going-backwards.patch added to -mm tree
Date: Tue, 03 Jun 2008 12:31:10 -0700
Message-ID: <200806031931.m53JVAgg015894@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48924 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753868AbYFCTbc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 3 Jun 2008 15:31:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jdike@addtoit.com, jdike@linux.intel.com, nix@esperi.org.uk


The patch titled
     uml: deal with host time going backwards
has been added to the -mm tree.  Its filename is
     uml-deal-with-host-time-going-backwards.patch

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
Subject: uml: deal with host time going backwards
From: Jeff Dike <jdike@addtoit.com>

Protection against the host's time going backwards - keep track of the
time at the last tick and if it's greater than the current time, keep time
stopped until the host catches up.

Cc: Nix <nix@esperi.org.uk>
Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/os-Linux/time.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff -puN arch/um/os-Linux/time.c~uml-deal-with-host-time-going-backwards arch/um/os-Linux/time.c
--- a/arch/um/os-Linux/time.c~uml-deal-with-host-time-going-backwards
+++ a/arch/um/os-Linux/time.c
@@ -106,6 +106,10 @@ static void deliver_alarm(void)
 	unsigned long long this_tick = os_nsecs();
 	int one_tick = UM_NSEC_PER_SEC / UM_HZ;
 
+	/* Protection against the host's time going backwards */
+	if ((last_tick != 0) && (this_tick < last_tick))
+		this_tick = last_tick;
+
 	if (last_tick == 0)
 		last_tick = this_tick - one_tick;
 
@@ -148,6 +152,9 @@ static int after_sleep_interval(struct t
 		start_usecs = usec;
 
 	start_usecs -= skew / UM_NSEC_PER_USEC;
+	if (start_usecs < 0)
+		start_usecs = 0;
+
 	tv = ((struct timeval) { .tv_sec  = start_usecs / UM_USEC_PER_SEC,
 				 .tv_usec = start_usecs % UM_USEC_PER_SEC });
 	interval = ((struct itimerval) { { 0, usec }, tv });
_

Patches currently in -mm which might be from jdike@addtoit.com are

uml-deal-with-host-time-going-backwards.patch
uml-deal-with-inaccessible-address-space-start.patch
uml-memcpy-export-needs-to-follow-host-declaration.patch
uml-stub-needs-to-tolerate-sigwinch.patch
linux-next.patch
arch-um-kernel-irqc-clean-up-some-functions.patch
arch-um-kernel-memc-remove-arch_validate.patch
uml-make-several-more-things-static.patch
uml-activate_mm-remove-the-dead-pf_borrowed_mm-check.patch

