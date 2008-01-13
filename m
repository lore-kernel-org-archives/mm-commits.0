From: akpm@linux-foundation.org
Subject: - keys-fix-macro.patch removed from -mm tree
Date: Sun, 13 Jan 2008 03:32:56 -0800
Message-ID: <200801131132.m0DBWa9S009783@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37521 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751360AbYAMLdc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 13 Jan 2008 06:33:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sebastian@breakpoint.cc, dhowells@redhat.com, mm-commits@vger.kernel.org


The patch titled
     KEYS: fix macro
has been removed from the -mm tree.  Its filename was
     keys-fix-macro.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
git-net.patch
git-cryptodev.patch
