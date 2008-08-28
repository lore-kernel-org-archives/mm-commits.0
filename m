From: akpm@linux-foundation.org
Subject: + sysfs-document-files-in-sys-firmware-sgi_uv.patch added to -mm tree
Date: Wed, 27 Aug 2008 20:39:32 -0700
Message-ID: <200808280339.m7S3dW0G005426@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50822 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753778AbYH1Dka (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 Aug 2008 23:40:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rja@sgi.com, gregkh@suse.de, mingo@elte.hu, steiner@sgi.com, tglx@linutronix.de


The patch titled
     sysfs: document files in /sys/firmware/sgi_uv/
has been added to the -mm tree.  Its filename is
     sysfs-document-files-in-sys-firmware-sgi_uv.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

sysfs-document-files-in-sys-firmware-sgi_uv.patch

