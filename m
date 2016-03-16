From: akpm@linux-foundation.org
Subject: [merged] paride-make-verbose-parameter-an-int-again.patch removed from -mm tree
Date: Wed, 16 Mar 2016 12:53:29 -0700
Message-ID: <56e9b9b9.8Xw0JRjydpFVvv9V%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38403 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752208AbcCPTxa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 16 Mar 2016 15:53:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arnd@arndb.de, axboe@fb.com, gregkh@linuxfoundation.org, sudipm.mukherjee@gmail.com, tim@cyberelk.net, mm-commits@vger.kernel.org


The patch titled
     Subject: paride: make 'verbose' parameter an 'int' again
has been removed from the -mm tree.  Its filename was
     paride-make-verbose-parameter-an-int-again.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Arnd Bergmann <arnd@arndb.de>
Subject: paride: make 'verbose' parameter an 'int' again

gcc-6.0 found an ancient bug in the paride driver, which had a
"module_param(verbose, bool, 0);" since before 2.6.12, but actually uses
it to accept '0', '1' or '2' as arguments:

drivers/block/paride/pd.c: In function 'pd_init_dev_parms':
drivers/block/paride/pd.c:298:29: warning: comparison of constant '1' with boolean expression is always false [-Wbool-compare]
 #define DBMSG(msg) ((verbose>1)?(msg):NULL)

In 2012, Rusty did a cleanup patch that also changed the type of the
variable to 'bool', which introduced what is now a gcc warning.

This changes the type back to 'int' and adapts the module_param() line
instead, so it should work as documented in case anyone ever cares about
running the ancient driver with debugging.

Fixes: 90ab5ee94171 ("module_param: make bool parameters really bool (drivers & misc)")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Rusty Russell <rusty@rustcorp.com.au>
Cc: Tim Waugh <tim@cyberelk.net>
Cc: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc: Jens Axboe <axboe@fb.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/paride/pd.c |    4 ++--
 drivers/block/paride/pt.c |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff -puN drivers/block/paride/pd.c~paride-make-verbose-parameter-an-int-again drivers/block/paride/pd.c
--- a/drivers/block/paride/pd.c~paride-make-verbose-parameter-an-int-again
+++ a/drivers/block/paride/pd.c
@@ -126,7 +126,7 @@
 */
 #include <linux/types.h>
 
-static bool verbose = 0;
+static int verbose = 0;
 static int major = PD_MAJOR;
 static char *name = PD_NAME;
 static int cluster = 64;
@@ -161,7 +161,7 @@ enum {D_PRT, D_PRO, D_UNI, D_MOD, D_GEO,
 static DEFINE_MUTEX(pd_mutex);
 static DEFINE_SPINLOCK(pd_lock);
 
-module_param(verbose, bool, 0);
+module_param(verbose, int, 0);
 module_param(major, int, 0);
 module_param(name, charp, 0);
 module_param(cluster, int, 0);
diff -puN drivers/block/paride/pt.c~paride-make-verbose-parameter-an-int-again drivers/block/paride/pt.c
--- a/drivers/block/paride/pt.c~paride-make-verbose-parameter-an-int-again
+++ a/drivers/block/paride/pt.c
@@ -117,7 +117,7 @@
 
 */
 
-static bool verbose = 0;
+static int verbose = 0;
 static int major = PT_MAJOR;
 static char *name = PT_NAME;
 static int disable = 0;
@@ -152,7 +152,7 @@ static int (*drives[4])[6] = {&drive0, &
 
 #include <asm/uaccess.h>
 
-module_param(verbose, bool, 0);
+module_param(verbose, int, 0);
 module_param(major, int, 0);
 module_param(name, charp, 0);
 module_param_array(drive0, int, NULL, 0);
_

Patches currently in -mm which might be from arnd@arndb.de are

mm-compaction-introduce-kcompactd-fix.patch
mm-page_ref-add-tracepoint-to-track-down-page-reference-manipulation-fix-2.patch
cred-userns-define-current_user_ns-as-a-function.patch
profile-hide-unused-functions-when-config_proc_fs.patch
staging-goldfish-use-6-arg-get_user_pages.patch

