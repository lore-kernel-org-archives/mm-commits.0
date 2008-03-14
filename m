From: akpm@linux-foundation.org
Subject: + keys-make-key_serial-a-function-if-config_keys=y.patch added to -mm tree
Date: Fri, 14 Mar 2008 12:58:49 -0700
Message-ID: <200803141958.m2EJwnDl016720@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36705 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753632AbYCNT7l (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 14 Mar 2008 15:59:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dhowells@redhat.com


The patch titled
     keys: make key_serial() a function if CONFIG_KEYS=y
has been added to the -mm tree.  Its filename is
     keys-make-key_serial-a-function-if-config_keys=y.patch

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
Subject: keys: make key_serial() a function if CONFIG_KEYS=y
From: David Howells <dhowells@redhat.com>

Make key_serial() an inline function rather than a macro if CONFIG_KEYS=y. 
This prevents double evaluation of the key pointer and also provides better
type checking.

Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/key.h |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN include/linux/key.h~keys-make-key_serial-a-function-if-config_keys=y include/linux/key.h
--- a/include/linux/key.h~keys-make-key_serial-a-function-if-config_keys=y
+++ a/include/linux/key.h
@@ -264,7 +264,10 @@ extern int keyring_add_key(struct key *k
 
 extern struct key *key_lookup(key_serial_t id);
 
-#define key_serial(key) ((key) ? (key)->serial : 0)
+static inline key_serial_t key_serial(struct key *key)
+{
+	return key ? key->serial : 0;
+}
 
 #ifdef CONFIG_SYSCTL
 extern ctl_table key_sysctls[];
_

Patches currently in -mm which might be from dhowells@redhat.com are

origin.patch
pm-remove-legacy-pm.patch
git-unionfs.patch
romfs-prevent-romfs_lookup-from-always-failing.patch
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
keys-explicitly-include-required-slabh-header-file.patch
keys-document-making-the-keyring-quotas-controllable-through-proc-sys.patch
keys-make-key_serial-a-function-if-config_keys=y.patch
procfs-task-exe-symlink.patch
procfs-task-exe-symlink-fix.patch
procfs-task-exe-symlink-fix-2.patch
alloc_uid-cleanup.patch
mutex-subsystem-synchro-test-module.patch

