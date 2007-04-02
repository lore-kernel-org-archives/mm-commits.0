From: akpm@linux-foundation.org
Subject: + fix-kevents-childs-priority-greediness.patch added to -mm tree
Date: Sun, 01 Apr 2007 22:40:31 -0700
Message-ID: <200704020540.l325eVxW025217@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:36368 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932067AbXDBFlg (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 2 Apr 2007 01:41:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jengelh@linux01.gwdg.de, chrisw@sous-sol.org, jengelh@gmx.de


The patch titled
     Fix kevent's childs priority greediness
has been added to the -mm tree.  Its filename is
     fix-kevents-childs-priority-greediness.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Fix kevent's childs priority greediness
From: Jan Engelhardt <jengelh@linux01.gwdg.de>

Fix kevent's childs priority greediness.  Such tasks were always scheduled
at nice level -5 and, at that time, udev stole us the CPU time with -5.

Already posted at http://lkml.org/lkml/2005/1/10/85

Signed-off-by: Jan Engelhardt <jengelh@gmx.de>
Cc: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kmod.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN kernel/kmod.c~fix-kevents-childs-priority-greediness kernel/kmod.c
--- a/kernel/kmod.c~fix-kevents-childs-priority-greediness
+++ a/kernel/kmod.c
@@ -164,6 +164,7 @@ static int ____call_usermodehelper(void 
 
 	/* We can run anywhere, unlike our parent keventd(). */
 	set_cpus_allowed(current, CPU_MASK_ALL);
+	set_user_nice(current, 0);
 
 	retval = -EPERM;
 	if (current->fs->root)
_

Patches currently in -mm which might be from jengelh@linux01.gwdg.de are

git-kbuild.patch
remove-artificial-software-max_loop-limit.patch
fix-kevents-childs-priority-greediness.patch
fix-kthread-nicenessdiff-fix.patch
vt-allow-for-the-palette-to-be-exposed-and-changed-via-sysfs.patch
vt-add-color-support-to-the-underline-and-italic-attributes.patch
