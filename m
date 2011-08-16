From: akpm@linux-foundation.org
Subject: + drivers-misc-ptic-add-missing-includes.patch added to -mm tree
Date: Tue, 16 Aug 2011 15:03:13 -0700
Message-ID: <201108162203.p7GM3DAl031226@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40805 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751816Ab1HPWDv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Aug 2011 18:03:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: slyfox@gentoo.org, gregkh@suse.de, james_p_freyensee@linux.intel.com, rocher.jeremy@gmail.com


The patch titled
     drivers/misc/pti.c: add missing includes
has been added to the -mm tree.  Its filename is
     drivers-misc-ptic-add-missing-includes.patch

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

drivers-misc-ptic-add-missing-includes.patch

