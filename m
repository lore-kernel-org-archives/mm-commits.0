From: akpm@linux-foundation.org
Subject: - sysfs-document-files-in-sys-firmware-sgi_uv.patch removed from -mm tree
Date: Wed, 03 Sep 2008 09:12:00 -0700
Message-ID: <200809031612.m83GC0On023809@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52740 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752103AbYICQMk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Sep 2008 12:12:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rja@sgi.com, gregkh@suse.de, mingo@elte.hu, steiner@sgi.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     sysfs: document files in /sys/firmware/sgi_uv/
has been removed from the -mm tree.  Its filename was
     sysfs-document-files-in-sys-firmware-sgi_uv.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sysfs: document files in /sys/firmware/sgi_uv/
From: Russ Anderson <rja@sgi.com>

Document files in /sys/firmware/sgi_uv/.

Signed-off-by: Russ Anderson <rja@sgi.com>
Cc: Jack Steiner <steiner@sgi.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/ABI/testing/sysfs-firmware-sgi_uv |   27 ++++++++++++++
 1 file changed, 27 insertions(+)

diff -puN /dev/null Documentation/ABI/testing/sysfs-firmware-sgi_uv
--- /dev/null
+++ a/Documentation/ABI/testing/sysfs-firmware-sgi_uv
@@ -0,0 +1,27 @@
+What:		/sys/firmware/sgi_uv/
+Date:		August 2008
+Contact:	Russ Anderson <rja@sgi.com>
+Description:
+		The /sys/firmware/sgi_uv directory contains information
+		about the SGI UV platform.
+
+		Under that directory are a number of files:
+
+			partition_id
+			coherence_id
+
+		The partition_id entry contains the partition id.
+		SGI UV systems can be partitioned into multiple physical
+		machines, which each partition running a unique copy
+		of the operating system.  Each partition will have a unique
+		partition id.  To display the partition id, use the command:
+
+			cat /sys/firmware/sgi_uv/partition_id
+
+		The coherence_id entry contains the coherence id.
+		A partitioned SGI UV system can have one or more coherence
+		domain.  The coherence id indicates which coherence domain
+		this partition is in.  To display the coherence id, use the
+		command:
+
+			cat /sys/firmware/sgi_uv/coherence_id
_

Patches currently in -mm which might be from rja@sgi.com are

origin.patch

