From: akpm@linux-foundation.org
Subject: [merged]
 kernel-audit_treec-audit_add_tree_rule-protect-rule-from-kill_rules.patch
 removed from -mm tree
Date: Thu, 13 Jun 2013 11:58:08 -0700
Message-ID: <51ba1640.Uuxy1AjClfG1GiUf%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37139 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756646Ab3FMS6J (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 13 Jun 2013 14:58:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk, eparis@redhat.com, gang.chen@asianux.com

Subject: [merged] kernel-audit_treec-audit_add_tree_rule-protect-rule-from-kill_rules.patch removed from -mm tree
To: gang.chen@asianux.com,eparis@redhat.com,viro@zeniv.linux.org.uk,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 13 Jun 2013 11:58:08 -0700


The patch titled
     Subject: kernel/audit_tree.c:audit_add_tree_rule(): protect `rule' from kill_rules()
has been removed from the -mm tree.  Its filename was
     kernel-audit_treec-audit_add_tree_rule-protect-rule-from-kill_rules.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Chen Gang <gang.chen@asianux.com>
Subject: kernel/audit_tree.c:audit_add_tree_rule(): protect `rule' from kill_rules()

audit_add_tree_rule() must set 'rule->tree = NULL;' firstly, to protect
the rule itself freed in kill_rules().

The reason is when it is killed, the 'rule' itself may have already
released, we should not access it.  one example: we add a rule to an
inode, just at the same time the other task is deleting this inode.

The work flow for adding a rule:

    audit_receive() -> (need audit_cmd_mutex lock)
      audit_receive_skb() ->
        audit_receive_msg() ->
          audit_receive_filter() ->
            audit_add_rule() ->
              audit_add_tree_rule() -> (need audit_filter_mutex lock)
                ...
                unlock audit_filter_mutex
                get_tree()
                ...
                iterate_mounts() -> (iterate all related inodes)
                  tag_mount() ->
                    tag_trunk() ->
                      create_trunk() -> (assume it is 1st rule)
                        fsnotify_add_mark() ->
                          fsnotify_add_inode_mark() ->  (add mark to inode->i_fsnotify_marks)
                        ...
                        get_tree(); (each inode will get one)
                ...
                lock audit_filter_mutex

The work flow for deleting an inode:

    __destroy_inode() ->
     fsnotify_inode_delete() ->
       __fsnotify_inode_delete() ->
        fsnotify_clear_marks_by_inode() ->  (get mark from inode->i_fsnotify_marks)
          fsnotify_destroy_mark() ->
           fsnotify_destroy_mark_locked() ->
             audit_tree_freeing_mark() ->
               evict_chunk() ->
                 ...
                 tree->goner = 1
                 ...
                 kill_rules() ->   (assume current->audit_context == NULL)
                   call_rcu() ->   (rule->tree != NULL)
                     audit_free_rule_rcu() ->
                       audit_free_rule()
                 ...
                 audit_schedule_prune() ->  (assume current->audit_context == NULL)
                   kthread_run() ->    (need audit_cmd_mutex and audit_filter_mutex lock)
                     prune_one() ->    (delete it from prue_list)
                       put_tree(); (match the original get_tree above)


Signed-off-by: Chen Gang <gang.chen@asianux.com>
Cc: Eric Paris <eparis@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/audit_tree.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN kernel/audit_tree.c~kernel-audit_treec-audit_add_tree_rule-protect-rule-from-kill_rules kernel/audit_tree.c
--- a/kernel/audit_tree.c~kernel-audit_treec-audit_add_tree_rule-protect-rule-from-kill_rules
+++ a/kernel/audit_tree.c
@@ -658,6 +658,7 @@ int audit_add_tree_rule(struct audit_kru
 	struct vfsmount *mnt;
 	int err;
 
+	rule->tree = NULL;
 	list_for_each_entry(tree, &tree_list, list) {
 		if (!strcmp(seed->pathname, tree->pathname)) {
 			put_tree(seed);
_

Patches currently in -mm which might be from gang.chen@asianux.com are

origin.patch
linux-next.patch
kernel-auditfilterc-fix-leak-in-audit_add_rule-error-path.patch
posix-timers-correctly-get-dying-task-time-sample-in-posix_cpu_timer_schedule.patch
mm-page_allocc-add-additional-checking-and-return-value-for-the-table-data.patch
mm-nommuc-add-additional-check-for-vread-just-like-vwrite-has-done.patch
arch-frv-kernel-trapsc-using-vsnprintf-instead-of-vsprintf.patch
arch-frv-kernel-setupc-use-strncmp-instead-of-memcmp.patch

