From: akpm@linux-foundation.org
Subject: + dvb-remove-deprecated-use-of-rw_lock_unlocked-in-frontends.patch added to -mm tree
Date: Thu, 11 Dec 2008 15:01:14 -0800
Message-ID: <200812112301.mBBN1EEv027826@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51535 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759051AbYLKXCJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 11 Dec 2008 18:02:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rostedt@goodmis.org, mchehab@infradead.org, srostedt@redhat.com


The patch titled
     dvb: remove deprecated use of RW_LOCK_UNLOCKED in frontends
has been added to the -mm tree.  Its filename is
     dvb-remove-deprecated-use-of-rw_lock_unlocked-in-frontends.patch

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

linux-next.patch
dvb-remove-deprecated-use-of-rw_lock_unlocked-in-frontends.patch
net-ipv4-netfilter-nf_nat_rulec-update-rwlock-initialization-for-nat_table.patch
drivers-isdn-misdn-teic-use-rwlock-runtime-init.patch
checkpatch-struct-file_operations-should-normally-be-const.patch

