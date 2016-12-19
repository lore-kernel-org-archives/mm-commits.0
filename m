From: akpm@linux-foundation.org
Subject: + tmpfs-change-shmem_mapping-to-test-shmem_aops.patch added to
 -mm tree
Date: Mon, 19 Dec 2016 11:48:45 -0800
Message-ID: <5858399d.iDeW/RDhcxQtP0e+%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35570 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753388AbcLSTrq (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 19 Dec 2016 14:47:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hughd@google.com, hannes@cmpxchg.org, kirill.shutemov@linux.intel.com, oleg@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: tmpfs: change shmem_mapping() to test shmem_aops
has been added to the -mm tree.  Its filename is
     tmpfs-change-shmem_mapping-to-test-shmem_aops.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/tmpfs-change-shmem_mapping-to-test-shmem_aops.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/tmpfs-change-shmem_mapping-to-test-shmem_aops.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: tmpfs: change shmem_mapping() to test shmem_aops

Callers of shmem_mapping() are interested in whether the mapping is swap
backed - except for uprobes, which is interested in whether it should use
shmem_read_mapping_page().  All these callers are better served by a
shmem_mapping() which checks for shmem_aops, than the current version
which goes through several indirections to find where the inode lives -
and has the surprising effect that a private mmap of /dev/zero satisfies
both vma_is_anonymous() and shmem_mapping(), when that device node is on
devtmpfs.  I don't think anything in the tree suffers from that surprise,
but it caught me out, and is better fixed.

Link: http://lkml.kernel.org/r/alpine.LSU.2.11.1612052148530.13021@eggly.anvils
Signed-off-by: Hugh Dickins <hughd@google.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff -puN mm/shmem.c~tmpfs-change-shmem_mapping-to-test-shmem_aops mm/shmem.c
--- a/mm/shmem.c~tmpfs-change-shmem_mapping-to-test-shmem_aops
+++ a/mm/shmem.c
@@ -2168,10 +2168,7 @@ static struct inode *shmem_get_inode(str
 
 bool shmem_mapping(struct address_space *mapping)
 {
-	if (!mapping->host)
-		return false;
