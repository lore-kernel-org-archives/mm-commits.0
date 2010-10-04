From: akpm@linux-foundation.org
Subject: + lirc-make-struct-file_operations-pointer-const.patch added to -mm tree
Date: Mon, 04 Oct 2010 16:00:01 -0700
Message-ID: <201010042300.o94N01ui020822@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52636 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752073Ab0JDXAi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 Oct 2010 19:00:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: geert@linux-m68k.org, greg@kroah.com, jarod@redhat.com


The patch titled
     lirc: make struct file_operations pointer const
has been added to the -mm tree.  Its filename is
     lirc-make-struct-file_operations-pointer-const.patch

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
Subject: lirc: make struct file_operations pointer const
From: Geert Uytterhoeven <geert@linux-m68k.org>

struct file_operations was made const in the drivers, but not in struct
lirc_driver:

drivers/staging/lirc/lirc_it87.c:365: warning: initialization discards qualifiers from pointer target type
drivers/staging/lirc/lirc_parallel.c:571: warning: initialization discards qualifiers from pointer target type
drivers/staging/lirc/lirc_serial.c:1073: warning: initialization discards qualifiers from pointer target type
drivers/staging/lirc/lirc_sir.c:482: warning: initialization discards qualifiers from pointer target type
drivers/staging/lirc/lirc_zilog.c:1284: warning: assignment discards qualifiers from pointer target type

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Acked-by: Jarod Wilson <jarod@redhat.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/media/lirc_dev.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/media/lirc_dev.h~lirc-make-struct-file_operations-pointer-const include/media/lirc_dev.h
--- a/include/media/lirc_dev.h~lirc-make-struct-file_operations-pointer-const
+++ a/include/media/lirc_dev.h
@@ -139,7 +139,7 @@ struct lirc_driver {
 	struct lirc_buffer *rbuf;
 	int (*set_use_inc) (void *data);
 	void (*set_use_dec) (void *data);
-	struct file_operations *fops;
+	const struct file_operations *fops;
 	struct device *dev;
 	struct module *owner;
 };
_

Patches currently in -mm which might be from geert@linux-m68k.org are

origin.patch
linux-next.patch
drivers-power-ds2782_batteryc-fix-ds2782-battery-driver-units.patch
block-m68k-z2ram-correct-printing-of-sector_t.patch
lirc-make-struct-file_operations-pointer-const.patch
m68k-__pa-cast-arg-to-long.patch
m68knommu-blackfin-remove-old-assembler-only-flags-bit-definitions.patch

