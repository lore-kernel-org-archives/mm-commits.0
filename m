From: akpm@linux-foundation.org
Subject: +
 ksm-replace-smp_read_barrier_depends-with-lockless_dereference.patch added
 to -mm tree
Date: Thu, 13 Nov 2014 13:40:44 -0800
Message-ID: <5465255c.gb14IzhgAJUBZ+tf%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40563 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934603AbaKMVkp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 13 Nov 2014 16:40:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bobby.prani@gmail.com, hughd@google.com, paulmck@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ksm: replace smp_read_barrier_depends() with lockless_dereference()
has been added to the -mm tree.  Its filename is
     ksm-replace-smp_read_barrier_depends-with-lockless_dereference.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ksm-replace-smp_read_barrier_depends-with-lockless_dereference.patch
		echo and later at
		echo  http://ozlabs.org/~akpm/mmotm/broken-out/ksm-replace-smp_read_barrier_depends-with-lockless_dereference.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Pranith Kumar <bobby.prani@gmail.com>
Subject: ksm: replace smp_read_barrier_depends() with lockless_dereference()

Recently lockless_dereference() was added which can be used in place of
hard-coding smp_read_barrier_depends().  The following PATCH makes the
change.

Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
Cc: "Paul E. McKenney" <paulmck@us.ibm.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/ksm.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff -puN mm/ksm.c~ksm-replace-smp_read_barrier_depends-with-lockless_dereference mm/ksm.c
--- a/mm/ksm.c~ksm-replace-smp_read_barrier_depends-with-lockless_dereference
+++ a/mm/ksm.c
@@ -542,15 +542,14 @@ static struct page *get_ksm_page(struct
 	expected_mapping = (void *)stable_node +
 				(PAGE_MAPPING_ANON | PAGE_MAPPING_KSM);
 again:
-	kpfn = ACCESS_ONCE(stable_node->kpfn);
-	page = pfn_to_page(kpfn);
