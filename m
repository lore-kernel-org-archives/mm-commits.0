From: akpm@linux-foundation.org
Subject: [merged] keys-get_instantiation_keyring-should-inc-the-keyring-refcount-in-all-cases.patch removed from -mm tree
Date: Fri, 16 Oct 2009 13:48:42 -0700
Message-ID: <200910162048.n9GKmgPm030472@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51325 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750825AbZJPUtB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 16 Oct 2009 16:49:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dhowells@redhat.com, az@bond.edu.au, jmorris@namei.org, mm-commits@vger.kernel.org


The patch titled
     keys: get_instantiation_keyring() should inc the keyring refcount in all cases
has been removed from the -mm tree.  Its filename was
     keys-get_instantiation_keyring-should-inc-the-keyring-refcount-in-all-cases.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: keys: get_instantiation_keyring() should inc the keyring refcount in all cases
From: David Howells <dhowells@redhat.com>

The destination keyring specified to request_key() and co.  is made
available to the process that instantiates the key (the slave process
started by /sbin/request-key typically).  This is passed in the
request_key_auth struct as the dest_keyring member.

keyctl_instantiate_key and keyctl_negate_key() call
get_instantiation_keyring() to get the keyring to attach the newly
constructed key to at the end of instantiation.  This may be given a
specific keyring into which a link will be made later, or it may be asked
to find the keyring passed to request_key().  In the former case, it
returns a keyring with the refcount incremented by lookup_user_key(); in
the latter case, it returns the keyring from the request_key_auth struct -
and does _not_ increment the refcount.

The latter case will eventually result in an oops when the keyring
prematurely runs out of references and gets destroyed.  The effect may
take some time to show up as the key is destroyed lazily.

To fix this, the keyring returned by get_instantiation_keyring() must
always have its refcount incremented, no matter where it comes from.

This can be tested by setting /etc/request-key.conf to:

#OP	TYPE	DESCRIPTION	CALLOUT INFO	PROGRAM ARG1 ARG2 ARG3 ...
#======	=======	===============	===============	===============================
create  *	test:*		*		|/bin/false %u %g %d %{user:_display}
negate	*	*		*		/bin/keyctl negate %k 10 @u

and then doing:

	keyctl add user _display aaaaaaaa @u
        while keyctl request2 user test:x test:x @u &&
        keyctl list @u;
        do
                keyctl request2 user test:x test:x @u;
                sleep 31;
                keyctl list @u;
        done

which will oops eventually.  Changing the negate line to have @u rather
than %S at the end is important as that forces the latter case by passing
a special keyring ID rather than an actual keyring ID.

Reported-by: Alexander Zangerl <az@bond.edu.au>
Signed-off-by: David Howells <dhowells@redhat.com>
Tested-by: Alexander Zangerl <az@bond.edu.au>
Cc: James Morris <jmorris@namei.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN security/keys/keyctl.c~keys-get_instantiation_keyring-should-inc-the-keyring-refcount-in-all-cases security/keys/keyctl.c
--- a/security/keys/keyctl.c~keys-get_instantiation_keyring-should-inc-the-keyring-refcount-in-all-cases
+++ a/security/keys/keyctl.c
@@ -873,7 +873,7 @@ static long get_instantiation_keyring(ke
 	/* otherwise specify the destination keyring recorded in the
 	 * authorisation key (any KEY_SPEC_*_KEYRING) */
 	if (ringid >= KEY_SPEC_REQUESTOR_KEYRING) {
-		*_dest_keyring = rka->dest_keyring;
+		*_dest_keyring = key_get(rka->dest_keyring);
 		return 0;
 	}
 
_

Patches currently in -mm which might be from dhowells@redhat.com are

linux-next.patch
nommu-ignore-the-address-parameter-in-the-file_mmap-security-check.patch
frv-duplicate-output_buffer-of-e03.patch
rwsem-spinlock-remove-useless-function-exports.patch
rwsem-fix-rwsem_is_locked-bugs.patch
rwsem-fix-rwsem_is_locked-bugs-fix.patch
mutex-subsystem-synchro-test-module.patch
mutex-subsystem-synchro-test-module-add-missing-header-file.patch

