From: akpm@linux-foundation.org
Subject: + fix-hid_device_id-for-cross-compiling.patch added to -mm tree
Date: Thu, 30 Oct 2008 14:53:05 -0700
Message-ID: <200810302153.m9ULr5H7027315@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36156 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754343AbYJ3Vx0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 30 Oct 2008 17:53:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: schwab@suse.de, geert@linux-m68k.org, jkosina@suse.cz


The patch titled
     Fix hid_device_id for cross compiling
has been added to the -mm tree.  Its filename is
     fix-hid_device_id-for-cross-compiling.patch

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
Subject: Fix hid_device_id for cross compiling
From: Andreas Schwab <schwab@suse.de>

struct hid_device_id contains hidden padding which is bad for cross
compiling.  It depends on the alignment restrictions of the architecture. 
On m68k everything is aligned on a 2-byte boundary, so this padding does
not exist.

Make the padding explicit and consistent across architectures.

Signed-off-by: Andreas Schwab <schwab@suse.de>
Cc: Jiri Kosina <jkosina@suse.cz>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mod_devicetable.h |    1 +
 1 file changed, 1 insertion(+)

diff -puN include/linux/mod_devicetable.h~fix-hid_device_id-for-cross-compiling include/linux/mod_devicetable.h
--- a/include/linux/mod_devicetable.h~fix-hid_device_id-for-cross-compiling
+++ a/include/linux/mod_devicetable.h
@@ -135,6 +135,7 @@ struct usb_device_id {
 
 struct hid_device_id {
 	__u16 bus;
+	__u16 pad1;
 	__u32 vendor;
 	__u32 product;
 	kernel_ulong_t driver_data
_

Patches currently in -mm which might be from schwab@suse.de are

fix-hid_device_id-for-cross-compiling.patch

