From: akpm@linux-foundation.org
Subject: + sgi-gru-add-definitions-of-ia64-gru-mmrs.patch added to -mm tree
Date: Tue, 27 Jan 2009 16:24:51 -0800
Message-ID: <200901280024.n0S0OpuZ004494@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59673 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751292AbZA1AY4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 Jan 2009 19:24:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: steiner@sgi.com, tony.luck@intel.com


The patch titled
     sgi-gru: add definitions of ia64 GRU MMRs
has been added to the -mm tree.  Its filename is
     sgi-gru-add-definitions-of-ia64-gru-mmrs.patch

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

sgi-gru-add-definitions-of-x86_64-gru-mmrs.patch
sgi-gru-add-definitions-of-ia64-gru-mmrs.patch
sgi-gru-add-macros-for-using-the-uv-hub-to-send-interrupts.patch
sgi-gru-misc-gru-cleanup.patch
sgi-gru-improvements-to-gru-debug-messages-statistics.patch
sgi-gru-change-gru-cch-commands-from-inline-functions-to-outofline-functions.patch
sgi-gru-add-statistics-to-the-gru-context-management-functions.patch
sgi-gru-add-support-for-a-user-to-explicitly-unload-a-gru-context.patch
sgi-gru-asid-context-management-bug-fixes.patch
sgi-gru-restructure-the-gru-vtop-functions.patch
sgi-gru-add-support-to-the-gru-driver-for-message-queue-interrupts.patch
sgi-gru-macro-for-scanning-all-gru-chiplets.patch
sgi-gru-fix-bugs-related-to-module-unload-of-the-gru-driver.patch
sgi-gru-support-multiple-pagesizes-in-gru.patch

