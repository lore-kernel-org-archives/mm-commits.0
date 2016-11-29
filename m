From: akpm@linux-foundation.org
Subject: + proc-save-decrement-during-lookup-readdir-in-proc-pid.patch
 added to -mm tree
Date: Tue, 29 Nov 2016 15:55:54 -0800
Message-ID: <583e158a.AIQTMBgQsn55I76y%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51596 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752099AbcK2Xzk (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 29 Nov 2016 18:55:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/proc/base.c: save decrement during lookup/readdir in /proc/$PID
has been added to the -mm tree.  Its filename is
     proc-save-decrement-during-lookup-readdir-in-proc-pid.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/proc-save-decrement-during-lookup-readdir-in-proc-pid.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/proc-save-decrement-during-lookup-readdir-in-proc-pid.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
scripts-bloat-o-meter-dont-use-readlines.patch
scripts-bloat-o-meter-compile-number-regex.patch
proc-make-struct-pid_entry-len-unsigned.patch
proc-make-struct-struct-map_files_info-len-unsigned-int.patch
proc-just-list_del-struct-pde_opener.patch
proc-fix-type-of-struct-pde_opener-closing-field.patch
proc-kmalloc-struct-pde_opener.patch
proc-tweak-comments-about-2-stage-open-and-everything.patch
proc-save-decrement-during-lookup-readdir-in-proc-pid.patch
coredump-clarify-unsafe-core_pattern-warning.patch

