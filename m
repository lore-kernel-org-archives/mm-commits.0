From: akpm@linux-foundation.org
Subject: + powerpc-add-scaled-time-accounting-speedup.patch added to -mm tree
Date: Mon, 01 Oct 2007 15:36:53 -0700
Message-ID: <200710012236.l91MarFE006792@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51781 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751817AbXJAWhP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 1 Oct 2007 18:37:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: pbadari@us.ibm.com, balbir@in.ibm.com, benh@kernel.crashing.org, jlan@engr.sgi.com, mikey@neuling.org, paulus@samba.org


The patch titled
     Avoid unnecessary PURR reading
has been added to the -mm tree.  Its filename is
     powerpc-add-scaled-time-accounting-speedup.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Avoid unnecessary PURR reading
From: Badari Pulavarty <pbadari@us.ibm.com>

Avoid reading PURR multiple times, by passing it in to read_spurr().

Signed-off-by: Badari Pulavarty <pbadari@us.ibm.com>
Cc: Michael Neuling <mikey@neuling.org>
Cc: Balbir Singh <balbir@in.ibm.com>
Cc: Jay Lan <jlan@engr.sgi.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN arch/powerpc/kernel/time.c~powerpc-add-scaled-time-accounting-speedup arch/powerpc/kernel/time.c
--- a/arch/powerpc/kernel/time.c~powerpc-add-scaled-time-accounting-speedup
+++ a/arch/powerpc/kernel/time.c
@@ -169,11 +169,11 @@ static u64 read_purr(void)
 /*
  * Read the SPURR on systems that have it, otherwise the purr
  */
-static u64 read_spurr(void)
+static u64 read_spurr(u64 purr)
 {
 	if (cpu_has_feature(CPU_FTR_SPURR))
 		return mfspr(SPRN_SPURR);
-	return read_purr();
+	return purr;
 }
 
 /*
@@ -189,7 +189,7 @@ void account_system_vtime(struct task_st
 	now = read_purr();
 	delta = now - get_paca()->startpurr;
 	get_paca()->startpurr = now;
-	nowscaled = read_spurr();
+	nowscaled = read_spurr(now);
 	deltascaled = nowscaled - get_paca()->startspurr;
 	get_paca()->startspurr = nowscaled;
 	if (!in_interrupt()) {
_

Patches currently in -mm which might be from pbadari@us.ibm.com are

x86_64-mm-vdso-text-offset.patch
ppc64-sparsemem_vmemmap-support-vmemmap-ppc64-convert-vmm_-macros-to-a-real-function-fix.patch
ext3-convert-to-new-aops.patch
ext4-convert-to-new-aops.patch
memory-unplug-v7-memory-hotplug-cleanup-fix.patch
hugetlbfs-read-support.patch
hugetlbfs-read-support-fix.patch
ext2-statfs-improvement-for-block-and-inode-free-count.patch
aio-account-i-o-wait-time-properly.patch
fix-for-ext2-reservation.patch
sysctl-remove-the-binary-interface-for-aio-nr-aio-max-nr-acpi_video_flags.patch
mem-controller-gfp-mask-fix.patch
powerpc-add-scaled-time-accounting-speedup.patch
