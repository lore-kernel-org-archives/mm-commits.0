From: akpm@linux-foundation.org
Subject: + vt-allow-for-the-palette-to-be-exposed-and-changed-via-sysfs.patch added to -mm tree
Date: Sun, 01 Apr 2007 22:31:50 -0700
Message-ID: <200704020531.l325VoGT025056@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:36150 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753317AbXDBFcF (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 2 Apr 2007 01:32:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jengelh@linux01.gwdg.de, adaplas@pol.net, jengelh@gmx.de


The patch titled
     vt: allow for the palette to be exposed and changed via sysfs
has been added to the -mm tree.  Its filename is
     vt-allow-for-the-palette-to-be-exposed-and-changed-via-sysfs.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: vt: allow for the palette to be exposed and changed via sysfs
From: Jan Engelhardt <jengelh@linux01.gwdg.de>

Allow for the palette to be exposed and changed via sysfs.  A call to
/usr/bin/reset will slurp the new definitions in for the current console.

Already posted at http://lkml.org/lkml/2006/1/15/149

Signed-off-by: Jan Engelhardt <jengelh@gmx.de>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/vt.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN drivers/char/vt.c~vt-allow-for-the-palette-to-be-exposed-and-changed-via-sysfs drivers/char/vt.c
--- a/drivers/char/vt.c~vt-allow-for-the-palette-to-be-exposed-and-changed-via-sysfs
+++ a/drivers/char/vt.c
@@ -934,6 +934,10 @@ int default_grn[] = {0x00,0x00,0xaa,0x55
 int default_blu[] = {0x00,0x00,0x00,0x00,0xaa,0xaa,0xaa,0xaa,
     0x55,0x55,0x55,0x55,0xff,0xff,0xff,0xff};
 
+module_param_array(default_red, int, NULL, S_IRUGO | S_IWUSR);
+module_param_array(default_grn, int, NULL, S_IRUGO | S_IWUSR);
+module_param_array(default_blu, int, NULL, S_IRUGO | S_IWUSR);
+
 /*
  * gotoxy() must verify all boundaries, because the arguments
  * might also be negative. If the given position is out of
_

Patches currently in -mm which might be from jengelh@linux01.gwdg.de are

git-kbuild.patch
remove-artificial-software-max_loop-limit.patch
vt-allow-for-the-palette-to-be-exposed-and-changed-via-sysfs.patch
