From: akpm@linux-foundation.org
Subject: [merged] keys-fix-unreachable-code.patch removed from -mm tree
Date: Fri, 21 Dec 2012 12:40:32 -0800
Message-ID: <20121221204033.1A60720004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-bk0-f73.google.com ([209.85.214.73]:39329 "EHLO
	mail-bk0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751927Ab2LUUkf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 21 Dec 2012 15:40:35 -0500
Received: by mail-bk0-f73.google.com with SMTP id jf3so272460bkc.0
        for <mm-commits@vger.kernel.org>; Fri, 21 Dec 2012 12:40:34 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@linux.intel.com, dhowells@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: keys: fix unreachable code
has been removed from the -mm tree.  Its filename was
     keys-fix-unreachable-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Alan Cox <alan@linux.intel.com>
Subject: keys: fix unreachable code

We set ret to NULL then test it. Remove the bogus test

Signed-off-by: Alan Cox <alan@linux.intel.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 security/keys/process_keys.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN security/keys/process_keys.c~keys-fix-unreachable-code security/keys/process_keys.c
--- a/security/keys/process_keys.c~keys-fix-unreachable-code
+++ a/security/keys/process_keys.c
@@ -367,8 +367,6 @@ key_ref_t search_my_process_keyrings(str
 
 		switch (PTR_ERR(key_ref)) {
 		case -EAGAIN: /* no key */
-			if (ret)
-				break;
 		case -ENOKEY: /* negative key */
 			ret = key_ref;
 			break;
_

Patches currently in -mm which might be from alan@linux.intel.com are

origin.patch
linux-next.patch
fb-rework-locking-to-fix-lock-ordering-on-takeover.patch
fb-rework-locking-to-fix-lock-ordering-on-takeover-fix.patch
fb-rework-locking-to-fix-lock-ordering-on-takeover-fix-2.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
fork-unshare-remove-dead-code.patch

