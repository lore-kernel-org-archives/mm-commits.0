From: akpm@linux-foundation.org
Subject: - proc-less-special-case-in-xlate-code.patch removed from -mm tree
Date: Tue, 29 Apr 2008 22:45:51 -0700
Message-ID: <200804300545.m3U5jpjh029549@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52339 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756591AbYD3GBe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 02:01:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, mm-commits@vger.kernel.org


The patch titled
     proc: less special case in xlate code
has been removed from the -mm tree.  Its filename was
     proc-less-special-case-in-xlate-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: proc: less special case in xlate code
From: Alexey Dobriyan <adobriyan@gmail.com>

If valid "parent" is passed to proc_create/remove_proc_entry(), then name of
PDE should consist of only one path component, otherwise creation or or
removal will fail.  However, if NULL is passed as parent then create/remove
accept full path as a argument.  This is arbitrary restriction -- all
infrastructure is in place.

So, patch allows the following to succeed:

	create_proc_entry("foo/bar", 0, pde_baz);
	remove_proc_entry("baz/foo/bar", &proc_root);

Also makes the following to behave identically:

	create_proc_entry("foo/bar", 0, NULL);
	create_proc_entry("foo/bar", 0, &proc_root);

Discrepancy noticed by Den Lunev (IIRC).

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/generic.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff -puN fs/proc/generic.c~proc-less-special-case-in-xlate-code fs/proc/generic.c
--- a/fs/proc/generic.c~proc-less-special-case-in-xlate-code
+++ a/fs/proc/generic.c
@@ -277,8 +277,11 @@ static int xlate_proc_name(const char *n
 	int			len;
 	int 			rtn = 0;
 
+	de = *ret;
+	if (!de)
+		de = &proc_root;
+
 	spin_lock(&proc_subdir_lock);
-	de = &proc_root;
 	while (1) {
 		next = strchr(cp, '/');
 		if (!next)
@@ -582,7 +585,7 @@ static struct proc_dir_entry *__proc_cre
 	/* make sure name is valid */
 	if (!name || !strlen(name)) goto out;
 
-	if (!(*parent) && xlate_proc_name(name, parent, &fn) != 0)
+	if (xlate_proc_name(name, parent, &fn) != 0)
 		goto out;
 
 	/* At this point there must not be any '/' characters beyond *fn */
@@ -738,7 +741,7 @@ void remove_proc_entry(const char *name,
 	const char *fn = name;
 	int len;
 
-	if (!parent && xlate_proc_name(name, &parent, &fn) != 0)
+	if (xlate_proc_name(name, &parent, &fn) != 0)
 		return;
 	len = strlen(fn);
 
_

Patches currently in -mm which might be from adobriyan@gmail.com are

origin.patch
drivers-use-non-racy-method-for-proc-entries-creation-2-rio.patch
mpt-remove-unused-struct-mpt_proc_entry_t.patch
git-xfs.patch
proc-use-non-racy-method-for-proc-page_owner-creation-page_owner.patch
likely_prof-changed-to-use-proc_create.patch
proc-remove-proc_root-from-drivers-likelyprof.patch

