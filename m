From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 003/118] mm/mempolicy.c: fix out of bounds write
 in mpol_parse_str()
Date: Thu, 30 Jan 2020 22:11:07 -0800
Message-ID: <20200131061107.US9oQYBpA%akpm@linux-foundation.org>
References: <20200130221021.5f0211c56346d5485af07923@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:57924 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725907AbgAaGLI (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 31 Jan 2020 01:11:08 -0500
In-Reply-To: <20200130221021.5f0211c56346d5485af07923@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, akpm@linux-foundation.org, dan.carpenter@oracle.com, hughd@google.com, lee.schermerhorn@hp.com, linux-mm@kvack.org, mhocko@kernel.org, mm-commits@vger.kernel.org, stable@vger.kernel.org, torvalds@linux-foundation.org, vbabka@suse.cz

From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: mm/mempolicy.c: fix out of bounds write in mpol_parse_str()

What we are trying to do is change the '=' character to a NUL terminator
and then at the end of the function we restore it back to an '='.  The
problem is there are two error paths where we jump to the end of the
function before we have replaced the '=' with NUL.  We end up putting the
'=' in the wrong place (possibly one element before the start of the
buffer).

Link: http://lkml.kernel.org/r/20200115055426.vdjwvry44nfug7yy@kili.mountain
Reported-by: syzbot+e64a13c5369a194d67df@syzkaller.appspotmail.com
Fixes: 095f1fc4ebf3 ("mempolicy: rework shmem mpol parsing and display")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Dmitry Vyukov <dvyukov@google.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Lee Schermerhorn <lee.schermerhorn@hp.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/mempolicy.c~mm-mempolicyc-fix-out-of-bounds-write-in-mpol_parse_str
+++ a/mm/mempolicy.c
@@ -2821,6 +2821,9 @@ int mpol_parse_str(char *str, struct mem
 	char *flags = strchr(str, '=');
 	int err = 1, mode;
 
+	if (flags)
+		*flags++ = '\0';	/* terminate mode string */
+
 	if (nodelist) {
 		/* NUL-terminate mode or flags string */
 		*nodelist++ = '\0';
@@ -2831,9 +2834,6 @@ int mpol_parse_str(char *str, struct mem
 	} else
 		nodes_clear(nodes);
 
-	if (flags)
-		*flags++ = '\0';	/* terminate mode string */
