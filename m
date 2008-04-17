From: akpm@linux-foundation.org
Subject: + mempolicy-use-mpol_f_local-to-indicate-preferred-local-policy-fix.patch added to -mm tree
Date: Thu, 17 Apr 2008 11:29:51 -0700
Message-ID: <200804171829.m3HITpOd022004@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53573 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757275AbYDQSaP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 17 Apr 2008 14:30:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: Lee.Schermerhorn@hp.com, ak@suse.de, clameter@sgi.com, lee.schermerhorn@hp.com, mel@csn.ul.ie, rientjes@google.com


The patch titled
     Mempolicy: fix mpol_to_str() to handle ignore mode flags
has been added to the -mm tree.  Its filename is
     mempolicy-use-mpol_f_local-to-indicate-preferred-local-policy-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Mempolicy: fix mpol_to_str() to handle ignore mode flags
From: Lee Schermerhorn <Lee.Schermerhorn@hp.com>

Fixes problem introduced by my previous patch:
  mempolicy-use-mpol_f_local-to-indicate-preferred-local-policy.patch

Eliminate display of bogus '=' flag indicator in presence of
internal mode flags.

Without this fix, on 25-rc8-mm1, a display of a process' numa_maps
will show, e.g., default policy as "default=".  Worse, if the maps
include longer policies, such as "interleave:0-3", this problem will
lose the string terminator after the "<mode>=" and display subsequent
default policies as "default=ve:0-3".

Signed-off-by: Lee Schermerhorn <lee.schermerhorn@hp.com>
Cc: Christoph Lameter <clameter@sgi.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/mempolicy.c~mempolicy-use-mpol_f_local-to-indicate-preferred-local-policy-fix mm/mempolicy.c
--- a/mm/mempolicy.c~mempolicy-use-mpol_f_local-to-indicate-preferred-local-policy-fix
+++ a/mm/mempolicy.c
@@ -2002,7 +2002,7 @@ static inline int mpol_to_str(char *buff
 	strcpy(p, policy_types[mode]);
 	p += l;
 
-	if (flags) {
+	if (flags & MPOL_MODE_FLAGS) {
 		int need_bar = 0;
 
 		if (buffer + maxlen < p + 2)
_

Patches currently in -mm which might be from Lee.Schermerhorn@hp.com are

mm-filter-based-on-a-nodemask-as-well-as-a-gfp_mask-doc-fixes.patch
mm-filter-based-on-a-nodemask-as-well-as-a-gfp_mask-make-dequeue_huge_page_vma-obey-mpol_bind-nodemask.patch
mm-filter-based-on-a-nodemask-as-well-as-a-gfp_mask-make-dequeue_huge_page_vma-obey-mpol_bind-nodemask-rework.patch
mempolicy-convert-mpol-constants-to-enum.patch
mempolicy-support-optional-mode-flags.patch
mempolicy-support-optional-mode-flags-fix.patch
mempolicy-add-mpol_f_static_nodes-flag.patch
mempolicy-add-mpol_f_relative_nodes-flag.patch
mempolicy-update-numa-memory-policy-documentation.patch
mempolicy-move-rebind-functions.patch
mempolicy-create-mempolicy_operations-structure.patch
mempolicy-create-mempolicy_operations-structure-fix.patch
mempolicy-small-header-file-cleanup.patch
mempolicy-disallow-static-or-relative-flags-for-local-preferred-mode.patch
mempolicy-fix-parsing-of-tmpfs-mpol-mount-option.patch
fix-indentation.patch
mempolicy-use-mpol_f_local-to-indicate-preferred-local-policy-fix.patch

