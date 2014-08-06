From: akpm@linux-foundation.org
Subject: [folded-merged]
 printk-allow-increasing-the-ring-buffer-depending-on-the-number-of-cpus-fix.patch removed from -mm tree
Date: Wed, 06 Aug 2014 15:52:51 -0700
Message-ID: <53e2b1c3.Bkpkqsm3bc1AXzLv%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-oi0-f74.google.com ([209.85.218.74]:39362 "EHLO
	mail-oi0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753963AbaHFWw4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Aug 2014 18:52:56 -0400
Received: by mail-oi0-f74.google.com with SMTP id a141so610086oig.3
        for <mm-commits@vger.kernel.org>; Wed, 06 Aug 2014 15:52:56 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: pmladek@suse.cz, mcgrof@suse.com, sfr@canb.auug.org.au, mm-commits@vger.kernel.org


The patch titled
     Subject: printk-allow-increasing-the-ring-buffer-depending-on-the-=
number-of-cpus-fix
has been removed from the -mm tree.  Its filename was
     printk-allow-increasing-the-ring-buffer-depending-on-the-number-of=
-cpus-fix.patch

This patch was dropped because it was folded into printk-allow-increasi=
ng-the-ring-buffer-depending-on-the-number-of-cpus.patch

------------------------------------------------------
=46rom: Petr Ml=E1dek <pmladek@suse.cz>
Subject: printk-allow-increasing-the-ring-buffer-depending-on-the-numbe=
r-of-cpus-fix

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

diff -puN init/Kconfig~printk-allow-increasing-the-ring-buffer-dependin=
g-on-the-number-of-cpus-fix init/Kconfig
--- a/init/Kconfig~printk-allow-increasing-the-ring-buffer-depending-on=
-the-number-of-cpus-fix
+++ a/init/Kconfig
@@ -813,47 +813,34 @@ config LOG_BUF_SHIFT
 	  by "log_buf_len" boot parameter.
=20
 	  Examples:
-	  	     17 =3D> 128 KB
+		     17 =3D> 128 KB
 		     16 =3D> 64 KB
-	             15 =3D> 32 KB
-	             14 =3D> 16 KB
+		     15 =3D> 32 KB
+		     14 =3D> 16 KB
 		     13 =3D>  8 KB
 		     12 =3D>  4 KB
=20
 config LOG_CPU_MAX_BUF_SHIFT
 	int "CPU kernel log buffer size contribution (13 =3D> 8 KB, 17 =3D> 1=
28KB)"
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
-	  a power of 2. The total sum amount of contributions made by all CPU=
s
-	  must be greater than half of the default kernel ring buffer size
-	  ((1 << LOG_BUF_SHIFT / 2 bytes)) in order to trigger an increase up=
on
-	  bootup. If an increase is required the ring buffer is increased to
-	  the next power of 2 that can fit both the minimum kernel ring buffe=
r
-	  (LOG_BUF_SHIFT) plus the additional worst case CPU contributions.
-	  For example if LOG_BUF_SHIFT is 18 (256 KB) you'd require at laest
-	  128 KB contributions by other CPUs in order to trigger an increase.
-	  With a LOG_CPU_BUF_SHIFT of 12 (4 KB) you'd require at least anythi=
ng
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
=20
-	     ((1 << 18) + ((128 - 1) * (1 << 12))) / 1024 =3D 764 KB
-
-	  Since we only allow powers of two for the kernel ring buffer size t=
he
-	  new kernel ring buffer size would be 1024 KB.
-
-	  CPU contributions are ignored when "log_buf_len" kernel parameter i=
s
-	  used as it forces an exact (power of two) size of the ring buffer t=
o
-	  an expected value.
+	  Also this option is ignored when "log_buf_len" kernel parameter is
+	  used as it forces an exact (power of two) size of the ring buffer.
=20
 	  The number of possible CPUs is used for this computation ignoring
 	  hotplugging making the compuation optimal for the the worst case
_

Patches currently in -mm which might be from pmladek@suse.cz are

makefile-tell-gcc-optimizer-to-never-introduce-new-data-races.patch
printk-make-dynamic-kernel-ring-buffer-alignment-explicit.patch
printk-move-power-of-2-practice-of-ring-buffer-size-to-a-helper.patch
printk-make-dynamic-units-clear-for-the-kernel-ring-buffer.patch
printk-allow-increasing-the-ring-buffer-depending-on-the-number-of-cpus=
=2Epatch
printk-tweak-do_syslog-to-match-comments.patch
printk-rename-default_message_loglevel.patch
printk-fix-some-comments.patch
printk-use-a-clever-macro.patch
printk-miscellaneous-cleanups.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
