From: akpm@linux-foundation.org
Subject: + mm-ratelimit-pfns-busy-info-message.patch added to -mm tree
Date: Wed, 02 Aug 2017 14:18:43 -0700
Message-ID: <598241b3.dN9/EYUzoZmHYh4N%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39620 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751174AbdHBVSo (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 2 Aug 2017 17:18:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jtoppins@redhat.com, dledford@redhat.com, hillf.zj@alibaba-inc.com, mgorman@techsingularity.net, mhocko@suse.com, stable@vger.kernel.org, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: ratelimit PFNs busy info message
has been added to the -mm tree.  Its filename is
     mm-ratelimit-pfns-busy-info-message.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-ratelimit-pfns-busy-info-message.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-ratelimit-pfns-busy-info-message.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jonathan Toppins <jtoppins@redhat.com>
Subject: mm: ratelimit PFNs busy info message

The RDMA subsystem can generate several thousand of these messages per
second eventually leading to a kernel crash.  Ratelimit these messages to
prevent this crash.

Doug said:

: I've been carrying a version of this for several kernel versions.  I don't
: remember when they started, but we have one (and only one) class of
: machines: Dell PE R730xd, that generate these errors.  When it happens,
: without a rate limit, we get rcu timeouts and kernel oopses.  With the
: rate limit, we just get a lot of annoying kernel messages but the machine
: continues on, recovers, and eventually the memory operations all succeed.

Link: http://lkml.kernel.org/r/499c0f6cc10d6eb829a67f2a4d75b4228a9b356e.1501695897.git.jtoppins@redhat.com
Signed-off-by: Jonathan Toppins <jtoppins@redhat.com>
Reviewed-by: Doug Ledford <dledford@redhat.com>
Tested-by: Doug Ledford <dledford@redhat.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Hillf Danton <hillf.zj@alibaba-inc.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/page_alloc.c~mm-ratelimit-pfns-busy-info-message mm/page_alloc.c
--- a/mm/page_alloc.c~mm-ratelimit-pfns-busy-info-message
+++ a/mm/page_alloc.c
@@ -7669,7 +7669,7 @@ int alloc_contig_range(unsigned long sta
 
 	/* Make sure the range is really isolated. */
 	if (test_pages_isolated(outer_start, end, false)) {
-		pr_info("%s: [%lx, %lx) PFNs busy\n",
+		pr_info_ratelimited("%s: [%lx, %lx) PFNs busy\n",
 			__func__, outer_start, end);
 		ret = -EBUSY;
 		goto done;
_

Patches currently in -mm which might be from jtoppins@redhat.com are

mm-ratelimit-pfns-busy-info-message.patch

