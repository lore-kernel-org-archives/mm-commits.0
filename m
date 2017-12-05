From: akpm@linux-foundation.org
Subject: + autofs-fix-careless-error-in-recent-commit.patch added to -mm
 tree
Date: Tue, 05 Dec 2017 14:25:11 -0800
Message-ID: <5a271cc7.p58JtvwRLLaAP87u%akpm__43744.7306387641$1512561126$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38362 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752734AbdLEWZM (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 5 Dec 2017 17:25:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: neilb@suse.com, ben.hutchings@codethink.co.uk, raven@themaw.net, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: autofs: fix careless error in recent commit
has been added to the -mm tree.  Its filename is
     autofs-fix-careless-error-in-recent-commit.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/autofs-fix-careless-error-in-recent-commit.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/autofs-fix-careless-error-in-recent-commit.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: NeilBrown <neilb@suse.com>
Subject: autofs: fix careless error in recent commit

ecc0c469f277 ("autofs: don't fail mount for transient error") was meant to
replace an 'if' with a 'switch', but instead added the 'switch' leaving
the case in place.

Link: http://lkml.kernel.org/r/87zi6wstmw.fsf@notabene.neil.brown.name
Fixes: ecc0c469f277 ("autofs: don't fail mount for transient error")
Reported-by: Ben Hutchings <ben.hutchings@codethink.co.uk>
Signed-off-by: NeilBrown <neilb@suse.com>
Cc: Ian Kent <raven@themaw.net>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/autofs4/waitq.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN fs/autofs4/waitq.c~autofs-fix-careless-error-in-recent-commit fs/autofs4/waitq.c
--- a/fs/autofs4/waitq.c~autofs-fix-careless-error-in-recent-commit
+++ a/fs/autofs4/waitq.c
@@ -170,7 +170,6 @@ static void autofs4_notify_daemon(struct
 
 	mutex_unlock(&sbi->wq_mutex);
 
-	if (autofs4_write(sbi, pipe, &pkt, pktsz))
 	switch (ret = autofs4_write(sbi, pipe, &pkt, pktsz)) {
 	case 0:
 		break;
_

Patches currently in -mm which might be from neilb@suse.com are

autofs-fix-careless-error-in-recent-commit.patch

