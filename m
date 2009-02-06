From: akpm@linux-foundation.org
Subject: [merged] intel_cacheinfo-add-cache-descriptors-for-intel-core-i7.patch removed from -mm tree
Date: Fri, 06 Feb 2009 11:38:39 -0800
Message-ID: <200902061938.n16Jcdfj012666@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38579 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754083AbZBFTjl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Feb 2009 14:39:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: davej@redhat.com, mm-commits@vger.kernel.org


The patch titled
     intel_cacheinfo: add cache descriptors for Intel Core i7
has been removed from the -mm tree.  Its filename was
     intel_cacheinfo-add-cache-descriptors-for-intel-core-i7.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: intel_cacheinfo: add cache descriptors for Intel Core i7
From: Dave Jones <davej@redhat.com>

Signed-off-by: Dave Jones <davej@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/cpu/intel_cacheinfo.c |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff -puN arch/x86/kernel/cpu/intel_cacheinfo.c~intel_cacheinfo-add-cache-descriptors-for-intel-core-i7 arch/x86/kernel/cpu/intel_cacheinfo.c
--- a/arch/x86/kernel/cpu/intel_cacheinfo.c~intel_cacheinfo-add-cache-descriptors-for-intel-core-i7
+++ a/arch/x86/kernel/cpu/intel_cacheinfo.c
@@ -36,8 +36,11 @@ static struct _cache_table cache_table[]
 {
 	{ 0x06, LVL_1_INST, 8 },	/* 4-way set assoc, 32 byte line size */
 	{ 0x08, LVL_1_INST, 16 },	/* 4-way set assoc, 32 byte line size */
+	{ 0x09, LVL_1_INST, 32 },	/* 4-way set assoc, 64 byte line size */
 	{ 0x0a, LVL_1_DATA, 8 },	/* 2 way set assoc, 32 byte line size */
 	{ 0x0c, LVL_1_DATA, 16 },	/* 4-way set assoc, 32 byte line size */
+	{ 0x0d, LVL_1_DATA, 16 },	/* 4-way set assoc, 64 byte line size */
+	{ 0x21, LVL_2,      256 },	/* 8-way set assoc, 64 byte line size */
 	{ 0x22, LVL_3,      512 },	/* 4-way set assoc, sectored cache, 64 byte line size */
 	{ 0x23, LVL_3,      1024 },	/* 8-way set assoc, sectored cache, 64 byte line size */
 	{ 0x25, LVL_3,      2048 },	/* 8-way set assoc, sectored cache, 64 byte line size */
@@ -85,6 +88,18 @@ static struct _cache_table cache_table[]
 	{ 0x85, LVL_2,    2048 },	/* 8-way set assoc, 32 byte line size */
 	{ 0x86, LVL_2,     512 },	/* 4-way set assoc, 64 byte line size */
 	{ 0x87, LVL_2,    1024 },	/* 8-way set assoc, 64 byte line size */
+	{ 0xd0, LVL_3,     512 },	/* 4-way set assoc, 64 byte line size */
+	{ 0xd1, LVL_3,    1024 },	/* 4-way set assoc, 64 byte line size */
+	{ 0xd2, LVL_3,    2048 },	/* 4-way set assoc, 64 byte line size */
+	{ 0xd6, LVL_3,    1024 },	/* 8-way set assoc, 64 byte line size */
+	{ 0xd7, LVL_3,    2038 },	/* 8-way set assoc, 64 byte line size */
+	{ 0xd8, LVL_3,    4096 },	/* 12-way set assoc, 64 byte line size */
+	{ 0xdc, LVL_3,    2048 },	/* 12-way set assoc, 64 byte line size */
+	{ 0xdd, LVL_3,    4096 },	/* 12-way set assoc, 64 byte line size */
+	{ 0xde, LVL_3,    8192 },	/* 12-way set assoc, 64 byte line size */
+	{ 0xe2, LVL_3,    2048 },	/* 16-way set assoc, 64 byte line size */
+	{ 0xe3, LVL_3,    4096 },	/* 16-way set assoc, 64 byte line size */
+	{ 0xe4, LVL_3,    8192 },	/* 16-way set assoc, 64 byte line size */
 	{ 0x00, 0, 0}
 };
 
_

Patches currently in -mm which might be from davej@redhat.com are

origin.patch
linux-next.patch
arch-x86-kernel-cpu-cpufreq-acpi-cpufreqc-avoid-using-work_on_cpu.patch

