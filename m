From: akpm@linux-foundation.org
Subject: + kasan-update-documentation-for-generic-kasan.patch
 added to -mm tree
Date: Thu, 02 Jul 2020 21:45:49 -0700
Message-ID: <20200703044549.CMbEzqRr2%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:33580 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725779AbgGCEpv (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 3 Jul 2020 00:45:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andreyknvl@google.com, aryabinin@virtuozzo.com, corbet@lwn.net, dvyukov@google.com, glider@google.com, jiangshanlai@gmail.com, joel@joelfernandes.org, josh@joshtriplett.org, mathieu.desnoyers@efficios.com, matthias.bgg@gmail.com, mm-commits@vger.kernel.org, paulmck@kernel.org, walter-zh.wu@mediatek.com


The patch titled
     Subject: kasan: update documentation for generic kasan
has been added to the -mm tree.  Its filename is
     kasan-update-documentation-for-generic-kasan.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kasan-update-documentation-for-generic-kasan.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kasan-update-documentation-for-generic-kasan.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Walter Wu <walter-zh.wu@mediatek.com>
Subject: kasan: update documentation for generic kasan

Generic KASAN will support to record the last two call_rcu() call stacks
and print them in KASAN report.  So that need to update documentation.

Link: http://lkml.kernel.org/r/20200601051111.1359-1-walter-zh.wu@mediatek.com
Signed-off-by: Walter Wu <walter-zh.wu@mediatek.com>
Reviewed-by: Dmitry Vyukov <dvyukov@google.com>
Tested-by: Dmitry Vyukov <dvyukov@google.com>
Reviewed-by: Andrey Konovalov <andreyknvl@google.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Matthias Brugger <matthias.bgg@gmail.com>
Cc: "Paul E . McKenney" <paulmck@kernel.org>
Cc: Josh Triplett <josh@joshtriplett.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Lai Jiangshan <jiangshanlai@gmail.com>
Cc: Joel Fernandes <joel@joelfernandes.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/dev-tools/kasan.rst |    3 +++
 1 file changed, 3 insertions(+)

--- a/Documentation/dev-tools/kasan.rst~kasan-update-documentation-for-generic-kasan
+++ a/Documentation/dev-tools/kasan.rst
@@ -190,6 +190,9 @@ function calls GCC directly inserts the
 This option significantly enlarges kernel but it gives x1.1-x2 performance
 boost over outline instrumented kernel.
 
+Generic KASAN prints up to 2 call_rcu() call stacks in reports, the last one
+and the second to last.
+
 Software tag-based KASAN
 ~~~~~~~~~~~~~~~~~~~~~~~~
 
_

Patches currently in -mm which might be from walter-zh.wu@mediatek.com are

rcu-kasan-record-and-print-call_rcu-call-stack.patch
kasan-record-and-print-the-free-track.patch
kasan-add-tests-for-call_rcu-stack-recording.patch
kasan-update-documentation-for-generic-kasan.patch
