From: akpm@linux-foundation.org
Subject: + block-partitions-mac-obey-the-state-limit-constraint.patch added to -mm tree
Date: Thu, 21 Feb 2013 14:27:22 -0800
Message-ID: <20130221222722.9A43B5A402F@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f202.google.com ([209.85.213.202]:32998 "EHLO
	mail-ye0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755979Ab3BUW1X (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Feb 2013 17:27:23 -0500
Received: by mail-ye0-f202.google.com with SMTP id q5so5358yen.5
        for <mm-commits@vger.kernel.org>; Thu, 21 Feb 2013 14:27:23 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ming.lei@canonical.com, axboe@kernel.dk, isimatu.yasuaki@jp.fujitsu.com


The patch titled
     Subject: block/partitions/mac.c: obey the state->limit constraint
has been added to the -mm tree.  Its filename is
     block-partitions-mac-obey-the-state-limit-constraint.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
linux-next.patch
mm-teach-mm-by-current-context-info-to-not-do-i-o-during-memory-allocation.patch
pm-runtime-introduce-pm_runtime_set_memalloc_noio.patch
block-genhdc-apply-pm_runtime_set_memalloc_noio-on-block-devices.patch
net-core-apply-pm_runtime_set_memalloc_noio-on-network-devices.patch
pm-runtime-force-memory-allocation-with-no-i-o-during-runtime-pm-callbcack.patch
usb-forbid-memory-allocation-with-i-o-during-bus-reset.patch
block-partitions-mac-obey-the-state-limit-constraint.patch

