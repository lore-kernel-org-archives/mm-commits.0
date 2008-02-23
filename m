From: akpm@linux-foundation.org
Subject: + nommu-is_vmalloc_addr-wont-compile-if-mmu.patch added to -mm tree
Date: Fri, 22 Feb 2008 23:28:38 -0800
Message-ID: <200802230729.m1N7TRkp017901@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:50927 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753601AbYBWHaV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 23 Feb 2008 02:30:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dhowells@redhat.com, clameter@sgi.com, gerg@snapgear.com


The patch titled
     NOMMU: is_vmalloc_addr() won't compile if !MMU
has been added to the -mm tree.  Its filename is
     nommu-is_vmalloc_addr-wont-compile-if-mmu.patch

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
Subject: NOMMU: is_vmalloc_addr() won't compile if !MMU
From: David Howells <dhowells@redhat.com>

Make is_vmalloc_addr() contingent on CONFIG_MMU=y, as it won't compile in !MMU
mode (commit 9e2779fa281cfda13ac060753d674bbcaa23367e).

Signed-off-by: David Howells <dhowells@redhat.com>
Cc: Greg Ungerer <gerg@snapgear.com>
Cc: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    2 ++
 1 file changed, 2 insertions(+)

diff -puN include/linux/mm.h~nommu-is_vmalloc_addr-wont-compile-if-mmu include/linux/mm.h
--- a/include/linux/mm.h~nommu-is_vmalloc_addr-wont-compile-if-mmu
+++ a/include/linux/mm.h
@@ -235,6 +235,7 @@ static inline int get_page_unless_zero(s
 struct page *vmalloc_to_page(const void *addr);
 unsigned long vmalloc_to_pfn(const void *addr);
 
+#ifdef CONFIG_MMU
 /* Determine if an address is within the vmalloc range */
 static inline int is_vmalloc_addr(const void *x)
 {
@@ -242,6 +243,7 @@ static inline int is_vmalloc_addr(const 
 
 	return addr >= VMALLOC_START && addr < VMALLOC_END;
 }
+#endif
 
 static inline struct page *compound_head(struct page *page)
 {
_

Patches currently in -mm which might be from dhowells@redhat.com are

mn10300-define-hz-as-a-config-option.patch
mn10300-define-so_mark.patch
nommu-is_vmalloc_addr-wont-compile-if-mmu.patch
iget-stop-unionfs-from-using-iget-and-read_inode.patch
ntp-make-the-kernel-ntp-code-hand-64-bit-unsigned-values-to-do_div.patch
keys-increase-the-payload-size-when-instantiating-a-key.patch
keys-check-starting-keyring-as-part-of-search.patch
keys-allow-the-callout-data-to-be-passed-as-a-blob-rather-than-a-string.patch
keys-add-keyctl-function-to-get-a-security-label.patch
procfs-task-exe-symlink.patch
procfs-task-exe-symlink-fix.patch
procfs-task-exe-symlink-fix-2.patch
mutex-subsystem-synchro-test-module.patch
