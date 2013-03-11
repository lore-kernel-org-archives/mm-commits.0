From: akpm@linux-foundation.org
Subject: + keys-fix-race-with-concurrent-install_user_keyrings.patch added to -mm tree
Date: Mon, 11 Mar 2013 14:11:54 -0700
Message-ID: <20130311211154.8581A31C18B@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:50433 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754011Ab3CKVLz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 11 Mar 2013 17:11:55 -0400
Received: by mail-qa0-f74.google.com with SMTP id o13so232000qaj.5
        for <mm-commits@vger.kernel.org>; Mon, 11 Mar 2013 14:11:55 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dhowells@redhat.com, james.l.morris@oracle.com, mguzik@redhat.com, stable@kernel.org


The patch titled
     Subject: keys: fix race with concurrent install_user_keyrings()
has been added to the -mm tree.  Its filename is
     keys-fix-race-with-concurrent-install_user_keyrings.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: David Howells <dhowells@redhat.com>
Subject: keys: fix race with concurrent install_user_keyrings()

This fixes CVE-2013-1792.

There is a race in install_user_keyrings() that can cause a NULL pointer
dereference when called concurrently for the same user if the uid and
uid-session keyrings are not yet created.  It might be possible for an
unprivileged user to trigger this by calling keyctl() from userspace in
parallel immediately after logging in.

Assume that we have two threads both executing lookup_user_key(), both
looking for KEY_SPEC_USER_SESSION_KEYRING.

	THREAD A			THREAD B
	===============================	===============================
					==>call install_user_keyrings();
	if (!cred->user->session_keyring)
	==>call install_user_keyrings()
					...
					user->uid_keyring = uid_keyring;
	if (user->uid_keyring)
		return 0;
	<==
	key = cred->user->session_keyring [== NULL]
					user->session_keyring = session_keyring;
	atomic_inc(&key->usage); [oops]

At the point thread A dereferences cred->user->session_keyring, thread B
hasn't updated user->session_keyring yet, but thread A assumes it is
populated because install_user_keyrings() returned ok.

The race window is really small but can be exploited if, for example,
thread B is interrupted or preempted after initializing uid_keyring, but
before doing setting session_keyring.

This couldn't be reproduced on a stock kernel.  However, after placing
systemtap probe on 'user->session_keyring = session_keyring;' that
introduced some delay, the kernel could be crashed reliably.

Fix this by checking both pointers before deciding whether to return. 
Alternatively, the test could be done away with entirely as it is checked
inside the mutex - but since the mutex is global, that may not be the best
way.

Signed-off-by: David Howells <dhowells@redhat.com>
Reported-by: Mateusz Guzik <mguzik@redhat.com>
Acked-by: James Morris <james.l.morris@oracle.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 security/keys/process_keys.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN security/keys/process_keys.c~keys-fix-race-with-concurrent-install_user_keyrings security/keys/process_keys.c
--- a/security/keys/process_keys.c~keys-fix-race-with-concurrent-install_user_keyrings
+++ a/security/keys/process_keys.c
@@ -57,7 +57,7 @@ int install_user_keyrings(void)
 
 	kenter("%p{%u}", user, uid);
 
-	if (user->uid_keyring) {
+	if (user->uid_keyring && user->session_keyring) {
 		kleave(" = 0 [exist]");
 		return 0;
 	}
_

Patches currently in -mm which might be from dhowells@redhat.com are

linux-next.patch
keys-fix-race-with-concurrent-install_user_keyrings.patch
debug_locksh-make-warning-more-verbose.patch
mm-remove-free_area_cache.patch
ptrace-add-ability-to-retrieve-signals-without-removing-from-a-queue-v4.patch
selftest-add-a-test-case-for-ptrace_peeksiginfo.patch
mutex-subsystem-synchro-test-module.patch

