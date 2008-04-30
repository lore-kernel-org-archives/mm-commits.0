From: akpm@linux-foundation.org
Subject: - keys-make-the-keyring-quotas-controllable-through-proc-sys.patch removed from -mm tree
Date: Tue, 29 Apr 2008 22:45:34 -0700
Message-ID: <200804300545.m3U5jYpD029511@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55407 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757340AbYD3Fqc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 01:46:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dhowells@redhat.com, arunsr@cse.iitk.ac.in, dwalsh@redhat.com, kwc@citi.umich.edu, mm-commits@vger.kernel.org


The patch titled
     keys: make the keyring quotas controllable through /proc/sys
has been removed from the -mm tree.  Its filename was
     keys-make-the-keyring-quotas-controllable-through-proc-sys.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: keys: make the keyring quotas controllable through /proc/sys
From: David Howells <dhowells@redhat.com>

Make the keyring quotas controllable through /proc/sys files:

 (*) /proc/sys/kernel/keys/root_maxkeys
     /proc/sys/kernel/keys/root_maxbytes

     Maximum number of keys that root may have and the maximum total number of
     bytes of data that root may have stored in those keys.

 (*) /proc/sys/kernel/keys/maxkeys
     /proc/sys/kernel/keys/maxbytes

     Maximum number of keys that each non-root user may have and the maximum
     total number of bytes of data that each of those users may have stored in
     their keys.

Also increase the quotas as a number of people have been complaining that it's
not big enough.  I'm not sure that it's big enough now either, but on the
other hand, it can now be set in /etc/sysctl.conf.

Signed-off-by: David Howells <dhowells@redhat.com>
Cc: <kwc@citi.umich.edu>
Cc: <arunsr@cse.iitk.ac.in>
Cc: <dwalsh@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/keys.txt   |   24 +++++++++++++++++
 include/linux/key.h      |    5 +++
 kernel/sysctl.c          |    9 ++++++
 security/keys/Makefile   |    1 
 security/keys/internal.h |   14 +++++++---
 security/keys/key.c      |   23 +++++++++++++----
 security/keys/keyctl.c   |   12 ++++++--
 security/keys/proc.c     |    9 ++++--
 security/keys/sysctl.c   |   50 +++++++++++++++++++++++++++++++++++++
 9 files changed, 131 insertions(+), 16 deletions(-)

diff -puN Documentation/keys.txt~keys-make-the-keyring-quotas-controllable-through-proc-sys Documentation/keys.txt
--- a/Documentation/keys.txt~keys-make-the-keyring-quotas-controllable-through-proc-sys
+++ a/Documentation/keys.txt
@@ -170,7 +170,8 @@ The key service provides a number of fea
      amount of description and payload space that can be consumed.
 
      The user can view information on this and other statistics through procfs
-     files.
+     files.  The root user may also alter the quota limits through sysctl files
+     (see the section "New procfs files").
 
      Process-specific and thread-specific keyrings are not counted towards a
      user's quota.
@@ -329,6 +330,27 @@ about the status of the key service:
 	<bytes>/<max>		Key size quota
 
 
+Four new sysctl files have been added also for the purpose of controlling the
+quota limits on keys:
+
+ (*) /proc/sys/kernel/keys/root_maxkeys
+     /proc/sys/kernel/keys/root_maxbytes
+
+     These files hold the maximum number of keys that root may have and the
+     maximum total number of bytes of data that root may have stored in those
+     keys.
+
+ (*) /proc/sys/kernel/keys/maxkeys
+     /proc/sys/kernel/keys/maxbytes
+
+     These files hold the maximum number of keys that each non-root user may
+     have and the maximum total number of bytes of data that each of those
+     users may have stored in their keys.
+
+Root may alter these by writing each new limit as a decimal number string to
+the appropriate file.
+
+
 ===============================
 USERSPACE SYSTEM CALL INTERFACE
 ===============================
diff -puN include/linux/key.h~keys-make-the-keyring-quotas-controllable-through-proc-sys include/linux/key.h
--- a/include/linux/key.h~keys-make-the-keyring-quotas-controllable-through-proc-sys
+++ a/include/linux/key.h
@@ -19,6 +19,7 @@
 #include <linux/list.h>
 #include <linux/rbtree.h>
 #include <linux/rcupdate.h>
+#include <linux/sysctl.h>
 #include <asm/atomic.h>
 
 #ifdef __KERNEL__
