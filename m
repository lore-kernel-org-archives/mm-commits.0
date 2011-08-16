From: akpm@linux-foundation.org
Subject: + oprofilefs-handle-zero-length-writes.patch added to -mm tree
Date: Tue, 16 Aug 2011 15:20:27 -0700
Message-ID: <201108162220.p7GMKROE031941@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47591 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751581Ab1HPWU7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Aug 2011 18:20:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mikew@google.com, robert.richter@amd.com


The patch titled
     oprofilefs: handle zero-length writes
has been added to the -mm tree.  Its filename is
     oprofilefs-handle-zero-length-writes.patch

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
Subject: oprofilefs: handle zero-length writes
From: Mike Waychison <mikew@google.com>

Currently in oprofilefs, files that use ulong_fops mis-handle writes of
zero length.  A count of 0 causes oprofilefs_ulong_from_user to return 0
(success), which then leads to oprofile_set_ulong being called to stuff
"value" into file->private_data without it being initialized.

Fix this by moving the check for a zero-length write up into
ulong_write_file.

Signed-off-by: Mike Waychison <mikew@google.com>
Cc: Robert Richter <robert.richter@amd.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/oprofile/oprofilefs.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN drivers/oprofile/oprofilefs.c~oprofilefs-handle-zero-length-writes drivers/oprofile/oprofilefs.c
--- a/drivers/oprofile/oprofilefs.c~oprofilefs-handle-zero-length-writes
+++ a/drivers/oprofile/oprofilefs.c
@@ -65,9 +65,6 @@ int oprofilefs_ulong_from_user(unsigned 
 	char tmpbuf[TMPBUFSIZE];
 	unsigned long flags;
 
-	if (!count)
-		return 0;
