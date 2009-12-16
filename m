From: akpm@linux-foundation.org
Subject: + sysctl-fix-sysctl-breakage-on-systems-with-older-glibc.patch added to -mm tree
Date: Wed, 16 Dec 2009 14:21:54 -0800
Message-ID: <200912162221.nBGMLs2U018269@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48534 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763023AbZLPWWE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 16 Dec 2009 17:22:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: andi@firstfloor.org, ak@linux.intel.com, ebiederm@xmission.com


The patch titled
     sysctl: fix sysctl breakage on systems with older glibc
has been added to the -mm tree.  Its filename is
     sysctl-fix-sysctl-breakage-on-systems-with-older-glibc.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sysctl: fix sysctl breakage on systems with older glibc
From: Andi Kleen <andi@firstfloor.org>

As predicted during code review, the sysctl(2) changes made systems with
old glibc nearly unusable.  About every command gives a:

warning: process `ls' used the deprecated sysctl s ystem call with 1.4

warning in the log.

I see this on a SUSE 10.0 system with glibc 2.3.5.  Don't warn for this
common case.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sysctl_binary.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff -puN kernel/sysctl_binary.c~sysctl-fix-sysctl-breakage-on-systems-with-older-glibc kernel/sysctl_binary.c
--- a/kernel/sysctl_binary.c~sysctl-fix-sysctl-breakage-on-systems-with-older-glibc
+++ a/kernel/sysctl_binary.c
@@ -1399,6 +1399,13 @@ static void deprecated_sysctl_warning(co
 {
 	int i;
 
+	/*
+	 * CTL_KERN/KERN_VERSION is used by older glibc and cannot
+	 * ever go away.
+	 */
+	if (name[0] == CTL_KERN && name[1] == KERN_VERSION)
+		return;
+
 	if (printk_ratelimit()) {
 		printk(KERN_INFO
 			"warning: process `%s' used the deprecated sysctl "
_

Patches currently in -mm which might be from andi@firstfloor.org are

origin.patch
linux-next.patch
hardware-latency-detector-remove-default-m.patch
sysctl-fix-sysctl-breakage-on-systems-with-older-glibc.patch

