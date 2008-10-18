From: akpm@linux-foundation.org
Subject: - md-check-for-memory-allocation-failure-in-faulty-personality.patch removed from -mm tree
Date: Sat, 18 Oct 2008 16:21:18 -0700
Message-ID: <200810182321.m9INLIcl029935@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56939 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751973AbYJRXV0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 18 Oct 2008 19:21:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sven.wegener@stealer.net, neilb@suse.de, mm-commits@vger.kernel.org


The patch titled
     md: check for memory allocation failure in faulty personality
has been removed from the -mm tree.  Its filename was
     md-check-for-memory-allocation-failure-in-faulty-personality.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: md: check for memory allocation failure in faulty personality
From: Sven Wegener <sven.wegener@stealer.net>

It's a fault injection module, but I don't think we should oops here.

Signed-off-by: Sven Wegener <sven.wegener@stealer.net>
Cc: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/md/faulty.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN drivers/md/faulty.c~md-check-for-memory-allocation-failure-in-faulty-personality drivers/md/faulty.c
--- a/drivers/md/faulty.c~md-check-for-memory-allocation-failure-in-faulty-personality
+++ a/drivers/md/faulty.c
@@ -287,6 +287,8 @@ static int run(mddev_t *mddev)
 	int i;
 
 	conf_t *conf = kmalloc(sizeof(*conf), GFP_KERNEL);
+	if (!conf)
+		return -ENOMEM;
 
 	for (i=0; i<Modes; i++) {
 		atomic_set(&conf->counters[i], 0);
_

Patches currently in -mm which might be from sven.wegener@stealer.net are

origin.patch

