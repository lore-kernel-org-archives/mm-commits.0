From: akpm@linux-foundation.org
Subject: - ipc-convert-handmade-min-to-min.patch removed from -mm tree
Date: Wed, 09 Jan 2008 15:13:42 -0800
Message-ID: <200801092313.m09NDgwd025991@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57521 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752123AbYAIXOv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 Jan 2008 18:14:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ricknu-0@student.ltu.se, Nadia.Derbey@bull.net, mm-commits@vger.kernel.org


The patch titled
     ipc: convert handmade 'min' to min().
has been removed from the -mm tree.  Its filename was
     ipc-convert-handmade-min-to-min.patch

This patch was dropped because sterner changes are needed

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ipc: convert handmade 'min' to min().
From: Richard Knutsson <ricknu-0@student.ltu.se>

Convert handmade 'min' to min().

Signed-off-by: Richard Knutsson <ricknu-0@student.ltu.se>
Cc: Nadia Derbey <Nadia.Derbey@bull.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/msg.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN ipc/msg.c~ipc-convert-handmade-min-to-min ipc/msg.c
--- a/ipc/msg.c~ipc-convert-handmade-min-to-min
+++ a/ipc/msg.c
@@ -898,7 +898,7 @@ out_unlock:
 	if (IS_ERR(msg))
 		return PTR_ERR(msg);
 
-	msgsz = (msgsz > msg->m_ts) ? msg->m_ts : msgsz;
+	msgsz = min(msgsz, msg->m_ts);
 	*pmtype = msg->m_type;
 	if (store_msg(mtext, msg, msgsz))
 		msgsz = -EFAULT;
_

Patches currently in -mm which might be from ricknu-0@student.ltu.se are

kernel-compliment-va_copy-with-va_end.patch
git-dvb.patch
pcmcia-3c574_cs-fix-dubious-bitfield-warning.patch
pcmcia-3c574_cs-fix-shadow-variable-warning.patch
pcmcia-axnet_cs-make-functions-static.patch
pcmcia-axnet_cs-make-use-of-max-instead-of-handcrafted-one.patch
pcmcia-fmvj18x_cs-fix-shadow-variable-warning.patch
pcmcia-pcnet_cs-fix-shadow-variable-warning.patch
git-selinux.patch
dio-array_size-cleanup-update.patch
dio-array_size-cleanup-update-checkpatch-fixes.patch
reiserfs-complement-va_start-with-va_end.patch
kernel-paramsc-remove-sparse-warning-different-signedness.patch
ipc-convert-handmade-min-to-min.patch
