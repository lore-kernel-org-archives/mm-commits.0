From: akpm@linux-foundation.org
Subject: + fix-mm-utilckrealloc.patch added to -mm tree
Date: Fri, 26 Oct 2007 15:04:05 -0700
Message-ID: <200710262204.l9QM45l8016837@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60762 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751031AbXJZWEw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 26 Oct 2007 18:04:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bunk@kernel.org, clameter@sgi.com


The patch titled
     fix mm/util.c:krealloc()
has been added to the -mm tree.  Its filename is
     fix-mm-utilckrealloc.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: fix mm/util.c:krealloc()
From: Adrian Bunk <bunk@kernel.org>

Commit ef8b4520bd9f8294ffce9abd6158085bde5dc902 added one NULL check for
"p" in krealloc(), but that doesn't seem to be enough since there
doesn't seem to be any guarantee that memcpy(ret, NULL, 0) works
(spotted by the Coverity checker).

For making it clearer what happens this patch also removes the pointless
min().

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Acked-by: Chriustoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/util.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/util.c~fix-mm-utilckrealloc mm/util.c
--- a/mm/util.c~fix-mm-utilckrealloc
+++ a/mm/util.c
@@ -95,8 +95,8 @@ void *krealloc(const void *p, size_t new
 		return (void *)p;
 
 	ret = kmalloc_track_caller(new_size, flags);
-	if (ret) {
-		memcpy(ret, p, min(new_size, ks));
+	if (ret && p) {
+		memcpy(ret, p, ks);
 		kfree(p);
 	}
 	return ret;
_

Patches currently in -mm which might be from bunk@kernel.org are

origin.patch
ipmi-fix-comparison-in-demangle_device_id.patch
fix-mm-utilckrealloc.patch
git-acpi.patch
git-dvb.patch
git-hwmon.patch
git-nfs-make-nfs_wb_page_priority-static.patch
git-ocfs2.patch
git-sh64.patch
sunrpc-xprtrdma-transportc-fix-use-after-free.patch
fuse-fuse_file_alloc-fix-null-dereferences.patch
make-jbd-journalc__journal_abort_hard-static.patch
memory-controller-add-per-container-lru-and-reclaim-v7.patch
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7.patch
reiser4.patch
