From: akpm@linux-foundation.org
Subject: + keys-fix-macro.patch added to -mm tree
Date: Fri, 04 Jan 2008 22:49:09 -0800
Message-ID: <200801050649.m056ntC0032450@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56549 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752503AbYAEGu7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sat, 5 Jan 2008 01:50:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sebastian@breakpoint.cc, dhowells@redhat.com


The patch titled
     KEYS: fix macro
has been added to the -mm tree.  Its filename is
     keys-fix-macro.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: KEYS: fix macro
From: Sebastian Siewior <sebastian@breakpoint.cc>

Commit 664cceb0093b755739e56572b836a99104ee8a75 changed the parameters of
the function make_key_ref().  The macros that are used in case CONFIG_KEY
is not defined did not change.

Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Sebastian Siewior <sebastian@breakpoint.cc>
Acked-by: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/key.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/key.h~keys-fix-macro include/linux/key.h
--- a/include/linux/key.h~keys-fix-macro
+++ a/include/linux/key.h
@@ -290,7 +290,7 @@ extern void key_init(void);
 #define key_get(k) 			({ NULL; })
 #define key_put(k)			do { } while(0)
 #define key_ref_put(k)			do { } while(0)
-#define make_key_ref(k)			({ NULL; })
+#define make_key_ref(k, p)			({ NULL; })
 #define key_ref_to_ptr(k)		({ NULL; })
 #define is_key_possessed(k)		0
 #define alloc_uid_keyring(u,c)		0
_

Patches currently in -mm which might be from sebastian@breakpoint.cc are

keys-fix-macro.patch
git-cryptodev.patch
