From: akpm@linux-foundation.org
Subject: + scripts-fix-the-sys-path-for-gdb-scripts.patch added to -mm
 tree
Date: Tue, 24 Nov 2015 15:47:35 -0800
Message-ID: <5654f717.BM/oqcF+Te7I9844%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56893 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753809AbbKXXrf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 24 Nov 2015 18:47:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yalin.wang2010@gmail.com, jan.kiszka@siemens.com, mm-commits@vger.kernel.org


The patch titled
     Subject: scripts/gdb/vmlinux-gdb.py: fix the sys path for gdb scripts
has been added to the -mm tree.  Its filename is
     scripts-fix-the-sys-path-for-gdb-scripts.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/scripts-fix-the-sys-path-for-gdb-scripts.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/scripts-fix-the-sys-path-for-gdb-scripts.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: yalin wang <yalin.wang2010@gmail.com>
Subject: scripts/gdb/vmlinux-gdb.py: fix the sys path for gdb scripts

The sys.path should be scripts/gdb, so that we can import linux lib
correctly.

Signed-off-by: yalin wang <yalin.wang2010@gmail.com>
Cc: Jan Kiszka <jan.kiszka@siemens.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/gdb/vmlinux-gdb.py |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN scripts/gdb/vmlinux-gdb.py~scripts-fix-the-sys-path-for-gdb-scripts scripts/gdb/vmlinux-gdb.py
--- a/scripts/gdb/vmlinux-gdb.py~scripts-fix-the-sys-path-for-gdb-scripts
+++ a/scripts/gdb/vmlinux-gdb.py
@@ -13,7 +13,7 @@
 
 import os
 
-sys.path.insert(0, os.path.dirname(__file__) + "/scripts/gdb")
+sys.path.insert(0, os.path.dirname(__file__))
 
 try:
     gdb.parse_and_eval("0")
_

Patches currently in -mm which might be from yalin.wang2010@gmail.com are

scripts-fix-the-sys-path-for-gdb-scripts.patch
mm-change-trace_mm_vmscan_writepage-proto-type.patch
mm-change-mm_vmscan_lru_shrink_inactive-proto-types.patch
mm-fix-kernel-crash-in-khugepaged-thread.patch

