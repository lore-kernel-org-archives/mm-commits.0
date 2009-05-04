From: akpm@linux-foundation.org
Subject: [merged] pagemap-require-aligned-length-non-null-reads-of-proc-pid-pagemap.patch removed from -mm tree
Date: Mon, 04 May 2009 13:12:47 -0700
Message-ID: <200905042012.n44KClXD022086@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39968 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753399AbZEDURy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 May 2009 16:17:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: v.mayatskih@gmail.com, adobriyan@gmail.com, mpm@selenic.com, stable@kernel.org, ttuttle@google.com, mm-commits@vger.kernel.org


The patch titled
     pagemap: require aligned-length, non-null reads of /proc/pid/pagemap
has been removed from the -mm tree.  Its filename was
     pagemap-require-aligned-length-non-null-reads-of-proc-pid-pagemap.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pagemap: require aligned-length, non-null reads of /proc/pid/pagemap
From: Vitaly Mayatskikh <v.mayatskih@gmail.com>

The intention of commit aae8679b0ebcaa92f99c1c3cb0cd651594a43915
("pagemap: fix bug in add_to_pagemap, require aligned-length reads of
/proc/pid/pagemap") was to force reads of /proc/pid/pagemap to be a
multiple of 8 bytes, but now it allows to read 0 bytes, which actually
puts some data to user's buffer.  According to POSIX, if count is zero,
read() should return zero and has no other results.

Signed-off-by: Vitaly Mayatskikh <v.mayatskih@gmail.com>
Cc: Thomas Tuttle <ttuttle@google.com>
Acked-by: Matt Mackall <mpm@selenic.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN fs/proc/task_mmu.c~pagemap-require-aligned-length-non-null-reads-of-proc-pid-pagemap fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~pagemap-require-aligned-length-non-null-reads-of-proc-pid-pagemap
+++ a/fs/proc/task_mmu.c
@@ -665,6 +665,10 @@ static ssize_t pagemap_read(struct file 
 		goto out_task;
 
 	ret = 0;
+
+	if (!count)
+		goto out_task;
+
 	mm = get_task_mm(task);
 	if (!mm)
 		goto out_task;
_

Patches currently in -mm which might be from v.mayatskih@gmail.com are

origin.patch

