From: akpm@linux-foundation.org
Subject: + drivers-char-use-list_head-instead-of-list_head_init.patch added to -mm tree
Date: Wed, 05 Dec 2007 15:22:16 -0800
Message-ID: <200712052322.lB5NMGh2030239@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43807 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752292AbXLEXW2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 5 Dec 2007 18:22:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: crquan@gmail.com, benh@kernel.crashing.org, minyard@acm.org, paulus@samba.org


The patch titled
     drivers/char: use LIST_HEAD instead of LIST_HEAD_INIT
has been added to the -mm tree.  Its filename is
     drivers-char-use-list_head-instead-of-list_head_init.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: drivers/char: use LIST_HEAD instead of LIST_HEAD_INIT
From: Denis Cheng <crquan@gmail.com>

single list_head variable initialized with LIST_HEAD_INIT could almost
always can be replaced with LIST_HEAD declaration, this shrinks the code
and looks better.

Signed-off-by: Denis Cheng <crquan@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Corey Minyard <minyard@acm.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/hvc_console.c          |    2 +-
 drivers/char/hvcs.c                 |    2 +-
 drivers/char/ipmi/ipmi_msghandler.c |    4 ++--
 3 files changed, 4 insertions(+), 4 deletions(-)

diff -puN drivers/char/hvc_console.c~drivers-char-use-list_head-instead-of-list_head_init drivers/char/hvc_console.c
--- a/drivers/char/hvc_console.c~drivers-char-use-list_head-instead-of-list_head_init
+++ a/drivers/char/hvc_console.c
@@ -93,7 +93,7 @@ struct hvc_struct {
 };
 
 /* dynamic list of hvc_struct instances */
-static struct list_head hvc_structs = LIST_HEAD_INIT(hvc_structs);
+static LIST_HEAD(hvc_structs);
 
 /*
  * Protect the list of hvc_struct instances from inserts and removals during
diff -puN drivers/char/hvcs.c~drivers-char-use-list_head-instead-of-list_head_init drivers/char/hvcs.c
--- a/drivers/char/hvcs.c~drivers-char-use-list_head-instead-of-list_head_init
+++ a/drivers/char/hvcs.c
@@ -306,7 +306,7 @@ struct hvcs_struct {
 /* Required to back map a kref to its containing object */
 #define from_kref(kref) container_of(kref, struct hvcs_struct, kref)
 
-static struct list_head hvcs_structs = LIST_HEAD_INIT(hvcs_structs);
+static LIST_HEAD(hvcs_structs);
 static DEFINE_SPINLOCK(hvcs_structs_lock);
 
 static void hvcs_unthrottle(struct tty_struct *tty);
diff -puN drivers/char/ipmi/ipmi_msghandler.c~drivers-char-use-list_head-instead-of-list_head_init drivers/char/ipmi/ipmi_msghandler.c
--- a/drivers/char/ipmi/ipmi_msghandler.c~drivers-char-use-list_head-instead-of-list_head_init
+++ a/drivers/char/ipmi/ipmi_msghandler.c
@@ -365,12 +365,12 @@ static struct device_driver ipmidriver =
 };
 static DEFINE_MUTEX(ipmidriver_mutex);
 
-static struct list_head ipmi_interfaces = LIST_HEAD_INIT(ipmi_interfaces);
+static LIST_HEAD(ipmi_interfaces);
 static DEFINE_MUTEX(ipmi_interfaces_mutex);
 
 /* List of watchers that want to know when smi's are added and
    deleted. */
-static struct list_head smi_watchers = LIST_HEAD_INIT(smi_watchers);
+static LIST_HEAD(smi_watchers);
 static DEFINE_MUTEX(smi_watchers_mutex);
 
 
_

Patches currently in -mm which might be from crquan@gmail.com are

mm-backing-devc-fix-percpu_counter_destroy-call-bug-in-bdi_init.patch
git-cryptodev.patch
drivers-char-use-list_head-instead-of-list_head_init.patch
