From: akpm@linux-foundation.org
Subject: + drivers-char-ipmi-ipmi_msghandlerc-use-list_head-instead-of-list_head_init.patch added to -mm tree
Date: Wed, 12 Dec 2007 00:40:30 -0800
Message-ID: <200712120840.lBC8eUhH001412@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42894 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752465AbXLLIke (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 12 Dec 2007 03:40:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: crquan@gmail.com, minyard@acm.org


The patch titled
     drivers/char/ipmi/ipmi_msghandler.c: use LIST_HEAD instead of LIST_HEAD_INIT
has been added to the -mm tree.  Its filename is
     drivers-char-ipmi-ipmi_msghandlerc-use-list_head-instead-of-list_head_init.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: drivers/char/ipmi/ipmi_msghandler.c: use LIST_HEAD instead of LIST_HEAD_INIT
From: Denis Cheng <crquan@gmail.com>

Signed-off-by: Denis Cheng <crquan@gmail.com>
Cc: Corey Minyard <minyard@acm.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/ipmi/ipmi_msghandler.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/char/ipmi/ipmi_msghandler.c~drivers-char-ipmi-ipmi_msghandlerc-use-list_head-instead-of-list_head_init drivers/char/ipmi/ipmi_msghandler.c
--- a/drivers/char/ipmi/ipmi_msghandler.c~drivers-char-ipmi-ipmi_msghandlerc-use-list_head-instead-of-list_head_init
+++ a/drivers/char/ipmi/ipmi_msghandler.c
@@ -441,7 +441,7 @@ struct watcher_entry {
 int ipmi_smi_watcher_register(struct ipmi_smi_watcher *watcher)
 {
 	ipmi_smi_t intf;
-	struct list_head to_deliver = LIST_HEAD_INIT(to_deliver);
+	LIST_HEAD(to_deliver);
 	struct watcher_entry *e, *e2;
 
 	mutex_lock(&smi_watchers_mutex);
_

Patches currently in -mm which might be from crquan@gmail.com are

git-net.patch
git-s390.patch
3w-raid-drivers-memset-not-needed-in-probe.patch
git-cryptodev.patch
drivers-char-use-list_head-instead-of-list_head_init.patch
drivers-char-ipmi-ipmi_msghandlerc-use-list_head-instead-of-list_head_init.patch
