From: akpm@linux-foundation.org
Subject: - fs-superc-use-list_for_each_entry-instead-of-list_for_each.patch removed from -mm tree
Date: Fri, 19 Oct 2007 15:51:08 -0700
Message-ID: <200710192251.l9JMp8GT024158@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34967 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966168AbXJSXFN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 19 Oct 2007 19:05:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: matthias.kaehlcke@gmail.com, mm-commits@vger.kernel.org


The patch titled
     fs/super.c: use list_for_each_entry() instead of list_for_each()
has been removed from the -mm tree.  Its filename was
     fs-superc-use-list_for_each_entry-instead-of-list_for_each.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: fs/super.c: use list_for_each_entry() instead of list_for_each()
From: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>

fs/super.c: use list_for_each_entry() instead of list_for_each() in
sget()

[akpm@linux-foundation.org: clean up some crap while we're there]
Signed-off-by: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/super.c |   22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff -puN fs/super.c~fs-superc-use-list_for_each_entry-instead-of-list_for_each fs/super.c
--- a/fs/super.c~fs-superc-use-list_for_each_entry-instead-of-list_for_each
+++ a/fs/super.c
@@ -332,21 +332,21 @@ struct super_block *sget(struct file_sys
 			void *data)
 {
 	struct super_block *s = NULL;
-	struct list_head *p;
+	struct super_block *old;
 	int err;
 
 retry:
 	spin_lock(&sb_lock);
-	if (test) list_for_each(p, &type->fs_supers) {
-		struct super_block *old;
-		old = list_entry(p, struct super_block, s_instances);
-		if (!test(old, data))
-			continue;
-		if (!grab_super(old))
-			goto retry;
-		if (s)
-			destroy_super(s);
-		return old;
+	if (test) {
+		list_for_each_entry(old, &type->fs_supers, s_instances) {
+			if (!test(old, data))
+				continue;
+			if (!grab_super(old))
+				goto retry;
+			if (s)
+				destroy_super(s);
+			return old;
+		}
 	}
 	if (!s) {
 		spin_unlock(&sb_lock);
_

Patches currently in -mm which might be from matthias.kaehlcke@gmail.com are

origin.patch
generic-ac97-mixer-modem-oss-use-list_for_each_entry.patch
ftdi-elan-driver-convert-ftdi-u132_lock-to-mutex.patch
