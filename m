From: akpm@linux-foundation.org
Subject: [merged] block-partitions-mac-obey-the-state-limit-constraint.patch removed from -mm tree
Date: Thu, 28 Feb 2013 12:16:44 -0800
Message-ID: <20130228201644.A553031C0A0@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:59176 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753851Ab3B1UQp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 28 Feb 2013 15:16:45 -0500
Received: by mail-qa0-f74.google.com with SMTP id o13so261503qaj.3
        for <mm-commits@vger.kernel.org>; Thu, 28 Feb 2013 12:16:45 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ming.lei@canonical.com, axboe@kernel.dk, isimatu.yasuaki@jp.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     Subject: block/partitions/mac.c: obey the state->limit constraint
has been removed from the -mm tree.  Its filename was
     block-partitions-mac-obey-the-state-limit-constraint.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Ming Lei <ming.lei@canonical.com>
Subject: block/partitions/mac.c: obey the state->limit constraint

It isn't necessary to read the information of partitions whose number is
equal and more than state->limit since only maximum state->limit
partitions will be added inside rescan_partitions().

That is also what other kind of partitions are doing.

Signed-off-by: Ming Lei <ming.lei@canonical.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 block/partitions/mac.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN block/partitions/mac.c~block-partitions-mac-obey-the-state-limit-constraint block/partitions/mac.c
--- a/block/partitions/mac.c~block-partitions-mac-obey-the-state-limit-constraint
+++ a/block/partitions/mac.c
@@ -63,6 +63,10 @@ int mac_partition(struct parsed_partitio
 		put_dev_sector(sect);
 		return 0;
 	}
+
+	if (blocks_in_map >= state->limit)
+		blocks_in_map = state->limit - 1;
+
 	strlcat(state->pp_buf, " [mac]", PAGE_SIZE);
 	for (slot = 1; slot <= blocks_in_map; ++slot) {
 		int pos = slot * secsize;
_

Patches currently in -mm which might be from ming.lei@canonical.com are

origin.patch

