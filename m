From: akpm@linux-foundation.org
Subject: [merged]
 mm-doc-cleanup-and-clarify-munmap-behavior-for-hugetlb-memory.patch removed from -mm tree
Date: Thu, 16 Apr 2015 09:52:25 -0700
Message-ID: <552fe8c9.mWK1A4K2ADX7cuRV%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42770 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753223AbbDPQq5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 16 Apr 2015 12:46:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, aarcange@redhat.com, corbet@lwn.net, davidel@xmailserver.org, emunson@akamai.com, hughd@google.com, joern@logfs.org, lcapitulino@redhat.com, mpe@ellerman.id.au, shuahkh@osg.samsung.com, wujianguo@huawei.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, doc: cleanup and clarify munmap behavior for hugetlb memory
has been removed from the -mm tree.  Its filename was
     mm-doc-cleanup-and-clarify-munmap-behavior-for-hugetlb-memory.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: David Rientjes <rientjes@google.com>
Subject: mm, doc: cleanup and clarify munmap behavior for hugetlb memory

munmap(2) of hugetlb memory requires a length that is hugepage aligned,
otherwise it may fail.  Add this to the documentation.

This also cleans up the documentation and separates it into logical units:
one part refers to MAP_HUGETLB and another part refers to requirements for
shared memory segments.

Signed-off-by: David Rientjes <rientjes@google.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Davide Libenzi <davidel@xmailserver.org>
Cc: Luiz Capitulino <lcapitulino@redhat.com>
Cc: Shuah Khan <shuahkh@osg.samsung.com>
Acked-by: Hugh Dickins <hughd@google.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Joern Engel <joern@logfs.org>
Cc: Jianguo Wu <wujianguo@huawei.com>
Cc: Eric B Munson <emunson@akamai.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/vm/hugetlbpage.txt |   24 ++++++++++++++++--------
 1 file changed, 16 insertions(+), 8 deletions(-)

diff -puN Documentation/vm/hugetlbpage.txt~mm-doc-cleanup-and-clarify-munmap-behavior-for-hugetlb-memory Documentation/vm/hugetlbpage.txt
--- a/Documentation/vm/hugetlbpage.txt~mm-doc-cleanup-and-clarify-munmap-behavior-for-hugetlb-memory
+++ a/Documentation/vm/hugetlbpage.txt
@@ -302,15 +302,23 @@ file systems, write system calls are not
 Regular chown, chgrp, and chmod commands (with right permissions) could be
 used to change the file attributes on hugetlbfs.
 
-Also, it is important to note that no such mount command is required if the
+Also, it is important to note that no such mount command is required if
 applications are going to use only shmat/shmget system calls or mmap with
-MAP_HUGETLB.  Users who wish to use hugetlb page via shared memory segment
-should be a member of a supplementary group and system admin needs to
-configure that gid into /proc/sys/vm/hugetlb_shm_group.  It is possible for
-same or different applications to use any combination of mmaps and shm*
-calls, though the mount of filesystem will be required for using mmap calls
-without MAP_HUGETLB.  For an example of how to use mmap with MAP_HUGETLB see
-map_hugetlb.c.
+MAP_HUGETLB.  For an example of how to use mmap with MAP_HUGETLB see map_hugetlb
+below.
+
+Users who wish to use hugetlb memory via shared memory segment should be a
+member of a supplementary group and system admin needs to configure that gid
+into /proc/sys/vm/hugetlb_shm_group.  It is possible for same or different
+applications to use any combination of mmaps and shm* calls, though the mount of
+filesystem will be required for using mmap calls without MAP_HUGETLB.
+
+Syscalls that operate on memory backed by hugetlb pages only have their lengths
+aligned to the native page size of the processor; they will normally fail with
+errno set to EINVAL or exclude hugetlb pages that extend beyond the length if
+not hugepage aligned.  For example, munmap(2) will fail if memory is backed by
+a hugetlb page and the length is smaller than the hugepage size.
+
 
 Examples
 ========
_

Patches currently in -mm which might be from rientjes@google.com are

origin.patch
jbd2-revert-must-not-fail-allocation-loops-back-to-gfp_nofail.patch
slab-infrastructure-for-bulk-object-allocation-and-freeing-v3.patch
slub-bulk-alloc-extract-objects-from-the-per-cpu-slab.patch
slub-bulk-allocation-from-per-cpu-partial-pages.patch
slub-bulk-allocation-from-per-cpu-partial-pages-fix.patch
page-flags-define-behavior-slb-related-flags-on-compound-pages.patch
mm-utilc-add-kstrimdup.patch
linux-next.patch
cxgb4-drop-__gfp_nofail-allocation.patch

