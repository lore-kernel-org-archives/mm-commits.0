From: akpm@linux-foundation.org
Subject: + cgroup-files-clean-up-whitespace-in-struct-cftype.patch added to -mm tree
Date: Tue, 24 Jun 2008 16:24:44 -0700
Message-ID: <200806242324.m5ONOiTr011635@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49866 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751484AbYFXXZi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 24 Jun 2008 19:25:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: menage@google.com, balbir@in.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, pj@sgi.com, serue@us.ibm.com, xemul@openvz.org


The patch titled
     cgroup files: clean up whitespace in struct cftype
has been added to the -mm tree.  Its filename is
     cgroup-files-clean-up-whitespace-in-struct-cftype.patch

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
Subject: cgroup files: clean up whitespace in struct cftype
From: Paul Menage <menage@google.com>

This patch removes some extraneous spaces from method declarations in
struct cftype, to fit in with conventional kernel style.

Signed-off-by: Paul Menage <menage@google.com>
Cc: Paul Jackson <pj@sgi.com>
Cc: Pavel Emelyanov <xemul@openvz.org>
Cc: Balbir Singh <balbir@in.ibm.com>
Cc: Serge Hallyn <serue@us.ibm.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/cgroup.h |   32 ++++++++++++++++----------------
 1 file changed, 16 insertions(+), 16 deletions(-)

diff -puN include/linux/cgroup.h~cgroup-files-clean-up-whitespace-in-struct-cftype include/linux/cgroup.h
--- a/include/linux/cgroup.h~cgroup-files-clean-up-whitespace-in-struct-cftype
+++ a/include/linux/cgroup.h
@@ -205,48 +205,48 @@ struct cftype {
 	 * subsystem, followed by a period */
 	char name[MAX_CFTYPE_NAME];
 	int private;
-	int (*open) (struct inode *inode, struct file *file);
-	ssize_t (*read) (struct cgroup *cgrp, struct cftype *cft,
-			 struct file *file,
-			 char __user *buf, size_t nbytes, loff_t *ppos);
+	int (*open)(struct inode *inode, struct file *file);
+	ssize_t (*read)(struct cgroup *cgrp, struct cftype *cft,
+			struct file *file,
+			char __user *buf, size_t nbytes, loff_t *ppos);
 	/*
 	 * read_u64() is a shortcut for the common case of returning a
 	 * single integer. Use it in place of read()
 	 */
-	u64 (*read_u64) (struct cgroup *cgrp, struct cftype *cft);
+	u64 (*read_u64)(struct cgroup *cgrp, struct cftype *cft);
 	/*
 	 * read_s64() is a signed version of read_u64()
 	 */
-	s64 (*read_s64) (struct cgroup *cgrp, struct cftype *cft);
+	s64 (*read_s64)(struct cgroup *cgrp, struct cftype *cft);
 	/*
 	 * read_map() is used for defining a map of key/value
 	 * pairs. It should call cb->fill(cb, key, value) for each
 	 * entry. The key/value pairs (and their ordering) should not
 	 * change between reboots.
 	 */
-	int (*read_map) (struct cgroup *cont, struct cftype *cft,
-			 struct cgroup_map_cb *cb);
+	int (*read_map)(struct cgroup *cont, struct cftype *cft,
+			struct cgroup_map_cb *cb);
 	/*
 	 * read_seq_string() is used for outputting a simple sequence
 	 * using seqfile.
 	 */
-	int (*read_seq_string) (struct cgroup *cont, struct cftype *cft,
-			 struct seq_file *m);
+	int (*read_seq_string)(struct cgroup *cont, struct cftype *cft,
+			       struct seq_file *m);
 
-	ssize_t (*write) (struct cgroup *cgrp, struct cftype *cft,
-			  struct file *file,
-			  const char __user *buf, size_t nbytes, loff_t *ppos);
+	ssize_t (*write)(struct cgroup *cgrp, struct cftype *cft,
+			 struct file *file,
+			 const char __user *buf, size_t nbytes, loff_t *ppos);
 
 	/*
 	 * write_u64() is a shortcut for the common case of accepting
 	 * a single integer (as parsed by simple_strtoull) from
 	 * userspace. Use in place of write(); return 0 or error.
 	 */
-	int (*write_u64) (struct cgroup *cgrp, struct cftype *cft, u64 val);
+	int (*write_u64)(struct cgroup *cgrp, struct cftype *cft, u64 val);
 	/*
 	 * write_s64() is a signed version of write_u64()
 	 */
-	int (*write_s64) (struct cgroup *cgrp, struct cftype *cft, s64 val);
+	int (*write_s64)(struct cgroup *cgrp, struct cftype *cft, s64 val);
 
 	/*
 	 * trigger() callback can be used to get some kick from the
@@ -256,7 +256,7 @@ struct cftype {
 	 */
 	int (*trigger)(struct cgroup *cgrp, unsigned int event);
 
-	int (*release) (struct inode *inode, struct file *file);
+	int (*release)(struct inode *inode, struct file *file);
 };
 
 struct cgroup_scanner {
_

Patches currently in -mm which might be from menage@google.com are

call_usermodehelper-increase-reliability.patch
cgroup-use-read-lock-to-guard-find_existing_css_set.patch
mark-res_counter_charge_locked-with-__must_check.patch
cgroup-list_for_each-cleanup-v2.patch
cgroup-anotate-two-variables-with-__read_mostly.patch
cgroup-files-clean-up-whitespace-in-struct-cftype.patch
cgroup-files-add-write_string-cgroup-control-file-method.patch
cgroup-files-move-the-release_agent-file-to-use-typed-handlers.patch
cgroup-files-move-notify_on_release-file-to-separate-write-handler.patch
cgroup-files-turn-attach_task_by_pid-directly-into-a-cgroup-write-handler.patch
cgroup-files-remove-cpuset_common_file_write.patch
cgroup-files-convert-devcgroup_access_write-into-a-cgroup-write_string-handler.patch
cgroup-files-convert-res_counter_write-to-be-a-cgroups-write_string-handler.patch
memcg-remove-refcnt-from-page_cgroup.patch
memcg-remove-refcnt-from-page_cgroup-fix.patch
memcg-remove-refcnt-from-page_cgroup-fix-2.patch
memcg-handle-swap-cache.patch
memcg-handle-swap-cache-fix.patch
memcg-helper-function-for-relcaim-from-shmem.patch
memcg-add-hints-for-branch.patch
memcg-remove-a-redundant-check.patch
memrlimit-add-memrlimit-controller-documentation.patch
memrlimit-setup-the-memrlimit-controller.patch
memrlimit-cgroup-mm-owner-callback-changes-to-add-task-info.patch
memrlimit-add-memrlimit-controller-accounting-and-control.patch
memrlimit-setup-the-memrlimit-controller-cgroup-files-convert-res_counter_write-to-be-a-cgroups-write_string-handler-memrlimitcgroup.patch
cpusets-update-tasks-cpus_allowed-and-mems_allowed-after-cpu-node-offline-online.patch
make-cgroup_seqfile_release-static.patch
add-a-refcount-check-in-dput.patch

