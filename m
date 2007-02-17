From: akpm@linux-foundation.org
Subject: + fix-build-errors-if-bitop-functions-are-do-while-macros.patch added to -mm tree
Date: Fri, 16 Feb 2007 19:29:59 -0800
Message-ID: <200702170329.l1H3TxLt017879@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:46564 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946394AbXBQDdf (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 16 Feb 2007 22:33:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ralf@linux-mips.org, neilb@suse.de, trond.myklebust@fys.uio.no


The patch titled
     Fix build errors if bitop functions are do {} while macros
has been added to the -mm tree.  Its filename is
     fix-build-errors-if-bitop-functions-are-do-while-macros.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Fix build errors if bitop functions are do {} while macros
From: Ralf Baechle <ralf@linux-mips.org>

If one of clear_bit, change_bit or set_bit is defined as a do { } while (0)
function usage of these functions in parenthesis like

  (foo_bit(23, &var))

while be expaned to something like

  (do { ... } while (0)}).

resulting in a build error.  This patch removes the useless parenthesis.

Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/floppy.c       |   12 ++++++------
 include/linux/sunrpc/sched.h |   12 ++++++------
 2 files changed, 12 insertions(+), 12 deletions(-)

diff -puN drivers/block/floppy.c~fix-build-errors-if-bitop-functions-are-do-while-macros drivers/block/floppy.c
--- a/drivers/block/floppy.c~fix-build-errors-if-bitop-functions-are-do-while-macros
+++ a/drivers/block/floppy.c
@@ -297,17 +297,17 @@ static int initialising = 1;
 #define DRS (&drive_state[current_drive])
 #define DRWE (&write_errors[current_drive])
 #define FDCS (&fdc_state[fdc])
-#define CLEARF(x) (clear_bit(x##_BIT, &DRS->flags))
-#define SETF(x) (set_bit(x##_BIT, &DRS->flags))
-#define TESTF(x) (test_bit(x##_BIT, &DRS->flags))
+#define CLEARF(x) clear_bit(x##_BIT, &DRS->flags)
+#define SETF(x) set_bit(x##_BIT, &DRS->flags)
+#define TESTF(x) test_bit(x##_BIT, &DRS->flags)
 
 #define UDP (&drive_params[drive])
 #define UDRS (&drive_state[drive])
 #define UDRWE (&write_errors[drive])
 #define UFDCS (&fdc_state[FDC(drive)])
-#define UCLEARF(x) (clear_bit(x##_BIT, &UDRS->flags))
-#define USETF(x) (set_bit(x##_BIT, &UDRS->flags))
-#define UTESTF(x) (test_bit(x##_BIT, &UDRS->flags))
+#define UCLEARF(x) clear_bit(x##_BIT, &UDRS->flags)
+#define USETF(x) set_bit(x##_BIT, &UDRS->flags)
+#define UTESTF(x) test_bit(x##_BIT, &UDRS->flags)
 
 #define DPRINT(format, args...) printk(DEVICE_NAME "%d: " format, current_drive , ## args)
 
diff -puN include/linux/sunrpc/sched.h~fix-build-errors-if-bitop-functions-are-do-while-macros include/linux/sunrpc/sched.h
--- a/include/linux/sunrpc/sched.h~fix-build-errors-if-bitop-functions-are-do-while-macros
+++ a/include/linux/sunrpc/sched.h
@@ -150,10 +150,10 @@ struct rpc_call_ops {
 #define RPC_TASK_HAS_TIMER	3
 #define RPC_TASK_ACTIVE		4
 
-#define RPC_IS_RUNNING(t)	(test_bit(RPC_TASK_RUNNING, &(t)->tk_runstate))
-#define rpc_set_running(t)	(set_bit(RPC_TASK_RUNNING, &(t)->tk_runstate))
+#define RPC_IS_RUNNING(t)	test_bit(RPC_TASK_RUNNING, &(t)->tk_runstate)
+#define rpc_set_running(t)	set_bit(RPC_TASK_RUNNING, &(t)->tk_runstate)
 #define rpc_test_and_set_running(t) \
-				(test_and_set_bit(RPC_TASK_RUNNING, &(t)->tk_runstate))
+				test_and_set_bit(RPC_TASK_RUNNING, &(t)->tk_runstate)
 #define rpc_clear_running(t)	\
 	do { \
 		smp_mb__before_clear_bit(); \
@@ -161,8 +161,8 @@ struct rpc_call_ops {
 		smp_mb__after_clear_bit(); \
 	} while (0)
 
-#define RPC_IS_QUEUED(t)	(test_bit(RPC_TASK_QUEUED, &(t)->tk_runstate))
-#define rpc_set_queued(t)	(set_bit(RPC_TASK_QUEUED, &(t)->tk_runstate))
+#define RPC_IS_QUEUED(t)	test_bit(RPC_TASK_QUEUED, &(t)->tk_runstate)
+#define rpc_set_queued(t)	set_bit(RPC_TASK_QUEUED, &(t)->tk_runstate)
 #define rpc_clear_queued(t)	\
 	do { \
 		smp_mb__before_clear_bit(); \
@@ -179,7 +179,7 @@ struct rpc_call_ops {
 		smp_mb__after_clear_bit(); \
 	} while (0)
 
-#define RPC_IS_ACTIVATED(t)	(test_bit(RPC_TASK_ACTIVE, &(t)->tk_runstate))
+#define RPC_IS_ACTIVATED(t)	test_bit(RPC_TASK_ACTIVE, &(t)->tk_runstate)
 
 /*
  * Task priorities.
_

Patches currently in -mm which might be from ralf@linux-mips.org are

origin.patch
fix-build-errors-if-bitop-functions-are-do-while-macros.patch
git-mips.patch
mips-remove-smp_tune_scheduling.patch
simplify-the-stacktrace-code.patch
mips-convert-to-use-shared-apm-emulation-fix.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-mips.patch
local_t-mips-extension.patch
local_t-mips-extension-fix.patch
local_t-mips-extension-shrink-duplicated-mips-32-64-bits-functions-from-localh.patch
