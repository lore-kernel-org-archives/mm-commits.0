From: akpm@linux-foundation.org
Subject: - mempolicy-clean-up-mpol-to-str-mempolicy-formatting.patch removed from -mm tree
Date: Mon, 28 Apr 2008 14:53:32 -0700
Message-ID: <200804282153.m3SLrWc9017880@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57955 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S936111AbYD1Vxu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Apr 2008 17:53:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lee.schermerhorn@hp.com, ak@suse.de, clameter@sgi.com, mel@csn.ul.ie, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     mempolicy: clean-up mpol-to-str() mempolicy formatting
has been removed from the -mm tree.  Its filename was
     mempolicy-clean-up-mpol-to-str-mempolicy-formatting.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mempolicy: clean-up mpol-to-str() mempolicy formatting
From: Lee Schermerhorn <lee.schermerhorn@hp.com>

mpol-to-str() formats memory policies into printable strings.  Currently this
is only used to display "numa_maps".  A subsequent patch will use
mpol_to_str() for formatting tmpfs [shmem] mpol mount options, allowing us to
remove essentially duplicate code in mm/shmem.c.  This patch cleans up
mpol_to_str() generally and in preparation for that patch.

1) show_numa_maps() is not checking the return code from mpol_to_str(). 
   There's not a lot we can do in this context if mpol_to_str() did return the
   error [insufficient space in buffer].  Proposed "solution": just check,
   under DEBUG_VM, that callers are providing sufficient buffer space for the
   policy, flags, and a few nodes.  This way, we'll get some display. 
   show_numa_maps() is providing a 50-byte buffer, so it won't trip this
   check.  50-bytes should be sufficient unless one has a large number of
   nodes in a very sparse nodemask.

2) The display of the new mode flags ["static" & "relative"] was set up to
   display multiple flags, separated by a "bar" '|'.  However, this support is
   incomplete--e.g., need_bar was never incremented; and currently, these two
   flags are mutually exclusive.  So remove the "bar" support, for now, and
   only display one flag.

3) Use snprint() to format flags, so as not to overflow the buffer.  Not
   that it's ever happed, AFAIK.

Signed-off-by: Lee Schermerhorn <lee.schermerhorn@hp.com>
Cc: Christoph Lameter <clameter@sgi.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c |   17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff -puN mm/mempolicy.c~mempolicy-clean-up-mpol-to-str-mempolicy-formatting mm/mempolicy.c
--- a/mm/mempolicy.c~mempolicy-clean-up-mpol-to-str-mempolicy-formatting
+++ a/mm/mempolicy.c
@@ -1965,6 +1965,11 @@ static inline int mpol_to_str(char *buff
 	unsigned short mode;
 	unsigned short flags = pol ? pol->flags : 0;
 
+	/*
+	 * Sanity check:  room for longest mode, flag and some nodes
+	 */
+	VM_BUG_ON(maxlen < strlen("interleave") + strlen("relative") + 16);
+
 	if (!pol || pol == &default_policy)
 		mode = MPOL_DEFAULT;
 	else
@@ -1991,7 +1996,6 @@ static inline int mpol_to_str(char *buff
 
 	default:
 		BUG();
-		return -EFAULT;
 	}
 
 	l = strlen(policy_types[mode]);
@@ -2002,16 +2006,17 @@ static inline int mpol_to_str(char *buff
 	p += l;
 
 	if (flags & MPOL_MODE_FLAGS) {
-		int need_bar = 0;
