From: akpm@linux-foundation.org
Subject: + drivers-md-dm-mpathc-fix-kernel-null-pointer-dereference.patch added to -mm tree
Date: Mon, 14 Jun 2010 13:58:07 -0700
Message-ID: <201006142058.o5EKw7ZR030550@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47417 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755322Ab0FNU6t (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 14 Jun 2010 16:58:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lopresti@gmail.com, agk@redhat.com


The patch titled
     drivers/md/dm-mpath.c: fix kernel NULL pointer dereference
has been added to the -mm tree.  Its filename is
     drivers-md-dm-mpathc-fix-kernel-null-pointer-dereference.patch

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
Subject: drivers/md/dm-mpath.c: fix kernel NULL pointer dereference
From: "Patrick J. LoPresti" <lopresti@gmail.com>

I discovered this when I accidentally put the following in my
/etc/multipath.conf file:

      path_selector least_pending

...instead of this:

    path_selector "least_pending 0"

To my surprise, this resulted in a NULL pointer dereference in the kernel.
 Without this patch, the parse_priority_group function can return 0, which
the caller (multipath_ctr()) immediately dereferences.

Cc: Alasdair G Kergon <agk@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/md/dm-mpath.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/md/dm-mpath.c~drivers-md-dm-mpathc-fix-kernel-null-pointer-dereference drivers/md/dm-mpath.c
--- a/drivers/md/dm-mpath.c~drivers-md-dm-mpathc-fix-kernel-null-pointer-dereference
+++ a/drivers/md/dm-mpath.c
@@ -706,6 +706,7 @@ static struct priority_group *parse_prio
 
 		if (as->argc < nr_params) {
 			ti->error = "not enough path parameters";
+			r = -EINVAL;
 			goto bad;
 		}
 
_

Patches currently in -mm which might be from lopresti@gmail.com are

drivers-md-dm-mpathc-fix-kernel-null-pointer-dereference.patch

