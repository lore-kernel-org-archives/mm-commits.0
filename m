From: akpm@linux-foundation.org
Subject: + driver-core-fix-uevent-action-string-regression.patch added to -mm tree
Date: Fri, 28 Mar 2008 16:51:12 -0700
Message-ID: <200803282351.m2SNpC6G016894@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57085 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756122AbYC1XwE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 28 Mar 2008 19:52:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lkml@rtr.ca, greg@kroah.com, kay.sievers@vrfy.org, mlord@pobox.com, stable@kernel.org


The patch titled
     driver core: fix uevent action-string regression
has been added to the -mm tree.  Its filename is
     driver-core-fix-uevent-action-string-regression.patch

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

driver-core-fix-uevent-action-string-regression.patch

