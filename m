From: akpm@linux-foundation.org
Subject: [merged] fs-gfs2-sysc-use-%pub-to-print-uuids.patch removed from -mm tree
Date: Tue, 15 Dec 2009 13:58:09 -0800
Message-ID: <200912152158.nBFLw9hS015788@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47814 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761310AbZLOV7N (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Dec 2009 16:59:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, swhiteho@redhat.com, mm-commits@vger.kernel.org


The patch titled
     fs/gfs2/sys.c: use %pUB to print UUIDs
has been removed from the -mm tree.  Its filename was
     fs-gfs2-sysc-use-%pub-to-print-uuids.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fs/gfs2/sys.c: use %pUB to print UUIDs
From: Joe Perches <joe@perches.com>

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Steven Whitehouse <swhiteho@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/gfs2/sys.c |   16 +++-------------
 1 file changed, 3 insertions(+), 13 deletions(-)

diff -puN fs/gfs2/sys.c~fs-gfs2-sysc-use-%pub-to-print-uuids fs/gfs2/sys.c
--- a/fs/gfs2/sys.c~fs-gfs2-sysc-use-%pub-to-print-uuids
+++ a/fs/gfs2/sys.c
@@ -85,11 +85,7 @@ static ssize_t uuid_show(struct gfs2_sbd
 	buf[0] = '\0';
 	if (!gfs2_uuid_valid(uuid))
 		return 0;
-	return snprintf(buf, PAGE_SIZE, "%02X%02X%02X%02X-%02X%02X-"
-			"%02X%02X-%02X%02X-%02X%02X%02X%02X%02X%02X\n",
-			uuid[0], uuid[1], uuid[2], uuid[3], uuid[4], uuid[5],
-			uuid[6], uuid[7], uuid[8], uuid[9], uuid[10], uuid[11],
-			uuid[12], uuid[13], uuid[14], uuid[15]);
+	return snprintf(buf, PAGE_SIZE, "%pUB\n", uuid);
 }
 
 static ssize_t freeze_show(struct gfs2_sbd *sdp, char *buf)
@@ -575,14 +571,8 @@ static int gfs2_uevent(struct kset *kset
 	add_uevent_var(env, "LOCKPROTO=%s", sdp->sd_proto_name);
 	if (!sdp->sd_args.ar_spectator)
 		add_uevent_var(env, "JOURNALID=%u", sdp->sd_lockstruct.ls_jid);
-	if (gfs2_uuid_valid(uuid)) {
-		add_uevent_var(env, "UUID=%02X%02X%02X%02X-%02X%02X-%02X%02X-"
-			       "%02X%02X-%02X%02X%02X%02X%02X%02X",
-			       uuid[0], uuid[1], uuid[2], uuid[3], uuid[4],
-			       uuid[5], uuid[6], uuid[7], uuid[8], uuid[9],
-			       uuid[10], uuid[11], uuid[12], uuid[13],
-			       uuid[14], uuid[15]);
-	}
+	if (gfs2_uuid_valid(uuid))
+		add_uevent_var(env, "UUID=%pUB", uuid);
 	return 0;
 }
 
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
linux-next.patch
scripts-checkpatchpl-add-warn-on-sizeof.patch
checkpatchpl-allow-80-char-lines-for-logging-functions-not-just-printk.patch
isicomc-use-pr_fmt-and-pr_level.patch
parport_pcc-use-correct-length-in-strncmp.patch

