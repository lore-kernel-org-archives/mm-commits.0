From: akpm@linux-foundation.org
Subject: + hdaps-add-support-for-various-newer-lenovo-thinkpads.patch added to -mm tree
Date: Mon, 30 Jun 2008 16:14:07 -0700
Message-ID: <200806302314.m5UNE7HC030571@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58066 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752187AbYF3XPC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Jun 2008 19:15:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: max@stro.at, khali@linux-fr.org, mhoffman@lightlink.com, tim.gardner@canonical.com, ubuntu@hjernemadsen.org, zulcss@ubuntu.com


The patch titled
     hdaps: add support for various newer Lenovo thinkpads
has been added to the -mm tree.  Its filename is
     hdaps-add-support-for-various-newer-lenovo-thinkpads.patch

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
Subject: hdaps: add support for various newer Lenovo thinkpads
From: maximilian attems <max@stro.at>

Adds R61, T61p, X61s, X61, Z61m, Z61p models to whitelist.

Fixes this:

cullen@lenny:~$ sudo modprobe hdaps
FATAL: Error inserting hdaps (/lib/modules/2.6.22-10-generic/kernel/drivers/hwmon/hdaps.ko): No such device

[25192.888000] hdaps: supported laptop not found!
[25192.888000] hdaps: driver init failed (ret=-19)!


Originally based on an Ubuntu patch that got it wrong, the dmidecode
output of the corresponding laptops shows LENOVO as the manufacturer. 
https://bugs.launchpad.net/ubuntu/+source/linux-source-2.6.22/+bug/133636

tested on X61s:
[  184.893588] hdaps: inverting axis readings.
[  184.893588] hdaps: LENOVO ThinkPad X61s detected.
[  184.893588] input: hdaps as /class/input/input12
[  184.924326] hdaps: driver successfully loaded.

Cc: Klaus S. Madsen <ubuntu@hjernemadsen.org>
Cc: Chuck Short <zulcss@ubuntu.com>
Cc: Jean Delvare <khali@linux-fr.org>
Cc: Tim Gardner <tim.gardner@canonical.com>
Signed-off-by: maximilian attems <max@stro.at>
Cc: Mark M. Hoffman <mhoffman@lightlink.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/hwmon/hdaps.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN drivers/hwmon/hdaps.c~hdaps-add-support-for-various-newer-lenovo-thinkpads drivers/hwmon/hdaps.c
--- a/drivers/hwmon/hdaps.c~hdaps-add-support-for-various-newer-lenovo-thinkpads
+++ a/drivers/hwmon/hdaps.c
@@ -516,17 +516,23 @@ static struct dmi_system_id __initdata h
 	HDAPS_DMI_MATCH_NORMAL("IBM", "ThinkPad R51"),
 	HDAPS_DMI_MATCH_NORMAL("IBM", "ThinkPad R52"),
 	HDAPS_DMI_MATCH_INVERT("LENOVO", "ThinkPad R61i"),
+	HDAPS_DMI_MATCH_INVERT("LENOVO", "ThinkPad R61"),
 	HDAPS_DMI_MATCH_INVERT("IBM", "ThinkPad T41p"),
 	HDAPS_DMI_MATCH_NORMAL("IBM", "ThinkPad T41"),
 	HDAPS_DMI_MATCH_INVERT("IBM", "ThinkPad T42p"),
 	HDAPS_DMI_MATCH_NORMAL("IBM", "ThinkPad T42"),
 	HDAPS_DMI_MATCH_NORMAL("IBM", "ThinkPad T43"),
 	HDAPS_DMI_MATCH_INVERT("LENOVO", "ThinkPad T60"),
+	HDAPS_DMI_MATCH_INVERT("LENOVO", "ThinkPad T61p"),
 	HDAPS_DMI_MATCH_INVERT("LENOVO", "ThinkPad T61"),
 	HDAPS_DMI_MATCH_NORMAL("IBM", "ThinkPad X40"),
 	HDAPS_DMI_MATCH_NORMAL("IBM", "ThinkPad X41"),
 	HDAPS_DMI_MATCH_INVERT("LENOVO", "ThinkPad X60"),
+	HDAPS_DMI_MATCH_INVERT("LENOVO", "ThinkPad X61s"),
+	HDAPS_DMI_MATCH_INVERT("LENOVO", "ThinkPad X61"),
 	HDAPS_DMI_MATCH_NORMAL("IBM", "ThinkPad Z60m"),
+	HDAPS_DMI_MATCH_INVERT("LENOVO", "ThinkPad Z61m"),
+	HDAPS_DMI_MATCH_INVERT("LENOVO", "ThinkPad Z61p"),
 	{ .ident = NULL }
 };
 
_

Patches currently in -mm which might be from max@stro.at are

hdaps-add-support-for-various-newer-lenovo-thinkpads.patch
block-request_module-use-format-string.patch

