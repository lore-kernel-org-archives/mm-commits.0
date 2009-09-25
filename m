From: akpm@linux-foundation.org
Subject: [merged] nommu-ignore-mmap-address-param-as-it-is-a-hint.patch removed from -mm tree
Date: Fri, 25 Sep 2009 12:53:41 -0700
Message-ID: <200909251953.n8PJrfU5003462@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56380 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751993AbZIYTx6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Sep 2009 15:53:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dhowells@redhat.com, gerg@snapgear.com, mm-commits@vger.kernel.org


The patch titled
     nommu: ignore mmap() address param as it is a hint
has been removed from the -mm tree.  Its filename was
     nommu-ignore-mmap-address-param-as-it-is-a-hint.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
