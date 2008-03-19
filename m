From: akpm@linux-foundation.org
Subject: - keys-document-making-the-keyring-quotas-controllable-through-proc-sys.patch removed from -mm tree
Date: Wed, 19 Mar 2008 13:56:39 -0700
Message-ID: <200803192056.m2JKudsp002145@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46213 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965214AbYCSVCV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 19 Mar 2008 17:02:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dhowells@redhat.com, mm-commits@vger.kernel.org


The patch titled
     keys: document making the keyring quotas controllable through /proc/sys
has been removed from the -mm tree.  Its filename was
     keys-document-making-the-keyring-quotas-controllable-through-proc-sys.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: keys: document making the keyring quotas controllable through /proc/sys
From: David Howells <dhowells@redhat.com>

Alter the key management documentation to include information on keyring quota
controls as added in a previous patch.

Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/keys.txt |   24 +++++++++++++++++++++++-
 1 file changed, 23 insertions(+), 1 deletion(-)

diff -puN Documentation/keys.txt~keys-document-making-the-keyring-quotas-controllable-through-proc-sys Documentation/keys.txt
--- a/Documentation/keys.txt~keys-document-making-the-keyring-quotas-controllable-through-proc-sys
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
_

Patches currently in -mm which might be from dhowells@redhat.com are

romfs-fix-up-an-error-in-iget-removal.patch
git-unionfs.patch
remove-the-macro-get_personality.patch
keys-increase-the-payload-size-when-instantiating-a-key.patch
keys-check-starting-keyring-as-part-of-search.patch
keys-allow-the-callout-data-to-be-passed-as-a-blob-rather-than-a-string.patch
keys-add-keyctl-function-to-get-a-security-label.patch
keys-add-keyctl-function-to-get-a-security-label-fix.patch
keys-switch-to-proc_create.patch
keys-allow-clients-to-set-key-perms-in-key_create_or_update.patch
keys-dont-generate-user-and-user-session-keyrings-unless-theyre-accessed.patch
keys-make-the-keyring-quotas-controllable-through-proc-sys.patch
keys-make-the-keyring-quotas-controllable-through-proc-sys-fix.patch
keys-explicitly-include-required-slabh-header-file.patch
keys-document-making-the-keyring-quotas-controllable-through-proc-sys.patch
keys-make-key_serial-a-function-if-config_keys=y.patch
procfs-task-exe-symlink.patch
procfs-task-exe-symlink-fix.patch
procfs-task-exe-symlink-fix-2.patch
alloc_uid-cleanup.patch
rename-div64_64-to-div64_u64.patch
mutex-subsystem-synchro-test-module.patch

