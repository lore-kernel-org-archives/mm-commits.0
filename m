From: akpm@linux-foundation.org
Subject: + kcore-use-registerd-physmem-information-fix2.patch added to -mm tree
Date: Fri, 21 Aug 2009 16:17:36 -0700
Message-ID: <200908212317.n7LNHalV010821@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59786 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932548AbZHUXRj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 21 Aug 2009 19:17:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jirislaby@gmail.com, kamezawa.hiroyu@jp.fujitsu.com


The patch titled
     kcore-use-registerd-physmem-information-fix2
has been added to the -mm tree.  Its filename is
     kcore-use-registerd-physmem-information-fix2.patch

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
Subject: kcore-use-registerd-physmem-information-fix2
From: Jiri Slaby <jirislaby@gmail.com>

Fix this compilation warning on x86_64:
fs/proc/kcore.c: In function `kclist_add_private':
fs/proc/kcore.c:175: warning: comparison between pointer and integer

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/kcore.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/proc/kcore.c~kcore-use-registerd-physmem-information-fix2 fs/proc/kcore.c
--- a/fs/proc/kcore.c~kcore-use-registerd-physmem-information-fix2
+++ a/fs/proc/kcore.c
@@ -172,7 +172,7 @@ kclist_add_private(unsigned long pfn, un
 		ent->size = ULONG_MAX - ent->addr;
 
 	/* cut when vmalloc() area is higher than direct-map area */
-	if (VMALLOC_START > __va(0)) {
+	if (VMALLOC_START > (unsigned long)__va(0)) {
 		if (ent->addr > VMALLOC_START)
 			goto free_out;
 		if (VMALLOC_START - ent->addr < ent->size)
_

Patches currently in -mm which might be from jirislaby@gmail.com are

linux-next.patch
toshiba_acpi-return-on-a-fail-path.patch
mtd-sst25l-fix-lock-imbalance.patch
isdn-hisax-fix-lock-imbalance.patch
icom-converting-space-to-tabs.patch
cyclades-read-buffer-overflow.patch
serial167-fix-read-buffer-overflow.patch
kcore-use-registerd-physmem-information-define-node__pfn-for-non-numa-builds.patch
kcore-use-registerd-physmem-information-fix2.patch
video-console-use-div_round_up.patch
memory-controller-soft-limit-organize-cgroups-v9-fix.patch
cyclades-allow-overriding-isa-defaults-also-when-the-driver-is-built-in.patch
drivers-char-rio-rioctrlc-off-by-one-error-in-rioctrlc.patch
reiser4.patch

