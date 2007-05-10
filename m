From: akpm@linux-foundation.org
Subject: - v4l-enlarge-the-size-of-ir-key-table-to-256.patch removed from -mm tree
Date: Thu, 10 May 2007 12:08:39 -0700
Message-ID: <200705101908.l4AJ8dKD027976@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:59989 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751704AbXEJTIt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 10 May 2007 15:08:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: wankai@sjtu.org, mchehab@infradead.org, mm-commits@vger.kernel.org


The patch titled
     v4l: enlarge the size of ir-key table to 256
has been removed from the -mm tree.  Its filename was
     v4l-enlarge-the-size-of-ir-key-table-to-256.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: v4l: enlarge the size of ir-key table to 256
From: Tony Wan <wankai@sjtu.org>

Some IR-remote will produce key codes larger than 128.  Enlarge the size
IR_KEYTAB_SIZE to 256 to enable all the keys.

Signed-off-by: Tony Wan <wankai@sjtu.org>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/media/ir-common.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/media/ir-common.h~v4l-enlarge-the-size-of-ir-key-table-to-256 include/media/ir-common.h
--- a/include/media/ir-common.h~v4l-enlarge-the-size-of-ir-key-table-to-256
+++ a/include/media/ir-common.h
@@ -31,7 +31,7 @@
 #define IR_TYPE_OTHER  99
 
 #define IR_KEYTAB_TYPE	u32
-#define IR_KEYTAB_SIZE	128  // enougth for rc5, probably need more some day ...
+#define IR_KEYTAB_SIZE	256  // some remote needs 8-bit keycodes
 
 #define IR_KEYCODE(tab,code)	(((unsigned)code < IR_KEYTAB_SIZE) \
 				 ? tab[code] : KEY_RESERVED)
_

Patches currently in -mm which might be from wankai@sjtu.org are

v4l-saa7134-add-support-for-10moons-tm300-card.patch
v4l-saa7134-enable-ir-remote-for-10moons-tm300-card.patch
v4l-enlarge-the-size-of-ir-key-table-to-256.patch
