From: akpm@linux-foundation.org
Subject: - dvb-remove-deprecated-use-of-rw_lock_unlocked-in-frontends.patch removed from -mm tree
Date: Sun, 04 Jan 2009 22:41:01 -0800
Message-ID: <200901050641.n056f19m005005@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54934 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750845AbZAEGlX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 Jan 2009 01:41:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rostedt@goodmis.org, mchehab@infradead.org, srostedt@redhat.com, mm-commits@vger.kernel.org


The patch titled
     dvb: remove deprecated use of RW_LOCK_UNLOCKED in frontends
has been removed from the -mm tree.  Its filename was
     dvb-remove-deprecated-use-of-rw_lock_unlocked-in-frontends.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: dvb: remove deprecated use of RW_LOCK_UNLOCKED in frontends
From: Steven Rostedt <rostedt@goodmis.org>

Impact: clean up

RW_LOCK_UNLOCKED is deprecated.  This patch replaces it with the
__RW_LOCK_UNLOCKED(lock) macro.  This change was a little trickier than
others due to the macro being used in another macro that fills an array.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/dvb/frontends/drx397xD.c    |   12 ++++++------
 drivers/media/dvb/frontends/drx397xD_fw.h |    4 ++--
 2 files changed, 8 insertions(+), 8 deletions(-)

diff -puN drivers/media/dvb/frontends/drx397xD.c~dvb-remove-deprecated-use-of-rw_lock_unlocked-in-frontends drivers/media/dvb/frontends/drx397xD.c
--- a/drivers/media/dvb/frontends/drx397xD.c~dvb-remove-deprecated-use-of-rw_lock_unlocked-in-frontends
+++ a/drivers/media/dvb/frontends/drx397xD.c
@@ -39,7 +39,7 @@ static const char mod_name[] = "drx397xD
 #define F_SET_0D4h	2
 
 enum fw_ix {
-#define _FW_ENTRY(a, b)		b
+#define _FW_ENTRY(a, b, c)	b
 #include "drx397xD_fw.h"
 };
 
@@ -72,11 +72,11 @@ static struct {
 	int refcnt;
 	const u8 *data[ARRAY_SIZE(blob_name)];
 } fw[] = {
-#define _FW_ENTRY(a, b)		{			\
-			.name	= a,			\
-			.file	= 0,			\
-			.lock	= RW_LOCK_UNLOCKED,	\
-			.refcnt = 0,			\
+#define _FW_ENTRY(a, b, c)	{					\
+			.name	= a,					\
+			.file	= 0,					\
+			.lock	= __RW_LOCK_UNLOCKED(fw[c].lock),	\
+			.refcnt = 0,					\
 			.data	= { }		}
 #include "drx397xD_fw.h"
 };
diff -puN drivers/media/dvb/frontends/drx397xD_fw.h~dvb-remove-deprecated-use-of-rw_lock_unlocked-in-frontends drivers/media/dvb/frontends/drx397xD_fw.h
--- a/drivers/media/dvb/frontends/drx397xD_fw.h~dvb-remove-deprecated-use-of-rw_lock_unlocked-in-frontends
+++ a/drivers/media/dvb/frontends/drx397xD_fw.h
@@ -18,8 +18,8 @@
  */
 
 #ifdef _FW_ENTRY
-	_FW_ENTRY("drx397xD.A2.fw",	DRXD_FW_A2 = 0		),
-	_FW_ENTRY("drx397xD.B1.fw",	DRXD_FW_B1		),
+	_FW_ENTRY("drx397xD.A2.fw",	DRXD_FW_A2 = 0,	DRXD_FW_A2	),
+	_FW_ENTRY("drx397xD.B1.fw",	DRXD_FW_B1,	DRXD_FW_B1	),
 #undef _FW_ENTRY
 #endif /* _FW_ENTRY */
 
_

Patches currently in -mm which might be from rostedt@goodmis.org are

origin.patch
remove-linux-hardirqh-from-asm-generic-localh-add-include-linux-irqflagsh-to-acpi-processor_idlec.patch
remove-linux-hardirqh-from-asm-generic-localh-fix.patch
checkpatch-struct-file_operations-should-normally-be-const.patch

