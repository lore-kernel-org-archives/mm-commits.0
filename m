From: akpm@osdl.org
Subject: - reject-corrupt-swapfiles-earlier.patch removed from -mm tree
Date: Thu, 07 Dec 2006 14:57:56 -0800
Message-ID: <200612072257.kB7Mvu97029338@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:50692 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163569AbWLGW6F (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 17:58:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sandeen@redhat.com, hugh@veritas.com, mm-commits@vger.kernel.org


The patch titled
     reject corrupt swapfiles earlier
has been removed from the -mm tree.  Its filename was
     reject-corrupt-swapfiles-earlier.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: reject corrupt swapfiles earlier
From: Eric Sandeen <sandeen@redhat.com>

The fsfuzzer found this; with a corrupt small swapfile that claims to have
many pages:

[root]# file swap.741.img
swap.741.img: Linux/i386 swap file (new style) 1 (4K pages) size 1040191487 pages
[root]# ls -l swap.741.img
-rw-r--r-- 1 root root 16777216 Nov 22 05:18 swap.741.img

sys_swapon() will try to vmalloc all those pages, and -then- check to see if
the file is actually that large:

                if (!(p->swap_map = vmalloc(maxpages * sizeof(short)))) {
<snip>
        if (swapfilesize && maxpages > swapfilesize) {
                printk(KERN_WARNING
                       "Swap area shorter than signature indicates\n");

It seems to me that it would make more sense to move this test up before
the vmalloc, with the other checks, to avoid the OOM-killer in this
situation...

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Cc: Hugh Dickins <hugh@veritas.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 mm/swapfile.c |   11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff -puN mm/swapfile.c~reject-corrupt-swapfiles-earlier mm/swapfile.c
--- a/mm/swapfile.c~reject-corrupt-swapfiles-earlier
+++ a/mm/swapfile.c
@@ -1552,6 +1552,11 @@ asmlinkage long sys_swapon(const char __
 		error = -EINVAL;
 		if (!maxpages)
 			goto bad_swap;
+		if (swapfilesize && maxpages > swapfilesize) {
+			printk(KERN_WARNING
+			       "Swap area shorter than signature indicates\n");
+			goto bad_swap;
+		}
 		if (swap_header->info.nr_badpages && S_ISREG(inode->i_mode))
 			goto bad_swap;
 		if (swap_header->info.nr_badpages > MAX_SWAP_BADPAGES)
@@ -1579,12 +1584,6 @@ asmlinkage long sys_swapon(const char __
 			goto bad_swap;
 	}
 
-	if (swapfilesize && maxpages > swapfilesize) {
-		printk(KERN_WARNING
-		       "Swap area shorter than signature indicates\n");
-		error = -EINVAL;
-		goto bad_swap;
-	}
 	if (nr_good_pages) {
 		p->swap_map[0] = SWAP_MAP_BAD;
 		p->max = maxpages;
_

Patches currently in -mm which might be from sandeen@redhat.com are

origin.patch
ext3-4-dont-do-orphan-processing-on-readonly-devices.patch

