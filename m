From: akpm@linux-foundation.org
Subject: +
 printk-allow-increasing-the-ring-buffer-depending-on-the-number-of-cpus.patch added to -mm tree
Date: Mon, 23 Jun 2014 15:44:47 -0700
Message-ID: <53a8addf.gMrCwFkGGOpiEj/f%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53767 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751437AbaFWWos (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 Jun 2014 18:44:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mcgrof@suse.com, andrew@lunn.ch, arunks.linux@gmail.com, cmetcalf@tilera.com, davidlohr@hp.com, jack@suse.cz, joe@perches.com, keescook@chromium.org, mhocko@suse.cz, pmladek@suse.cz, swarren@wwwdotorg.org, mm-commits@vger.kernel.org


The patch titled
     Subject: printk: allow increasing the ring buffer depending on the number of CPUs
has been added to the -mm tree.  Its filename is
     printk-allow-increasing-the-ring-buffer-depending-on-the-number-of-cpus.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/printk-allow-increasing-the-ring-buffer-depending-on-the-number-of-cpus.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/printk-allow-increasing-the-ring-buffer-depending-on-the-number-of-cpus.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Luis R. Rodriguez" <mcgrof@suse.com>
Subject: printk: allow increasing the ring buffer depending on the number of CPUs

The default size of the ring buffer is too small for machines with a large
amount of CPUs under heavy load.  What ends up happening when debugging is
the ring buffer overlaps and chews up old messages making debugging
impossible unless the size is passed as a kernel parameter.  An idle
system upon boot up will on average spew out only about one or two extra
lines but where this really matters is on heavy load and that will vary
widely depending on the system and environment.

There are mechanisms to help increase the kernel ring buffer for tracing
through debugfs, and those interfaces even allow growing the kernel ring
buffer per CPU.  We also have a static value which can be passed upon
boot.  Relying on debugfs however is not ideal for production, and relying
on the value passed upon bootup is can only used *after* an issue has
creeped up.  Instead of being reactive this adds a proactive measure which
lets you scale the amount of contributions you'd expect to the kernel ring
buffer under load by each CPU in the worst case scenario.

We use num_possible_cpus() to avoid complexities which could be introduced
by dynamically changing the ring buffer size at run time,
num_possible_cpus() lets us use the upper limit on possible number of CPUs
therefore avoiding having to deal with hotplugging CPUs on and off.  This
introduces the kernel configuration option LOG_CPU_MAX_BUF_SHIFT which is
used to specify the maximum amount of contributions to the kernel ring
buffer in the worst case before the kernel ring buffer flips over, the
size is specified as a power of 2.  The total amount of contributions made
by each CPU must be greater than half of the default kernel ring buffer
size (1 << LOG_BUF_SHIFT bytes) in order to trigger an increase upon
bootup.  The kernel ring buffer is increased to the next power of two that
would fit the required minimum kernel ring buffer size plus the additional
CPU contribution.  For example if LOG_BUF_SHIFT is 18 (256 KB) you'd
require at least 128 KB contributions by other CPUs in order to trigger an
increase of the kernel ring buffer.  With a LOG_CPU_BUF_SHIFT of 12 (4 KB)
you'd require at least anything over > 64 possible CPUs to trigger an
increase.  If you had 128 possible CPUs the amount of minimum required
kernel ring buffer bumps to:

   ((1 << 18) + ((128 - 1) * (1 << 12))) / 1024 = 764 KB

Since we require the ring buffer to be a power of two the new required
size would be 1024 KB.

This CPU contributions are ignored when the "log_buf_len" kernel parameter
is used as it forces the exact size of the ring buffer to an expected
power of two value.

Signed-off-by: Luis R. Rodriguez <mcgrof@suse.com>
Signed-off-by: Petr Mladek <pmladek@suse.cz>
Tested-by: Davidlohr Bueso <davidlohr@hp.com>
Tested-by: Petr Mladek <pmladek@suse.cz>
Reviewed-by: Davidlohr Bueso <davidlohr@hp.com>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Stephen Warren <swarren@wwwdotorg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Petr Mladek <pmladek@suse.cz>
Cc: Joe Perches <joe@perches.com>
Cc: Arun KS <arunks.linux@gmail.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Davidlohr Bueso <davidlohr@hp.com>
Cc: Chris Metcalf <cmetcalf@tilera.com>
Cc: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/kernel-parameters.txt |    8 ++-
 init/Kconfig                        |   53 +++++++++++++++++++++++++-
 kernel/printk/printk.c              |   34 ++++++++++++++++
 3 files changed, 92 insertions(+), 3 deletions(-)

diff -puN Documentation/kernel-parameters.txt~printk-allow-increasing-the-ring-buffer-depending-on-the-number-of-cpus Documentation/kernel-parameters.txt
--- a/Documentation/kernel-parameters.txt~printk-allow-increasing-the-ring-buffer-depending-on-the-number-of-cpus
+++ a/Documentation/kernel-parameters.txt
@@ -1692,8 +1692,12 @@ bytes respectively. Such letter suffixes
 			7 (KERN_DEBUG)		debug-level messages
 
 	log_buf_len=n[KMG]	Sets the size of the printk ring buffer,
-			in bytes.  n must be a power of two.  The default
-			size is set in the kernel config file.
+			in bytes.  n must be a power of two and greater
+			than the minimal size. The minimal size is defined
+			by LOG_BUF_SHIFT kernel config parameter. There is
+			also CONFIG_LOG_CPU_MAX_BUF_SHIFT config parameter
+			that allows to increase the default size depending on
+			the number of CPUs. See init/Kconfig for more details.
 
 	logo.nologo	[FB] Disables display of the built-in Linux logo.
 			This may be used to provide more screen space for
diff -puN init/Kconfig~printk-allow-increasing-the-ring-buffer-depending-on-the-number-of-cpus init/Kconfig
--- a/init/Kconfig~printk-allow-increasing-the-ring-buffer-depending-on-the-number-of-cpus
+++ a/init/Kconfig
@@ -807,7 +807,11 @@ config LOG_BUF_SHIFT
 	range 12 21
 	default 17
 	help
-	  Select kernel log buffer size as a power of 2.
+	  Select the minimal kernel log buffer size as a power of 2.
+	  The final size is affected by LOG_CPU_MAX_BUF_SHIFT config
+	  parameter, see below. Any higher size also might be forced
+	  by "log_buf_len" boot parameter.
+
 	  Examples:
 	  	     17 => 128 KB
 		     16 => 64 KB
@@ -816,6 +820,53 @@ config LOG_BUF_SHIFT
 		     13 =>  8 KB
 		     12 =>  4 KB
 
+config LOG_CPU_MAX_BUF_SHIFT
+	int "CPU kernel log buffer size contribution (13 => 8 KB, 17 => 128KB)"
+	range 0 21
+	default 12
+	depends on SMP
+	depends on !BASE_SMALL
+	help
+	  The kernel ring buffer will get additional data logged onto it
+	  when multiple CPUs are supported. Typically the contributions are
+	  only a few lines when idle however under under load this can vary
+	  and in the worst case it can mean losing logging information. You
+	  can use this to set the maximum expected amount of logging
+	  contribution under load by each CPU in the worst case scenario, as
+	  a power of 2. The total sum amount of contributions made by all CPUs
+	  must be greater than half of the default kernel ring buffer size
+	  ((1 << LOG_BUF_SHIFT / 2 bytes)) in order to trigger an increase upon
+	  bootup. If an increase is required the ring buffer is increased to
+	  the next power of 2 that can fit both the minimum kernel ring buffer
+	  (LOG_BUF_SHIFT) plus the additional worst case CPU contributions.
+	  For example if LOG_BUF_SHIFT is 18 (256 KB) you'd require at laest
+	  128 KB contributions by other CPUs in order to trigger an increase.
+	  With a LOG_CPU_BUF_SHIFT of 12 (4 KB) you'd require at least anything
+	  over > 64 possible CPUs to trigger an increase. If you had 128
+	  possible CPUs the new minimum required kernel ring buffer size
+	  would be:
+
+	     ((1 << 18) + ((128 - 1) * (1 << 12))) / 1024 = 764 KB
+
+	  Since we only allow powers of two for the kernel ring buffer size the
+	  new kernel ring buffer size would be 1024 KB.
+
+	  CPU contributions are ignored when "log_buf_len" kernel parameter is
+	  used as it forces an exact (power of two) size of the ring buffer to
+	  an expected value.
+
+	  The number of possible CPUs is used for this computation ignoring
+	  hotplugging making the compuation optimal for the the worst case
+	  scenerio while allowing a simple algorithm to be used from bootup.
+
+	  Examples shift values and their meaning:
+		     17 => 128 KB for each CPU
+		     16 =>  64 KB for each CPU
+		     15 =>  32 KB for each CPU
+		     14 =>  16 KB for each CPU
+		     13 =>   8 KB for each CPU
+		     12 =>   4 KB for each CPU
+
 #
 # Architectures with an unreliable sched_clock() should select this:
 #
diff -puN kernel/printk/printk.c~printk-allow-increasing-the-ring-buffer-depending-on-the-number-of-cpus kernel/printk/printk.c
--- a/kernel/printk/printk.c~printk-allow-increasing-the-ring-buffer-depending-on-the-number-of-cpus
+++ a/kernel/printk/printk.c
@@ -266,6 +266,7 @@ static u32 clear_idx;
 #define LOG_ALIGN __alignof__(struct printk_log)
 #endif
 #define __LOG_BUF_LEN (1 << CONFIG_LOG_BUF_SHIFT)
+#define __LOG_CPU_MAX_BUF_LEN (1 << CONFIG_LOG_CPU_MAX_BUF_SHIFT)
 static char __log_buf[__LOG_BUF_LEN] __aligned(LOG_ALIGN);
 static char *log_buf = __log_buf;
 static u32 log_buf_len = __LOG_BUF_LEN;
@@ -848,12 +849,45 @@ static int __init log_buf_len_setup(char
 }
 early_param("log_buf_len", log_buf_len_setup);
 
+static void __init log_buf_add_cpu(void)
+{
+	unsigned int cpu_extra;
+
+	/*
+	 * archs should set up cpu_possible_bits properly with
+	 * set_cpu_possible() after setup_arch() but just in
+	 * case lets ensure this is valid.
+	 */
+	if (num_possible_cpus() == 1)
+		return;
+
+	cpu_extra = (num_possible_cpus() - 1) * __LOG_CPU_MAX_BUF_LEN;
+
+	/* by default this will only continue through for large > 64 CPUs */
+	if (cpu_extra <= __LOG_BUF_LEN / 2)
+		return;
+
+	pr_info("log_buf_len individual max cpu contribution: %d bytes\n",
+		__LOG_CPU_MAX_BUF_LEN);
+	pr_info("log_buf_len total cpu_extra contributions: %d bytes\n",
+		cpu_extra);
+	pr_info("log_buf_len min size: %d bytes\n", __LOG_BUF_LEN);
+
+	log_buf_len_update(cpu_extra + __LOG_BUF_LEN);
+}
+
 void __init setup_log_buf(int early)
 {
 	unsigned long flags;
 	char *new_log_buf;
 	int free;
 
+	if (log_buf != __log_buf)
+		return;
+
+	if (!early && !new_log_buf_len)
+		log_buf_add_cpu();
+
 	if (!new_log_buf_len)
 		return;
 
_

Patches currently in -mm which might be from mcgrof@suse.com are

printk-make-dynamic-kernel-ring-buffer-alignment-explicit.patch
printk-move-power-of-2-practice-of-ring-buffer-size-to-a-helper.patch
printk-make-dynamic-units-clear-for-the-kernel-ring-buffer.patch
printk-allow-increasing-the-ring-buffer-depending-on-the-number-of-cpus.patch

