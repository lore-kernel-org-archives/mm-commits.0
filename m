From: akpm@linux-foundation.org
Subject: [alternative-merged] fs-partitions-osfc-corrupted-osf-partition-table-can-cause-information-disclosure.patch removed from -mm tree
Date: Tue, 15 Mar 2011 13:30:05 -0700
Message-ID: <201103152032.p2FKWFAD009717@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46437 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758294Ab1COUci (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Mar 2011 16:32:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Warns@pre-sense.de, warns@pre-sense.de, mm-commits@vger.kernel.org


The patch titled
     fs/partitions/osf.c: corrupted OSF partition table can cause information disclosure
has been removed from the -mm tree.  Its filename was
     fs-partitions-osfc-corrupted-osf-partition-table-can-cause-information-disclosure.patch

This patch was dropped because an alternative patch was merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fs/partitions/osf.c: corrupted OSF partition table can cause information disclosure
From: Timo Warns <Warns@pre-sense.de>

The kernel automatically evaluates partition tables of storage devices. 
The code for evaluating OSF partitions (in fs/partitions/osf.c) contains a
bug that leaks data from kernel heap memory to userspace for certain
corrupted OSF partitions.

In more detail (from Kernel 2.6.37 fs/partition/osf.c):

(66)    for (i = 0 ; i < le16_to_cpu(label->d_npartitions); i++, partition++) {

iterates from 0 to d_npartitions - 1, where

    d_npartitions is read from the partition table without validation and
    partition is a pointer to an array of at most 8 d_partitions.

(70)        put_partition(state, slot,
(71)          le32_to_cpu(partition->p_offset),
(72)          le32_to_cpu(partition->p_size));

adds a partition based on data referenced by partition.  As partition may
point beyond the partition table data structure, p_offset and p_size are
read from kernel heap beyond the partition table.

In some cases, put_partition logs error messages to userspace including
the p_offset and p_size values.  Hence, some values from kernel heap are
leaked to userspace.

So validate the value of d_npartitions.

Signed-off-by: Timo Warns <warns@pre-sense.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/partitions/osf.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN fs/partitions/osf.c~fs-partitions-osfc-corrupted-osf-partition-table-can-cause-information-disclosure fs/partitions/osf.c
--- a/fs/partitions/osf.c~fs-partitions-osfc-corrupted-osf-partition-table-can-cause-information-disclosure
+++ a/fs/partitions/osf.c
@@ -63,6 +63,10 @@ int osf_partition(struct parsed_partitio
 		put_dev_sector(sect);
 		return 0;
 	}
+	if (le16_to_cpu(label->d_npartitions) > 8) {
+		put_dev_sector(sect);
+		return 0;
+	}
 	for (i = 0 ; i < le16_to_cpu(label->d_npartitions); i++, partition++) {
 		if (slot == state->limit)
 		        break;
_

Patches currently in -mm which might be from Warns@pre-sense.de are


