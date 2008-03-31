From: akpm@linux-foundation.org
Subject: - driver-core-fix-uevent-action-string-regression.patch removed from -mm tree
Date: Mon, 31 Mar 2008 13:19:13 -0700
Message-ID: <200803312019.m2VKJDcM024189@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44619 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754668AbYCaUel (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 31 Mar 2008 16:34:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lkml@rtr.ca, greg@kroah.com, kay.sievers@vrfy.org, mlord@pobox.com, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     driver core: fix uevent action-string regression
has been removed from the -mm tree.  Its filename was
     driver-core-fix-uevent-action-string-regression.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: driver core: fix uevent action-string regression
From: Mark Lord <lkml@rtr.ca>

On boot, syslog is flooded with "uevent: unsupported action-string;" messages.
..
Mar 28 14:43:29 shrimp kernel: tty ptyqd: uevent: unsupported
action-string; this will be ignored in a future kernel version
Mar 28 14:43:29 shrimp kernel: tty ptyqe: uevent: unsupported
action-string; this will be ignored in a future kernel version
Mar 28 14:43:29 shrimp kernel: tty ptyqf: uevent: unsupported
action-string; this will be ignored in a future kernel version
Mar 28 14:43:29 shrimp kernel: tty ptyr0: uevent: unsupported
action-string; this will be ignored in a future kernel version


These messages are a regression compared with 2.6.24, which did not flood the
syslog with them.

The actual underlying problem was introduced in 2.6.23, when somebody made the
string parsing no longer accept nul-terminated strings as a valid input to
store_uevent().

Eg.  "add\0" was valid prior to 2.6.23, where the code regressed to require
"add" without the '\0'.

This patch fixes the 2.6.23 / 2.6.24 regressions, by having the code once
again tolerate the trailing '\0', if present.

According to GregKH, this mainly affects older Ubuntu systems, such as the one
I have here that requires this fix.

Signed-off-by: Mark Lord <mlord@pobox.com>
Cc: Greg KH <greg@kroah.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/kobject_uevent.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN lib/kobject_uevent.c~driver-core-fix-uevent-action-string-regression lib/kobject_uevent.c
--- a/lib/kobject_uevent.c~driver-core-fix-uevent-action-string-regression
+++ a/lib/kobject_uevent.c
@@ -59,7 +59,7 @@ int kobject_action_type(const char *buf,
 	enum kobject_action action;
 	int ret = -EINVAL;
 
-	if (count && buf[count-1] == '\n')
+	if (count && (buf[count-1] == '\n' || buf[count-1] == '\0'))
 		count--;
 
 	if (!count)
_

Patches currently in -mm which might be from lkml@rtr.ca are

origin.patch

