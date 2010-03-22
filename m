From: akpm@linux-foundation.org
Subject: + mempolicy-document-cpuset-interaction-with-tmpfs-mpol-mount-option.patch added to -mm tree
Date: Mon, 22 Mar 2010 16:58:22 -0700
Message-ID: <201003222358.o2MNwMNo002484@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58411 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754500Ab0CVX6h (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 22 Mar 2010 19:58:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lee.schermerhorn@hp.com, cl@linux-foundation.org, hugh.dickins@tiscali.co.uk, kiran@scalex86.org, kosaki.motohiro@jp.fujitsu.com, rientjes@google.com


The patch titled
     mempolicy: document cpuset interaction with tmpfs mpol mount option
has been added to the -mm tree.  Its filename is
     mempolicy-document-cpuset-interaction-with-tmpfs-mpol-mount-option.patch

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
Subject: mempolicy: document cpuset interaction with tmpfs mpol mount option
From: Lee Schermerhorn <lee.schermerhorn@hp.com>

Update Documentation/filesystems/tmpfs.txt to describe the interaction of
tmpfs mount option memory policy with tasks' cpuset mems_allowed.

Note: the mount(8) man page [in the util-linux-ng package] requires
similiar updates.

Signed-off-by: Lee Schermerhorn <lee.schermerhorn@hp.com>
Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: Ravikiran Thirumalai <kiran@scalex86.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/tmpfs.txt |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff -puN Documentation/filesystems/tmpfs.txt~mempolicy-document-cpuset-interaction-with-tmpfs-mpol-mount-option Documentation/filesystems/tmpfs.txt
--- a/Documentation/filesystems/tmpfs.txt~mempolicy-document-cpuset-interaction-with-tmpfs-mpol-mount-option
+++ a/Documentation/filesystems/tmpfs.txt
@@ -94,11 +94,19 @@ NodeList format is a comma-separated lis
 a range being two hyphen-separated decimal numbers, the smallest and
 largest node numbers in the range.  For example, mpol=bind:0-3,5,7,9-15
 
+A memory policy with a valid NodeList will be saved, as specified, for
+use at file creation time.  When a task allocates a file in the file
+system, the mount option memory policy will be applied with a NodeList,
+if any, modified by the calling task's cpuset constraints
+[See Documentation/cgroups/cpusets.txt] and any optional flags, listed
+below.  If the resulting NodeLists is the empty set, the effective memory
+policy for the file will revert to "default" policy.
+
 NUMA memory allocation policies have optional flags that can be used in
 conjunction with their modes.  These optional flags can be specified
 when tmpfs is mounted by appending them to the mode before the NodeList.
 See Documentation/vm/numa_memory_policy.txt for a list of all available
-memory allocation policy mode flags.
+memory allocation policy mode flags and their effect on memory policy.
 
 	=static		is equivalent to	MPOL_F_STATIC_NODES
 	=relative	is equivalent to	MPOL_F_RELATIVE_NODES
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

