From: akpm@linux-foundation.org
Subject: [merged] nommu-check-fd-read-permission-in-validate_mmap_request.patch removed from -mm tree
Date: Thu, 20 Aug 2009 13:13:00 -0700
Message-ID: <200908202013.n7KKD0nX015941@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46307 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755289AbZHTUSd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 20 Aug 2009 16:18:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: graff.yang@gmail.com, dhowells@redhat.com, gerg@snapgear.com, lethal@linux-sh.org, mm-commits@vger.kernel.org


The patch titled
     nommu: check fd read permission in validate_mmap_request()
has been removed from the -mm tree.  Its filename was
     nommu-check-fd-read-permission-in-validate_mmap_request.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: nommu: check fd read permission in validate_mmap_request()
From: Graff Yang <graff.yang@gmail.com>

According to the POSIX (1003.1-2008), the file descriptor shall have been
opened with read permission, regardless of the protection options specified to
mmap().  The ltp test cases mmap06/07 need this.

Signed-off-by: Graff Yang <graff.yang@gmail.com>
Acked-by: Paul Mundt <lethal@linux-sh.org>
Signed-off-by: David Howells <dhowells@redhat.com>
Acked-by: Greg Ungerer <gerg@snapgear.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/nommu.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN mm/nommu.c~nommu-check-fd-read-permission-in-validate_mmap_request mm/nommu.c
--- a/mm/nommu.c~nommu-check-fd-read-permission-in-validate_mmap_request
+++ a/mm/nommu.c
@@ -919,6 +919,10 @@ static int validate_mmap_request(struct 
 		if (!file->f_op->read)
 			capabilities &= ~BDI_CAP_MAP_COPY;
 
+		/* The file shall have been opened with read permission. */
+		if (!(file->f_mode & FMODE_READ))
+			return -EACCES;
+
 		if (flags & MAP_SHARED) {
 			/* do checks for writing, appending and locking */
 			if ((prot & PROT_WRITE) &&
_

Patches currently in -mm which might be from graff.yang@gmail.com are

origin.patch

