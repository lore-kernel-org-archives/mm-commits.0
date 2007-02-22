From: akpm@linux-foundation.org
Subject: + frv-missing-error-defs.patch added to -mm tree
Date: Wed, 21 Feb 2007 16:04:29 -0800
Message-ID: <200702220004.l1M04TO5030726@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:58868 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1945927AbXBVAEh (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 21 Feb 2007 19:04:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dhowells@redhat.com


The patch titled
     FRV: Missing error defs
has been added to the -mm tree.  Its filename is
     frv-missing-error-defs.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: FRV: Missing error defs
From: David Howells <dhowells@redhat.com>

linux/irq.h uses EINVAL but does not #include linux/errno.h.  This results in
the compiler spitting out errors on some files.

Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/irq.h |    1 +
 1 files changed, 1 insertion(+)

diff -puN include/linux/irq.h~frv-missing-error-defs include/linux/irq.h
--- a/include/linux/irq.h~frv-missing-error-defs
+++ a/include/linux/irq.h
@@ -18,6 +18,7 @@
 #include <linux/spinlock.h>
 #include <linux/cpumask.h>
 #include <linux/irqreturn.h>
+#include <linux/errno.h>
 
 #include <asm/irq.h>
 #include <asm/ptrace.h>
_

Patches currently in -mm which might be from dhowells@redhat.com are

git-cpufreq.patch
drivers-media-video-cpia_ppc-dont-use-_work_nar.patch
git-parisc.patch
frv-missing-error-defs.patch
doc-atomic_add_unless-doesnt-imply-mb-on-failure.patch
kill-net-rxrpc-rxrpc_symsc.patch
aio-use-flush_work.patch
kblockd-use-flush_work.patch
relayfs-use-flush_keventd_work.patch
tg3-use-flush_keventd_work.patch
e1000-use-flush_keventd_work.patch
libata-use-flush_work.patch
phy-use-flush_work.patch
reiser4-get_sb_dev-fix.patch
mutex-subsystem-synchro-test-module.patch
