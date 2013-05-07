From: akpm@linux-foundation.org
Subject: [merged] keys-split-call-to-call_usermodehelper_fns.patch removed from -mm tree
Date: Tue, 07 May 2013 10:49:12 -0700
Message-ID: <20130507174912.8EC0A31C2FF@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:36961 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756103Ab3EGRtN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 May 2013 13:49:13 -0400
Received: by mail-vb0-f74.google.com with SMTP id q16so85291vbe.3
        for <mm-commits@vger.kernel.org>; Tue, 07 May 2013 10:49:13 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lucas.demarchi@profusion.mobi, dhowells@redhat.com, james.l.morris@oracle.com, oleg@redhat.com, rjw@sisk.pl, tj@kernel.org, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: KEYS: split call to call_usermodehelper_fns()
has been removed from the -mm tree.  Its filename was
     keys-split-call-to-call_usermodehelper_fns.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Lucas De Marchi <lucas.demarchi@profusion.mobi>
Subject: KEYS: split call to call_usermodehelper_fns()

Use call_usermodehelper_setup() + call_usermodehelper_exec() instead of
calling call_usermodehelper_fns().  In case there's an OOM in this last
function the cleanup function may not be called - in this case we would
miss a call to key_put().

Signed-off-by: Lucas De Marchi <lucas.demarchi@profusion.mobi>
Cc: Oleg Nesterov <oleg@redhat.com>
Acked-by: David Howells <dhowells@redhat.com>
Acked-by: James Morris <james.l.morris@oracle.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Tejun Heo <tj@kernel.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 security/keys/request_key.c |   13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff -puN security/keys/request_key.c~keys-split-call-to-call_usermodehelper_fns security/keys/request_key.c
--- a/security/keys/request_key.c~keys-split-call-to-call_usermodehelper_fns
+++ a/security/keys/request_key.c
@@ -93,9 +93,16 @@ static void umh_keys_cleanup(struct subp
 static int call_usermodehelper_keys(char *path, char **argv, char **envp,
 					struct key *session_keyring, int wait)
 {
-	return call_usermodehelper_fns(path, argv, envp, wait,
-				       umh_keys_init, umh_keys_cleanup,
-				       key_get(session_keyring));
+	struct subprocess_info *info;
+
+	info = call_usermodehelper_setup(path, argv, envp, GFP_KERNEL,
+					  umh_keys_init, umh_keys_cleanup,
+					  session_keyring);
+	if (!info)
+		return -ENOMEM;
+
+	key_get(session_keyring);
+	return call_usermodehelper_exec(info, wait);
 }
 
 /*
_

Patches currently in -mm which might be from lucas.demarchi@profusion.mobi are

origin.patch

