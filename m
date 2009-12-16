From: akpm@linux-foundation.org
Subject: [merged] x86-uv-introduce-uv_gpa_is_mmr.patch removed from -mm tree
Date: Wed, 16 Dec 2009 12:41:45 -0800
Message-ID: <200912162041.nBGKfj6o013842@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46060 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753866AbZLPUmB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 16 Dec 2009 15:42:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: holt@sgi.com, mingo@elte.hu, steiner@sgi.com, mm-commits@vger.kernel.org


The patch titled
     x86: uv: introduce uv_gpa_is_mmr
has been removed from the -mm tree.  Its filename was
     x86-uv-introduce-uv_gpa_is_mmr.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: x86: uv: introduce uv_gpa_is_mmr
From: Robin Holt <holt@sgi.com>

Provide a mechanism for determining if a global physical address is
pointing to a UV hub MMR.

Signed-off-by: Robin Holt <holt@sgi.com>
Cc: Jack Steiner <steiner@sgi.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/uv/uv_hub.h |    7 +++++++
 1 file changed, 7 insertions(+)

diff -puN arch/x86/include/asm/uv/uv_hub.h~x86-uv-introduce-uv_gpa_is_mmr arch/x86/include/asm/uv/uv_hub.h
--- a/arch/x86/include/asm/uv/uv_hub.h~x86-uv-introduce-uv_gpa_is_mmr
+++ a/arch/x86/include/asm/uv/uv_hub.h
@@ -232,6 +232,13 @@ static inline unsigned long uv_gpa(void 
 	return uv_soc_phys_ram_to_gpa(__pa(v));
 }
 
+/* Top two bits indicate the requested address is in MMR space.  */
+static inline int
+uv_gpa_in_mmr_space(unsigned long gpa)
+{
+	return (gpa >> 62) == 0x3UL;
+}
+
 /* UV global physical address --> socket phys RAM */
 static inline unsigned long uv_gpa_to_soc_phys_ram(unsigned long gpa)
 {
_

Patches currently in -mm which might be from holt@sgi.com are

origin.patch

