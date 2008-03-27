From: akpm@linux-foundation.org
Subject: + ixp4xx-beeper-add-module_alias.patch added to -mm tree
Date: Thu, 27 Mar 2008 00:49:41 -0700
Message-ID: <200803270749.m2R7nfmY024325@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51688 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755204AbYC0HuK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 27 Mar 2008 03:50:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alessandro.zummo@towertech.it, a.zummo@towertech.it, anemo@mba.ocn.ne.jp, david-b@pacbell.net, dtor@mail.ru, gordonfarquharson@gmail.com, gregkh@suse.de, kay.sievers@vrfy.org


The patch titled
     ixp4xx-beeper: add MODULE_ALIAS
has been added to the -mm tree.  Its filename is
     ixp4xx-beeper-add-module_alias.patch

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
Subject: ixp4xx-beeper: add MODULE_ALIAS
From: Alessandro Zummo <alessandro.zummo@towertech.it>

The following patch allows ixp4xx-beeper to be loaded by udev automatically
when compiled as a module with kernel versions 2.4.24 and greater.  This patch
is required because

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=43cc71eed1250755986da4c0f9898f9a635cb3bf

adds "platform:" to the modalias string.

LKG7102D7:~# udevinfo -a -p /sys/devices/platform/ixp4xx-beeper.4

 looking at device '/devices/platform/ixp4xx-beeper.4':
   KERNEL=="ixp4xx-beeper.4"
   SUBSYSTEM=="platform"
   DRIVER==""
   ATTR{modalias}=="platform:ixp4xx-beeper"

udev therefore tries to modprobe platform:ixp4xx-beeper instead of
ixp4xx-beeper.

LKG7102D7:~# udevtest /sys/devices/platform/ixp4xx-beeper.4
...
import_uevent_var: import into environment: 'PHYSDEVBUS=platform'
import_uevent_var: import into environment: 'MODALIAS=platform:ixp4xx-beeper'
main: looking at device '/devices/platform/ixp4xx-beeper.4' from
subsystem 'platform'
wait_for_sysfs: file '/sys/devices/platform/ixp4xx-beeper.4/bus'
appeared after 0 loops
main: run: 'socket:/org/kernel/udev/monitor'
main: run: '/sbin/modprobe --use-blacklist platform:ixp4xx-beeper'

With this patch, depmod adds an alias line (see below) to
modules.alias which allows modprobe to load the right module.

alias platform:ixp4xx-beeper ixp4xx-beeper

Signed-off-by: Gordon Farquharson <gordonfarquharson@gmail.com>
Signed-off-by: Alessandro Zummo <a.zummo@towertech.it>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Cc: David Brownell <david-b@pacbell.net>
Cc: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Dmitry Torokhov <dtor@mail.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/input/misc/ixp4xx-beeper.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/input/misc/ixp4xx-beeper.c~ixp4xx-beeper-add-module_alias drivers/input/misc/ixp4xx-beeper.c
--- a/drivers/input/misc/ixp4xx-beeper.c~ixp4xx-beeper-add-module_alias
+++ a/drivers/input/misc/ixp4xx-beeper.c
@@ -25,6 +25,7 @@
 MODULE_AUTHOR("Alessandro Zummo <a.zummo@towertech.it>");
 MODULE_DESCRIPTION("ixp4xx beeper driver");
 MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:ixp4xx-beeper");
 
 static DEFINE_SPINLOCK(beep_lock);
 
_

Patches currently in -mm which might be from alessandro.zummo@towertech.it are

ixp4xx-beeper-add-module_alias.patch

