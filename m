From: akpm@linux-foundation.org
Subject: [merged] panic-add-taint_softlockup.patch removed from -mm tree
Date: Tue, 12 Aug 2014 12:40:50 -0700
Message-ID: <53ea6dc2.iW2ExF0h/9C/lSrj%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qg0-f73.google.com ([209.85.192.73]:52914 "EHLO
	mail-qg0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754981AbaHLTkv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 12 Aug 2014 15:40:51 -0400
Received: by mail-qg0-f73.google.com with SMTP id q107so1306917qgd.4
        for <mm-commits@vger.kernel.org>; Tue, 12 Aug 2014 12:40:50 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: johunt@akamai.com, jbaron@akamai.com, rdunlap@infradead.org, mm-commits@vger.kernel.org


The patch titled
     Subject: panic: add TAINT_SOFTLOCKUP
has been removed from the -mm tree.  Its filename was
     panic-add-taint_softlockup.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Josh Hunt <johunt@akamai.com>
Subject: panic: add TAINT_SOFTLOCKUP

This taint flag will be set if the system has ever entered a softlockup
state.  Similar to TAINT_WARN it is useful to know whether or not the
system has been in a softlockup state when debugging.

[akpm@linux-foundation.org: apply the taint before calling panic()]
Signed-off-by: Josh Hunt <johunt@akamai.com>
Cc: Jason Baron <jbaron@akamai.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/oops-tracing.txt  |    2 ++
 Documentation/sysctl/kernel.txt |    1 +
 include/linux/kernel.h          |    1 +
 kernel/panic.c                  |    1 +
 kernel/watchdog.c               |    1 +
 5 files changed, 6 insertions(+)

diff -puN Documentation/oops-tracing.txt~panic-add-taint_softlockup Documentation/oops-tracing.txt
--- a/Documentation/oops-tracing.txt~panic-add-taint_softlockup
+++ a/Documentation/oops-tracing.txt
@@ -268,6 +268,8 @@ characters, each representing a particul
  14: 'E' if an unsigned module has been loaded in a kernel supporting
      module signature.
 
+ 15: 'L' if a soft lockup has previously occurred on the system.
+
 The primary reason for the 'Tainted: ' string is to tell kernel
 debuggers if this is a clean kernel or if anything unusual has
 occurred.  Tainting is permanent: even if an offending module is
diff -puN Documentation/sysctl/kernel.txt~panic-add-taint_softlockup Documentation/sysctl/kernel.txt
--- a/Documentation/sysctl/kernel.txt~panic-add-taint_softlockup
+++ a/Documentation/sysctl/kernel.txt
@@ -826,6 +826,7 @@ can be ORed together:
 4096 - An out-of-tree module has been loaded.
 8192 - An unsigned module has been loaded in a kernel supporting module
        signature.
+16384 - A soft lockup has previously occurred on the system.
 
 ==============================================================
 
diff -puN include/linux/kernel.h~panic-add-taint_softlockup include/linux/kernel.h
--- a/include/linux/kernel.h~panic-add-taint_softlockup
+++ a/include/linux/kernel.h
@@ -470,6 +470,7 @@ extern enum system_states {
 #define TAINT_FIRMWARE_WORKAROUND	11
 #define TAINT_OOT_MODULE		12
 #define TAINT_UNSIGNED_MODULE		13
+#define TAINT_SOFTLOCKUP		14
 
 extern const char hex_asc[];
 #define hex_asc_lo(x)	hex_asc[((x) & 0x0f)]
diff -puN kernel/panic.c~panic-add-taint_softlockup kernel/panic.c
--- a/kernel/panic.c~panic-add-taint_softlockup
+++ a/kernel/panic.c
@@ -224,6 +224,7 @@ static const struct tnt tnts[] = {
 	{ TAINT_FIRMWARE_WORKAROUND,	'I', ' ' },
 	{ TAINT_OOT_MODULE,		'O', ' ' },
 	{ TAINT_UNSIGNED_MODULE,	'E', ' ' },
+	{ TAINT_SOFTLOCKUP,		'L', ' ' },
 };
 
 /**
diff -puN kernel/watchdog.c~panic-add-taint_softlockup kernel/watchdog.c
--- a/kernel/watchdog.c~panic-add-taint_softlockup
+++ a/kernel/watchdog.c
@@ -368,6 +368,7 @@ static enum hrtimer_restart watchdog_tim
 			smp_mb__after_atomic();
 		}
 
+		add_taint(TAINT_SOFTLOCKUP, LOCKDEP_STILL_OK);
 		if (softlockup_panic)
 			panic("softlockup: hung tasks");
 		__this_cpu_write(soft_watchdog_warn, true);
_

Patches currently in -mm which might be from johunt@akamai.com are

origin.patch
block-restore-proc-partitions-to-not-display-non-partitionable-removable-devices.patch

