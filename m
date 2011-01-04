From: akpm@linux-foundation.org
Subject: [merged] name_to_dev_t-must-not-call-__init-code.patch removed from -mm tree
Date: Tue, 04 Jan 2011 11:41:31 -0800
Message-ID: <201101041942.p04Jgvci020663@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37310 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751379Ab1ADTnC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Jan 2011 14:43:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: JBeulich@novell.com, jbeulich@novell.com, randy.dunlap@oracle.com, mm-commits@vger.kernel.org


The patch titled
     init/do_mounts.c: name_to_dev_t() must not call __init code
has been removed from the -mm tree.  Its filename was
     name_to_dev_t-must-not-call-__init-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: init/do_mounts.c: name_to_dev_t() must not call __init code
From: "Jan Beulich" <JBeulich@novell.com>

The function can't be __init itself (being called from some sysfs
handler), and hence none of the functions it calls can be either.

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Acked-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/do_mounts.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN init/do_mounts.c~name_to_dev_t-must-not-call-__init-code init/do_mounts.c
--- a/init/do_mounts.c~name_to_dev_t-must-not-call-__init-code
+++ a/init/do_mounts.c
@@ -93,7 +93,7 @@ no_match:
  *
  * Returns the matching dev_t on success or 0 on failure.
  */
-static dev_t __init devt_from_partuuid(char *uuid_str)
+static dev_t devt_from_partuuid(char *uuid_str)
 {
 	dev_t res = 0;
 	struct device *dev = NULL;
_

Patches currently in -mm which might be from JBeulich@novell.com are

origin.patch
linux-next.patch

