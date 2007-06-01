From: akpm@linux-foundation.org
Subject: - x86-fix-oprofile-double-free-was-re-multiple-free-fix.patch removed from -mm tree
Date: Fri, 01 Jun 2007 00:15:54 -0700
Message-ID: <200706010715.l517FrS9004898@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:46067 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755914AbXFAHQK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 1 Jun 2007 03:16:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: acme@redhat.com, ak@suse.de, alan@lxorguk.ukuu.org.uk, cebbert@redhat.com, chrisw@sous-sol.org, davej@redhat.com, mm-commits@vger.kernel.org


The patch titled
     x86-fix-oprofile-double-free-was-re-multiple-free fix
has been removed from the -mm tree.  Its filename was
     x86-fix-oprofile-double-free-was-re-multiple-free-fix.patch

This patch was dropped because it was folded into x86-fix-oprofile-double-free-was-re-multiple-free.patch

------------------------------------------------------
Subject: x86-fix-oprofile-double-free-was-re-multiple-free fix
From: Arnaldo Carvalho de Melo <acme@redhat.com>

The fix for the fix needed a fix: allocate_msrs() was using
for_each_online_cpu(), but nmi_setup uses for_each_possible_cpu(), and in
my test machine, a Dell Poweredge 1950 I have 2 dual core Xeons, which
makes for 4 possible cores, but wait, they are HT capable, so...

[acme@mica linux-2.6.21.3.orig]$ dmesg | grep Allowing
SMP: Allowing 8 CPUs, 4 hotplug CPUs
[acme@mica linux-2.6.21.3.orig]$

We have 8 possible CPUs, but only 4 online, b00m. Fix it by making
allocate_msrs agree with nmi_setup, i.e. make both use
for_each_possible_cpu().

Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Acked-by: Chris Wright <chrisw@sous-sol.org>
Cc: Andi Kleen <ak@suse.de>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Dave Jones <davej@redhat.com>
Cc: Chuck Ebbert <cebbert@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/oprofile/nmi_int.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/i386/oprofile/nmi_int.c~x86-fix-oprofile-double-free-was-re-multiple-free-fix arch/i386/oprofile/nmi_int.c
--- a/arch/i386/oprofile/nmi_int.c~x86-fix-oprofile-double-free-was-re-multiple-free-fix
+++ a/arch/i386/oprofile/nmi_int.c
@@ -154,7 +154,7 @@ static int allocate_msrs(void)
 	size_t counters_size = sizeof(struct op_msr) * model->num_counters;
 
 	int i;
-	for_each_online_cpu(i) {
+	for_each_possible_cpu(i) {
 		cpu_msrs[i].counters = kmalloc(counters_size, GFP_KERNEL);
 		if (!cpu_msrs[i].counters) {
 			success = 0;
_

Patches currently in -mm which might be from acme@redhat.com are

origin.patch
x86-fix-oprofile-double-free-was-re-multiple-free.patch
x86-fix-oprofile-double-free-was-re-multiple-free-fix.patch
