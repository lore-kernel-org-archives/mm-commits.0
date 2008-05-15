From: akpm@linux-foundation.org
Subject: + x86-fix-crash-on-cpu-hotplug-on-pat-incapable-machines.patch added to -mm tree
Date: Thu, 15 May 2008 15:58:48 -0700
Message-ID: <200805152258.m4FMwmGf014814@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38449 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752187AbYEOW7V (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 May 2008 18:59:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: avi@qumranet.com


The patch titled
     x86: fix crash on cpu hotplug on pat-incapable machines
has been added to the -mm tree.  Its filename is
     x86-fix-crash-on-cpu-hotplug-on-pat-incapable-machines.patch

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
Subject: x86: fix crash on cpu hotplug on pat-incapable machines
From: Avi Kivity <avi@qumranet.com>

pat_disable() is __init, which means it goes away after booting is
complete.  Unfortunately it is used by the hotplug code if the machine is
not pat-capable, causing a crash.

Fix by marking pat_disable() as __cpuinit.

Signed-off-by: Avi Kivity <avi@qumranet.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/pat.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/x86/mm/pat.c~x86-fix-crash-on-cpu-hotplug-on-pat-incapable-machines arch/x86/mm/pat.c
--- a/arch/x86/mm/pat.c~x86-fix-crash-on-cpu-hotplug-on-pat-incapable-machines
+++ a/arch/x86/mm/pat.c
@@ -28,7 +28,7 @@
 #ifdef CONFIG_X86_PAT
 int __read_mostly pat_wc_enabled = 1;
 
-void __init pat_disable(char *reason)
+void __cpuinit pat_disable(char *reason)
 {
 	pat_wc_enabled = 0;
 	printk(KERN_INFO "%s\n", reason);
_

Patches currently in -mm which might be from avi@qumranet.com are

linux-next.patch
x86-fix-crash-on-cpu-hotplug-on-pat-incapable-machines.patch

