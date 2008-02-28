From: akpm@linux-foundation.org
Subject: + markers-dont-risk-null-deref-in-marker.patch added to -mm tree
Date: Wed, 27 Feb 2008 19:33:45 -0800
Message-ID: <200802280333.m1S3Xjvm013559@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:36042 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752516AbYB1Dd7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 Feb 2008 22:33:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jesper.juhl@gmail.com, mathieu.desnoyers@polymtl.ca


The patch titled
     markers: don't risk NULL deref in marker
has been added to the -mm tree.  Its filename is
     markers-dont-risk-null-deref-in-marker.patch

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
Subject: markers: don't risk NULL deref in marker
From: Jesper Juhl <jesper.juhl@gmail.com>

get_marker() may return NULL, so test for it.

Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
Acked-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/marker.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff -puN kernel/marker.c~markers-dont-risk-null-deref-in-marker kernel/marker.c
--- a/kernel/marker.c~markers-dont-risk-null-deref-in-marker
+++ a/kernel/marker.c
@@ -698,12 +698,11 @@ int marker_probe_unregister(const char *
 {
 	struct marker_entry *entry;
 	struct marker_probe_closure *old;
-	int ret = 0;
+	int ret = -ENOENT;
 
 	mutex_lock(&markers_mutex);
 	entry = get_marker(name);
 	if (!entry) {
-		ret = -ENOENT;
 		goto end;
 	}
 	if (entry->rcu_pending)
@@ -713,12 +712,16 @@ int marker_probe_unregister(const char *
 	marker_update_probes();		/* may update entry */
 	mutex_lock(&markers_mutex);
 	entry = get_marker(name);
+	if (!entry) {
+		goto end;
+	}
 	entry->oldptr = old;
 	entry->rcu_pending = 1;
 	/* write rcu_pending before calling the RCU callback */
 	smp_wmb();
 	call_rcu(&entry->rcu, free_old_closure);
 	remove_marker(name);	/* Ignore busy error message */
+	ret = 0;
 end:
 	mutex_unlock(&markers_mutex);
 	return ret;
_

Patches currently in -mm which might be from jesper.juhl@gmail.com are

markers-dont-risk-null-deref-in-marker.patch
