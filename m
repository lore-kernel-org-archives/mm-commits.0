From: akpm@linux-foundation.org
Subject: + keys-propagate-error-code-instead-of-returning-einval.patch added to -mm tree
Date: Thu, 03 Jun 2010 12:35:24 -0700
Message-ID: <201006031935.o53JZO2M011353@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55547 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755593Ab0FCTfj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 3 Jun 2010 15:35:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: error27@gmail.com, dhowells@redhat.com, jmorris@namei.org


The patch titled
     keys: propagate error code instead of returning -EINVAL
has been added to the -mm tree.  Its filename is
     keys-propagate-error-code-instead-of-returning-einval.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: keys: propagate error code instead of returning -EINVAL
From: Dan Carpenter <error27@gmail.com>

This is from a Smatch check I'm writing.

strncpy_from_user() returns -EFAULT on error so the first change just
silences a smatch warning but doesn't change how the code works.

The other change is a bug fix because install_thread_keyring_to_cred() can
return a variety of errors such as -EINVAL, -EEXIST, -ENOMEM or
-EKEYREVOKED.

Signed-off-by: Dan Carpenter <error27@gmail.com>
Cc: David Howells <dhowells@redhat.com>
Cc: James Morris <jmorris@namei.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 security/keys/keyctl.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN security/keys/keyctl.c~keys-propagate-error-code-instead-of-returning-einval security/keys/keyctl.c
--- a/security/keys/keyctl.c~keys-propagate-error-code-instead-of-returning-einval
+++ a/security/keys/keyctl.c
@@ -33,7 +33,7 @@ static int key_get_type_from_user(char *
 	ret = strncpy_from_user(type, _type, len);
 
 	if (ret < 0)
-		return -EFAULT;
+		return ret;
 
 	if (ret == 0 || ret >= len)
 		return -EINVAL;
@@ -1080,7 +1080,7 @@ set:
 	return old_setting;
 error:
 	abort_creds(new);
-	return -EINVAL;
+	return ret;
 
 } /* end keyctl_set_reqkey_keyring() */
 
_

Patches currently in -mm which might be from error27@gmail.com are

origin.patch
linux-next.patch
mtd-sst25l-check-for-null-consistently.patch
scsi-remove-superfluous-null-pointer-check-from-scsi_kill_request.patch
padata-add-parenthesis-in-max_seq_nr-macro.patch
keys-propagate-error-code-instead-of-returning-einval.patch

