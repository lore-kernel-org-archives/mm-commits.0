From: akpm@linux-foundation.org
Subject: [merged] documentation-sysrq-fix-inconstistent-help-message-of-sysrq-key.patch removed from -mm tree
Date: Tue, 07 May 2013 10:51:34 -0700
Message-ID: <20130507175134.783565A451C@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f201.google.com ([209.85.220.201]:37654 "EHLO
	mail-vc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753993Ab3EGRvf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 May 2013 13:51:35 -0400
Received: by mail-vc0-f201.google.com with SMTP id hz10so86492vcb.4
        for <mm-commits@vger.kernel.org>; Tue, 07 May 2013 10:51:34 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jovi.zhangwei@huawei.com, rdunlap@infradead.org, mm-commits@vger.kernel.org


The patch titled
     Subject: Documentation/sysrq: fix inconstistent help message of sysrq key
has been removed from the -mm tree.  Its filename was
     documentation-sysrq-fix-inconstistent-help-message-of-sysrq-key.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>
Subject: Documentation/sysrq: fix inconstistent help message of sysrq key

Currently help message of /proc/sysrq-trigger highlight its
upper-case characters, like below:

      SysRq : HELP : loglevel(0-9) reBoot Crash terminate-all-tasks(E)
      memory-full-oom-kill(F) kill-all-tasks(I) ...

this would confuse user trigger sysrq by upper-case character, which is
inconsistent with the real lower-case character registed key.

This inconsistent help message will also lead more confused when
26 upper-case letters put into use in future.

This patch fix sysrq documentation.

Signed-off-by: zhangwei(Jovi) <jovi.zhangwei@huawei.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/sysrq.txt |   20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff -puN Documentation/sysrq.txt~documentation-sysrq-fix-inconstistent-help-message-of-sysrq-key Documentation/sysrq.txt
--- a/Documentation/sysrq.txt~documentation-sysrq-fix-inconstistent-help-message-of-sysrq-key
+++ a/Documentation/sysrq.txt
@@ -129,9 +129,9 @@ On all -  write a character to /proc/sys
 
 *  Okay, so what can I use them for?
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-Well, un'R'aw is very handy when your X server or a svgalib program crashes.
+Well, unraw(r) is very handy when your X server or a svgalib program crashes.
 
-sa'K' (Secure Access Key) is useful when you want to be sure there is no
+sak(k) (Secure Access Key) is useful when you want to be sure there is no
 trojan program running at console which could grab your password
 when you would try to login. It will kill all programs on given console,
 thus letting you make sure that the login prompt you see is actually
@@ -143,20 +143,20 @@ IMPORTANT: such.
 useful when you want to exit a program that will not let you switch consoles.
 (For example, X or a svgalib program.)
 
-re'B'oot is good when you're unable to shut down. But you should also 'S'ync
-and 'U'mount first.
+reboot(b) is good when you're unable to shut down. But you should also
+sync(s) and umount(u) first.
 
-'C'rash can be used to manually trigger a crashdump when the system is hung.
+crash(c) can be used to manually trigger a crashdump when the system is hung.
 Note that this just triggers a crash if there is no dump mechanism available.
 
-'S'ync is great when your system is locked up, it allows you to sync your
+sync(s) is great when your system is locked up, it allows you to sync your
 disks and will certainly lessen the chance of data loss and fscking. Note
 that the sync hasn't taken place until you see the "OK" and "Done" appear
 on the screen. (If the kernel is really in strife, you may not ever get the
 OK or Done message...)
 
-'U'mount is basically useful in the same ways as 'S'ync. I generally 'S'ync,
-'U'mount, then re'B'oot when my system locks. It's saved me many a fsck.
+umount(u) is basically useful in the same ways as sync(s). I generally sync(s),
+umount(u), then reboot(b) when my system locks. It's saved me many a fsck.
 Again, the unmount (remount read-only) hasn't taken place until you see the
 "OK" and "Done" message appear on the screen.
 
@@ -165,11 +165,11 @@ kernel messages you do not want to see.
 the most urgent kernel messages from reaching your console. (They will
 still be logged if syslogd/klogd are alive, though.)
 
-t'E'rm and k'I'll are useful if you have some sort of runaway process you
+term(e) and kill(i) are useful if you have some sort of runaway process you
 are unable to kill any other way, especially if it's spawning other
 processes.
 
-"'J'ust thaw it" is useful if your system becomes unresponsive due to a frozen
+"just thaw it(j)" is useful if your system becomes unresponsive due to a frozen
 (probably root) filesystem via the FIFREEZE ioctl.
 
 *  Sometimes SysRq seems to get 'stuck' after using it, what can I do?
_

Patches currently in -mm which might be from jovi.zhangwei@huawei.com are

origin.patch
relay-fix-timer-madness.patch

