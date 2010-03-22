From: akpm@linux-foundation.org
Subject: + mempolicy-lose-unnecessary-loop-variable-in-mpol_parse_str.patch added to -mm tree
Date: Mon, 22 Mar 2010 16:58:13 -0700
Message-ID: <201003222358.o2MNwEQs002475@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56014 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752475Ab0CVX60 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 22 Mar 2010 19:58:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lee.schermerhorn@hp.com, cl@linux-foundation.org, hugh.dickins@tiscali.co.uk, kiran@scalex86.org, kosaki.motohiro@jp.fujitsu.com, rientjes@google.com


The patch titled
     mempolicy: lose unnecessary loop variable in mpol_parse_str()
has been added to the -mm tree.  Its filename is
     mempolicy-lose-unnecessary-loop-variable-in-mpol_parse_str.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mempolicy: lose unnecessary loop variable in mpol_parse_str()
From: Lee Schermerhorn <lee.schermerhorn@hp.com>

We don't really need the extra variable 'i' in mpol_parse_str().  The only
use is as the the loop variable.  Then, it's assigned to 'mode'.  Just use
mode, and loose the 'uninitialized_var()' macro.

Signed-off-by: Lee Schermerhorn <lee.schermerhorn@hp.com>
Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: Ravikiran Thirumalai <kiran@scalex86.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff -puN mm/mempolicy.c~mempolicy-lose-unnecessary-loop-variable-in-mpol_parse_str mm/mempolicy.c
--- a/mm/mempolicy.c~mempolicy-lose-unnecessary-loop-variable-in-mpol_parse_str
+++ a/mm/mempolicy.c
@@ -2193,12 +2193,11 @@ static const char * const policy_types[]
 int mpol_parse_str(char *str, struct mempolicy **mpol, int no_context)
 {
 	struct mempolicy *new = NULL;
-	unsigned short uninitialized_var(mode);
+	unsigned short mode;
 	unsigned short uninitialized_var(mode_flags);
 	nodemask_t nodes;
 	char *nodelist = strchr(str, ':');
 	char *flags = strchr(str, '=');
-	int i;
 	int err = 1;
 
 	if (nodelist) {
@@ -2214,13 +2213,12 @@ int mpol_parse_str(char *str, struct mem
 	if (flags)
 		*flags++ = '\0';	/* terminate mode string */
 
-	for (i = 0; i <= MPOL_LOCAL; i++) {
-		if (!strcmp(str, policy_types[i])) {
-			mode = i;
+	for (mode = 0; mode <= MPOL_LOCAL; mode++) {
+		if (!strcmp(str, policy_types[mode])) {
 			break;
 		}
 	}
-	if (i > MPOL_LOCAL)
+	if (mode > MPOL_LOCAL)
 		goto out;
 
 	switch (mode) {
_

Patches currently in -mm which might be from lee.schermerhorn@hp.com are

tmpfs-fix-oops-on-mounts-with-mpol=default.patch
tmpfs-mpol=bind-0-dont-cause-mount-error.patch
tmpfs-handle-mpol_local-mount-option-properly.patch
tmpfs-cleanup-mpol_parse_str.patch
doc-add-the-documentation-for-mpol=local.patch
mempolicy-fix-get_mempolicy-for-relative-and-static-nodes.patch
mempolicy-remove-case-mpol_interleave-from-policy_zonelist.patch
mempolicy-remove-redundant-check.patch
mempolicy-dont-call-mpol_set_nodemask-when-no_context.patch
mempolicy-lose-unnecessary-loop-variable-in-mpol_parse_str.patch
mempolicy-rename-policy_types-and-cleanup-initialization.patch
mempolicy-factor-mpol_shared_policy_init-return-paths.patch
mempolicy-document-cpuset-interaction-with-tmpfs-mpol-mount-option.patch

