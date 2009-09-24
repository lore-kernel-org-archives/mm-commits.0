From: akpm@linux-foundation.org
Subject: + nommu-ignore-mmap-address-param-as-it-is-a-hint.patch added to -mm tree
Date: Thu, 24 Sep 2009 15:15:39 -0700
Message-ID: <200909242215.n8OMFdFS027317@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48257 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751749AbZIXWQU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Sep 2009 18:16:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dhowells@redhat.com, gerg@snapgear.com


The patch titled
     nommu: ignore mmap() address param as it is a hint
has been added to the -mm tree.  Its filename is
     nommu-ignore-mmap-address-param-as-it-is-a-hint.patch

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
Subject: nommu: ignore mmap() address param as it is a hint
From: David Howells <dhowells@redhat.com>

Ignore the address parameter given to NOMMU mmap() as it is a hint, rather
than giving an error if it's non-zero.  MAP_FIXED still gets an error.

Signed-off-by: David Howells <dhowells@redhat.com>
Cc: Greg Ungerer <gerg@snapgear.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/nommu.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN mm/nommu.c~nommu-ignore-mmap-address-param-as-it-is-a-hint mm/nommu.c
--- a/mm/nommu.c~nommu-ignore-mmap-address-param-as-it-is-a-hint
+++ a/mm/nommu.c
@@ -826,7 +826,7 @@ static int validate_mmap_request(struct 
 	int ret;
 
 	/* do the simple checks first */
-	if (flags & MAP_FIXED || addr) {
+	if (flags & MAP_FIXED) {
 		printk(KERN_DEBUG
 		       "%d: Can't do fixed-address/overlay mmap of RAM\n",
 		       current->pid);
@@ -1182,9 +1182,6 @@ unsigned long do_mmap_pgoff(struct file 
 
 	kenter(",%lx,%lx,%lx,%lx,%lx", addr, len, prot, flags, pgoff);
 
-	if (!(flags & MAP_FIXED))
-		addr = round_hint_to_min(addr);
-
 	/* decide whether we should attempt the mapping, and if so what sort of
 	 * mapping */
 	ret = validate_mmap_request(file, addr, len, prot, flags, pgoff,
@@ -1194,6 +1191,9 @@ unsigned long do_mmap_pgoff(struct file 
 		return ret;
 	}
 
+	/* we ignore the address hint */
+	addr = 0;
+
 	/* we've determined that we can make the mapping, now translate what we
 	 * now know into VMA flags */
 	vm_flags = determine_vm_flags(file, prot, flags, capabilities);
_

Patches currently in -mm which might be from dhowells@redhat.com are

origin.patch
procfs-disable-per-task-stack-usage-on-nommu.patch
hugetlb_file_setup-use-c-not-cpp.patch
nommu-fix-map_private-mmap-of-objects-where-the-data-can-be-mapped-directly.patch
frv-flash-mappings-for-the-mb93090-mb00-motherboard.patch
nommu-fallback-for-is_vmalloc_or_module_addr-should-be-inline.patch
nommu-ignore-mmap-address-param-as-it-is-a-hint.patch
frv-duplicate-output_buffer-of-e03.patch
mutex-subsystem-synchro-test-module.patch

