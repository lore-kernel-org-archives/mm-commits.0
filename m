From: akpm@linux-foundation.org
Subject: - arch-ia64-kernel-use-time_-macros.patch removed from -mm tree
Date: Thu, 10 Apr 2008 13:01:25 -0700
Message-ID: <200804102001.m3AK1Pvb014972@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52811 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758835AbYDJUC1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 10 Apr 2008 16:02:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: caglar@pardus.org.tr, kosaki.motohiro@jp.fujitsu.com, tony.luck@intel.com, mm-commits@vger.kernel.org


The patch titled
     arch/ia64/kernel/: use time_* macros
has been removed from the -mm tree.  Its filename was
     arch-ia64-kernel-use-time_-macros.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: arch/ia64/kernel/: use time_* macros
From: S.Caglar Onur <caglar@pardus.org.tr>

The functions time_before, time_before_eq, time_after, and time_after_eq are
more robust for comparing jiffies against other values.

So use the time_after() & time_before() macros, defined at linux/jiffies.h,
which deal with wrapping correctly

[akpm@linux-foundation.org: coding-style fixes]
Signed-off-by: S.Caglar Onur <caglar@pardus.org.tr>
Cc: "Luck, Tony" <tony.luck@intel.com>
Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/kernel/irq_ia64.c  |    2 +-
 arch/ia64/kernel/mca.c       |    4 +++-
 arch/ia64/kernel/unaligned.c |    3 ++-
 3 files changed, 6 insertions(+), 3 deletions(-)

diff -puN arch/ia64/kernel/irq_ia64.c~arch-ia64-kernel-use-time_-macros arch/ia64/kernel/irq_ia64.c
--- a/arch/ia64/kernel/irq_ia64.c~arch-ia64-kernel-use-time_-macros
+++ a/arch/ia64/kernel/irq_ia64.c
@@ -472,7 +472,7 @@ ia64_handle_irq (ia64_vector vector, str
 			static unsigned char count;
 			static long last_time;
 
-			if (jiffies - last_time > 5*HZ)
+			if (time_after(jiffies, last_time + 5 * HZ))
 				count = 0;
 			if (++count < 5) {
 				last_time = jiffies;
diff -puN arch/ia64/kernel/mca.c~arch-ia64-kernel-use-time_-macros arch/ia64/kernel/mca.c
--- a/arch/ia64/kernel/mca.c~arch-ia64-kernel-use-time_-macros
+++ a/arch/ia64/kernel/mca.c
@@ -69,6 +69,7 @@
  * 2007-04-27 Russ Anderson <rja@sgi.com>
  *	      Support multiple cpus going through OS_MCA in the same event.
  */
+#include <linux/jiffies.h>
 #include <linux/types.h>
 #include <linux/init.h>
 #include <linux/sched.h>
@@ -293,7 +294,8 @@ static void ia64_mlogbuf_dump_from_init(
 	if (mlogbuf_finished)
 		return;
 
-	if (mlogbuf_timestamp && (mlogbuf_timestamp + 30*HZ > jiffies)) {
+	if (mlogbuf_timestamp &&
+			time_before(jiffies, mlogbuf_timestamp + 30 * HZ)) {
 		printk(KERN_ERR "INIT: mlogbuf_dump is interrupted by INIT "
 			" and the system seems to be messed up.\n");
 		ia64_mlogbuf_finish(0);
diff -puN arch/ia64/kernel/unaligned.c~arch-ia64-kernel-use-time_-macros arch/ia64/kernel/unaligned.c
--- a/arch/ia64/kernel/unaligned.c~arch-ia64-kernel-use-time_-macros
+++ a/arch/ia64/kernel/unaligned.c
@@ -13,6 +13,7 @@
  * 2001/08/13	Correct size of extended floats (float_fsz) from 16 to 10 bytes.
  * 2001/01/17	Add support emulation of unaligned kernel accesses.
  */
+#include <linux/jiffies.h>
 #include <linux/kernel.h>
 #include <linux/sched.h>
 #include <linux/tty.h>
@@ -1290,7 +1291,7 @@ within_logging_rate_limit (void)
 {
 	static unsigned long count, last_time;
 
-	if (jiffies - last_time > 5*HZ)
+	if (time_after(jiffies, last_time + 5 * HZ))
 		count = 0;
 	if (count < 5) {
 		last_time = jiffies;
_

Patches currently in -mm which might be from caglar@pardus.org.tr are

git-powerpc.patch
git-ia64.patch
git-net.patch
arch-parisc-kernel-unalignedc-use-time_-macros.patch
fix-indentation.patch
arch-alpha-kernel-trapsc-use-time_-macros.patch
arch-alpha-kernel-trapsc-use-time_-macros-fix.patch
fs-binfmt_aoutc-use-printk_ratelimit.patch

