From: akpm@linux-foundation.org
Subject: - export-hidh-and-hidrawh-to-userspace.patch removed from -mm tree
Date: Tue, 08 Apr 2008 11:59:24 -0700
Message-ID: <200804081859.m38IxOrh006982@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51826 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757392AbYDHS7r (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Apr 2008 14:59:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vapier@gentoo.org, dtor@mail.ru, jikos@jikos.cz, mm-commits@vger.kernel.org


The patch titled
     export hid.h and hidraw.h to userspace
has been removed from the -mm tree.  Its filename was
     export-hidh-and-hidrawh-to-userspace.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
git-hid.patch
kbuild-silence-documentation-gen-xml-messages-according-to-quiet.patch
mtd-maps-document-mtd_physmap-module-name-in-kconfig.patch
remove-duplicated-unlikely-in-is_err.patch

