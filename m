From: akpm@linux-foundation.org
Subject: [patch 045/123] mm/mempolicy.c: forbid static or relative flags
 for local NUMA mode
Date: Mon, 12 Dec 2016 16:42:49 -0800
Message-ID: <584f4409.QavFeFATKAPP8+mT%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41012 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752843AbcLMAmu (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 12 Dec 2016 19:42:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, kwapulinski.piotr@gmail.com, dave.hansen@linux.intel.com, kirill.shutemov@linux.intel.com, liangchen.linux@gmail.com, mgorman@techsingularity.net, mhocko@suse.com, nzimmer@sgi.com, rientjes@google.com, vbabka@suse.cz

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
Acked-by: David Rientjes <rientjes@google.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
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
