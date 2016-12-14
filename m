From: akpm@linux-foundation.org
Subject: [merged]
 proc-save-decrement-during-lookup-readdir-in-proc-pid.patch removed from
 -mm tree
Date: Wed, 14 Dec 2016 11:27:01 -0800
Message-ID: <58519d05.B7d4WEOO2LGognKa%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45620 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752786AbcLNT1C (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 14 Dec 2016 14:27:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/proc/base.c: save decrement during lookup/readdir in /proc/$PID
has been removed from the -mm tree.  Its filename was
     proc-save-decrement-during-lookup-readdir-in-proc-pid.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from adobriyan@gmail.com are

kbuild-simpler-generation-of-assembly-constants.patch
coredump-clarify-unsafe-core_pattern-warning.patch

