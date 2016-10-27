From: akpm@linux-foundation.org
Subject: +
 mm-mempolicyc-forbid-static-or-relative-flags-for-local-numa-mode.patch
 added to -mm tree
Date: Thu, 27 Oct 2016 14:01:00 -0700
Message-ID: <58126b0c.Lf67I/60AhfTtQV4%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50186 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935601AbcJ0VBB (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 27 Oct 2016 17:01:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kwapulinski.piotr@gmail.com, dave.hansen@linux.intel.com, kirill.shutemov@linux.intel.com, liangchen.linux@gmail.com, mgorman@techsingularity.net, mhocko@suse.com, nzimmer@sgi.com, rientjes@google.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mempolicy.c: forbid static or relative flags for local NUMA mode
has been added to the -mm tree.  Its filename is
     mm-mempolicyc-forbid-static-or-relative-flags-for-local-numa-mode.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-mempolicyc-forbid-static-or-relative-flags-for-local-numa-mode.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-mempolicyc-forbid-static-or-relative-flags-for-local-numa-mode.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Piotr Kwapulinski <kwapulinski.piotr@gmail.com>
Subject: mm/mempolicy.c: forbid static or relative flags for local NUMA mode

The MPOL_F_STATIC_NODES and MPOL_F_RELATIVE_NODES flags are irrelevant
when setting them for MPOL_LOCAL NUMA memory policy via set_mempolicy or
mbind.

Return the "invalid argument" from set_mempolicy and mbind whenever any of
these flags is passed along with MPOL_LOCAL.

It is consistent with MPOL_PREFERRED passed with empty nodemask.

It slightly shortens the execution time in paths where these flags are
used e.g.  when trying to rebind the NUMA nodes for changes in cgroups
cpuset mems (mpol_rebind_preferred()) or when just printing the mempolicy
structure (/proc/PID/numa_maps).  Isolated tests done.

Link: http://lkml.kernel.org/r/20161027163037.4089-1-kwapulinski.piotr@gmail.com
Signed-off-by: Piotr Kwapulinski <kwapulinski.piotr@gmail.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: David Rientjes <rientjes@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Liang Chen <liangchen.linux@gmail.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Nathan Zimmer <nzimmer@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN mm/mempolicy.c~mm-mempolicyc-forbid-static-or-relative-flags-for-local-numa-mode mm/mempolicy.c
--- a/mm/mempolicy.c~mm-mempolicyc-forbid-static-or-relative-flags-for-local-numa-mode
+++ a/mm/mempolicy.c
@@ -276,7 +276,9 @@ static struct mempolicy *mpol_new(unsign
 				return ERR_PTR(-EINVAL);
 		}
 	} else if (mode == MPOL_LOCAL) {
-		if (!nodes_empty(*nodes))
+		if (!nodes_empty(*nodes) ||
+		    (flags & MPOL_F_STATIC_NODES) ||
+		    (flags & MPOL_F_RELATIVE_NODES))
 			return ERR_PTR(-EINVAL);
 		mode = MPOL_PREFERRED;
 	} else if (nodes_empty(*nodes))
_

Patches currently in -mm which might be from kwapulinski.piotr@gmail.com are

mm-mempolicyc-forbid-static-or-relative-flags-for-local-numa-mode.patch

