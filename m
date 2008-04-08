From: akpm@linux-foundation.org
Subject: + export-hidh-and-hidrawh-to-userspace.patch added to -mm tree
Date: Mon, 07 Apr 2008 20:28:38 -0700
Message-ID: <200804080328.m383Sc1o006135@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45397 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751910AbYDHD2z (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Apr 2008 23:28:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: vapier@gentoo.org, dtor@mail.ru, jikos@jikos.cz


The patch titled
     export hid.h and hidraw.h to userspace
has been added to the -mm tree.  Its filename is
     export-hidh-and-hidrawh-to-userspace.patch

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
Subject: export hid.h and hidraw.h to userspace
From: Mike Frysinger <vapier@gentoo.org>

I have people whining about using these headers in userspace, and they have
__KERNEL__ markings which implies they're supposed to be exported.  I also
added the required linux/types.h include to hidraw.h since it uses the __u##
kernel types.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Cc: Jiri Kosina <jikos@jikos.cz>
Cc: Dmitry Torokhov <dtor@mail.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/Kbuild   |    2 ++
 include/linux/hidraw.h |    1 +
 2 files changed, 3 insertions(+)

diff -puN include/linux/Kbuild~export-hidh-and-hidrawh-to-userspace include/linux/Kbuild
--- a/include/linux/Kbuild~export-hidh-and-hidrawh-to-userspace
+++ a/include/linux/Kbuild
@@ -209,7 +209,9 @@ unifdef-y += hayesesp.h
 unifdef-y += hdlcdrv.h
 unifdef-y += hdlc.h
 unifdef-y += hdreg.h
+unifdef-y += hid.h
 unifdef-y += hiddev.h
+unifdef-y += hidraw.h
 unifdef-y += hpet.h
 unifdef-y += i2c.h
 unifdef-y += i2c-dev.h
diff -puN include/linux/hidraw.h~export-hidh-and-hidrawh-to-userspace include/linux/hidraw.h
--- a/include/linux/hidraw.h~export-hidh-and-hidrawh-to-userspace
+++ a/include/linux/hidraw.h
@@ -16,6 +16,7 @@
  */
 
 #include <linux/hid.h>
+#include <linux/types.h>
 
 struct hidraw_report_descriptor {
 	__u32 size;
_

Patches currently in -mm which might be from vapier@gentoo.org are

origin.patch
kbuild-silence-documentation-gen-xml-messages-according-to-quiet.patch
mtd-maps-document-mtd_physmap-module-name-in-kconfig.patch
export-hidh-and-hidrawh-to-userspace.patch
remove-duplicated-unlikely-in-is_err.patch

