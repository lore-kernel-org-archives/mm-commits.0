From: akpm@linux-foundation.org
Subject: + kernel-cpuc-export-__cpu__mask.patch added to -mm tree
Date: Mon, 23 Nov 2015 15:56:25 -0800
Message-ID: <5653a7a9.A5JuGeOIlyEdleFf%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57161 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751700AbbKWX40 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 Nov 2015 18:56:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@rasmusvillemoes.dk, gregkh@linuxfoundation.org, mpe@ellerman.id.au, rusty@rustcorp.com.au, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/cpu.c: export __cpu_*_mask
has been added to the -mm tree.  Its filename is
     kernel-cpuc-export-__cpu__mask.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kernel-cpuc-export-__cpu__mask.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kernel-cpuc-export-__cpu__mask.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: kernel/cpu.c: export __cpu_*_mask

Exporting the cpumasks __cpu_possible_mask and friends will allow us to
remove the extra indirection through the cpu_*_mask variables.  It will
also allow the set_cpu_* functions to become static inlines, which will
give a .text reduction.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Acked-by: Rusty Russell <rusty@rustcorp.com.au>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/cpumask.h |    4 ++++
 kernel/cpu.c            |   14 +++++++++-----
 2 files changed, 13 insertions(+), 5 deletions(-)

diff -puN include/linux/cpumask.h~kernel-cpuc-export-__cpu__mask include/linux/cpumask.h
--- a/include/linux/cpumask.h~kernel-cpuc-export-__cpu__mask
+++ a/include/linux/cpumask.h
@@ -89,6 +89,10 @@ extern const struct cpumask *const cpu_p
 extern const struct cpumask *const cpu_online_mask;
 extern const struct cpumask *const cpu_present_mask;
 extern const struct cpumask *const cpu_active_mask;
+extern struct cpumask __cpu_possible_mask;
+extern struct cpumask __cpu_online_mask;
+extern struct cpumask __cpu_present_mask;
+extern struct cpumask __cpu_active_mask;
 
 #if NR_CPUS > 1
 #define num_online_cpus()	cpumask_weight(cpu_online_mask)
diff -puN kernel/cpu.c~kernel-cpuc-export-__cpu__mask kernel/cpu.c
--- a/kernel/cpu.c~kernel-cpuc-export-__cpu__mask
+++ a/kernel/cpu.c
@@ -759,23 +759,27 @@ const DECLARE_BITMAP(cpu_all_bits, NR_CP
 EXPORT_SYMBOL(cpu_all_bits);
 
 #ifdef CONFIG_INIT_ALL_POSSIBLE
-static struct cpumask __cpu_possible_mask __read_mostly
+struct cpumask __cpu_possible_mask __read_mostly
 	= {CPU_BITS_ALL};
 #else
-static struct cpumask __cpu_possible_mask __read_mostly;
+struct cpumask __cpu_possible_mask __read_mostly;
 #endif
+EXPORT_SYMBOL(__cpu_possible_mask);
 const struct cpumask *const cpu_possible_mask = &__cpu_possible_mask;
 EXPORT_SYMBOL(cpu_possible_mask);
 
-static struct cpumask __cpu_online_mask __read_mostly;
+struct cpumask __cpu_online_mask __read_mostly;
+EXPORT_SYMBOL(__cpu_online_mask);
 const struct cpumask *const cpu_online_mask = &__cpu_online_mask;
 EXPORT_SYMBOL(cpu_online_mask);
 
-static struct cpumask __cpu_present_mask __read_mostly;
+struct cpumask __cpu_present_mask __read_mostly;
+EXPORT_SYMBOL(__cpu_present_mask);
 const struct cpumask *const cpu_present_mask = &__cpu_present_mask;
 EXPORT_SYMBOL(cpu_present_mask);
 
-static struct cpumask __cpu_active_mask __read_mostly;
+struct cpumask __cpu_active_mask __read_mostly;
+EXPORT_SYMBOL(__cpu_active_mask);
 const struct cpumask *const cpu_active_mask = &__cpu_active_mask;
 EXPORT_SYMBOL(cpu_active_mask);
 
_

Patches currently in -mm which might be from linux@rasmusvillemoes.dk are

powerpc-fadump-rename-cpu_online_mask-member-of-struct-fadump_crash_info_header.patch
kernel-cpuc-change-type-of-cpu_possible_bits-and-friends.patch
kernel-cpuc-export-__cpu__mask.patch
drivers-base-cpuc-use-__cpu__mask-directly.patch
kernel-cpuc-eliminate-cpu__mask.patch
kernel-cpuc-make-set_cpu_-static-inlines.patch

