From: akpm@linux-foundation.org
Subject: + drivers-base-cpuc-use-__cpu__mask-directly.patch added to -mm
 tree
Date: Mon, 23 Nov 2015 15:56:27 -0800
Message-ID: <5653a7ab.i5NLIq9EctK5L2EA%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57166 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751700AbbKWX42 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 Nov 2015 18:56:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@rasmusvillemoes.dk, gregkh@linuxfoundation.org, mpe@ellerman.id.au, rusty@rustcorp.com.au, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/base/cpu.c: use __cpu_*_mask directly
has been added to the -mm tree.  Its filename is
     drivers-base-cpuc-use-__cpu__mask-directly.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/drivers-base-cpuc-use-__cpu__mask-directly.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/drivers-base-cpuc-use-__cpu__mask-directly.patch

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
Subject: drivers/base/cpu.c: use __cpu_*_mask directly

The only user of the lvalue-ness of the cpu_*_mask variables is in
drivers/base/cpu.c, and that is mostly a work-around for the fact that not
even const variables can be used in static initialization.  Now that the
underlying struct cpumasks are exposed we can take their address.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Acked-by: Rusty Russell <rusty@rustcorp.com.au>
Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/cpu.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN drivers/base/cpu.c~drivers-base-cpuc-use-__cpu__mask-directly drivers/base/cpu.c
--- a/drivers/base/cpu.c~drivers-base-cpuc-use-__cpu__mask-directly
+++ a/drivers/base/cpu.c
@@ -200,7 +200,7 @@ static const struct attribute_group *hot
 
 struct cpu_attr {
 	struct device_attribute attr;
-	const struct cpumask *const * const map;
+	const struct cpumask *const map;
 };
 
 static ssize_t show_cpus_attr(struct device *dev,
@@ -209,7 +209,7 @@ static ssize_t show_cpus_attr(struct dev
 {
 	struct cpu_attr *ca = container_of(attr, struct cpu_attr, attr);
 
-	return cpumap_print_to_pagebuf(true, buf, *ca->map);
+	return cpumap_print_to_pagebuf(true, buf, ca->map);
 }
 
 #define _CPU_ATTR(name, map) \
@@ -217,9 +217,9 @@ static ssize_t show_cpus_attr(struct dev
 
 /* Keep in sync with cpu_subsys_attrs */
 static struct cpu_attr cpu_attrs[] = {
-	_CPU_ATTR(online, &cpu_online_mask),
-	_CPU_ATTR(possible, &cpu_possible_mask),
-	_CPU_ATTR(present, &cpu_present_mask),
+	_CPU_ATTR(online, &__cpu_online_mask),
+	_CPU_ATTR(possible, &__cpu_possible_mask),
+	_CPU_ATTR(present, &__cpu_present_mask),
 };
 
 /*
_

Patches currently in -mm which might be from linux@rasmusvillemoes.dk are

powerpc-fadump-rename-cpu_online_mask-member-of-struct-fadump_crash_info_header.patch
kernel-cpuc-change-type-of-cpu_possible_bits-and-friends.patch
kernel-cpuc-export-__cpu__mask.patch
drivers-base-cpuc-use-__cpu__mask-directly.patch
kernel-cpuc-eliminate-cpu__mask.patch
kernel-cpuc-make-set_cpu_-static-inlines.patch

