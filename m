From: akpm@linux-foundation.org
Subject: + nommu-check-fd-read-permission-in-validate_mmap_request.patch added to -mm tree
Date: Fri, 14 Aug 2009 16:45:19 -0700
Message-ID: <200908142345.n7ENjJe4013836@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46145 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932238AbZHNXpn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 14 Aug 2009 19:45:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: graff.yang@gmail.com, dhowells@redhat.com, gerg@snapgear.com, lethal@linux-sh.org


The patch titled
     nommu: check fd read permission in validate_mmap_request()
has been added to the -mm tree.  Its filename is
     nommu-check-fd-read-permission-in-validate_mmap_request.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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
Cc: Greg Ungerer <gerg@snapgear.com>
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

nommu-check-fd-read-permission-in-validate_mmap_request.patch

