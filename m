From: akpm@linux-foundation.org
Subject: - keys-switch-to-proc_create.patch removed from -mm tree
Date: Tue, 29 Apr 2008 22:45:24 -0700
Message-ID: <200804300545.m3U5jOPV029500@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50707 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751083AbYD3GIi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 02:08:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@sw.ru, dhowells@redhat.com, mm-commits@vger.kernel.org


The patch titled
     keys: switch to proc_create()
has been removed from the -mm tree.  Its filename was
     keys-switch-to-proc_create.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: keys: switch to proc_create()
From: Alexey Dobriyan <adobriyan@sw.ru>

Signed-off-by: Alexey Dobriyan <adobriyan@sw.ru>
Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 security/keys/proc.c |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff -puN security/keys/proc.c~keys-switch-to-proc_create security/keys/proc.c
--- a/security/keys/proc.c~keys-switch-to-proc_create
+++ a/security/keys/proc.c
@@ -70,19 +70,15 @@ static int __init key_proc_init(void)
 	struct proc_dir_entry *p;
 
 #ifdef CONFIG_KEYS_DEBUG_PROC_KEYS
-	p = create_proc_entry("keys", 0, NULL);
+	p = proc_create("keys", 0, NULL, &proc_keys_fops);
 	if (!p)
 		panic("Cannot create /proc/keys\n");
-
-	p->proc_fops = &proc_keys_fops;
 #endif
 
-	p = create_proc_entry("key-users", 0, NULL);
+	p = proc_create("key-users", 0, NULL, &proc_key_users_fops);
 	if (!p)
 		panic("Cannot create /proc/key-users\n");
 
-	p->proc_fops = &proc_key_users_fops;
