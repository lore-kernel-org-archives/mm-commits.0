From: akpm@linux-foundation.org
Subject: + docs-convert-kref-semaphore-to-mutex.patch added to -mm tree
Date: Fri, 21 Dec 2007 20:16:56 -0800
Message-ID: <200712220416.lBM4GuUB016665@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44874 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751168AbXLVERJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 21 Dec 2007 23:17:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dwalker@mvista.com, greg@kroah.com, minyard@acm.org


The patch titled
     docs: convert kref semaphore to mutex
has been added to the -mm tree.  Its filename is
     docs-convert-kref-semaphore-to-mutex.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: docs: convert kref semaphore to mutex
From: Daniel Walker <dwalker@mvista.com>

Just converting this documentation semaphore reference, since we don't
want to promote semaphore usage.

Signed-off-by: Daniel Walker <dwalker@mvista.com>
Acked-by: Corey Minyard <minyard@acm.org>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/kref.txt |   20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff -puN Documentation/kref.txt~docs-convert-kref-semaphore-to-mutex Documentation/kref.txt
--- a/Documentation/kref.txt~docs-convert-kref-semaphore-to-mutex
+++ a/Documentation/kref.txt
@@ -141,10 +141,10 @@ The last rule (rule 3) is the nastiest o
 instance, you have a list of items that are each kref-ed, and you wish
 to get the first one.  You can't just pull the first item off the list
 and kref_get() it.  That violates rule 3 because you are not already
-holding a valid pointer.  You must add locks or semaphores.  For
-instance:
+holding a valid pointer.  You must add a mutex (or some other lock).
+For instance:
 
-static DECLARE_MUTEX(sem);
+static DEFINE_MUTEX(mutex);
 static LIST_HEAD(q);
 struct my_data
 {
@@ -155,12 +155,12 @@ struct my_data
 static struct my_data *get_entry()
 {
 	struct my_data *entry = NULL;
-	down(&sem);
+	mutex_lock(&mutex);
 	if (!list_empty(&q)) {
 		entry = container_of(q.next, struct my_q_entry, link);
 		kref_get(&entry->refcount);
 	}
-	up(&sem);
+	mutex_unlock(&mutex);
 	return entry;
 }
 
@@ -174,9 +174,9 @@ static void release_entry(struct kref *r
 
 static void put_entry(struct my_data *entry)
 {
-	down(&sem);
+	mutex_lock(&mutex);
 	kref_put(&entry->refcount, release_entry);
-	up(&sem);
+	mutex_unlock(&mutex);
 }
 
 The kref_put() return value is useful if you do not want to hold the
@@ -191,13 +191,13 @@ static void release_entry(struct kref *r
 
 static void put_entry(struct my_data *entry)
 {
-	down(&sem);
+	mutex_lock(&mutex);
 	if (kref_put(&entry->refcount, release_entry)) {
 		list_del(&entry->link);
-		up(&sem);
+		mutex_unlock(&mutex);
 		kfree(entry);
 	} else
-		up(&sem);
+		mutex_unlock(&mutex);
 }
 
 This is really more useful if you have to call other routines as part
_

Patches currently in -mm which might be from dwalker@mvista.com are

ps3-vuart-fix-error-path-locking.patch
driver-base-memory-semaphore-to-mutex.patch
git-dvb.patch
usb-microtek-remove-unused-semaphore.patch
prism54-remove-questionable-down_interruptible-usage.patch
git-x86.patch
page-allocator-clean-up-pcp-draining-functions-swsusp-fix.patch
page-allocator-clean-up-pcp-draining-functions-swsusp-fix-fix.patch
drivers-char-tty_ioc-remove-pty_sem.patch
drivers-isdn-i4l-isdn_ttyc-remove-write_sem.patch
unix98-allocated_ptys_lock-semaphore-to-mutex.patch
docs-kernel-locking-convert-semaphore-references.patch
stopmachine-semaphore-to-mutex.patch
stopmachine-semaphore-to-mutex-fix.patch
amiga-serial-driver-port_write_mutex-fixup.patch
docs-convert-kref-semaphore-to-mutex.patch
isapnp-driver-semaphore-to-mutex.patch
isapnp-driver-semaphore-to-mutex-fix.patch
isapnp-driver-semaphore-to-mutex-fix-fix.patch
profile-likely-unlikely-macros.patch
profile-likely-unlikely-macros-fix.patch