@@ -265,6 +266,10 @@ extern struct key *key_lookup(key_serial
 
 #define key_serial(key) ((key) ? (key)->serial : 0)
 
+#ifdef CONFIG_SYSCTL
+extern ctl_table key_sysctls[];
+#endif
+
 /*
  * the userspace interface
  */
diff -puN kernel/sysctl.c~keys-make-the-keyring-quotas-controllable-through-proc-sys kernel/sysctl.c
--- a/kernel/sysctl.c~keys-make-the-keyring-quotas-controllable-through-proc-sys
+++ a/kernel/sysctl.c
@@ -38,6 +38,7 @@
 #include <linux/writeback.h>
 #include <linux/hugetlb.h>
 #include <linux/initrd.h>
+#include <linux/key.h>
 #include <linux/times.h>
 #include <linux/limits.h>
 #include <linux/dcache.h>
@@ -809,6 +810,14 @@ static struct ctl_table kern_table[] = {
 		.proc_handler	= &proc_dostring,
 		.strategy	= &sysctl_string,
 	},
+#ifdef CONFIG_KEYS
+	{
+		.ctl_name	= CTL_UNNUMBERED,
+		.procname	= "keys",
+		.mode		= 0555,
+		.child		= key_sysctls,
+	},
+#endif
 /*
  * NOTE: do not add new entries to this table unless you have read
  * Documentation/sysctl/ctl_unnumbered.txt
diff -puN security/keys/Makefile~keys-make-the-keyring-quotas-controllable-through-proc-sys security/keys/Makefile
--- a/security/keys/Makefile~keys-make-the-keyring-quotas-controllable-through-proc-sys
+++ a/security/keys/Makefile
@@ -14,3 +14,4 @@ obj-y := \
 
 obj-$(CONFIG_KEYS_COMPAT) += compat.o
 obj-$(CONFIG_PROC_FS) += proc.o
+obj-$(CONFIG_SYSCTL) += sysctl.o
diff -puN security/keys/internal.h~keys-make-the-keyring-quotas-controllable-through-proc-sys security/keys/internal.h
--- a/security/keys/internal.h~keys-make-the-keyring-quotas-controllable-through-proc-sys
+++ a/security/keys/internal.h
@@ -57,10 +57,6 @@ struct key_user {
 	int			qnbytes;	/* number of bytes allocated to this user */
 };
 
-#define KEYQUOTA_MAX_KEYS	100
-#define KEYQUOTA_MAX_BYTES	10000
-#define KEYQUOTA_LINK_BYTES	4		/* a link in a keyring is worth 4 bytes */
-
 extern struct rb_root	key_user_tree;
 extern spinlock_t	key_user_lock;
 extern struct key_user	root_key_user;
@@ -68,6 +64,16 @@ extern struct key_user	root_key_user;
 extern struct key_user *key_user_lookup(uid_t uid);
 extern void key_user_put(struct key_user *user);
 
+/*
+ * key quota limits
+ * - root has its own separate limits to everyone else
+ */
+extern unsigned key_quota_root_maxkeys;
+extern unsigned key_quota_root_maxbytes;
+extern unsigned key_quota_maxkeys;
+extern unsigned key_quota_maxbytes;
+
+#define KEYQUOTA_LINK_BYTES	4		/* a link in a keyring is worth 4 bytes */
 
 
 extern struct rb_root key_serial_tree;
diff -puN security/keys/key.c~keys-make-the-keyring-quotas-controllable-through-proc-sys security/keys/key.c
--- a/security/keys/key.c~keys-make-the-keyring-quotas-controllable-through-proc-sys
+++ a/security/keys/key.c
@@ -27,6 +27,11 @@ DEFINE_SPINLOCK(key_serial_lock);
 struct rb_root	key_user_tree; /* tree of quota records indexed by UID */
 DEFINE_SPINLOCK(key_user_lock);
 
+unsigned int key_quota_root_maxkeys = 200;	/* root's key count quota */
+unsigned int key_quota_root_maxbytes = 20000;	/* root's key space quota */
+unsigned int key_quota_maxkeys = 200;		/* general key count quota */
+unsigned int key_quota_maxbytes = 20000;	/* general key space quota */
+
 static LIST_HEAD(key_types_list);
 static DECLARE_RWSEM(key_types_sem);
 
