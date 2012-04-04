From: akpm@linux-foundation.org
Subject: + drivers-char-randomc-fix-boot-id-uniqueness-race.patch added to -mm tree
Date: Wed, 04 Apr 2012 16:16:25 -0700
Message-ID: <20120404231625.C069DA04F2@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:40302 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757286Ab2DDXQ2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 4 Apr 2012 19:16:28 -0400
Received: by eekc41 with SMTP id c41so40742eek.1
        for <mm-commits@vger.kernel.org>; Wed, 04 Apr 2012 16:16:26 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mathieu.desnoyers@efficios.com, eric.dumazet@gmail.com, greg@kroah.com, mpm@selenic.com, tytso@mit.edu


The patch titled
     Subject: drivers/char/random.c: fix boot id uniqueness race
has been added to the -mm tree.  Its filename is
     drivers-char-randomc-fix-boot-id-uniqueness-race.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Subject: Subject: drivers/char/random.c: fix boot id uniqueness race

Patches currently in -mm which might be from mathieu.desnoyers@efficios.com are

drivers-char-randomc-fix-boot-id-uniqueness-race.patch

