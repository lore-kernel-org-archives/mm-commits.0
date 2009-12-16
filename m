From: akpm@linux-foundation.org
Subject: [merged] gru-function-to-generate-chipset-ipi-values.patch removed from -mm tree
Date: Wed, 16 Dec 2009 12:41:15 -0800
Message-ID: <200912162041.nBGKfFqx013721@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60453 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965029AbZLPUlS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 16 Dec 2009 15:41:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: steiner@sgi.com, mm-commits@vger.kernel.org


The patch titled
     gru: function to generate chipset IPI values
has been removed from the -mm tree.  Its filename was
     gru-function-to-generate-chipset-ipi-values.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: gru: function to generate chipset IPI values
From: Jack Steiner <steiner@sgi.com>

Create a function to generate the value that is written to the UV hub MMR
to cause an IPI interrupt to be sent.  The function will be used in the
GRU message queue error recovery code that sends IPIs to nodes in remote
partitions.

Signed-off-by: Jack Steiner <steiner@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/uv/uv_hub.h |   24 ++++++++++++++++++++----
 1 file changed, 20 insertions(+), 4 deletions(-)

diff -puN arch/x86/include/asm/uv/uv_hub.h~gru-function-to-generate-chipset-ipi-values arch/x86/include/asm/uv/uv_hub.h
--- a/arch/x86/include/asm/uv/uv_hub.h~gru-function-to-generate-chipset-ipi-values
+++ a/arch/x86/include/asm/uv/uv_hub.h
@@ -172,6 +172,8 @@ DECLARE_PER_CPU(struct uv_hub_info_s, __
 #define UV_LOCAL_MMR_SIZE		(64UL * 1024 * 1024)
 #define UV_GLOBAL_MMR32_SIZE		(64UL * 1024 * 1024)
 
+#define UV_GLOBAL_GRU_MMR_BASE		0x4000000
+
 #define UV_GLOBAL_MMR32_PNODE_SHIFT	15
 #define UV_GLOBAL_MMR64_PNODE_SHIFT	26
 
@@ -328,6 +330,15 @@ static inline unsigned long uv_read_glob
 }
 
 /*
+ * Global MMR space addresses when referenced by the GRU. (GRU does
+ * NOT use socket addressing).
+ */
+static inline unsigned long uv_global_gru_mmr_address(int pnode, unsigned long offset)
+{
+	return UV_GLOBAL_GRU_MMR_BASE | offset | (pnode << uv_hub_info->m_val);
+}
+
+/*
  * Access hub local MMRs. Faster than using global space but only local MMRs
  * are accessible.
  */
@@ -454,6 +465,14 @@ static inline void uv_set_cpu_scir_bits(
 	}
 }
 
+static unsigned long uv_hub_ipi_value(int apicid, int vector, int mode)
+{
+	return (1UL << UVH_IPI_INT_SEND_SHFT) |
+			((apicid) << UVH_IPI_INT_APIC_ID_SHFT) |
+			(mode << UVH_IPI_INT_DELIVERY_MODE_SHFT) |
+			(vector << UVH_IPI_INT_VECTOR_SHFT);
+}
+
 static inline void uv_hub_send_ipi(int pnode, int apicid, int vector)
 {
 	unsigned long val;
@@ -462,10 +481,7 @@ static inline void uv_hub_send_ipi(int p
 	if (vector == NMI_VECTOR)
 		dmode = dest_NMI;
 
-	val = (1UL << UVH_IPI_INT_SEND_SHFT) |
-			((apicid) << UVH_IPI_INT_APIC_ID_SHFT) |
-			(dmode << UVH_IPI_INT_DELIVERY_MODE_SHFT) |
-			(vector << UVH_IPI_INT_VECTOR_SHFT);
+	val = uv_hub_ipi_value(apicid, vector, dmode);
 	uv_write_global_mmr64(pnode, UVH_IPI_INT, val);
 }
 
_

Patches currently in -mm which might be from steiner@sgi.com are

origin.patch

