From: akpm@linux-foundation.org
Subject: + m32r-remove-redundant-tests-on-unsigned.patch added to -mm tree
Date: Fri, 26 Jun 2009 14:28:19 -0700
Message-ID: <200906262128.n5QLSJNi018655@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36090 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751799AbZFZV2a (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 26 Jun 2009 17:28:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: roel.kluin@gmail.com, takata@linux-m32r.org


The patch titled
     m32r: remove redundant tests on unsigned
has been added to the -mm tree.  Its filename is
     m32r-remove-redundant-tests-on-unsigned.patch

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
Subject: m32r: remove redundant tests on unsigned
From: Roel Kluin <roel.kluin@gmail.com>

`off' and `max_cpus' are unsigned.  When negative they are wrapped and
caught by the other test.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Cc: Hirokazu Takata <takata@linux-m32r.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/m32r/kernel/ptrace.c  |    5 ++---
 arch/m32r/kernel/smpboot.c |    2 +-
 2 files changed, 3 insertions(+), 4 deletions(-)

diff -puN arch/m32r/kernel/ptrace.c~m32r-remove-redundant-tests-on-unsigned arch/m32r/kernel/ptrace.c
--- a/arch/m32r/kernel/ptrace.c~m32r-remove-redundant-tests-on-unsigned
+++ a/arch/m32r/kernel/ptrace.c
@@ -78,7 +78,7 @@ static int ptrace_read_user(struct task_
 	struct user * dummy = NULL;
 #endif
 
-	if ((off & 3) || (off < 0) || (off > sizeof(struct user) - 3))
+	if ((off & 3) || off > sizeof(struct user) - 3)
 		return -EIO;
 
 	off >>= 2;
@@ -140,8 +140,7 @@ static int ptrace_write_user(struct task
 	struct user * dummy = NULL;
 #endif
 
-	if ((off & 3) || off < 0 ||
-	    off > sizeof(struct user) - 3)
+	if ((off & 3) || off > sizeof(struct user) - 3)
 		return -EIO;
 
 	off >>= 2;
diff -puN arch/m32r/kernel/smpboot.c~m32r-remove-redundant-tests-on-unsigned arch/m32r/kernel/smpboot.c
--- a/arch/m32r/kernel/smpboot.c~m32r-remove-redundant-tests-on-unsigned
+++ a/arch/m32r/kernel/smpboot.c
@@ -213,7 +213,7 @@ void __init smp_prepare_cpus(unsigned in
 		if (!physid_isset(phys_id, phys_cpu_present_map))
 			continue;
 
-		if ((max_cpus >= 0) && (max_cpus <= cpucount + 1))
+		if (max_cpus <= cpucount + 1)
 			continue;
 
 		do_boot_cpu(phys_id);
_

Patches currently in -mm which might be from roel.kluin@gmail.com are

linux-next.patch
s3c-fix-check-of-index-into-s3c_gpios.patch
powerpc-sky-cpu-redundant-or-incorrect-tests-on-unsigned.patch
media-remove-redundant-tests-on-unsigned.patch
ext4-remove-redundant-test-on-unsigned.patch
wireless-remove-redundant-tests-on-unsigned.patch
frv-duplicate-output_buffer-of-e03.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
m32r-remove-redundant-tests-on-unsigned.patch
m68k-count-can-reach-51-not-50.patch
m68k-cnt-reaches-1-not-0.patch
platinumfb-misplaced-parenthesis.patch
adfs-remove-redundant-test-on-unsigned.patch

