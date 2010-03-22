From: akpm@linux-foundation.org
Subject: + mempolicy-rename-policy_types-and-cleanup-initialization.patch added to -mm tree
Date: Mon, 22 Mar 2010 16:58:16 -0700
Message-ID: <201003222358.o2MNwG1s002478@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51629 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754500Ab0CVX6f (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 22 Mar 2010 19:58:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lee.schermerhorn@hp.com, cl@linux-foundation.org, hugh.dickins@tiscali.co.uk, kiran@scalex86.org, kosaki.motohiro@jp.fujitsu.com, rientjes@google.com


The patch titled
     mempolicy: rename policy_types and cleanup initialization
has been added to the -mm tree.  Its filename is
     mempolicy-rename-policy_types-and-cleanup-initialization.patch

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
Subject: mempolicy: rename policy_types and cleanup initialization
From: Lee Schermerhorn <lee.schermerhorn@hp.com>

Rename 'policy_types[]' to 'policy_modes[]' to better match the array
contents.

Use designated intializer syntax for policy_modes[].

Signed-off-by: Lee Schermerhorn <lee.schermerhorn@hp.com>
Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: Ravikiran Thirumalai <kiran@scalex86.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c |   18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff -puN mm/mempolicy.c~mempolicy-rename-policy_types-and-cleanup-initialization mm/mempolicy.c
--- a/mm/mempolicy.c~mempolicy-rename-policy_types-and-cleanup-initialization
+++ a/mm/mempolicy.c
@@ -2166,9 +2166,15 @@ void numa_default_policy(void)
  * "local" is pseudo-policy:  MPOL_PREFERRED with MPOL_F_LOCAL flag
  * Used only for mpol_parse_str() and mpol_to_str()
  */
-#define MPOL_LOCAL (MPOL_INTERLEAVE + 1)
-static const char * const policy_types[] =
-	{ "default", "prefer", "bind", "interleave", "local" };
+#define MPOL_LOCAL MPOL_MAX
+static const char * const policy_modes[] =
+{
+ 	[MPOL_DEFAULT]    = "default",
+ 	[MPOL_PREFERRED]  = "prefer",
+	[MPOL_BIND]       = "bind",
+	[MPOL_INTERLEAVE] = "interleave",
+	[MPOL_LOCAL]      = "local"
+};
 
 
 #ifdef CONFIG_TMPFS
@@ -2214,7 +2220,7 @@ int mpol_parse_str(char *str, struct mem
 		*flags++ = '\0';	/* terminate mode string */
 
 	for (mode = 0; mode <= MPOL_LOCAL; mode++) {
-		if (!strcmp(str, policy_types[mode])) {
+		if (!strcmp(str, policy_modes[mode])) {
 			break;
 		}
 	}
@@ -2369,11 +2375,11 @@ int mpol_to_str(char *buffer, int maxlen
 		BUG();
 	}
 
-	l = strlen(policy_types[mode]);
+	l = strlen(policy_modes[mode]);
 	if (buffer + maxlen < p + l + 1)
 		return -ENOSPC;
 
-	strcpy(p, policy_types[mode]);
+	strcpy(p, policy_modes[mode]);
 	p += l;
 
 	if (flags & MPOL_MODE_FLAGS) {
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

