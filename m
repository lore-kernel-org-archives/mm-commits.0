From: akpm@linux-foundation.org
Subject: + kernel-audit_treec-audit_add_tree_rule-protect-rule-from-kill_rules.patch added to -mm tree
Date: Thu, 09 May 2013 13:11:18 -0700
Message-ID: <20130509201118.93A3B31C022@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:42164 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753213Ab3EIULT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 May 2013 16:11:19 -0400
Received: by mail-gg0-f202.google.com with SMTP id 4so329090ggm.5
        for <mm-commits@vger.kernel.org>; Thu, 09 May 2013 13:11:19 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: gang.chen@asianux.com, eparis@redhat.com, viro@zeniv.linux.org.uk


The patch titled
     Subject: kernel/audit_tree.c:audit_add_tree_rule(): protect `rule' from kill_rules()
has been added to the -mm tree.  Its filename is
     kernel-audit_treec-audit_add_tree_rule-protect-rule-from-kill_rules.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
kernel-audit_treec-audit_add_tree_rule-protect-rule-from-kill_rules.patch
posix-timers-correctly-get-dying-task-time-sample-in-posix_cpu_timer_schedule.patch

