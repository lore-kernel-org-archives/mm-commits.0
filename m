From: akpm@linux-foundation.org
Subject: + intel_cacheinfo-add-cache-descriptors-for-intel-core-i7.patch added to -mm tree
Date: Mon, 02 Feb 2009 23:11:03 -0800
Message-ID: <200902030711.n137B3OZ004520@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40243 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750835AbZBCHLV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 3 Feb 2009 02:11:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: davej@redhat.com


The patch titled
     intel_cacheinfo: add cache descriptors for Intel Core i7
has been added to the -mm tree.  Its filename is
     intel_cacheinfo-add-cache-descriptors-for-intel-core-i7.patch

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
fbmem-copy_from-to_user-with-mutex-held-v3.patch
linux-next.patch
intel_cacheinfo-add-cache-descriptors-for-intel-core-i7.patch
linuxpps-core-support.patch
pps-userland-header-file-for-pps-api.patch
pps-documentation-programs-and-examples.patch
pps-linuxpps-clients-support.patch
ldisc-new-dcd_change-method-for-line-disciplines.patch
pps-parallel-port-clients-support.patch

