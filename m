From: akpm@linux-foundation.org
Subject: +
 partitions-add-aix-lvm-partition-support-files-add-the-aix_partition-entry.patch added to -mm tree
Date: Mon, 20 May 2013 16:42:08 -0700
Message-ID: <519ab4d0.w3d9djC3+Z7wt1P1%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45235 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758538Ab3ETXmJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 20 May 2013 19:42:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, kzak@redhat.com, axboe@kernel.dk, phdm@macqel.be

Subject: + partitions-add-aix-lvm-partition-support-files-add-the-aix_partition-entry.patch added to -mm tree
To: phdm@macqel.be,axboe@kernel.dk,kzak@redhat.com
From: akpm@linux-foundation.org
Date: Mon, 20 May 2013 16:42:08 -0700


The patch titled
     Subject: partitions-add-aix-lvm-partition-support-files: add the AIX_PARTITION entry
has been added to the -mm tree.  Its filename is
     partitions-add-aix-lvm-partition-support-files-add-the-aix_partition-entry.patch

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
Subject: partitions-add-aix-lvm-partition-support-files: add the AIX_PARTITION entry

This is the final patch enabling a user to select AIX lvm partitions
detection.

Signed-off-by: Philippe De Muyter <phdm@macqel.be>
Cc: Karel Zak <kzak@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 block/partitions/Kconfig |   11 +++++++++++
 1 file changed, 11 insertions(+)

diff -puN block/partitions/Kconfig~partitions-add-aix-lvm-partition-support-files-add-the-aix_partition-entry block/partitions/Kconfig
--- a/block/partitions/Kconfig~partitions-add-aix-lvm-partition-support-files-add-the-aix_partition-entry
+++ a/block/partitions/Kconfig
@@ -68,6 +68,17 @@ config ACORN_PARTITION_RISCIX
 	  of machines called RISCiX.  If you say 'Y' here, Linux will be able
 	  to read disks partitioned under RISCiX.
 
+config AIX_PARTITION
+	bool "AIX basic partition table support" if PARTITION_ADVANCED
+	help
+	  Say Y here if you would like to be able to read the hard disk
+	  partition table format used by IBM or Motorola PowerPC machines
+	  running AIX.  AIX actually uses a Logical Volume Manager, where
+	  "logical volumes" can be spread across one or multiple disks,
+	  but this driver works only for the simple case of partitions which
+	  are contiguous.
+	  Otherwise, say N.
+
 config OSF_PARTITION
 	bool "Alpha OSF partition support" if PARTITION_ADVANCED
 	default y if ALPHA
_

Patches currently in -mm which might be from phdm@macqel.be are

partitions-msdosc-end-of-line-whitespace-and-semicolon-cleanup.patch
partitions-add-aix-lvm-partition-support-files.patch
partitions-add-aix-lvm-partition-support-files-compile-aixc-if-configured.patch
partitions-add-aix-lvm-partition-support-files-add-the-aix_partition-entry.patch
partitions-msdos-enumerate-also-aix-lvm-partitions.patch

