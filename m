From: akpm@linux-foundation.org
Subject: + binfmt_misc-add-missing-break-statement.patch added to -mm tree
Date: Fri, 28 Mar 2014 16:05:51 -0700
Message-ID: <5336004f.+rgGn4sExsP5ljvC%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54290 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750864AbaC1XFw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 28 Mar 2014 19:05:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, luis.henriques@canonical.com

Subject: + binfmt_misc-add-missing-break-statement.patch added to -mm tree
To: luis.henriques@canonical.com
From: akpm@linux-foundation.org
Date: Fri, 28 Mar 2014 16:05:51 -0700


The patch titled
     Subject: binfmt_misc: add missing 'break' statement
has been added to the -mm tree.  Its filename is
     binfmt_misc-add-missing-break-statement.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/binfmt_misc-add-missing-break-statement.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/binfmt_misc-add-missing-break-statement.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

binfmt_misc-add-missing-break-statement.patch
linux-next.patch

