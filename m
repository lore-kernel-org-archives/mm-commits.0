From: akpm@linux-foundation.org
Subject: + diskquota-32bit-quota-tools-on-64bit-architectures-fix.patch added to -mm tree
Date: Mon, 25 Jun 2007 21:28:23 -0700
Message-ID: <200706260428.l5Q4SNWR018310@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52570 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750966AbXFZE2i (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 Jun 2007 00:28:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: michal.k.k.piotrowski@gmail.com, ak@suse.de, jack@ucw.cz, tony.luck@intel.com, vtaras@openvz.org


The patch titled
     fs/quota.c build fix
has been added to the -mm tree.  Its filename is
     diskquota-32bit-quota-tools-on-64bit-architectures-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: fs/quota.c build fix
From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>

  CC      fs/quota.o
fs/quota.c:13:24: error: asm/compat.h: No such file or directory
make[1]: *** [fs/quota.o] Error 1
make: *** [fs] Error 2

diskquota-32bit-quota-tools-on-64bit-architectures.patch

Signed-off-by: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Cc: Vasily Tarasov <vtaras@openvz.org>
Cc: Andi Kleen <ak@suse.de>
Cc: "Luck, Tony" <tony.luck@intel.com>
Cc: Jan Kara <jack@ucw.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/quota.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/quota.c~diskquota-32bit-quota-tools-on-64bit-architectures-fix fs/quota.c
--- a/fs/quota.c~diskquota-32bit-quota-tools-on-64bit-architectures-fix
+++ a/fs/quota.c
@@ -10,7 +10,7 @@
 #include <linux/slab.h>
 #include <asm/current.h>
 #include <asm/uaccess.h>
-#include <asm/compat.h>
+#include <linux/compat.h>
 #include <linux/kernel.h>
 #include <linux/security.h>
 #include <linux/syscalls.h>
_

Patches currently in -mm which might be from michal.k.k.piotrowski@gmail.com are

smsc-ircc2-skip-preconfiguration-for-pnp-devices.patch
pnp-smcf010-quirk-auto-config-device-if-bios-left-it-broken.patch
git-kvm.patch
diskquota-32bit-quota-tools-on-64bit-architectures-fix.patch
revoke-special-mmap-handling-vs-fault-vs-invalidate.patch
reiser4.patch
