From: akpm@linux-foundation.org
Subject: + keys-split-call-to-call_usermodehelper_fns.patch added to -mm tree
Date: Tue, 12 Mar 2013 13:32:36 -0700
Message-ID: <20130312203236.D824F5A4260@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:33517 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932514Ab3CLUci (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 12 Mar 2013 16:32:38 -0400
Received: by mail-gg0-f202.google.com with SMTP id l4so32126ggi.1
        for <mm-commits@vger.kernel.org>; Tue, 12 Mar 2013 13:32:37 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lucas.demarchi@profusion.mobi, dhowells@redhat.com, james.l.morris@oracle.com, oleg@redhat.com, rjw@sisk.pl, tj@kernel.org, viro@zeniv.linux.org.uk


The patch titled
     Subject: KEYS: split call to call_usermodehelper_fns()
has been added to the -mm tree.  Its filename is
     keys-split-call-to-call_usermodehelper_fns.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Lucas De Marchi <lucas.demarchi@profusion.mobi>
Subject: KEYS: split call to call_usermodehelper_fns()

Use call_usermodehelper_setup() + call_usermodehelper_exec() instead of
calling call_usermodehelper_fns().  In case there's an OOM in this last
function the cleanup function may not be called - in this case we would
miss a call to key_put().

Signed-off-by: Lucas De Marchi <lucas.demarchi@profusion.mobi>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: David Howells <dhowells@redhat.com>
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

kernel-sysc-use-the-simpler-call_usermodehelper.patch
usermodehelper-export-_exec-and-_setup-functions.patch
kmod-split-call-to-call_usermodehelper_fns.patch
keys-split-call-to-call_usermodehelper_fns.patch
coredump-remove-trailling-whitespaces.patch
split-remaining-calls-to-call_usermodehelper_fns.patch
kmod-remove-call_usermodehelper_fns.patch

