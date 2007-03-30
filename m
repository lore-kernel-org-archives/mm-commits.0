From: akpm@linux-foundation.org
Subject: + 2621-rc5-mm3-fix-e1000-compilation.patch added to -mm tree
Date: Fri, 30 Mar 2007 02:06:48 -0700
Message-ID: <200703300906.l2U96mLI023996@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:56526 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1945948AbXC3JH1 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 30 Mar 2007 05:07:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adobriyan@sw.ru, auke-jan.h.kok@intel.com


The patch titled
     2.6.21-rc5-mm3: fix e1000 compilation
has been added to the -mm tree.  Its filename is
     2621-rc5-mm3-fix-e1000-compilation.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: 2.6.21-rc5-mm3: fix e1000 compilation
From: Alexey Dobriyan <adobriyan@sw.ru>

  CC [M]  drivers/net/e1000/e1000_main.o
drivers/net/e1000/e1000_main.c: In function 'e1000_tso':
drivers/net/e1000/e1000_main.c:2968: error: dereferencing pointer to incomplete type
	...

Cc: Auke Kok <auke-jan.h.kok@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/e1000/e1000_main.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN drivers/net/e1000/e1000_main.c~2621-rc5-mm3-fix-e1000-compilation drivers/net/e1000/e1000_main.c
--- a/drivers/net/e1000/e1000_main.c~2621-rc5-mm3-fix-e1000-compilation
+++ a/drivers/net/e1000/e1000_main.c
@@ -32,6 +32,8 @@
 #include <linux/vmalloc.h>
 #include <linux/pagemap.h>
 #include <linux/netdevice.h>
+#include <linux/tcp.h>
+#include <linux/ipv6.h>
 #include <net/checksum.h>
 #include <net/ip6_checksum.h>
 #include <linux/mii.h>
_

Patches currently in -mm which might be from adobriyan@sw.ru are

origin.patch
git-cpufreq.patch
2621-rc5-mm3-fix-e1000-compilation.patch
fix-race-between-proc_readdir-and-remove_proc_entry.patch
proc-remove-pathetic-deleted-warn_on.patch
add-file-position-info-to-proc.patch
fix-rmmod-read-write-races-in-proc-entries.patch
fix-rmmod-read-write-races-in-proc-entries-fix.patch
proc-oom_score-oops-re-badness.patch
protect-tty-drivers-list-with-tty_mutex.patch
