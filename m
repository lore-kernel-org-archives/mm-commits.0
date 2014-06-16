From: akpm@linux-foundation.org
Subject: +
 tmpfs-zero_range-and-collapse_range-not-currently-supported.patch added to
 -mm tree
Date: Mon, 16 Jun 2014 16:44:07 -0700
Message-ID: <539f8147.ADGWOh+rt34QY43S%akpm__32173.4177334749$1402962272$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46856 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752623AbaFPXoI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 16 Jun 2014 19:44:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, stable@vger.kernel.org, hughd@google.com


The patch titled
     Subject: tmpfs: ZERO_RANGE and COLLAPSE_RANGE not currently supported
has been added to the -mm tree.  Its filename is
     tmpfs-zero_range-and-collapse_range-not-currently-supported.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/tmpfs-zero_range-and-collapse_range-not-currently-supported.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/tmpfs-zero_range-and-collapse_range-not-currently-supported.patch

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
Subject: tmpfs: ZERO_RANGE and COLLAPSE_RANGE not currently supported

I was well aware of FALLOC_FL_ZERO_RANGE and FALLOC_FL_COLLAPSE_RANGE
support being added to fallocate(); but didn't realize until now that I
had been too stupid to future-proof shmem_fallocate() against new
additions.  -EOPNOTSUPP instead of going on to ordinary fallocation.

Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: <stable@vger.kernel.org>	[3.15]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN mm/shmem.c~tmpfs-zero_range-and-collapse_range-not-currently-supported mm/shmem.c
--- a/mm/shmem.c~tmpfs-zero_range-and-collapse_range-not-currently-supported
+++ a/mm/shmem.c
@@ -1724,6 +1724,9 @@ static long shmem_fallocate(struct file
 	pgoff_t start, index, end;
 	int error;
 
+	if (mode & ~(FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE))
+		return -EOPNOTSUPP;
+
 	mutex_lock(&inode->i_mutex);
 
 	if (mode & FALLOC_FL_PUNCH_HOLE) {
_

Patches currently in -mm which might be from hughd@google.com are

tmpfs-zero_range-and-collapse_range-not-currently-supported.patch
mm-memoryc-use-entry-=-access_oncepte-in-handle_pte_fault.patch
list-use-argument-hlist_add_after-names-from-rcu-variant.patch
list-fix-order-of-arguments-for-hlist_add_after_rcu.patch
klist-use-same-naming-scheme-as-hlist-for-klist_add_after.patch
mm-replace-remap_file_pages-syscall-with-emulation-fix-3.patch

