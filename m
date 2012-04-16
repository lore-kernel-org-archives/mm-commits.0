From: akpm@linux-foundation.org
Subject: [merged] drivers-char-randomc-fix-boot-id-uniqueness-race.patch removed from -mm tree
Date: Mon, 16 Apr 2012 13:15:22 -0700
Message-ID: <20120416201522.696E4A0308@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yw0-f74.google.com ([209.85.213.74]:37999 "EHLO
	mail-yw0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753552Ab2DPUPX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 16 Apr 2012 16:15:23 -0400
Received: by yhgm50 with SMTP id m50so640589yhg.1
        for <mm-commits@vger.kernel.org>; Mon, 16 Apr 2012 13:15:22 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mathieu.desnoyers@efficios.com, eric.dumazet@gmail.com, greg@kroah.com, mpm@selenic.com, tytso@mit.edu, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/char/random.c: fix boot id uniqueness race
has been removed from the -mm tree.  Its filename was
     drivers-char-randomc-fix-boot-id-uniqueness-race.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: drivers/char/random.c: fix boot id uniqueness race

/proc/sys/kernel/random/boot_id can be read concurrently by userspace
processes.  If two (or more) user-space processes concurrently read
boot_id when sysctl_bootid is not yet assigned, a race can occur making
boot_id differ between the reads.  Because the whole point of the boot id
is to be unique across a kernel execution, fix this by protecting this
operation with a spinlock.

Given that this operation is not frequently used, hitting the spinlock
on each call should not be an issue.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: Matt Mackall <mpm@selenic.com>
Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Greg Kroah-Hartman <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/random.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff -puN drivers/char/random.c~drivers-char-randomc-fix-boot-id-uniqueness-race drivers/char/random.c
--- a/drivers/char/random.c~drivers-char-randomc-fix-boot-id-uniqueness-race
+++ a/drivers/char/random.c
@@ -1260,10 +1260,15 @@ static int proc_do_uuid(ctl_table *table
 	uuid = table->data;
 	if (!uuid) {
 		uuid = tmp_uuid;
-		uuid[8] = 0;
-	}
-	if (uuid[8] == 0)
 		generate_random_uuid(uuid);
+	} else {
+		static DEFINE_SPINLOCK(bootid_spinlock);
+
+		spin_lock(&bootid_spinlock);
+		if (!uuid[8])
+			generate_random_uuid(uuid);
+		spin_unlock(&bootid_spinlock);
+	}
 
 	sprintf(buf, "%pU", uuid);
 
_

Patches currently in -mm which might be from mathieu.desnoyers@efficios.com are


