From: akpm@linux-foundation.org
Subject: + keys-revert-one-application-of-fix-unreachable-code-patch.patch added to -mm tree
Date: Wed, 20 Feb 2013 13:58:45 -0800
Message-ID: <20130220215845.E448031C194@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qe0-f74.google.com ([209.85.128.74]:59911 "EHLO
	mail-qe0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752380Ab3BTV6r (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 20 Feb 2013 16:58:47 -0500
Received: by mail-qe0-f74.google.com with SMTP id a11so834419qen.3
        for <mm-commits@vger.kernel.org>; Wed, 20 Feb 2013 13:58:46 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alan@linux.intel.com, alan@lxorguk.ukuu.org.uk, dhowells@redhat.com, jkosina@suse.cz, stable@vger.kernel.org


The patch titled
     Subject: keys: revert one application of "Fix unreachable code" patch
has been added to the -mm tree.  Its filename is
     keys-revert-one-application-of-fix-unreachable-code-patch.patch

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
Subject: keys: revert one application of "Fix unreachable code" patch

A patch to fix some unreachable code in search_my_process_keyrings() got
applied twice by two different routes upstream:

	commit e67eab39bee26f509d38d00ca1a8f24b63f46a31
	Author: Alan Cox <alan@linux.intel.com>
	Date:   Thu Dec 20 15:05:54 2012 -0800
	keys: fix unreachable code

and:

	commit b010520ab3d2c05eb444ed5e01fe6c33842f597a
	Author: Alan Cox <alan@linux.intel.com>
	Date:   Thu Oct 25 15:23:35 2012 +0100
	keys: Fix unreachable code

Unfortunately, the second application removed something it shouldn't have
and this wasn't detected by GIT.  This is due to the patch not having
sufficient lines of context to distinguish the two places of application.

So revert the second application of the patch.

Signed-off-by: David Howells <dhowells@redhat.com>
Cc: Jiri Kosina <jkosina@suse.cz>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 security/keys/process_keys.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN security/keys/process_keys.c~keys-revert-one-application-of-fix-unreachable-code-patch security/keys/process_keys.c
--- a/security/keys/process_keys.c~keys-revert-one-application-of-fix-unreachable-code-patch
+++ a/security/keys/process_keys.c
@@ -367,6 +367,8 @@ key_ref_t search_my_process_keyrings(str
 
 		switch (PTR_ERR(key_ref)) {
 		case -EAGAIN: /* no key */
+			if (ret)
+				break;
 		case -ENOKEY: /* negative key */
 			ret = key_ref;
 			break;
_

Patches currently in -mm which might be from alan@linux.intel.com are

origin.patch
linux-next.patch
goldfish-framebuffer-driver.patch
goldfish-framebuffer-driver-fix.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
coredump-remove-redundant-defines-for-dumpable-states.patch
fork-unshare-remove-dead-code.patch
keys-revert-one-application-of-fix-unreachable-code-patch.patch

