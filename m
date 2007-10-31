From: akpm@linux-foundation.org
Subject: - ia64-vmcore_find_descriptor_size-should-be-in-__init.patch removed from -mm tree
Date: Wed, 31 Oct 2007 16:21:49 -0700
Message-ID: <200710312321.l9VNLnWr001903@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56885 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752904AbXJaXW0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 31 Oct 2007 19:22:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: horms@verge.net.au, tony.luck@intel.com, mm-commits@vger.kernel.org


The patch titled
     ia64: vmcore_find_descriptor_size should be in __init
has been removed from the -mm tree.  Its filename was
     ia64-vmcore_find_descriptor_size-should-be-in-__init.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ia64: vmcore_find_descriptor_size should be in __init
From: Simon Horman <horms@verge.net.au>

vmcore_find_descriptor_size() is only called by reserve_elfcorehdr(), which
is in __init, so it seems to me that vmcore_find_descriptor_size() should
be there too.

Signed-off-by: Simon Horman <horms@verge.net.au>
Cc: "Luck, Tony" <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/kernel/efi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/ia64/kernel/efi.c~ia64-vmcore_find_descriptor_size-should-be-in-__init arch/ia64/kernel/efi.c
--- a/arch/ia64/kernel/efi.c~ia64-vmcore_find_descriptor_size-should-be-in-__init
+++ a/arch/ia64/kernel/efi.c
@@ -1231,7 +1231,7 @@ kdump_find_rsvd_region (unsigned long si
 
 #ifdef CONFIG_PROC_VMCORE
 /* locate the size find a the descriptor at a certain address */
-unsigned long
+unsigned long __init
 vmcore_find_descriptor_size (unsigned long address)
 {
 	void *efi_map_start, *efi_map_end, *p;
_

Patches currently in -mm which might be from horms@verge.net.au are

origin.patch
