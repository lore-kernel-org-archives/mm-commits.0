From: akpm@linux-foundation.org
Subject: - kprobes-add-unregister_kprobes-for-batch-registration-fix.patch removed from -mm tree
Date: Sun, 27 Apr 2008 23:58:12 -0700
Message-ID: <200804280658.m3S6wCbs012886@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42695 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763223AbYD1G7D (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Apr 2008 02:59:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhiramat@redhat.com, mm-commits@vger.kernel.org


The patch titled
     list.h: rename list_singleton to list_is_singular
has been removed from the -mm tree.  Its filename was
     kprobes-add-unregister_kprobes-for-batch-registration-fix.patch

This patch was dropped because it was folded into kprobes-add-unregister_kprobes-for-batch-registration.patch

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

origin.patch
listh-add-list_singleton.patch
kprobes-add-unregister_kprobes-for-batch-registration.patch
kprobes-add-unregister_kprobes-for-batch-registration-fix.patch
kprobes-add-unregister_kretprobes-for-batch-registration.patch
kprobes-add-unregister_jprobes-for-batch-registration.patch
kprobes-update-document-about-batch-registration.patch

