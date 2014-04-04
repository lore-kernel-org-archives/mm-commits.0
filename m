From: akpm@linux-foundation.org
Subject: [merged] binfmt_misc-add-missing-break-statement.patch removed
 from -mm tree
Date: Fri, 04 Apr 2014 12:34:36 -0700
Message-ID: <533f094c.6G7tQwm2mf6zLqFH%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43444 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754318AbaDDTeg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Apr 2014 15:34:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, luis.henriques@canonical.com

Subject: [merged] binfmt_misc-add-missing-break-statement.patch removed from -mm tree
To: luis.henriques@canonical.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 04 Apr 2014 12:34:36 -0700


The patch titled
     Subject: binfmt_misc: add missing 'break' statement
has been removed from the -mm tree.  Its filename was
     binfmt_misc-add-missing-break-statement.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Luis Henriques <luis.henriques@canonical.com>
Subject: binfmt_misc: add missing 'break' statement

A missing 'break' statement in bm_status_write() results in a user program
receiving '3' when doing the following:

  write(fd, "-1", 2);

Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
Alexander Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/binfmt_misc.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN fs/binfmt_misc.c~binfmt_misc-add-missing-break-statement fs/binfmt_misc.c
--- a/fs/binfmt_misc.c~binfmt_misc-add-missing-break-statement
+++ a/fs/binfmt_misc.c
@@ -656,6 +656,7 @@ static ssize_t bm_status_write(struct fi
 
 			mutex_unlock(&root->d_inode->i_mutex);
 			dput(root);
+			break;
 		default: return res;
 	}
 	return count;
_

Patches currently in -mm which might be from luis.henriques@canonical.com are

origin.patch

