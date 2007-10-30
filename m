From: akpm@linux-foundation.org
Subject: + ia64-vmcore_find_descriptor_size-should-be-in-__init.patch added to -mm tree
Date: Tue, 30 Oct 2007 13:12:55 -0700
Message-ID: <200710302012.l9UKCt90025930@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52822 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754220AbXJ3UNG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 30 Oct 2007 16:13:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: horms@verge.net.au, tony.luck@intel.com


The patch titled
     ia64: vmcore_find_descriptor_size should be in __init
has been added to the -mm tree.  Its filename is
     ia64-vmcore_find_descriptor_size-should-be-in-__init.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
ia64-vmcore_find_descriptor_size-should-be-in-__init.patch
