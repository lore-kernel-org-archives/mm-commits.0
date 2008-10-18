From: akpm@linux-foundation.org
Subject: - kdump-use-is_vmcore_usable-and-vmcore_unusable-in-reserve_elfcorehdr.patch removed from -mm tree
Date: Sat, 18 Oct 2008 16:53:18 -0700
Message-ID: <200810182353.m9INrISw002081@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50177 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751867AbYJRXyD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 18 Oct 2008 19:54:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: horms@verge.net.au, vgoyal@redhat.com, mm-commits@vger.kernel.org


The patch titled
     kdump: use is_vmcore_usable() and vmcore_unusable() in reserve_elfcorehdr()
has been removed from the -mm tree.  Its filename was
     kdump-use-is_vmcore_usable-and-vmcore_unusable-in-reserve_elfcorehdr.patch

This patch was dropped because it was folded into kdump-add-is_vmcore_usable-and-vmcore_unusable.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kdump: use is_vmcore_usable() and vmcore_unusable() in reserve_elfcorehdr()
From: Simon Horman <horms@verge.net.au>

After recent changes setting elfcorehdr_addr to ELFCORE_ADDR_MAX will
cause is_kdump_kernel() to return 0 when it should return 1.  Instead use
vmcore_unusable(), which has been added for this purpose.

Signed-off-by: Simon Horman <horms@verge.net.au>
Cc: Vivek Goyal <vgoyal@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/kernel/setup.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN arch/ia64/kernel/setup.c~kdump-use-is_vmcore_usable-and-vmcore_unusable-in-reserve_elfcorehdr arch/ia64/kernel/setup.c
--- a/arch/ia64/kernel/setup.c~kdump-use-is_vmcore_usable-and-vmcore_unusable-in-reserve_elfcorehdr
+++ a/arch/ia64/kernel/setup.c
@@ -509,11 +509,11 @@ int __init reserve_elfcorehdr(unsigned l
 	 * to work properly.
 	 */
 
-	if (elfcorehdr_addr >= ELFCORE_ADDR_MAX)
+	if (!is_vmcore_usable())
 		return -EINVAL;
 
 	if ((length = vmcore_find_descriptor_size(elfcorehdr_addr)) == 0) {
-		elfcorehdr_addr = ELFCORE_ADDR_MAX;
+		vmcore_unusable();
 		return -EINVAL;
 	}
 
_

Patches currently in -mm which might be from horms@verge.net.au are

origin.patch
kdump-make-elfcorehdr_addr-independent-of-config_proc_vmcore.patch
kdump-update-elfcorehdr-documentation-to-reflect-supported-architectures.patch
kdump-use-is_kdump_kernel-in-sba_init.patch
kdump-add-is_vmcore_usable-and-vmcore_unusable.patch
kdump-use-is_vmcore_usable-and-vmcore_unusable-in-reserve_elfcorehdr.patch
kdump-ia64-always-reserve-elfcore-header-memory-in-crash-kernel.patch

