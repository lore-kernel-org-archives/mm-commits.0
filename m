From: akpm@linux-foundation.org
Subject: + partitions-msdos-enumerate-also-aix-lvm-partitions.patch added
 to -mm tree
Date: Mon, 20 May 2013 16:42:09 -0700
Message-ID: <519ab4d1.Quue7PIBquIPbQxQ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45238 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758539Ab3ETXmK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 20 May 2013 19:42:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, kzak@redhat.com, axboe@kernel.dk, phdm@macqel.be

Subject: + partitions-msdos-enumerate-also-aix-lvm-partitions.patch added to -mm tree
To: phdm@macqel.be,axboe@kernel.dk,kzak@redhat.com
From: akpm@linux-foundation.org
Date: Mon, 20 May 2013 16:42:09 -0700


The patch titled
     Subject: partitions/msdos: enumerate also AIX LVM partitions
has been added to the -mm tree.  Its filename is
     partitions-msdos-enumerate-also-aix-lvm-partitions.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

partitions-msdosc-end-of-line-whitespace-and-semicolon-cleanup.patch
partitions-add-aix-lvm-partition-support-files.patch
partitions-add-aix-lvm-partition-support-files-compile-aixc-if-configured.patch
partitions-add-aix-lvm-partition-support-files-add-the-aix_partition-entry.patch
partitions-msdos-enumerate-also-aix-lvm-partitions.patch

