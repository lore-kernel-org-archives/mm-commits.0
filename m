From: akpm@linux-foundation.org
Subject: - keys-make-the-keyring-quotas-controllable-through-proc-sys-fix.patch removed from -mm tree
Date: Mon, 28 Apr 2008 22:55:08 -0700
Message-ID: <200804290555.m3T5t8sB004051@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43010 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753957AbYD2F5H (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 Apr 2008 01:57:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dhowells@redhat.com, arunsr@cse.iitk.ac.in, dwalsh@redhat.com, kwc@citi.umich.edu, mm-commits@vger.kernel.org


The patch titled
     KEYS: Make the keyring quotas controllable through /proc/sys (fix)
has been removed from the -mm tree.  Its filename was
     keys-make-the-keyring-quotas-controllable-through-proc-sys-fix.patch

This patch was dropped because it was folded into keys-make-the-keyring-quotas-controllable-through-proc-sys.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: KEYS: Make the keyring quotas controllable through /proc/sys (fix)
From: David Howells <dhowells@redhat.com>

Oops.  Here's a copy of the patch *with* sysctl.c.  Note that I've folded the
doc updates patch into this one.

Signed-off-by: David Howells <dhowells@redhat.com>
Cc: <kwc@citi.umich.edu>
Cc: <arunsr@cse.iitk.ac.in>
Cc: <dwalsh@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/keys.txt |   24 +++++++++++++++++-
 security/keys/sysctl.c |   50 +++++++++++++++++++++++++++++++++++++++
 2 files changed, 73 insertions(+), 1 deletion(-)

diff -puN Documentation/keys.txt~keys-make-the-keyring-quotas-controllable-through-proc-sys-fix Documentation/keys.txt
--- a/Documentation/keys.txt~keys-make-the-keyring-quotas-controllable-through-proc-sys-fix
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
remove-the-macro-get_personality.patch
fdpic-check-that-the-size-returned-by-kernel_read-is-what-we-asked-for.patch
maintainers-clarify-status-of-mn10300-mailing-list-as-moderated.patch
xattr-add-missing-consts-to-function-arguments.patch
keys-increase-the-payload-size-when-instantiating-a-key.patch
keys-check-starting-keyring-as-part-of-search.patch
keys-allow-the-callout-data-to-be-passed-as-a-blob-rather-than-a-string.patch
keys-add-keyctl-function-to-get-a-security-label.patch
keys-switch-to-proc_create.patch
keys-allow-clients-to-set-key-perms-in-key_create_or_update.patch
keys-dont-generate-user-and-user-session-keyrings-unless-theyre-accessed.patch
keys-make-the-keyring-quotas-controllable-through-proc-sys.patch
keys-make-the-keyring-quotas-controllable-through-proc-sys-fix.patch
keys-explicitly-include-required-slabh-header-file.patch
keys-make-key_serial-a-function-if-config_keys=y.patch
procfs-task-exe-symlink.patch
procfs-task-exe-symlink-fix.patch
procfs-task-exe-symlink-fix-2.patch
proc-introduce-proc_create_data-to-setup-de-data.patch
afs-use-non-racy-method-for-proc-entries-creation.patch
alloc_uid-cleanup.patch
rename-div64_64-to-div64_u64.patch
afs-use-the-shorter-list_head-for-brevity.patch
afs-the-afs-rpc-op-cbgetcapabilities-is-actually-cbtellmeaboutyourself.patch
afs-the-afs-rpc-op-cbgetcapabilities-is-actually-cbtellmeaboutyourself-try-3.patch
afs-support-the-cbprobeuuid-rpc-op.patch
add-kbuildh-that-contains-common-definitions-for-kbuild-users.patch
frv-use-kbuildh-instead-of-defining-macros-in-asm-offsetsc.patch
mn10300-use-kbuildh-instead-of-defining-macros-in-asm-offsetsc.patch
mutex-subsystem-synchro-test-module.patch

