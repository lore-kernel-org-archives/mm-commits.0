From: akpm@linux-foundation.org
Subject: + udf-fix-anchor-point-detection.patch added to -mm tree
Date: Fri, 22 Feb 2008 23:35:11 -0800
Message-ID: <200802230736.m1N7a0eN018390@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:47165 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763931AbYBWIEp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 23 Feb 2008 03:04:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: xemul@openvz.org, Andrew.Neporada@acronis.com, Max.Lyadvinsky@acronis.com, Vladimir.Simonov@acronis.com, Yuri.Per@acronis.com, dev@openvz.org, jack@suse.cz


The patch titled
     UDF: fix anchor point detection
has been added to the -mm tree.  Its filename is
     udf-fix-anchor-point-detection.patch

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
Subject: UDF: fix anchor point detection
From: Pavel Emelyanov <xemul@openvz.org>

According to ECMA 167 rev.  3 (see 3/8.4.2.1), Anchor Volume Descriptor
Pointer should be recorded at two or more anchor points located at sectors
256, N, N - 256, where N - is a largest logical sector number at volume
space.

So we should always try to detect N on UDF volume before trying to find
Anchor Volume Descriptor (i.e.  calling to udf_find_anchor()).

That said, all this patch does is updates the s_last_block even if the
udf_vrs() returns positive value.

Originally written and tested by Yuri Per, ported on latest mainline by me.

Signed-off-by: Yuri Per <Yuri.Per@acronis.com>
Signed-off-by: Pavel Emelyanov <xemul@openvz.org>
Cc: Max Lyadvinsky <Max.Lyadvinsky@acronis.com>
Cc: Vladimir Simonov <Vladimir.Simonov@acronis.com>
Cc: Andrew Neporada <Andrew.Neporada@acronis.com>
Cc: Kirill Korotaev <dev@openvz.org>
Cc: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/udf/super.c |   15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff -puN fs/udf/super.c~udf-fix-anchor-point-detection fs/udf/super.c
--- a/fs/udf/super.c~udf-fix-anchor-point-detection
+++ a/fs/udf/super.c
@@ -1488,16 +1488,17 @@ static int udf_check_valid(struct super_
 	/* Check that it is NSR02 compliant */
 	/* Process any "CD-ROM Volume Descriptor Set" (ECMA 167 2/8.3.1) */
 	else {
+		struct udf_sb_info *sbi = UDF_SB(sb);
+
 		block = udf_vrs(sb, silent);
-		if (block == -1) {
-			struct udf_sb_info *sbi = UDF_SB(sb);
+		if (block == -1)
 			udf_debug("Failed to read byte 32768. Assuming open "
 				  "disc. Skipping validity check\n");
-			if (!sbi->s_last_block)
-				sbi->s_last_block = udf_get_last_block(sb);
-			return 0;
-		} else
-			return !block;
+
+		if (block && !sbi->s_last_block)
+			sbi->s_last_block = udf_get_last_block(sb);
+
+		return !block;
 	}
 }
 
_

Patches currently in -mm which might be from xemul@openvz.org are

use-find_task_by_vpid-in-audit-code.patch
ia64-fix-ptrace-inside-a-namespace.patch
mips-use-find_task_by_vpid-in-system-calls.patch
usbatm-switch-to-kthread-api-stop-using-kill_proc.patch
udf-fix-anchor-point-detection.patch
remove-unused-variable-from-send_signal.patch
turn-legacy_queue-macro-into-static-inline-function.patch
consolidate-checking-for-ignored-legacy-signals.patch
consolidate-checking-for-ignored-legacy-signals-simplify.patch
free_pidmap-turn-it-into-free_pidmapstruct-upid.patch
use-find_task_by_vpid-in-taskstats.patch
deprecate-find_task_by_pid.patch
reiser4.patch
put_pid-make-sure-we-dont-free-the-live-pid.patch
