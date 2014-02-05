From: akpm@linux-foundation.org
Subject: + zram-document-failed_reads-failed_writes-stats.patch added to
 -mm tree
Date: Wed, 05 Feb 2014 12:45:39 -0800
Message-ID: <52f2a2f3.ZVkq5LHoRlsLVsbE%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38193 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932599AbaBEUpk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 5 Feb 2014 15:45:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, ngupta@vflare.org, minchan@kernel.org, jmarchan@redhat.com, sergey.senozhatsky@gmail.com

Subject: + zram-document-failed_reads-failed_writes-stats.patch added to -mm tree
To: sergey.senozhatsky@gmail.com,jmarchan@redhat.com,minchan@kernel.org,ngupta@vflare.org
From: akpm@linux-foundation.org
Date: Wed, 05 Feb 2014 12:45:39 -0800


The patch titled
     Subject: zram: document failed_reads, failed_writes stats
has been added to the -mm tree.  Its filename is
     zram-document-failed_reads-failed_writes-stats.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/zram-document-failed_reads-failed_writes-stats.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/zram-document-failed_reads-failed_writes-stats.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
-
 What:		/sys/block/zram<id>/zero_pages
 Date:		August 2010
 Contact:	Nitin Gupta <ngupta@vflare.org>
diff -puN Documentation/blockdev/zram.txt~zram-document-failed_reads-failed_writes-stats Documentation/blockdev/zram.txt
--- a/Documentation/blockdev/zram.txt~zram-document-failed_reads-failed_writes-stats
+++ a/Documentation/blockdev/zram.txt
@@ -51,9 +51,10 @@ size of the disk when not in use so a hu
 		disksize
 		num_reads
 		num_writes
+		failed_reads
+		failed_writes
 		invalid_io
 		notify_free
-		discard
 		zero_pages
 		orig_data_size
 		compr_data_size
_

Patches currently in -mm which might be from sergey.senozhatsky@gmail.com are

zram-drop-init_done-struct-zram-member.patch
zram-do-not-pass-rw-argument-to-__zram_make_request.patch
zram-remove-good-and-bad-compress-stats.patch
zram-use-atomic64_t-for-all-zram-stats.patch
zram-remove-zram-stats-code-duplication.patch
zram-report-failed-read-and-write-stats.patch
zram-drop-not-used-table-count-member.patch
zram-move-zram-size-warning-to-documentation.patch
zram-document-failed_reads-failed_writes-stats.patch

