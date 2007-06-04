From: akpm@linux-foundation.org
Subject: + document-page_mkwrite-locking.patch added to -mm tree
Date: Mon, 04 Jun 2007 12:58:50 -0700
Message-ID: <200706041958.l54JwoJn013562@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49827 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756525AbXFDT7I (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 Jun 2007 15:59:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mark.fasheh@oracle.com, dhowells@redhat.com, nickpiggin@yahoo.com.au


The patch titled
     Document ->page_mkwrite() locking
has been added to the -mm tree.  Its filename is
     document-page_mkwrite-locking.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
 1 files changed, 10 insertions(+), 1 deletion(-)

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

ocfs2-release-page-lock-before-calling-page_mkwrite.patch
document-page_mkwrite-locking.patch
fs-introduce-write_begin-write_end-and-perform_write-aops.patch
