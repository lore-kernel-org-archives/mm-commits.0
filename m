From: akpm@linux-foundation.org
Subject: [merged] zram-document-failed_reads-failed_writes-stats.patch
 removed from -mm tree
Date: Tue, 08 Apr 2014 14:05:01 -0700
Message-ID: <5344647d.PJxZXK5gioJJzeIb%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56681 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756639AbaDHVFC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Apr 2014 17:05:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, ngupta@vflare.org, minchan@kernel.org, jmarchan@redhat.com, sergey.senozhatsky@gmail.com

Subject: [merged] zram-document-failed_reads-failed_writes-stats.patch removed from -mm tree
To: sergey.senozhatsky@gmail.com,jmarchan@redhat.com,minchan@kernel.org,ngupta@vflare.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 08 Apr 2014 14:05:01 -0700


The patch titled
     Subject: zram: document failed_reads, failed_writes stats
has been removed from the -mm tree.  Its filename was
     zram-document-failed_reads-failed_writes-stats.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: zram: document failed_reads, failed_writes stats

Document `failed_reads' and `failed_writes' device attributes.
Remove info about `discard' - there is no such zram attr.

Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Jerome Marchand <jmarchan@redhat.com>
Cc: Nitin Gupta <ngupta@vflare.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/ABI/testing/sysfs-block-zram |   24 +++++++++++--------
 Documentation/blockdev/zram.txt            |    3 +-
 2 files changed, 17 insertions(+), 10 deletions(-)

diff -puN Documentation/ABI/testing/sysfs-block-zram~zram-document-failed_reads-failed_writes-stats Documentation/ABI/testing/sysfs-block-zram
--- a/Documentation/ABI/testing/sysfs-block-zram~zram-document-failed_reads-failed_writes-stats
+++ a/Documentation/ABI/testing/sysfs-block-zram
@@ -43,6 +43,21 @@ Description:
 		The invalid_io file is read-only and specifies the number of
 		non-page-size-aligned I/O requests issued to this device.
 
+What:		/sys/block/zram<id>/failed_reads
+Date:		February 2014
+Contact:	Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
+Description:
+		The failed_reads file is read-only and specifies the number of
+		failed reads happened on this device.
+
+
+What:		/sys/block/zram<id>/failed_writes
+Date:		February 2014
+Contact:	Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
+Description:
+		The failed_writes file is read-only and specifies the number of
+		failed writes happened on this device.
+
 What:		/sys/block/zram<id>/notify_free
 Date:		August 2010
 Contact:	Nitin Gupta <ngupta@vflare.org>
@@ -53,15 +68,6 @@ Description:
 		is freed. This statistic is applicable only when this disk is
 		being used as a swap disk.
 
-What:		/sys/block/zram<id>/discard
-Date:		August 2010
-Contact:	Nitin Gupta <ngupta@vflare.org>
-Description:
-		The discard file is read-only and specifies the number of
-		discard requests received by this device. These requests
-		provide information to block device regarding blocks which are
-		no longer used by filesystem.
