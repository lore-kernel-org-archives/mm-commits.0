From: akpm@linux-foundation.org
Subject: + keys-switch-to-proc_create.patch added to -mm tree
Date: Wed, 27 Feb 2008 22:29:20 -0800
Message-ID: <200802280629.m1S6TKmG019466@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:37990 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751582AbYB1GbS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 28 Feb 2008 01:31:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adobriyan@sw.ru, dhowells@redhat.com


The patch titled
     keys: switch to proc_create()
has been added to the -mm tree.  Its filename is
     keys-switch-to-proc_create.patch

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
-
 	return 0;
 
 } /* end key_proc_init() */
_

Patches currently in -mm which might be from adobriyan@sw.ru are

proc-print-more-information-when-removing-non-empty-directories.patch
single_open-seq_release-leak-diagnostics.patch
proc-switch-to-proc_create.patch
keys-switch-to-proc_create.patch
crypto-switch-to-proc_create.patch
