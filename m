From: akpm@linux-foundation.org
Subject: [merged] sgi-gru-add-definitions-of-ia64-gru-mmrs.patch removed from -mm tree
Date: Mon, 06 Apr 2009 12:37:19 -0700
Message-ID: <200904061937.n36JbJ3h012877@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54125 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752615AbZDFUIn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Apr 2009 16:08:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: steiner@sgi.com, tony.luck@intel.com, mm-commits@vger.kernel.org


The patch titled
     sgi-gru: add definitions of ia64 GRU MMRs
has been removed from the -mm tree.  Its filename was
     sgi-gru-add-definitions-of-ia64-gru-mmrs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sgi-gru: add definitions of ia64 GRU MMRs
From: Jack Steiner <steiner@sgi.com>

Add definitions for IA64 GRU MMRs.

Signed-off-by: Jack Steiner <steiner@sgi.com>
Cc: "Luck, Tony" <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/include/asm/uv/uv_mmrs.h |  158 ++++++++++++++++++++++++++-
 1 file changed, 155 insertions(+), 3 deletions(-)

diff -puN arch/ia64/include/asm/uv/uv_mmrs.h~sgi-gru-add-definitions-of-ia64-gru-mmrs arch/ia64/include/asm/uv/uv_mmrs.h
--- a/arch/ia64/include/asm/uv/uv_mmrs.h~sgi-gru-add-definitions-of-ia64-gru-mmrs
+++ a/arch/ia64/include/asm/uv/uv_mmrs.h
@@ -8,8 +8,8 @@
  * Copyright (C) 2007-2008 Silicon Graphics, Inc. All rights reserved.
  */
 
-#ifndef __ASM_IA64_UV_MMRS__
-#define __ASM_IA64_UV_MMRS__
+#ifndef _ASM_IA64_UV_UV_MMRS_H
+#define _ASM_IA64_UV_UV_MMRS_H
 
 #define UV_MMR_ENABLE		(1UL << 63)
 
