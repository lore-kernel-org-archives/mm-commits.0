From: akpm@linux-foundation.org
Subject: + kprobes-add-unregister_kprobes-for-batch-registration-fix.patch added to -mm tree
Date: Mon, 17 Mar 2008 22:13:27 -0700
Message-ID: <200803180513.m2I5DRil015664@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33160 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752645AbYCRFOZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 18 Mar 2008 01:14:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mhiramat@redhat.com


The patch titled
     list.h: rename list_singleton to list_is_singular
has been added to the -mm tree.  Its filename is
     kprobes-add-unregister_kprobes-for-batch-registration-fix.patch

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
Subject: list.h: rename list_singleton to list_is_singular
From: Masami Hiramatsu <mhiramat@redhat.com>

Rename list_singleton to list_is_singular.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kprobes.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN kernel/kprobes.c~kprobes-add-unregister_kprobes-for-batch-registration-fix kernel/kprobes.c
--- a/kernel/kprobes.c~kprobes-add-unregister_kprobes-for-batch-registration-fix
+++ a/kernel/kprobes.c
@@ -628,7 +628,7 @@ static int __kprobes __unregister_kprobe
 valid_p:
 	if (old_p == p ||
 	    (old_p->pre_handler == aggr_pre_handler &&
-	     list_singleton(&old_p->list))) {
+	     list_is_singular(&old_p->list))) {
 		/*
 		 * Only probe on the hash list. Disarm only if kprobes are
 		 * enabled - otherwise, the breakpoint would already have
@@ -664,7 +664,7 @@ static void __kprobes __unregister_kprob
 			module_put(mod);
 	}
 
-	if (list_empty(&p->list) || list_singleton(&p->list)) {
+	if (list_empty(&p->list) || list_is_singular(&p->list)) {
 		if (!list_empty(&p->list)) {
 			/* "p" is the last child of an aggr_kprobe */
 			old_p = list_entry(p->list.next, struct kprobe, list);
_

Patches currently in -mm which might be from mhiramat@redhat.com are

kprobes-kprobe-booster-for-ia64.patch
kprobes-kprobe-booster-for-ia64-fix.patch
listh-add-list_singleton.patch
listh-add-list_singleton-fix.patch
kprobes-add-unregister_kprobes-for-batch-registration.patch
kprobes-add-unregister_kprobes-for-batch-registration-fix.patch
kprobes-add-unregister_kretprobes-for-batch-registration.patch
kprobes-add-unregister_jprobes-for-batch-registration.patch
kprobes-update-document-about-batch-registration.patch

