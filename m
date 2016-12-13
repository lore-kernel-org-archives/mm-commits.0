From: akpm@linux-foundation.org
Subject: [patch 098/123] fs/proc/base.c: save decrement during
 lookup/readdir in /proc/$PID
Date: Mon, 12 Dec 2016 16:45:28 -0800
Message-ID: <584f44a8.C2So02oS5N43qMKb%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41812 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932499AbcLMAp3 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 12 Dec 2016 19:45:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, adobriyan@gmail.com

From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: fs/proc/base.c: save decrement during lookup/readdir in /proc/$PID

Comparison for "<" works equally well as comparison for "<="
but one SUB/LEA is saved (no, it is not optimised away, at least here).

Link: http://lkml.kernel.org/r/20161122195143.GA29812@avx2
Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/base.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN fs/proc/base.c~proc-save-decrement-during-lookup-readdir-in-proc-pid fs/proc/base.c
--- a/fs/proc/base.c~proc-save-decrement-during-lookup-readdir-in-proc-pid
+++ a/fs/proc/base.c
@@ -2412,14 +2412,14 @@ static struct dentry *proc_pident_lookup
 	 * Yes, it does not scale. And it should not. Don't add
 	 * new entries into /proc/<tgid>/ without very good reasons.
 	 */
-	last = &ents[nents - 1];
-	for (p = ents; p <= last; p++) {
+	last = &ents[nents];
+	for (p = ents; p < last; p++) {
 		if (p->len != dentry->d_name.len)
 			continue;
 		if (!memcmp(dentry->d_name.name, p->name, p->len))
 			break;
 	}
-	if (p > last)
+	if (p >= last)
 		goto out;
 
 	error = proc_pident_instantiate(dir, dentry, task, p);
@@ -2444,7 +2444,7 @@ static int proc_pident_readdir(struct fi
 	if (ctx->pos >= nents + 2)
 		goto out;
 
-	for (p = ents + (ctx->pos - 2); p <= ents + nents - 1; p++) {
+	for (p = ents + (ctx->pos - 2); p < ents + nents; p++) {
 		if (!proc_fill_cache(file, ctx, p->name, p->len,
 				proc_pident_instantiate, task, p))
 			break;
_
