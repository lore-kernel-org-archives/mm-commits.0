From: akpm@osdl.org
Subject: - dm-snapshot-abstract-memory-release.patch removed from -mm tree
Date: Fri, 08 Dec 2006 12:15:23 -0800
Message-ID: <200612082015.kB8KFNa9003294@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:60007 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1947007AbWLHUPa (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 15:15:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mbroz@redhat.com, agk@redhat.com, mm-commits@vger.kernel.org


The patch titled
     dm: snapshot: abstract memory release
has been removed from the -mm tree.  Its filename was
     dm-snapshot-abstract-memory-release.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: dm: snapshot: abstract memory release
From: Milan Broz <mbroz@redhat.com>

Move the code that releases memory used by a snapshot into a separate function.

Signed-off-by: Milan Broz <mbroz@redhat.com>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>
Cc: dm-devel@redhat.com
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/md/dm-snap.c |   19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff -puN drivers/md/dm-snap.c~dm-snapshot-abstract-memory-release drivers/md/dm-snap.c
--- a/drivers/md/dm-snap.c~dm-snapshot-abstract-memory-release
+++ a/drivers/md/dm-snap.c
@@ -564,6 +564,17 @@ static int snapshot_ctr(struct dm_target
 	return r;
 }
 
+static void __free_exceptions(struct dm_snapshot *s)
+{
+	kcopyd_client_destroy(s->kcopyd_client);
+	s->kcopyd_client = NULL;
+
+	exit_exception_table(&s->pending, pending_cache);
+	exit_exception_table(&s->complete, exception_cache);
+
+	s->store.destroy(&s->store);
+}
+
 static void snapshot_dtr(struct dm_target *ti)
 {
 	struct dm_snapshot *s = (struct dm_snapshot *) ti->private;
@@ -574,13 +585,7 @@ static void snapshot_dtr(struct dm_targe
 	/* After this returns there can be no new kcopyd jobs. */
 	unregister_snapshot(s);
 
-	kcopyd_client_destroy(s->kcopyd_client);
-
-	exit_exception_table(&s->pending, pending_cache);
-	exit_exception_table(&s->complete, exception_cache);
-
-	/* Deallocate memory used */
-	s->store.destroy(&s->store);
+	__free_exceptions(s);
 
 	dm_put_device(ti, s->origin);
 	dm_put_device(ti, s->cow);
_

Patches currently in -mm which might be from mbroz@redhat.com are

dm-snapshot-abstract-memory-release.patch

