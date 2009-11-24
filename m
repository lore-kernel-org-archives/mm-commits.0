From: akpm@linux-foundation.org
Subject: + x86-uv-introduce-a-means-to-translate-from-gpa-socket_paddr.patch added to -mm tree
Date: Tue, 24 Nov 2009 11:41:31 -0800
Message-ID: <200911241941.nAOJfVwt010230@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36916 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758054AbZKXTsg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 24 Nov 2009 14:48:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: holt@sgi.com, mingo@elte.hu, steiner@sgi.com


The patch titled
     x86: uv: introduce a means to translate from gpa -> socket_paddr
has been added to the -mm tree.  Its filename is
     x86-uv-introduce-a-means-to-translate-from-gpa-socket_paddr.patch

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
Subject: x86: uv: introduce a means to translate from gpa -> socket_paddr
From: Robin Holt <holt@sgi.com>

The UV BIOS has been updated to implement some of our interface
functionality differently than originally expected.  These patches update
the kernel to the bios implementation and include a few minor bug fixes
which prevent us from doing significant testing on real hardware.


This patch:

For SGI UV systems, translate from a global physical address back to a
socket physical address.  This does nothing to ensure the socket physical
address is actually addressable by the kernel.  That is the responsibility
of the user of the function.

Signed-off-by: Robin Holt <holt@sgi.com>
Cc: Jack Steiner <steiner@sgi.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/uv/uv_hub.h |   13 +++++++++++++
 1 file changed, 13 insertions(+)

diff -puN arch/x86/include/asm/uv/uv_hub.h~x86-uv-introduce-a-means-to-translate-from-gpa-socket_paddr arch/x86/include/asm/uv/uv_hub.h
--- a/arch/x86/include/asm/uv/uv_hub.h~x86-uv-introduce-a-means-to-translate-from-gpa-socket_paddr
+++ a/arch/x86/include/asm/uv/uv_hub.h
@@ -232,6 +232,19 @@ static inline unsigned long uv_gpa(void 
 	return uv_soc_phys_ram_to_gpa(__pa(v));
 }
 
+/* UV global physical address --> socket phys RAM */
+static inline unsigned long uv_gpa_to_soc_phys_ram(unsigned long gpa)
+{
+	unsigned long paddr = gpa & uv_hub_info->gpa_mask;
+	unsigned long remap_base = uv_hub_info->lowmem_remap_base;
+	unsigned long remap_top =  uv_hub_info->lowmem_remap_top;
+
+	if (paddr >= remap_base && paddr < remap_base + remap_top)
+		paddr -= remap_base;
+	return paddr;
+}
+
+
 /* gnode -> pnode */
 static inline unsigned long uv_gpa_to_gnode(unsigned long gpa)
 {
_

Patches currently in -mm which might be from holt@sgi.com are

x86-uv-introduce-a-means-to-translate-from-gpa-socket_paddr.patch
x86-uv-xpc-needs-to-provide-an-abstraction-for-uv_gpa.patch
x86-uv-introduce-uv_gpa_is_mmr.patch
x86-uv-implement-a-gru_read_gpa-kernel-function.patch
x86-uv-update-xpc-to-handle-updated-bios-interface.patch
x86-uv-xpc-null-deref-when-mesq-becomes-empty.patch
x86-uv-xpc_make_first_contact-hang-due-to-not-accepting-active-state.patch
x86-uv-xpc-receive-message-reuse-triggers-invalid-bug_on.patch

