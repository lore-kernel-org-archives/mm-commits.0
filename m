From: akpm@linux-foundation.org
Subject: + mutex-subsystem-synchro-test-module-add-missing-header-file.patch added to -mm tree
Date: Mon, 12 Oct 2009 19:32:27 -0700
Message-ID: <200910130232.n9D2WRvr026737@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52950 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756138AbZJMCdr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Oct 2009 22:33:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, dhowells@redhat.com


The patch titled
     synchro-test: add missing header file
has been added to the -mm tree.  Its filename is
     mutex-subsystem-synchro-test-module-add-missing-header-file.patch

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
Subject: synchro-test: add missing header file
From: Randy Dunlap <randy.dunlap@oracle.com>

Fix build errors, add <sched.h> header file:

kernel/synchro-test.c: In function 'sched':
kernel/synchro-test.c:220: error: implicit declaration of function 'schedule'
kernel/synchro-test.c: In function 'mutexer':
kernel/synchro-test.c:227: error: implicit declaration of function 'daemonize'
kernel/synchro-test.c:228: error: implicit declaration of function 'set_user_nice'
kernel/synchro-test.c:241: error: dereferencing pointer to incomplete type
kernel/synchro-test.c: In function 'semaphorer':
kernel/synchro-test.c:263: error: dereferencing pointer to incomplete type
kernel/synchro-test.c: In function 'reader':
kernel/synchro-test.c:287: error: dereferencing pointer to incomplete type
kernel/synchro-test.c: In function 'writer':
kernel/synchro-test.c:311: error: dereferencing pointer to incomplete type
kernel/synchro-test.c: In function 'downgrader':
kernel/synchro-test.c:340: error: dereferencing pointer to incomplete type

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Acked-by: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/synchro-test.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN kernel/synchro-test.c~mutex-subsystem-synchro-test-module-add-missing-header-file kernel/synchro-test.c
--- a/kernel/synchro-test.c~mutex-subsystem-synchro-test-module-add-missing-header-file
+++ a/kernel/synchro-test.c
@@ -21,6 +21,7 @@
 #include <linux/module.h>
 #include <linux/poll.h>
 #include <linux/moduleparam.h>
+#include <linux/sched.h>
 #include <linux/stat.h>
 #include <linux/init.h>
 #include <asm/atomic.h>
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

cpufreq-add-cpufreq_get-stub-for-config_cpu_freq=n.patch
linux-next.patch
cmpc_acpi-add-support-for-classmate-pc-acpi-devices-depends-on-acpi.patch
scsi-fix-func-names-in-kernel-doc.patch
pcmcia-fix-controller-printk-format-warnings.patch
readahead-add-blk_run_backing_dev.patch
page-types-unsigned-cannot-be-less-than-0-in-add_page.patch
reiser4-export-remove_from_page_cache-fix.patch
mutex-subsystem-synchro-test-module-add-missing-header-file.patch

