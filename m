From: akpm@linux-foundation.org
Subject: [merged] ksm-add-sysfs-abi-documentation.patch removed from -mm tree
Date: Mon, 25 Feb 2013 12:53:47 -0800
Message-ID: <20130225205347.C77095A426D@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f201.google.com ([209.85.213.201]:43237 "EHLO
	mail-ye0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759798Ab3BYUxt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 25 Feb 2013 15:53:49 -0500
Received: by mail-ye0-f201.google.com with SMTP id m12so142233yen.0
        for <mm-commits@vger.kernel.org>; Mon, 25 Feb 2013 12:53:48 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: pholasek@redhat.com, aarcange@redhat.com, gerald.schaefer@de.ibm.com, hughd@google.com, izik.eidus@ravellosystems.com, kosaki.motohiro@gmail.com, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ksm: add sysfs ABI Documentation
has been removed from the -mm tree.  Its filename was
     ksm-add-sysfs-abi-documentation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Petr Holasek <pholasek@redhat.com>
Subject: ksm: add sysfs ABI Documentation

Add sysfs documentation for Kernel Samepage Merging (KSM) including new
merge_across_nodes knob.

Signed-off-by: Petr Holasek <pholasek@redhat.com>
Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Izik Eidus <izik.eidus@ravellosystems.com>
Cc: Gerald Schaefer <gerald.schaefer@de.ibm.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/ABI/testing/sysfs-kernel-mm-ksm |   52 ++++++++++++++++
 1 file changed, 52 insertions(+)

diff -puN /dev/null Documentation/ABI/testing/sysfs-kernel-mm-ksm
--- /dev/null
+++ a/Documentation/ABI/testing/sysfs-kernel-mm-ksm
@@ -0,0 +1,52 @@
+What:		/sys/kernel/mm/ksm
+Date:		September 2009
+KernelVersion:	2.6.32
+Contact:	Linux memory management mailing list <linux-mm@kvack.org>
+Description:	Interface for Kernel Samepage Merging (KSM)
+
+What:		/sys/kernel/mm/ksm/full_scans
+What:		/sys/kernel/mm/ksm/pages_shared
+What:		/sys/kernel/mm/ksm/pages_sharing
+What:		/sys/kernel/mm/ksm/pages_to_scan
+What:		/sys/kernel/mm/ksm/pages_unshared
+What:		/sys/kernel/mm/ksm/pages_volatile
+What:		/sys/kernel/mm/ksm/run
+What:		/sys/kernel/mm/ksm/sleep_millisecs
+Date:		September 2009
+Contact:	Linux memory management mailing list <linux-mm@kvack.org>
+Description:	Kernel Samepage Merging daemon sysfs interface
+
+		full_scans: how many times all mergeable areas have been
+		scanned.
+
+		pages_shared: how many shared pages are being used.
+
+		pages_sharing: how many more sites are sharing them i.e. how
+		much saved.
+
+		pages_to_scan: how many present pages to scan before ksmd goes
+		to sleep.
+
+		pages_unshared: how many pages unique but repeatedly checked
+		for merging.
+
+		pages_volatile: how many pages changing too fast to be placed
+		in a tree.
+
+		run: write 0 to disable ksm, read 0 while ksm is disabled.
+			write 1 to run ksm, read 1 while ksm is running.
+			write 2 to disable ksm and unmerge all its pages.
+
+		sleep_millisecs: how many milliseconds ksm should sleep between
+		scans.
+
+		See Documentation/vm/ksm.txt for more information.
+
+What:		/sys/kernel/mm/ksm/merge_across_nodes
+Date:		January 2013
+KernelVersion:	3.9
+Contact:	Linux memory management mailing list <linux-mm@kvack.org>
+Description:	Control merging pages across different NUMA nodes.
+
+		When it is set to 0 only pages from the same node are merged,
+		otherwise pages from all nodes can be merged together (default).
_

Patches currently in -mm which might be from pholasek@redhat.com are

origin.patch

