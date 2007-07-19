From: akpm@linux-foundation.org
Subject: - document-page_mkwrite-locking.patch removed from -mm tree
Date: Thu, 19 Jul 2007 12:59:25 -0700
Message-ID: <200707191959.l6JJxPZh019363@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37382 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756913AbXGSUAZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 16:00:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mark.fasheh@oracle.com, dhowells@redhat.com, nickpiggin@yahoo.com.au, mm-commits@vger.kernel.org


The patch titled
     Document ->page_mkwrite() locking
has been removed from the -mm tree.  Its filename was
     document-page_mkwrite-locking.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Document ->page_mkwrite() locking
From: Mark Fasheh <mark.fasheh@oracle.com>

There seems to be very little documentation about this callback in general.
The locking in particular is a bit tricky, so it's worth having this in
writing.

Signed-off-by: Mark Fasheh <mark.fasheh@oracle.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/Locking |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff -puN Documentation/filesystems/Locking~document-page_mkwrite-locking Documentation/filesystems/Locking
--- a/Documentation/filesystems/Locking~document-page_mkwrite-locking
+++ a/Documentation/filesystems/Locking
@@ -512,13 +512,22 @@ prototypes:
 	void (*close)(struct vm_area_struct*);
 	struct page *(*fault)(struct vm_area_struct*, struct fault_data *);
 	struct page *(*nopage)(struct vm_area_struct*, unsigned long, int *);
+	int (*page_mkwrite)(struct vm_area_struct *, struct page *);
 
 locking rules:
-		BKL	mmap_sem
+		BKL	mmap_sem	PageLocked(page)
 open:		no	yes
 close:		no	yes
 fault:		no	yes
 nopage:		no	yes
+page_mkwrite:	no	yes		no
+
+	->page_mkwrite() is called when a previously read-only page is
+about to become writeable. The file system is responsible for
+protecting against truncate races. Once appropriate action has been
+taking to lock out truncate, the page range should be verified to be
+within i_size. The page mapping should also be checked that it is not
+NULL.
 
 ================================================================================
 			Dubious stuff
_

Patches currently in -mm which might be from mark.fasheh@oracle.com are

origin.patch
git-ocfs2.patch
fs-introduce-write_begin-write_end-and-perform_write-aops.patch
ext3-convert-to-new-aops-fix.patch
ext4-convert-to-new-aops-fix.patch
ocfs2-convert-to-new-aops.patch
fs-remove-some-aop_truncated_page.patch
