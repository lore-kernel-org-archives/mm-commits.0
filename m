From: akpm@linux-foundation.org
Subject: [merged] drivers-misc-ptic-add-missing-includes.patch removed from -mm tree
Date: Fri, 26 Aug 2011 12:06:12 -0700
Message-ID: <201108261902.p7QJ2uMM005634@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57293 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750973Ab1HZTDd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 26 Aug 2011 15:03:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: slyfox@gentoo.org, gregkh@suse.de, james_p_freyensee@linux.intel.com, rocher.jeremy@gmail.com, mm-commits@vger.kernel.org


The patch titled
     drivers/misc/pti.c: add missing includes
has been removed from the -mm tree.  Its filename was
     drivers-misc-ptic-add-missing-includes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/misc/pti.c: add missing includes
From: Sergei Trofimovich <slyfox@gentoo.org>

Found on allmodconfig build (ARCH=alpha)

    drivers/misc/pti.c: In function 'get_id':
    drivers/misc/pti.c:249: error: implicit declaration of function 'kmalloc'
    drivers/misc/pti.c: In function 'pti_char_write':
    drivers/misc/pti.c:658: error: implicit declaration of function 'copy_from_user'

Signed-off-by: Sergei Trofimovich <slyfox@gentoo.org>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: J Freyensee <james_p_freyensee@linux.intel.com>
Cc: Jeremy Rocher <rocher.jeremy@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/pti.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN drivers/misc/pti.c~drivers-misc-ptic-add-missing-includes drivers/misc/pti.c
--- a/drivers/misc/pti.c~drivers-misc-ptic-add-missing-includes
+++ a/drivers/misc/pti.c
@@ -33,6 +33,8 @@
 #include <linux/mutex.h>
 #include <linux/miscdevice.h>
 #include <linux/pti.h>
+#include <linux/slab.h>
+#include <linux/uaccess.h>
 
 #define DRIVERNAME		"pti"
 #define PCINAME			"pciPTI"
_

Patches currently in -mm which might be from slyfox@gentoo.org are

origin.patch
linux-next.patch

