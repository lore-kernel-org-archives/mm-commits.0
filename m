From: akpm@linux-foundation.org
Subject: + kernel-acct-fix-coding-style-warnings-and-errors.patch added to -mm tree
Date: Mon, 14 Jul 2014 13:43:21 -0700
Message-ID: <53c440e9.+gbBc9YPV54mSxkB%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-pa0-f73.google.com ([209.85.220.73]:62520 "EHLO
	mail-pa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756215AbaGNUnW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 14 Jul 2014 16:43:22 -0400
Received: by mail-pa0-f73.google.com with SMTP id kx10so817792pab.4
        for <mm-commits@vger.kernel.org>; Mon, 14 Jul 2014 13:43:21 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ionut.m.alexa@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/acct.c: fix coding style warnings and errors
has been added to the -mm tree.  Its filename is
     kernel-acct-fix-coding-style-warnings-and-errors.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kernel-acct-fix-coding-style-warnings-and-errors.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kernel-acct-fix-coding-style-warnings-and-errors.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Ionut Alexa <ionut.m.alexa@gmail.com>
Subject: kernel/acct.c: fix coding style warnings and errors

Signed-off-by: Ionut Alexa <ionut.m.alexa@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/acct.c |   30 +++++++++++++++++-------------
 1 file changed, 17 insertions(+), 13 deletions(-)

diff -puN kernel/acct.c~kernel-acct-fix-coding-style-warnings-and-errors kernel/acct.c
--- a/kernel/acct.c~kernel-acct-fix-coding-style-warnings-and-errors
+++ a/kernel/acct.c
@@ -141,12 +141,12 @@ static int check_free_space(struct bsd_a
 	if (acct->active) {
 		if (act < 0) {
 			acct->active = 0;
-			printk(KERN_INFO "Process accounting paused\n");
+			pr_info("Process accounting paused\n");
 		}
 	} else {
 		if (act > 0) {
 			acct->active = 1;
-			printk(KERN_INFO "Process accounting resumed\n");
+			pr_info("Process accounting resumed\n");
 		}
 	}
 
@@ -261,6 +261,7 @@ SYSCALL_DEFINE1(acct, const char __user
 
 	if (name) {
 		struct filename *tmp = getname(name);
+
 		if (IS_ERR(tmp))
 			return PTR_ERR(tmp);
 		error = acct_on(tmp);
@@ -376,7 +377,7 @@ static comp_t encode_comp_t(unsigned lon
 	return exp;
 }
 
-#if ACCT_VERSION==1 || ACCT_VERSION==2
+#if ACCT_VERSION == 1 || ACCT_VERSION == 2
 /*
  * encode an u64 into a comp2_t (24 bits)
  *
@@ -389,7 +390,7 @@ static comp_t encode_comp_t(unsigned lon
 #define MANTSIZE2       20                      /* 20 bit mantissa. */
 #define EXPSIZE2        5                       /* 5 bit base 2 exponent. */
 #define MAXFRACT2       ((1ul << MANTSIZE2) - 1) /* Maximum fractional value. */
-#define MAXEXP2         ((1 <<EXPSIZE2) - 1)    /* Maximum exponent. */
+#define MAXEXP2         ((1 << EXPSIZE2) - 1)    /* Maximum exponent. */
 
 static comp2_t encode_comp2_t(u64 value)
 {
@@ -420,7 +421,7 @@ static comp2_t encode_comp2_t(u64 value)
 }
 #endif
 
-#if ACCT_VERSION==3
+#if ACCT_VERSION == 3
 /*
  * encode an u64 into a 32 bit IEEE float
  */
@@ -429,8 +430,9 @@ static u32 encode_float(u64 value)
 	unsigned exp = 190;
 	unsigned u;
 
-	if (value==0) return 0;
-	while ((s64)value > 0){
+	if (value == 0)
+		return 0;
+	while ((s64)value > 0) {
 		value <<= 1;
 		exp--;
 	}
@@ -490,16 +492,17 @@ static void do_acct_process(struct bsd_a
 		       + current->group_leader->start_time.tv_nsec;
 	/* convert nsec -> AHZ */
 	elapsed = nsec_to_AHZ(run_time);
-#if ACCT_VERSION==3
+#if ACCT_VERSION == 3
 	ac.ac_etime = encode_float(elapsed);
 #else
 	ac.ac_etime = encode_comp_t(elapsed < (unsigned long) -1l ?
-	                       (unsigned long) elapsed : (unsigned long) -1l);
+				(unsigned long) elapsed : (unsigned long) -1l);
 #endif
-#if ACCT_VERSION==1 || ACCT_VERSION==2
+#if ACCT_VERSION == 1 || ACCT_VERSION == 2
 	{
 		/* new enlarged etime field */
 		comp2_t etime = encode_comp2_t(elapsed);
+
 		ac.ac_etime_hi = etime >> 16;
 		ac.ac_etime_lo = (u16) etime;
 	}
@@ -509,15 +512,15 @@ static void do_acct_process(struct bsd_a
 	/* we really need to bite the bullet and change layout */
 	ac.ac_uid = from_kuid_munged(file->f_cred->user_ns, orig_cred->uid);
 	ac.ac_gid = from_kgid_munged(file->f_cred->user_ns, orig_cred->gid);
-#if ACCT_VERSION==2
+#if ACCT_VERSION == 2
 	ac.ac_ahz = AHZ;
 #endif
-#if ACCT_VERSION==1 || ACCT_VERSION==2
+#if ACCT_VERSION == 1 || ACCT_VERSION == 2
 	/* backward-compatible 16 bit fields */
 	ac.ac_uid16 = ac.ac_uid;
 	ac.ac_gid16 = ac.ac_gid;
 #endif
-#if ACCT_VERSION==3
+#if ACCT_VERSION == 3
 	ac.ac_pid = task_tgid_nr_ns(current, ns);
 	rcu_read_lock();
 	ac.ac_ppid = task_tgid_nr_ns(rcu_dereference(current->real_parent), ns);
@@ -578,6 +581,7 @@ void acct_collect(long exitcode, int gro
 
 	if (group_dead && current->mm) {
 		struct vm_area_struct *vma;
+
 		down_read(&current->mm->mmap_sem);
 		vma = current->mm->mmap;
 		while (vma) {
_

Patches currently in -mm which might be from ionut.m.alexa@gmail.com are

kernel-acct-fix-coding-style-warnings-and-errors.patch
kernel-exit-fix-coding-style-warnings-and-errors.patch

