From: akpm@linux-foundation.org
Subject: + userfaultfd-fix-remap-event-with-mremap_dontunmap.patch
 added to -mm tree
Date: Thu, 07 May 2020 16:40:32 -0700
Message-ID: <20200507234032.wxO_WS_dz%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:48668 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726464AbgEGXkd (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 7 May 2020 19:40:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, bgeffon@google.com, joel@joelfernandes.org, kirill.shutemov@linux.intel.com, lokeshgidra@google.com, minchan@kernel.org, mm-commits@vger.kernel.org, mst@redhat.com, sonnyrao@google.com, vbabka@suse.cz


The patch titled
     Subject: userfaultfd: fix remap event with MREMAP_DONTUNMAP.
has been added to the -mm tree.  Its filename is
     userfaultfd-fix-remap-event-with-mremap_dontunmap.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/userfaultfd-fix-remap-event-with-mremap_dontunmap.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/userfaultfd-fix-remap-event-with-mremap_dontunmap.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Brian Geffon <bgeffon@google.com>
Subject: userfaultfd: fix remap event with MREMAP_DONTUNMAP.

A user is not required to set a new address when using MREMAP_DONTUNMAP as
it can be used without MREMAP_FIXED.  When doing so the remap event will
use new_addr which may not have been set and we didn't propagate it back
other then in the return value of remap_to.

Because ret is always the new address it's probably more correct to use it
rather than new_addr on the remap_event_complete call, and it resolves
this bug.

Link: http://lkml.kernel.org/r/20200506172158.218366-1-bgeffon@google.com
Fixes: e346b3813067d4b ("mm/mremap: add MREMAP_DONTUNMAP to mremap()")
Signed-off-by: Brian Geffon <bgeffon@google.com>
Cc: Lokesh Gidra <lokeshgidra@google.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: "Michael S . Tsirkin" <mst@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Sonny Rao <sonnyrao@google.com>
Cc: Joel Fernandes <joel@joelfernandes.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mremap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/mremap.c~userfaultfd-fix-remap-event-with-mremap_dontunmap
+++ a/mm/mremap.c
@@ -794,7 +794,7 @@ out:
 	if (locked && new_len > old_len)
 		mm_populate(new_addr + old_len, new_len - old_len);
 	userfaultfd_unmap_complete(mm, &uf_unmap_early);
-	mremap_userfaultfd_complete(&uf, addr, new_addr, old_len);
+	mremap_userfaultfd_complete(&uf, addr, ret, old_len);
 	userfaultfd_unmap_complete(mm, &uf_unmap);
 	return ret;
 }
_

Patches currently in -mm which might be from bgeffon@google.com are

userfaultfd-fix-remap-event-with-mremap_dontunmap.patch
