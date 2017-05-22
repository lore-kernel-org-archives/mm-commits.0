From: akpm@linux-foundation.org
Subject: + ocfs2-get-rid-of-ocfs2_is_o2cb_active-function.patch added to
 -mm tree
Date: Mon, 22 May 2017 14:13:52 -0700
Message-ID: <59235490.qRNyyt4pXVECCQrb%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43508 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934015AbdEVVNx (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 22 May 2017 17:13:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ghe@suse.com, jiangqi903@gmail.com, jlbec@evilplan.org, junxiao.bi@oracle.com, mfasheh@versity.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: remove ocfs2_is_o2cb_active()
has been added to the -mm tree.  Its filename is
     ocfs2-get-rid-of-ocfs2_is_o2cb_active-function.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-get-rid-of-ocfs2_is_o2cb_active-function.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-get-rid-of-ocfs2_is_o2cb_active-function.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Gang He <ghe@suse.com>
Subject: ocfs2: remove ocfs2_is_o2cb_active()

Remove ocfs2_is_o2cb_active().  We have similar functions to identify
which cluster stack is being used via osb->osb_cluster_stack.

Secondly, the current implementation of ocfs2_is_o2cb_active() is not
totally safe.  Based on the design of stackglue, we need to get
ocfs2_stack_lock before using ocfs2_stack related data structures, and
that active_stack pointer can be NULL in the case of mount failure.

Link: http://lkml.kernel.org/r/1495441079-11708-1-git-send-email-ghe@suse.com
Signed-off-by: Gang He <ghe@suse.com>
Cc: Mark Fasheh <mfasheh@versity.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Joseph Qi <jiangqi903@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/dlmglue.c   |    2 +-
 fs/ocfs2/stackglue.c |    6 ------
 fs/ocfs2/stackglue.h |    3 ---
 3 files changed, 1 insertion(+), 10 deletions(-)

diff -puN fs/ocfs2/dlmglue.c~ocfs2-get-rid-of-ocfs2_is_o2cb_active-function fs/ocfs2/dlmglue.c
--- a/fs/ocfs2/dlmglue.c~ocfs2-get-rid-of-ocfs2_is_o2cb_active-function
+++ a/fs/ocfs2/dlmglue.c
@@ -3409,7 +3409,7 @@ static int ocfs2_downconvert_lock(struct
 	 * we can recover correctly from node failure. Otherwise, we may get
 	 * invalid LVB in LKB, but without DLM_SBF_VALNOTVALID being set.
 	 */
-	if (!ocfs2_is_o2cb_active() &&
+	if (ocfs2_userspace_stack(osb) &&
 	    lockres->l_ops->flags & LOCK_TYPE_USES_LVB)
 		lvb = 1;
 
diff -puN fs/ocfs2/stackglue.c~ocfs2-get-rid-of-ocfs2_is_o2cb_active-function fs/ocfs2/stackglue.c
--- a/fs/ocfs2/stackglue.c~ocfs2-get-rid-of-ocfs2_is_o2cb_active-function
+++ a/fs/ocfs2/stackglue.c
@@ -48,12 +48,6 @@ static char ocfs2_hb_ctl_path[OCFS2_MAX_
  */
 static struct ocfs2_stack_plugin *active_stack;
 
-inline int ocfs2_is_o2cb_active(void)
-{
-	return !strcmp(active_stack->sp_name, OCFS2_STACK_PLUGIN_O2CB);
-}
-EXPORT_SYMBOL_GPL(ocfs2_is_o2cb_active);
-
 static struct ocfs2_stack_plugin *ocfs2_stack_lookup(const char *name)
 {
 	struct ocfs2_stack_plugin *p;
diff -puN fs/ocfs2/stackglue.h~ocfs2-get-rid-of-ocfs2_is_o2cb_active-function fs/ocfs2/stackglue.h
--- a/fs/ocfs2/stackglue.h~ocfs2-get-rid-of-ocfs2_is_o2cb_active-function
+++ a/fs/ocfs2/stackglue.h
@@ -298,9 +298,6 @@ void ocfs2_stack_glue_set_max_proto_vers
 int ocfs2_stack_glue_register(struct ocfs2_stack_plugin *plugin);
 void ocfs2_stack_glue_unregister(struct ocfs2_stack_plugin *plugin);
 
-/* In ocfs2_downconvert_lock(), we need to know which stack we are using */
-int ocfs2_is_o2cb_active(void);
