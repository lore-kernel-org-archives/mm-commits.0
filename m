From: akpm@linux-foundation.org
Subject: [alternative-merged] dm-fix-exstore-lookup-error.patch removed from -mm tree
Date: Wed, 01 Jul 2009 10:23:02 -0700
Message-ID: <200907011723.n61HN2E9029796@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34583 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755505AbZGARYS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Jul 2009 13:24:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yi.y.yang@intel.com, agk@redhat.com, jbrassow@redhat.com, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     dm: fix exstore lookup error
has been removed from the -mm tree.  Its filename was
     dm-fix-exstore-lookup-error.patch

This patch was dropped because an alternative patch was merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: dm: fix exstore lookup error
From: Yi Yang <yi.y.yang@intel.com>

Live image with 2.6.30 kernel created by livecd-tools can't boot because
of device mapper driver regression, error info is below:

device-mapper: snapshot exception stores: Module for exstore type "p" not found

commit f6bd4eb73cdf2a5bf954e497972842f39cabb7e3 ("dm exception store: fix
exstore lookup to be case insensitive") claimed it fixed a regression, but
actually it introduced another error, 'p' in the above error message will
become 'P' followed by many strange characters.

The root cause is the variable persistent is of type char but it is used
as char *, so commit f6bd4eb73cdf2a5bf954e497972842f39cabb7e3 didn't fix
the issue and introduced one more issue.

Signed-off-by: Yi Yang <yi.y.yang@intel.com>
Cc: Jonathan Brassow <jbrassow@redhat.com>
Cc: <stable@kernel.org>
Cc: Alasdair G Kergon <agk@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/md/dm-exception-store.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff -puN drivers/md/dm-exception-store.c~dm-fix-exstore-lookup-error drivers/md/dm-exception-store.c
--- a/drivers/md/dm-exception-store.c~dm-fix-exstore-lookup-error
+++ a/drivers/md/dm-exception-store.c
@@ -197,7 +197,7 @@ int dm_exception_store_create(struct dm_
 	int r = 0;
 	struct dm_exception_store_type *type;
 	struct dm_exception_store *tmp_store;
-	char persistent;
+	char persistent[2];
 
 	if (argc < 3) {
 		ti->error = "Insufficient exception store arguments";
@@ -210,13 +210,14 @@ int dm_exception_store_create(struct dm_
 		return -ENOMEM;
 	}
 
-	persistent = toupper(*argv[1]);
-	if (persistent != 'P' && persistent != 'N') {
+	persistent[0] = toupper(*argv[1]);
+	if (persistent[0] != 'P' && persistent[0] != 'N') {
 		ti->error = "Persistent flag is not P or N";
 		return -EINVAL;
 	}
 
-	type = get_type(&persistent);
+	persistent[1] = '\0';
+	type = get_type(persistent);
 	if (!type) {
 		ti->error = "Exception store type not recognised";
 		r = -EINVAL;
_

Patches currently in -mm which might be from yi.y.yang@intel.com are

origin.patch
linux-next.patch
dm-fix-exstore-lookup-error.patch

