From: akpm@linux-foundation.org
Subject: [merged]
 kernel-profilec-use-static-const-char-instead-of-static-char.patch removed
 from -mm tree
Date: Mon, 09 Jun 2014 12:36:27 -0700
Message-ID: <53960cbb.jZmphYFLiaa9Lb+0%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54183 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752945AbaFITg1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jun 2014 15:36:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, paul.gortmaker@windriver.com, fabf@skynet.be

Subject: [merged] kernel-profilec-use-static-const-char-instead-of-static-char.patch removed from -mm tree
To: fabf@skynet.be,paul.gortmaker@windriver.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 09 Jun 2014 12:36:27 -0700


The patch titled
     Subject: kernel/profile.c: use static const char instead of static char
has been removed from the -mm tree.  Its filename was
     kernel-profilec-use-static-const-char-instead-of-static-char.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Fabian Frederick <fabf@skynet.be>
Subject: kernel/profile.c: use static const char instead of static char

schedstr, sleepstr and kvmstr are only used in strcmp & strlen

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/profile.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN kernel/profile.c~kernel-profilec-use-static-const-char-instead-of-static-char kernel/profile.c
--- a/kernel/profile.c~kernel-profilec-use-static-const-char-instead-of-static-char
+++ a/kernel/profile.c
@@ -52,9 +52,9 @@ static DEFINE_MUTEX(profile_flip_mutex);
 
 int profile_setup(char *str)
 {
-	static char schedstr[] = "schedule";
-	static char sleepstr[] = "sleep";
-	static char kvmstr[] = "kvm";
+	static const char schedstr[] = "schedule";
+	static const char sleepstr[] = "sleep";
+	static const char kvmstr[] = "kvm";
 	int par;
 
 	if (!strncmp(str, sleepstr, strlen(sleepstr))) {
_

Patches currently in -mm which might be from fabf@skynet.be are

origin.patch
fs-cifs-remove-obsolete-__constant.patch
kernel-posix-timersc-code-clean-up.patch
kernel-posix-timersc-code-clean-up-checkpatch-fixes.patch
fs-ext4-fsyncc-generic_file_fsync-call-based-on-barrier-flag.patch
fs-isofs-logging-clean-up.patch
linux-next.patch
kernel-watchdogc-convert-printk-pr_warning-to-pr_foo.patch
init-mainc-code-clean-up.patch
kernel-kprobesc-convert-printk-to-pr_foo.patch

