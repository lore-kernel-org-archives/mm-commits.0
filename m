From: akpm@linux-foundation.org
Subject: + x86-mtrr-if-remove-use-of-seq_printf-return-value.patch added
 to -mm tree
Date: Mon, 23 Feb 2015 15:58:42 -0800
Message-ID: <54ebbeb2./0Wd0bptF9y8iwEx%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48259 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752303AbbBWX6n (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 Feb 2015 18:58:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, hpa@zytor.com, mingo@redhat.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: x86: mtrr: if: remove use of seq_printf return value
has been added to the -mm tree.  Its filename is
     x86-mtrr-if-remove-use-of-seq_printf-return-value.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/x86-mtrr-if-remove-use-of-seq_printf-return-value.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/x86-mtrr-if-remove-use-of-seq_printf-return-value.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: x86: mtrr: if: remove use of seq_printf return value

The seq_printf return value, because it's frequently misused,
will eventually be converted to void.

See: commit 1f33c41c03da ("seq_file: Rename seq_overflow() to
     seq_has_overflowed() and make public")

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/cpu/mtrr/if.c |   12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff -puN arch/x86/kernel/cpu/mtrr/if.c~x86-mtrr-if-remove-use-of-seq_printf-return-value arch/x86/kernel/cpu/mtrr/if.c
--- a/arch/x86/kernel/cpu/mtrr/if.c~x86-mtrr-if-remove-use-of-seq_printf-return-value
+++ a/arch/x86/kernel/cpu/mtrr/if.c
@@ -404,11 +404,10 @@ static const struct file_operations mtrr
 static int mtrr_seq_show(struct seq_file *seq, void *offset)
 {
 	char factor;
-	int i, max, len;
+	int i, max;
 	mtrr_type type;
 	unsigned long base, size;
 
-	len = 0;
 	max = num_var_ranges;
 	for (i = 0; i < max; i++) {
 		mtrr_if->get(i, &base, &size, &type);
@@ -425,11 +424,10 @@ static int mtrr_seq_show(struct seq_file
 			size >>= 20 - PAGE_SHIFT;
 		}
 		/* Base can be > 32bit */
-		len += seq_printf(seq, "reg%02i: base=0x%06lx000 "
-			"(%5luMB), size=%5lu%cB, count=%d: %s\n",
-			i, base, base >> (20 - PAGE_SHIFT), size,
-			factor, mtrr_usage_table[i],
-			mtrr_attrib_to_str(type));
+		seq_printf(seq, "reg%02i: base=0x%06lx000 (%5luMB), size=%5lu%cB, count=%d: %s\n",
+			   i, base, base >> (20 - PAGE_SHIFT),
+			   size, factor,
+			   mtrr_usage_table[i], mtrr_attrib_to_str(type));
 	}
 	return 0;
 }
_

Patches currently in -mm which might be from joe@perches.com are

staging-lustre-convert-return-seq_printf-uses.patch
staging-lustre-convert-seq_-hash-functions-to-return-void.patch
staging-lustre-convert-uses-of-int-rc-=-seq_printf.patch
staging-lustre-convert-remaining-uses-of-=-seq_printf.patch
x86-mtrr-if-remove-use-of-seq_printf-return-value.patch
power-wakeup-remove-use-of-seq_printf-return-value.patch
rtc-remove-use-of-seq_printf-return-value.patch
ipc-remove-use-of-seq_printf-return-value.patch
pxa27x_udc-remove-use-of-seq_printf-return-value.patch
microblaze-mb-remove-use-of-seq_printf-return-value.patch
nios2-cpuinfo-remove-use-of-seq_printf-return-value.patch
arm-plat-pxa-remove-use-of-seq_printf-return-value.patch
openrisc-remove-use-of-seq_printf-return-value.patch
cris-remove-use-of-seq_printf-return-value.patch
mfd-ab8500-debugfs-remove-use-of-seq_printf-return-value.patch
staging-i2o-remove-use-of-seq_printf-return-value.patch
staging-rtl8192x-remove-use-of-seq_printf-return-value.patch
s390-remove-use-of-seq_printf-return-value.patch
i8k-remove-use-of-seq_printf-return-value.patch
watchdog-bcm281xx-remove-use-of-seq_printf-return-value.patch
proc-remove-use-of-seq_printf-return-value.patch
cgroup-remove-use-of-seq_printf-return-value.patch
tracing-remove-use-of-seq_printf-return-value.patch
lru_cache-remove-use-of-seq_printf-return-value.patch
parisc-remove-use-of-seq_printf-return-value.patch
regulator-dbx500-remove-use-of-seq_puts-seq_printf-return-value.patch
mm-utilc-add-kstrimdup.patch
checkpatch-improve-no-space-is-necessary-after-a-cast-test.patch
linux-next.patch

