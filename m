From: akpm@linux-foundation.org
Subject: + cgroup-remove-use-of-seq_printf-return-value.patch added to -mm tree
Date: Mon, 23 Feb 2015 15:59:16 -0800
Message-ID: <54ebbed4./j+DezakdzRrSU46%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48322 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752714AbbBWX7R (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 Feb 2015 18:59:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: cgroup: remove use of seq_printf return value
has been added to the -mm tree.  Its filename is
     cgroup-remove-use-of-seq_printf-return-value.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/cgroup-remove-use-of-seq_printf-return-value.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/cgroup-remove-use-of-seq_printf-return-value.patch

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
Subject: cgroup: remove use of seq_printf return value

The seq_printf return value, because it's frequently misused,
will eventually be converted to void.

See: commit 1f33c41c03da ("seq_file: Rename seq_overflow() to
     seq_has_overflowed() and make public")

Signed-off-by: Joe Perches <joe@perches.com>
Acked-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cgroup.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN kernel/cgroup.c~cgroup-remove-use-of-seq_printf-return-value kernel/cgroup.c
--- a/kernel/cgroup.c~cgroup-remove-use-of-seq_printf-return-value
+++ a/kernel/cgroup.c
@@ -4199,7 +4199,9 @@ static void *cgroup_pidlist_next(struct
 
 static int cgroup_pidlist_show(struct seq_file *s, void *v)
 {
-	return seq_printf(s, "%d\n", *(int *)v);
+	seq_printf(s, "%d\n", *(int *)v);
+
+	return 0;
 }
 
 static u64 cgroup_read_notify_on_release(struct cgroup_subsys_state *css,
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

