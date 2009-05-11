From: akpm@linux-foundation.org
Subject: + cred-include-inith-in-credh.patch added to -mm tree
Date: Mon, 11 May 2009 13:20:11 -0700
Message-ID: <200905112020.n4BKKBgM023422@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59275 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752808AbZEKUWt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 11 May 2009 16:22:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adobriyan@gmail.com, dhowells@redhat.com, jmorris@namei.org


The patch titled
     cred: #include init.h in cred.h
has been added to the -mm tree.  Its filename is
     cred-include-inith-in-credh.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cred: #include init.h in cred.h
From: Alexey Dobriyan <adobriyan@gmail.com>

linux/cred.h can't be included as first header (alphabetical order)
because it uses __init which is enough to break compilation on some archs.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Cc: James Morris <jmorris@namei.org>
Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/cred.h |    1 +
 1 file changed, 1 insertion(+)

diff -puN include/linux/cred.h~cred-include-inith-in-credh include/linux/cred.h
--- a/include/linux/cred.h~cred-include-inith-in-credh
+++ a/include/linux/cred.h
@@ -13,6 +13,7 @@
 #define _LINUX_CRED_H
 
 #include <linux/capability.h>
+#include <linux/init.h>
 #include <linux/key.h>
 #include <asm/atomic.h>
 
_

Patches currently in -mm which might be from adobriyan@gmail.com are

linux-next.patch
fs-remove-sparse-errors-in-proc_devtreec.patch
procfs-make-errno-values-consistent-when-open-pident-vs-exit2-race-occurs.patch
cred-include-inith-in-credh.patch
mm-consolidate-init_mm-definition.patch
mm-consolidate-init_mm-definition-fix.patch
mm-introduce-pagehuge-for-testing-huge-gigantic-pages.patch
slob-use-pg_slab-for-identifying-slob-pages.patch
proc-kpagecount-kpageflags-code-cleanup.patch
proc-export-more-page-flags-in-proc-kpageflags.patch
pagemap-document-clarifications.patch
pagemap-document-9-more-exported-page-flags.patch
pagemap-add-page-types-tool.patch
pagemap-export-pg_hwpoison.patch
groups-move-code-to-kernel-groupsc.patch
softirq-introduce-statistics-for-softirq.patch
proc-export-statistics-for-softirq-to-proc.patch
proc-update-document-for-proc-softirqs-and-proc-stat.patch
pidns-make-create_pid_namespace-accept-parent-pidns.patch
pidns-rewrite-copy_pid_ns.patch
utsns-extract-creeate_uts_ns.patch
ipcns-remove-useless-get-put-while-clone_newipc.patch
ipcns-extract-create_ipc_ns.patch
nsproxy-extract-create_nsproxy.patch

