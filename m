From: akpm@linux-foundation.org
Subject: + keys-fix-unreachable-code.patch added to -mm tree
Date: Wed, 19 Dec 2012 16:22:35 -0800
Message-ID: <20121220002236.12F2582004A@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f201.google.com ([209.85.216.201]:52551 "EHLO
	mail-qc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751475Ab2LTAWh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 19 Dec 2012 19:22:37 -0500
Received: by mail-qc0-f201.google.com with SMTP id a6so307096qch.2
        for <mm-commits@vger.kernel.org>; Wed, 19 Dec 2012 16:22:36 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alan@linux.intel.com, dhowells@redhat.com


The patch titled
     Subject: keys: fix unreachable code
has been added to the -mm tree.  Its filename is
     keys-fix-unreachable-code.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
hfsplus-avoid-crash-on-failed-block-map-free.patch
sendfile-allows-bypassing-of-notifier-events.patch
keys-fix-unreachable-code.patch
fb-rework-locking-to-fix-lock-ordering-on-takeover.patch
fb-rework-locking-to-fix-lock-ordering-on-takeover-fix.patch
fb-rework-locking-to-fix-lock-ordering-on-takeover-fix-2.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
fork-unshare-remove-dead-code.patch

