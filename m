From: akpm@linux-foundation.org
Subject: - powerpc-add-scaled-time-accounting-speedup.patch removed from -mm tree
Date: Thu, 18 Oct 2007 01:51:23 -0700
Message-ID: <200710180851.l9I8pNXS002925@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58604 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932643AbXJRIwM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 04:52:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: pbadari@us.ibm.com, balbir@in.ibm.com, benh@kernel.crashing.org, jlan@engr.sgi.com, mikey@neuling.org, paulus@samba.org, mm-commits@vger.kernel.org


The patch titled
     Avoid unnecessary PURR reading
has been removed from the -mm tree.  Its filename was
     powerpc-add-scaled-time-accounting-speedup.patch

This patch was dropped because it was folded into powerpc-add-scaled-time-accounting.patch

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

 arch/powerpc/kernel/time.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN arch/powerpc/kernel/time.c~powerpc-add-scaled-time-accounting-speedup arch/powerpc/kernel/time.c
--- a/arch/powerpc/kernel/time.c~powerpc-add-scaled-time-accounting-speedup
+++ a/arch/powerpc/kernel/time.c
@@ -214,11 +214,11 @@ static u64 read_purr(void)
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
@@ -234,7 +234,7 @@ void account_system_vtime(struct task_st
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

origin.patch
sysctl-remove-the-binary-interface-for-aio-nr-aio-max-nr-acpi_video_flags.patch
powerpc-add-scaled-time-accounting.patch
powerpc-add-scaled-time-accounting-speedup.patch
