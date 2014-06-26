From: akpm@linux-foundation.org
Subject: +
 printk-allow-increasing-the-ring-buffer-depending-on-the-number-of-cpus-fix.patch added to -mm tree
Date: Thu, 26 Jun 2014 12:36:44 -0700
Message-ID: <53ac764c.g5TksxkrDusomWn4%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: application/octet-stream
Content-Transfer-Encoding: 8bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58922 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750737AbaFZTgp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 26 Jun 2014 15:36:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: pmladek@suse.cz, mcgrof@suse.com, sfr@canb.auug.org.au, mm-commits@vger.kernel.org


The patch titled
     Subject: printk-allow-increasing-the-ring-buffer-depending-on-the-number-of-cpus-fix
has been added to the -mm tree.  Its filename is
     printk-allow-increasing-the-ring-buffer-depending-on-the-number-of-cpus-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/printk-allow-increasing-the-ring-buffer-depending-on-the-number-of-cpus-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/printk-allow-increasing-the-ring-buffer-depending-on-the-number-of-cpus-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Petr Mládek <pmladek@suse.cz>
Subject: printk-allow-increasing-the-ring-buffer-depending-on-the-number-of-cpus-fix

There are situations when the default value is not defined, for
example, when both SMP and BASE_SMALL are set.

I would ignore SMP. It is handled in the code. If SMP is not defined,
num_possible_cpus() returns 1 and "cpu_extra" is always 0. Then we
could have:

       range 0 21
       default 12 if !BASE_SMALL
       default 0 if BASE_SMALL

What about the following patch? It does the above change. Plus
it tries to make the help text better readable. It says the basic
details first. Then it says other useful information in
separate paragraphs. Also I removed the computation example. It was
not easy to parse. Interested people might want to look into sources.

Cc: Luis R. Rodriguez <mcgrof@suse.com>
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/Kconfig |   51 ++++++++++++++++++-------------------------------
 1 file changed, 19 insertions(+), 32 deletions(-)

diff -puN init/Kconfig~printk-allow-increasing-the-ring-buffer-depending-on-the-number-of-cpus-fix init/Kconfig
--- a/init/Kconfig~printk-allow-increasing-the-ring-buffer-depending-on-the-number-of-cpus-fix
+++ a/init/Kconfig
@@ -813,47 +813,34 @@ config LOG_BUF_SHIFT
 	  by "log_buf_len" boot parameter.
 
 	  Examples:
-	  	     17 => 128 KB
+		     17 => 128 KB
 		     16 => 64 KB
-	             15 => 32 KB
-	             14 => 16 KB
+		     15 => 32 KB
+		     14 => 16 KB
 		     13 =>  8 KB
 		     12 =>  4 KB
 
 config LOG_CPU_MAX_BUF_SHIFT
 	int "CPU kernel log buffer size contribution (13 => 8 KB, 17 => 128KB)"
 	range 0 21
-	default 12
-	depends on SMP
-	depends on !BASE_SMALL
+	default 12 if !BASE_SMALL
+	default 0 if BASE_SMALL
 	help
-	  The kernel ring buffer will get additional data logged onto it
-	  when multiple CPUs are supported. Typically the contributions are
-	  only a few lines when idle however under under load this can vary
-	  and in the worst case it can mean losing logging information. You
-	  can use this to set the maximum expected amount of logging
-	  contribution under load by each CPU in the worst case scenario, as
-	  a power of 2. The total sum amount of contributions made by all CPUs
-	  must be greater than half of the default kernel ring buffer size
-	  ((1 << LOG_BUF_SHIFT / 2 bytes)) in order to trigger an increase upon
-	  bootup. If an increase is required the ring buffer is increased to
-	  the next power of 2 that can fit both the minimum kernel ring buffer
-	  (LOG_BUF_SHIFT) plus the additional worst case CPU contributions.
-	  For example if LOG_BUF_SHIFT is 18 (256 KB) you'd require at laest
-	  128 KB contributions by other CPUs in order to trigger an increase.
-	  With a LOG_CPU_BUF_SHIFT of 12 (4 KB) you'd require at least anything
-	  over > 64 possible CPUs to trigger an increase. If you had 128
-	  possible CPUs the new minimum required kernel ring buffer size
-	  would be:
+	  This option allows to increase the default ring buffer size
+	  according to the number of CPUs. The value defines the contribution
+	  of each CPU as a power of 2. The used space is typically only few
+	  lines however it might be much more when problems are reported,
+	  e.g. backtraces.
+
+	  The increased size means that a new buffer has to be allocated and
+	  the original static one is unused. It makes sense only on systems
+	  with more CPUs. Therefore this value is used only when the sum of
+	  contributions is greater than the half of the default kernel ring
+	  buffer as defined by LOG_BUF_SHIFT. The default values are set
+	  so that more than 64 CPUs are needed to trigger the allocation.
 
-	     ((1 << 18) + ((128 - 1) * (1 << 12))) / 1024 = 764 KB
-
-	  Since we only allow powers of two for the kernel ring buffer size the
-	  new kernel ring buffer size would be 1024 KB.