@@ -243,6 +243,158 @@ union uvh_event_occurred0_u {
 #define UVH_EVENT_OCCURRED0_ALIAS_32 0x005f0
 
 /* ========================================================================= */
+/*                         UVH_GR0_TLB_INT0_CONFIG                           */
+/* ========================================================================= */
+#define UVH_GR0_TLB_INT0_CONFIG 0x61b00UL
+
+#define UVH_GR0_TLB_INT0_CONFIG_VECTOR_SHFT 0
+#define UVH_GR0_TLB_INT0_CONFIG_VECTOR_MASK 0x00000000000000ffUL
+#define UVH_GR0_TLB_INT0_CONFIG_DM_SHFT 8
+#define UVH_GR0_TLB_INT0_CONFIG_DM_MASK 0x0000000000000700UL
+#define UVH_GR0_TLB_INT0_CONFIG_DESTMODE_SHFT 11
+#define UVH_GR0_TLB_INT0_CONFIG_DESTMODE_MASK 0x0000000000000800UL
+#define UVH_GR0_TLB_INT0_CONFIG_STATUS_SHFT 12
+#define UVH_GR0_TLB_INT0_CONFIG_STATUS_MASK 0x0000000000001000UL
+#define UVH_GR0_TLB_INT0_CONFIG_P_SHFT 13
+#define UVH_GR0_TLB_INT0_CONFIG_P_MASK 0x0000000000002000UL
+#define UVH_GR0_TLB_INT0_CONFIG_T_SHFT 15
+#define UVH_GR0_TLB_INT0_CONFIG_T_MASK 0x0000000000008000UL
+#define UVH_GR0_TLB_INT0_CONFIG_M_SHFT 16
+#define UVH_GR0_TLB_INT0_CONFIG_M_MASK 0x0000000000010000UL
+#define UVH_GR0_TLB_INT0_CONFIG_APIC_ID_SHFT 32
+#define UVH_GR0_TLB_INT0_CONFIG_APIC_ID_MASK 0xffffffff00000000UL
+
+union uvh_gr0_tlb_int0_config_u {
+    unsigned long	v;
+    struct uvh_gr0_tlb_int0_config_s {
+	unsigned long	vector_  :  8;  /* RW */
+	unsigned long	dm       :  3;  /* RW */
+	unsigned long	destmode :  1;  /* RW */
+	unsigned long	status   :  1;  /* RO */
+	unsigned long	p        :  1;  /* RO */
+	unsigned long	rsvd_14  :  1;  /*    */
+	unsigned long	t        :  1;  /* RO */
+	unsigned long	m        :  1;  /* RW */
+	unsigned long	rsvd_17_31: 15;  /*    */
+	unsigned long	apic_id  : 32;  /* RW */
+    } s;
+};
+
+/* ========================================================================= */
+/*                         UVH_GR0_TLB_INT1_CONFIG                           */
+/* ========================================================================= */
+#define UVH_GR0_TLB_INT1_CONFIG 0x61b40UL
+
+#define UVH_GR0_TLB_INT1_CONFIG_VECTOR_SHFT 0
+#define UVH_GR0_TLB_INT1_CONFIG_VECTOR_MASK 0x00000000000000ffUL
+#define UVH_GR0_TLB_INT1_CONFIG_DM_SHFT 8
+#define UVH_GR0_TLB_INT1_CONFIG_DM_MASK 0x0000000000000700UL
+#define UVH_GR0_TLB_INT1_CONFIG_DESTMODE_SHFT 11
+#define UVH_GR0_TLB_INT1_CONFIG_DESTMODE_MASK 0x0000000000000800UL
+#define UVH_GR0_TLB_INT1_CONFIG_STATUS_SHFT 12
+#define UVH_GR0_TLB_INT1_CONFIG_STATUS_MASK 0x0000000000001000UL
+#define UVH_GR0_TLB_INT1_CONFIG_P_SHFT 13
+#define UVH_GR0_TLB_INT1_CONFIG_P_MASK 0x0000000000002000UL
+#define UVH_GR0_TLB_INT1_CONFIG_T_SHFT 15
+#define UVH_GR0_TLB_INT1_CONFIG_T_MASK 0x0000000000008000UL
+#define UVH_GR0_TLB_INT1_CONFIG_M_SHFT 16
+#define UVH_GR0_TLB_INT1_CONFIG_M_MASK 0x0000000000010000UL
+#define UVH_GR0_TLB_INT1_CONFIG_APIC_ID_SHFT 32
+#define UVH_GR0_TLB_INT1_CONFIG_APIC_ID_MASK 0xffffffff00000000UL
+
+union uvh_gr0_tlb_int1_config_u {
+    unsigned long	v;
+    struct uvh_gr0_tlb_int1_config_s {
+	unsigned long	vector_  :  8;  /* RW */
+	unsigned long	dm       :  3;  /* RW */
+	unsigned long	destmode :  1;  /* RW */
+	unsigned long	status   :  1;  /* RO */
+	unsigned long	p        :  1;  /* RO */
+	unsigned long	rsvd_14  :  1;  /*    */
+	unsigned long	t        :  1;  /* RO */
+	unsigned long	m        :  1;  /* RW */
+	unsigned long	rsvd_17_31: 15;  /*    */
+	unsigned long	apic_id  : 32;  /* RW */
+    } s;
+};
+
+/* ========================================================================= */
+/*                         UVH_GR1_TLB_INT0_CONFIG                           */
+/* ========================================================================= */
+#define UVH_GR1_TLB_INT0_CONFIG 0x61f00UL
+
+#define UVH_GR1_TLB_INT0_CONFIG_VECTOR_SHFT 0
+#define UVH_GR1_TLB_INT0_CONFIG_VECTOR_MASK 0x00000000000000ffUL
+#define UVH_GR1_TLB_INT0_CONFIG_DM_SHFT 8
+#define UVH_GR1_TLB_INT0_CONFIG_DM_MASK 0x0000000000000700UL
+#define UVH_GR1_TLB_INT0_CONFIG_DESTMODE_SHFT 11
+#define UVH_GR1_TLB_INT0_CONFIG_DESTMODE_MASK 0x0000000000000800UL
+#define UVH_GR1_TLB_INT0_CONFIG_STATUS_SHFT 12
+#define UVH_GR1_TLB_INT0_CONFIG_STATUS_MASK 0x0000000000001000UL
+#define UVH_GR1_TLB_INT0_CONFIG_P_SHFT 13
+#define UVH_GR1_TLB_INT0_CONFIG_P_MASK 0x0000000000002000UL
+#define UVH_GR1_TLB_INT0_CONFIG_T_SHFT 15
+#define UVH_GR1_TLB_INT0_CONFIG_T_MASK 0x0000000000008000UL
+#define UVH_GR1_TLB_INT0_CONFIG_M_SHFT 16
+#define UVH_GR1_TLB_INT0_CONFIG_M_MASK 0x0000000000010000UL
+#define UVH_GR1_TLB_INT0_CONFIG_APIC_ID_SHFT 32
+#define UVH_GR1_TLB_INT0_CONFIG_APIC_ID_MASK 0xffffffff00000000UL
+
+union uvh_gr1_tlb_int0_config_u {
+    unsigned long	v;
+    struct uvh_gr1_tlb_int0_config_s {
+	unsigned long	vector_  :  8;  /* RW */
+	unsigned long	dm       :  3;  /* RW */
+	unsigned long	destmode :  1;  /* RW */
+	unsigned long	status   :  1;  /* RO */
+	unsigned long	p        :  1;  /* RO */
+	unsigned long	rsvd_14  :  1;  /*    */
+	unsigned long	t        :  1;  /* RO */
+	unsigned long	m        :  1;  /* RW */
+	unsigned long	rsvd_17_31: 15;  /*    */
+	unsigned long	apic_id  : 32;  /* RW */
+    } s;
+};
+
+/* ========================================================================= */
+/*                         UVH_GR1_TLB_INT1_CONFIG                           */
+/* ========================================================================= */
+#define UVH_GR1_TLB_INT1_CONFIG 0x61f40UL
+
+#define UVH_GR1_TLB_INT1_CONFIG_VECTOR_SHFT 0
+#define UVH_GR1_TLB_INT1_CONFIG_VECTOR_MASK 0x00000000000000ffUL
+#define UVH_GR1_TLB_INT1_CONFIG_DM_SHFT 8
+#define UVH_GR1_TLB_INT1_CONFIG_DM_MASK 0x0000000000000700UL
+#define UVH_GR1_TLB_INT1_CONFIG_DESTMODE_SHFT 11
+#define UVH_GR1_TLB_INT1_CONFIG_DESTMODE_MASK 0x0000000000000800UL
+#define UVH_GR1_TLB_INT1_CONFIG_STATUS_SHFT 12
+#define UVH_GR1_TLB_INT1_CONFIG_STATUS_MASK 0x0000000000001000UL
+#define UVH_GR1_TLB_INT1_CONFIG_P_SHFT 13
+#define UVH_GR1_TLB_INT1_CONFIG_P_MASK 0x0000000000002000UL
+#define UVH_GR1_TLB_INT1_CONFIG_T_SHFT 15
+#define UVH_GR1_TLB_INT1_CONFIG_T_MASK 0x0000000000008000UL
+#define UVH_GR1_TLB_INT1_CONFIG_M_SHFT 16
+#define UVH_GR1_TLB_INT1_CONFIG_M_MASK 0x0000000000010000UL
+#define UVH_GR1_TLB_INT1_CONFIG_APIC_ID_SHFT 32
+#define UVH_GR1_TLB_INT1_CONFIG_APIC_ID_MASK 0xffffffff00000000UL
+
+union uvh_gr1_tlb_int1_config_u {
+    unsigned long	v;
+    struct uvh_gr1_tlb_int1_config_s {
+	unsigned long	vector_  :  8;  /* RW */
+	unsigned long	dm       :  3;  /* RW */
+	unsigned long	destmode :  1;  /* RW */
+	unsigned long	status   :  1;  /* RO */
+	unsigned long	p        :  1;  /* RO */
+	unsigned long	rsvd_14  :  1;  /*    */
+	unsigned long	t        :  1;  /* RO */
+	unsigned long	m        :  1;  /* RW */
+	unsigned long	rsvd_17_31: 15;  /*    */
+	unsigned long	apic_id  : 32;  /* RW */
+    } s;
+};
+
+/* ========================================================================= */
 /*                               UVH_INT_CMPB                                */
 /* ========================================================================= */
 #define UVH_INT_CMPB 0x22080UL
@@ -670,4 +822,4 @@ union uvh_si_alias2_overlay_config_u {
 };
 
 
-#endif /* __ASM_IA64_UV_MMRS__ */
+#endif /* _ASM_IA64_UV_UV_MMRS_H */
_

Patches currently in -mm which might be from steiner@sgi.com are

origin.patch

