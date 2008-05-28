From: akpm@linux-foundation.org
Subject: + sysctl-permission-check-based-on-capability-not-euid.patch added to -mm tree
Date: Wed, 28 May 2008 12:37:35 -0700
Message-ID: <200805281937.m4SJbZ89029098@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60943 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752225AbYE1Th6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 28 May 2008 15:37:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: stephen.hemminger@vyatta.com, adobriyan@gmail.com, ebiederm@xmission.com, morgan@kernel.org, shemminger@vyatta.com, xemul@openvz.org


The patch titled
     sysctl: permission check based on capability not euid
has been added to the -mm tree.  Its filename is
     sysctl-permission-check-based-on-capability-not-euid.patch

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
Subject: sysctl: permission check based on capability not euid
From: Stephen Hemminger <stephen.hemminger@vyatta.com>

Modify the permission checks for sysctl's from being based on uid=0 (root)
to use the capability system.  This matches the behavior of other OS's
using sysctl's and capabilities.  Linux has tried to get away from using
uid=0 for security overrides and use capabilities instead.

I was working on Quagga enhancement that involved enabling a sysctl, and
it didn't work because is a safe daemon and drops privileges and resets
its real/effective uid after initialization; it then re-enables only the
capabilities when it needs to do some privileged operation.  This wouldn't
work because sysctl's were still using the root based permission check. 
The existing code in quagga to enable ip forwarding doesn't work for the
same reason.

Signed-off-by: Stephen Hemminger <shemminger@vyatta.com>
Cc: Andrew Morgan <morgan@kernel.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Pavel Emelyanov <xemul@openvz.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/capability.h |    1 +
 kernel/sysctl.c            |    2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

diff -puN include/linux/capability.h~sysctl-permission-check-based-on-capability-not-euid include/linux/capability.h
--- a/include/linux/capability.h~sysctl-permission-check-based-on-capability-not-euid
+++ a/include/linux/capability.h
@@ -274,6 +274,7 @@ typedef struct kernel_cap_struct {
    arbitrary SCSI commands */
 /* Allow setting encryption key on loopback filesystem */
 /* Allow setting zone reclaim policy */
+/* Allow setting any sysctl value */
 
 #define CAP_SYS_ADMIN        21
 
diff -puN kernel/sysctl.c~sysctl-permission-check-based-on-capability-not-euid kernel/sysctl.c
--- a/kernel/sysctl.c~sysctl-permission-check-based-on-capability-not-euid
+++ a/kernel/sysctl.c
@@ -1565,7 +1565,7 @@ out:
 
 static int test_perm(int mode, int op)
 {
-	if (!current->euid)
+	if (capable(CAP_SYS_ADMIN))
 		mode >>= 6;
 	else if (in_egroup_p(0))
 		mode >>= 3;
_

Patches currently in -mm which might be from stephen.hemminger@vyatta.com are

sysctl-permission-check-based-on-capability-not-euid.patch

