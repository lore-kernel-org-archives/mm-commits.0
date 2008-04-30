From: akpm@linux-foundation.org
Subject: - keys-make-key_serial-a-function-if-config_keys=y.patch removed from -mm tree
Date: Tue, 29 Apr 2008 22:45:38 -0700
Message-ID: <200804300545.m3U5jcOq029523@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40725 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756735AbYD3Fq2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 01:46:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dhowells@redhat.com, mm-commits@vger.kernel.org


The patch titled
     keys: make key_serial() a function if CONFIG_KEYS=y
has been removed from the -mm tree.  Its filename was
     keys-make-key_serial-a-function-if-config_keys=y.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
git-unionfs.patch
alloc_uid-cleanup.patch
rename-div64_64-to-div64_u64.patch
mutex-subsystem-synchro-test-module.patch

