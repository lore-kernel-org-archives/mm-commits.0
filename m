From: akpm@linux-foundation.org
Subject: + kdump-use-is_vmcore_usable-and-vmcore_unusable-in-reserve_elfcorehdr.patch added to -mm tree
Date: Tue, 05 Aug 2008 02:59:14 -0700
Message-ID: <200808050959.m759xEBb028901@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53677 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756848AbYHEKA1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Aug 2008 06:00:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: horms@verge.net.au, vgoyal@redhat.com


The patch titled
     kdump: use is_vmcore_usable() and vmcore_unusable() in reserve_elfcorehdr()
has been added to the -mm tree.  Its filename is
     kdump-use-is_vmcore_usable-and-vmcore_unusable-in-reserve_elfcorehdr.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
linux-next.patch
kdump-make-elfcorehdr_addr-independent-of-config_proc_vmcore.patch
kdump-update-elfcorehdr-documentation-to-reflect-supported-architectures.patch
kdump-use-is_kdump_kernel-in-sba_init.patch
kdump-add-is_vmcore_usable-and-vmcore_unusable.patch
kdump-use-is_vmcore_usable-and-vmcore_unusable-in-reserve_elfcorehdr.patch
kdump-ia64-always-reserve-elfcore-header-memory-in-crash-kernel.patch

