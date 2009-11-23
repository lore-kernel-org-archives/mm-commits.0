From: akpm@linux-foundation.org
Subject: + enclosure-fix-oops-while-iterating-enclosure_status-array.patch added to -mm tree
Date: Mon, 23 Nov 2009 13:45:55 -0800
Message-ID: <200911232145.nANLjtJ9004756@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37721 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753226AbZKWVp7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 23 Nov 2009 16:45:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jeffm@jeffreymahoney.com, James.Bottomley@HansenPartnership.com, artur.wojcik@intel.com, jeffm@suse.com


The patch titled
     enclosure: fix oops while iterating enclosure_status array
has been added to the -mm tree.  Its filename is
     enclosure-fix-oops-while-iterating-enclosure_status-array.patch

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
Subject: enclosure: fix oops while iterating enclosure_status array
From: Jeff Mahoney <jeffm@jeffreymahoney.com>

enclosure_status is expected to be a NULL terminated array of strings but
isn't actually NULL terminated.  When writing an invalid value to
/sys/class/enclosure/.../.../status, it goes off the end of the array and
Oopses.

This patch uses the array size instead.

Reported-by: Artur Wojcik <artur.wojcik@intel.com>
Signed-off-by: Jeff Mahoney <jeffm@suse.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/enclosure.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN drivers/misc/enclosure.c~enclosure-fix-oops-while-iterating-enclosure_status-array drivers/misc/enclosure.c
--- a/drivers/misc/enclosure.c~enclosure-fix-oops-while-iterating-enclosure_status-array
+++ a/drivers/misc/enclosure.c
@@ -441,8 +441,9 @@ static ssize_t set_component_status(stru
 	struct enclosure_component *ecomp = to_enclosure_component(cdev);
 	int i;
 
-	for (i = 0; enclosure_status[i]; i++) {
-		if (strncmp(buf, enclosure_status[i],
+	for (i = 0; i < ARRAY_SIZE(enclosure_status); i++) {
+		if (enclosure_status[i] &&
+		    strncmp(buf, enclosure_status[i],
 			    strlen(enclosure_status[i])) == 0 &&
 		    (buf[strlen(enclosure_status[i])] == '\n' ||
 		     buf[strlen(enclosure_status[i])] == '\0'))
_

Patches currently in -mm which might be from jeffm@jeffreymahoney.com are

enclosure-fix-oops-while-iterating-enclosure_status-array.patch

