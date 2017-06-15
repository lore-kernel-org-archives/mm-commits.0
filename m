From: akpm@linux-foundation.org
Subject: + mm-vmpressure-pass-through-notification-support-fix.patch added to -mm tree
Date: Thu, 15 Jun 2017 13:13:21 -0700
Message-ID: <5942ea61.7hXDLB1Ua9VUdUZ1%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34698 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752323AbdFOUNW (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 15 Jun 2017 16:13:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dan.carpenter@oracle.com, mhocko@suse.com, minchan@kernel.org, rientjes@google.com, vinmenon@codeaurora.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmpressure.c: free the same pointer we allocated
has been added to the -mm tree.  Its filename is
     mm-vmpressure-pass-through-notification-support-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-vmpressure-pass-through-notification-support-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-vmpressure-pass-through-notification-support-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: mm/vmpressure.c: free the same pointer we allocated

We keep incrementing "spec" as we parse the args so we end up calling
kfree() on a modified of spec.  It probably works or this would have been
caught in testing, but it looks weird.

Link: http://lkml.kernel.org/r/20170613191820.GA20003@elgon.mountain
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Acked-by: David Rientjes <rientjes@google.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Vinayak Menon <vinmenon@codeaurora.org>
Cc: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmpressure.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN mm/vmpressure.c~mm-vmpressure-pass-through-notification-support-fix mm/vmpressure.c
--- a/mm/vmpressure.c~mm-vmpressure-pass-through-notification-support-fix
+++ a/mm/vmpressure.c
@@ -386,11 +386,11 @@ int vmpressure_register_event(struct mem
 	struct vmpressure_event *ev;
 	enum vmpressure_modes mode = VMPRESSURE_NO_PASSTHROUGH;
 	enum vmpressure_levels level = -1;
-	char *spec = NULL;
+	char *spec, *spec_orig;
 	char *token;
 	int ret = 0;
 
-	spec = kzalloc(MAX_VMPRESSURE_ARGS_LEN + 1, GFP_KERNEL);
+	spec_orig = spec = kzalloc(MAX_VMPRESSURE_ARGS_LEN + 1, GFP_KERNEL);
 	if (!spec) {
 		ret = -ENOMEM;
 		goto out;
@@ -429,7 +429,7 @@ int vmpressure_register_event(struct mem
 	list_add(&ev->node, &vmpr->events);
 	mutex_unlock(&vmpr->events_lock);
 out:
-	kfree(spec);
+	kfree(spec_orig);
 	return ret;
 }
 
_

Patches currently in -mm which might be from dan.carpenter@oracle.com are

mm-vmpressure-pass-through-notification-support-fix.patch

