From: Andrew Morton <akpm@linux-foundation.org>
Subject: + doc-mm-clarify-proc-pid-oom_score-value-range.patch
 added to -mm tree
Date: Thu, 09 Jul 2020 17:36:13 -0700
Message-ID: <20200710003613.odKYUvC0f%akpm@linux-foundation.org>
References: <20200703151445.b6a0cfee402c7c5c4651f1b1@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:34134 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726272AbgGJAgO (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 9 Jul 2020 20:36:14 -0400
In-Reply-To: <20200703151445.b6a0cfee402c7c5c4651f1b1@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: corbet@lwn.net, laoar.shao@gmail.com, mhocko@suse.com, mm-commits@vger.kernel.org, rientjes@google.com


The patch titled
     Subject: doc, mm: clarify /proc/<pid>/oom_score value range
has been added to the -mm tree.  Its filename is
     doc-mm-clarify-proc-pid-oom_score-value-range.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/doc-mm-clarify-proc-pid-oom_score-value-range.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/doc-mm-clarify-proc-pid-oom_score-value-range.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Michal Hocko <mhocko@suse.com>
Subject: doc, mm: clarify /proc/<pid>/oom_score value range

The exported value includes oom_score_adj so the range is no [0, 1000] as
described in the previous section but rather [0, 2000].  Mention that fact
explicitly.

Link: http://lkml.kernel.org/r/20200709062603.18480-2-mhocko@kernel.org
Signed-off-by: Michal Hocko <mhocko@suse.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: David Rientjes <rientjes@google.com>
Cc: Yafang Shao <laoar.shao@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/proc.rst |    3 +++
 1 file changed, 3 insertions(+)

--- a/Documentation/filesystems/proc.rst~doc-mm-clarify-proc-pid-oom_score-value-range
+++ a/Documentation/filesystems/proc.rst
@@ -1673,6 +1673,9 @@ requires CAP_SYS_RESOURCE.
 3.2 /proc/<pid>/oom_score - Display current oom-killer score
 -------------------------------------------------------------
 
+Please note that the exported value includes oom_score_adj so it is effectively
+in range [0,2000].
+
 This file can be used to check the current score used by the oom-killer is for
 any given <pid>. Use it together with /proc/<pid>/oom_score_adj to tune which
 process should be killed in an out-of-memory situation.
_

Patches currently in -mm which might be from mhocko@suse.com are

doc-mm-sync-up-oom_score_adj-documentation.patch
doc-mm-clarify-proc-pid-oom_score-value-range.patch
