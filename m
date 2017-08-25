From: akpm@linux-foundation.org
Subject: + cpumask-make-cpumask_next-out-of-line.patch added to -mm tree
Date: Fri, 25 Aug 2017 13:05:17 -0700
Message-ID: <59a082fd.pX+d1GoYfpIjvlRb%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46174 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932644AbdHYUFS (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 25 Aug 2017 16:05:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: cpumask: make cpumask_next() out-of-line
has been added to the -mm tree.  Its filename is
     cpumask-make-cpumask_next-out-of-line.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/cpumask-make-cpumask_next-out-of-line.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/cpumask-make-cpumask_next-out-of-line.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: cpumask: make cpumask_next() out-of-line

Every for_each_XXX_cpu() invocation calls cpumask_next() which is an
inline function:

	static inline unsigned int cpumask_next(int n, const struct cpumask *srcp)
	{
	        /* -1 is a legal arg here. */
	        if (n != -1)
	                cpumask_check(n);
	        return find_next_bit(cpumask_bits(srcp), nr_cpumask_bits, n + 1);
	}

However!

find_next_bit() is regular out-of-line function which means "nr_cpu_ids"
load and increment happen at the caller resulting in a lot of bloat

x86_64 defconfig:
	add/remove: 3/0 grow/shrink: 8/373 up/down: 155/-5668 (-5513)
x86_64 allyesconfig-ish:
	add/remove: 3/1 grow/shrink: 57/634 up/down: 3515/-28177 (-24662) !!!

Some archs redefine find_next_bit() but it is OK:

	m68k		inline but SMP is not supported
	arm		out-of-line
	unicore32	out-of-line

Function call will happen anyway, so move load and increment into callee.

Link: http://lkml.kernel.org/r/20170824230010.GA1593@avx2
Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/cpumask.h |   15 +--------------
 lib/cpumask.c           |   16 ++++++++++++++++
 2 files changed, 17 insertions(+), 14 deletions(-)

diff -puN include/linux/cpumask.h~cpumask-make-cpumask_next-out-of-line include/linux/cpumask.h
--- a/include/linux/cpumask.h~cpumask-make-cpumask_next-out-of-line
+++ a/include/linux/cpumask.h
@@ -178,20 +178,7 @@ static inline unsigned int cpumask_first
 	return find_first_bit(cpumask_bits(srcp), nr_cpumask_bits);
 }
 
-/**
- * cpumask_next - get the next cpu in a cpumask
- * @n: the cpu prior to the place to search (ie. return will be > @n)
- * @srcp: the cpumask pointer
- *
- * Returns >= nr_cpu_ids if no further cpus set.
- */
-static inline unsigned int cpumask_next(int n, const struct cpumask *srcp)
-{
-	/* -1 is a legal arg here. */
-	if (n != -1)
-		cpumask_check(n);
-	return find_next_bit(cpumask_bits(srcp), nr_cpumask_bits, n+1);
-}
+unsigned int cpumask_next(int n, const struct cpumask *srcp);
 
 /**
  * cpumask_next_zero - get the next unset cpu in a cpumask
diff -puN lib/cpumask.c~cpumask-make-cpumask_next-out-of-line lib/cpumask.c
--- a/lib/cpumask.c~cpumask-make-cpumask_next-out-of-line
+++ a/lib/cpumask.c
@@ -6,6 +6,22 @@
 #include <linux/bootmem.h>
 
 /**
+ * cpumask_next - get the next cpu in a cpumask
+ * @n: the cpu prior to the place to search (ie. return will be > @n)
+ * @srcp: the cpumask pointer
+ *
+ * Returns >= nr_cpu_ids if no further cpus set.
+ */
+unsigned int cpumask_next(int n, const struct cpumask *srcp)
+{
+	/* -1 is a legal arg here. */
+	if (n != -1)
+		cpumask_check(n);
+	return find_next_bit(cpumask_bits(srcp), nr_cpumask_bits, n + 1);
+}
+EXPORT_SYMBOL(cpumask_next);
+
+/**
  * cpumask_next_and - get the next cpu in *src1p & *src2p
  * @n: the cpu prior to the place to search (ie. return will be > @n)
  * @src1p: the first cpumask pointer
_

Patches currently in -mm which might be from adobriyan@gmail.com are

proc-uninline-proc_create.patch
make-nr_cpu_ids-unsigned.patch
seq_file-delete-small-value-optimization.patch
cpumask-make-cpumask_next-out-of-line.patch

