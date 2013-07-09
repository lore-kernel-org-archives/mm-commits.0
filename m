From: akpm@linux-foundation.org
Subject: [merged] partitions-msdos-enumerate-also-aix-lvm-partitions.patch removed from -mm tree
Date: Tue, 09 Jul 2013 16:22:07 -0700
Message-ID: <51dc9b1f.ZGONnSso3quMrSfS%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39232 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753545Ab3GIXWH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Jul 2013 19:22:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, kzak@redhat.com, axboe@kernel.dk, phdm@macqel.be

Subject: [merged] partitions-msdos-enumerate-also-aix-lvm-partitions.patch removed from -mm tree
To: phdm@macqel.be,axboe@kernel.dk,kzak@redhat.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 09 Jul 2013 16:22:07 -0700


The patch titled
     Subject: partitions/msdos: enumerate also AIX LVM partitions
has been removed from the -mm tree.  Its filename was
     partitions-msdos-enumerate-also-aix-lvm-partitions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Philippe De Muyter <phdm@macqel.be>
Subject: partitions/msdos: enumerate also AIX LVM partitions

Graft AIX partitions enumeration into partitions/msdos.c

There is already a AIX disks detection logic in msdos.c.  When an AIX disk
has been found, and if configured to, call the aix partitions recognizer. 
This avoids removal of AIX disks protection from msdos.c, avoids code
duplication, and ensures that AIX partitions enumeration is called before
plain msdos partitions enumeration.

Signed-off-by: Philippe De Muyter <phdm@macqel.be>
Cc: Karel Zak <kzak@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 block/partitions/msdos.c |    5 +++++
 1 file changed, 5 insertions(+)

diff -puN block/partitions/msdos.c~partitions-msdos-enumerate-also-aix-lvm-partitions block/partitions/msdos.c
--- a/block/partitions/msdos.c~partitions-msdos-enumerate-also-aix-lvm-partitions
+++ a/block/partitions/msdos.c
@@ -23,6 +23,7 @@
 #include "check.h"
 #include "msdos.h"
 #include "efi.h"
+#include "aix.h"
 
 /*
  * Many architectures don't like unaligned accesses, while
@@ -462,8 +463,12 @@ int msdos_partition(struct parsed_partit
 	 */
 	if (aix_magic_present(state, data)) {
 		put_dev_sector(sect);
+#ifdef CONFIG_AIX_PARTITION
+		return aix_partition(state);
+#else
 		strlcat(state->pp_buf, " [AIX]", PAGE_SIZE);
 		return 0;
+#endif
 	}
 
 	if (!msdos_magic_present(data + 510)) {
_

Patches currently in -mm which might be from phdm@macqel.be are

origin.patch

