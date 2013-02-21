From: akpm@linux-foundation.org
Subject: [merged] keys-revert-one-application-of-fix-unreachable-code-patch.patch removed from -mm tree
Date: Thu, 21 Feb 2013 12:50:23 -0800
Message-ID: <20130221205025.3C30731C18B__25045.2906162993$1361479856$gmane$org@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f201.google.com ([209.85.220.201]:42821 "EHLO
	mail-vc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753138Ab3BUUu3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Feb 2013 15:50:29 -0500
Received: by mail-vc0-f201.google.com with SMTP id n11so960940vch.4
        for <mm-commits@vger.kernel.org>; Thu, 21 Feb 2013 12:50:29 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@linux.intel.com, alan@lxorguk.ukuu.org.uk, dhowells@redhat.com, jkosina@suse.cz, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: keys: revert one application of "Fix unreachable code" patch
has been removed from the -mm tree.  Its filename was
     keys-revert-one-application-of-fix-unreachable-code-patch.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