@@ -236,11 +241,16 @@ struct key *key_alloc(struct key_type *t
 	/* check that the user's quota permits allocation of another key and
 	 * its description */
 	if (!(flags & KEY_ALLOC_NOT_IN_QUOTA)) {
+		unsigned maxkeys = (uid == 0) ?
+			key_quota_root_maxkeys : key_quota_maxkeys;
+		unsigned maxbytes = (uid == 0) ?
+			key_quota_root_maxbytes : key_quota_maxbytes;
+
 		spin_lock(&user->lock);
 		if (!(flags & KEY_ALLOC_QUOTA_OVERRUN)) {
-			if (user->qnkeys + 1 >= KEYQUOTA_MAX_KEYS ||
-			    user->qnbytes + quotalen >= KEYQUOTA_MAX_BYTES
-			    )
+			if (user->qnkeys + 1 >= maxkeys ||
+			    user->qnbytes + quotalen >= maxbytes ||
+			    user->qnbytes + quotalen < user->qnbytes)
 				goto no_quota;
 		}
 
@@ -345,11 +355,14 @@ int key_payload_reserve(struct key *key,
 
 	/* contemplate the quota adjustment */
 	if (delta != 0 && test_bit(KEY_FLAG_IN_QUOTA, &key->flags)) {
+		unsigned maxbytes = (key->user->uid == 0) ?
+			key_quota_root_maxbytes : key_quota_maxbytes;
+
 		spin_lock(&key->user->lock);
 
 		if (delta > 0 &&
-		    key->user->qnbytes + delta > KEYQUOTA_MAX_BYTES
-		    ) {
+		    (key->user->qnbytes + delta >= maxbytes ||
+		     key->user->qnbytes + delta < key->user->qnbytes)) {
 			ret = -EDQUOT;
 		}
 		else {
diff -puN security/keys/keyctl.c~keys-make-the-keyring-quotas-controllable-through-proc-sys security/keys/keyctl.c
--- a/security/keys/keyctl.c~keys-make-the-keyring-quotas-controllable-through-proc-sys
+++ a/security/keys/keyctl.c
@@ -731,10 +731,16 @@ long keyctl_chown_key(key_serial_t id, u
 
 		/* transfer the quota burden to the new user */
 		if (test_bit(KEY_FLAG_IN_QUOTA, &key->flags)) {
+			unsigned maxkeys = (uid == 0) ?
+				key_quota_root_maxkeys : key_quota_maxkeys;
+			unsigned maxbytes = (uid == 0) ?
+				key_quota_root_maxbytes : key_quota_maxbytes;
+
 			spin_lock(&newowner->lock);
-			if (newowner->qnkeys + 1 >= KEYQUOTA_MAX_KEYS ||
-			    newowner->qnbytes + key->quotalen >=
-			    KEYQUOTA_MAX_BYTES)
+			if (newowner->qnkeys + 1 >= maxkeys ||
+			    newowner->qnbytes + key->quotalen >= maxbytes ||
+			    newowner->qnbytes + key->quotalen <
+			    newowner->qnbytes)
 				goto quota_overrun;
 
 			newowner->qnkeys++;
diff -puN security/keys/proc.c~keys-make-the-keyring-quotas-controllable-through-proc-sys security/keys/proc.c
--- a/security/keys/proc.c~keys-make-the-keyring-quotas-controllable-through-proc-sys
+++ a/security/keys/proc.c
@@ -242,6 +242,10 @@ static int proc_key_users_show(struct se
 {
 	struct rb_node *_p = v;
 	struct key_user *user = rb_entry(_p, struct key_user, node);
+	unsigned maxkeys = (user->uid == 0) ?
+		key_quota_root_maxkeys : key_quota_maxkeys;
+	unsigned maxbytes = (user->uid == 0) ?
+		key_quota_root_maxbytes : key_quota_maxbytes;
 
 	seq_printf(m, "%5u: %5d %d/%d %d/%d %d/%d\n",
 		   user->uid,
@@ -249,10 +253,9 @@ static int proc_key_users_show(struct se
 		   atomic_read(&user->nkeys),
 		   atomic_read(&user->nikeys),
 		   user->qnkeys,
-		   KEYQUOTA_MAX_KEYS,
+		   maxkeys,
 		   user->qnbytes,
-		   KEYQUOTA_MAX_BYTES
-		   );
+		   maxbytes);
 
 	return 0;
 
diff -puN /dev/null security/keys/sysctl.c
--- /dev/null
+++ a/security/keys/sysctl.c
@@ -0,0 +1,50 @@
+/* Key management controls
+ *
+ * Copyright (C) 2008 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+
+#include <linux/key.h>
+#include <linux/sysctl.h>
+#include "internal.h"
+
+ctl_table key_sysctls[] = {
+	{
+		.ctl_name = CTL_UNNUMBERED,
+		.procname = "maxkeys",
+		.data = &key_quota_maxkeys,
+		.maxlen = sizeof(unsigned),
+		.mode = 0644,
+		.proc_handler = &proc_dointvec,
+	},
+	{
+		.ctl_name = CTL_UNNUMBERED,
+		.procname = "maxbytes",
+		.data = &key_quota_maxbytes,
+		.maxlen = sizeof(unsigned),
+		.mode = 0644,
+		.proc_handler = &proc_dointvec,
+	},
+	{
+		.ctl_name = CTL_UNNUMBERED,
+		.procname = "root_maxkeys",
+		.data = &key_quota_root_maxkeys,
+		.maxlen = sizeof(unsigned),
+		.mode = 0644,
+		.proc_handler = &proc_dointvec,
+	},
+	{
+		.ctl_name = CTL_UNNUMBERED,
+		.procname = "root_maxbytes",
+		.data = &key_quota_root_maxbytes,
+		.maxlen = sizeof(unsigned),
+		.mode = 0644,
+		.proc_handler = &proc_dointvec,
+	},
+	{ .ctl_name = 0 }
+};
_

Patches currently in -mm which might be from dhowells@redhat.com are

origin.patch
git-unionfs.patch
alloc_uid-cleanup.patch
rename-div64_64-to-div64_u64.patch
mutex-subsystem-synchro-test-module.patch

