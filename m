From: akpm@linux-foundation.org
Subject: + ecryptfs-fix-missed-mutex_unlock.patch added to -mm tree
Date: Tue, 20 May 2008 00:28:37 -0700
Message-ID: <200805200728.m4K7Sbu3010948@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60861 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760852AbYETH3G (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 20 May 2008 03:29:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: gorcunov@gmail.com, mhalcrow@us.ibm.com


The patch titled
     ecryptfs: fix missed mutex_unlock
has been added to the -mm tree.  Its filename is
     ecryptfs-fix-missed-mutex_unlock.patch

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
Subject: ecryptfs: fix missed mutex_unlock
From: Cyrill Gorcunov <gorcunov@gmail.com>

Cc: Michael Halcrow <mhalcrow@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ecryptfs/crypto.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/ecryptfs/crypto.c~ecryptfs-fix-missed-mutex_unlock fs/ecryptfs/crypto.c
--- a/fs/ecryptfs/crypto.c~ecryptfs-fix-missed-mutex_unlock
+++ a/fs/ecryptfs/crypto.c
@@ -1906,9 +1906,9 @@ int ecryptfs_get_tfm_and_mutex_for_ciphe
 			goto out;
 		}
 	}
-	mutex_unlock(&key_tfm_list_mutex);
 	(*tfm) = key_tfm->key_tfm;
 	(*tfm_mutex) = &key_tfm->key_tfm_mutex;
 out:
+	mutex_unlock(&key_tfm_list_mutex);
 	return rc;
 }
_

Patches currently in -mm which might be from gorcunov@gmail.com are

ecryptfs-fix-missed-mutex_unlock.patch
linux-next.patch
module-loading-elf-handling-use-selfmag-instead-of-numeric-constant.patch

