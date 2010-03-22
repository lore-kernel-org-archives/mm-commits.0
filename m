From: akpm@linux-foundation.org
Subject: + notifier-change-notifier_from_errno0-to-return-notify_ok.patch added to -mm tree
Date: Mon, 22 Mar 2010 14:49:07 -0700
Message-ID: <201003222149.o2MLn804029424@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52361 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756521Ab0CVVtK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 22 Mar 2010 17:49:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akinobu.mita@gmail.com


The patch titled
     notifier: change notifier_from_errno(0) to return NOTIFY_OK
has been added to the -mm tree.  Its filename is
     notifier-change-notifier_from_errno0-to-return-notify_ok.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: notifier: change notifier_from_errno(0) to return NOTIFY_OK
From: Akinobu Mita <akinobu.mita@gmail.com>

This changes notifier_from_errno(0) to be NOTIFY_OK instead of
NOTIFY_STOP_MASK | NOTIFY_OK.

Currently, the notifiers which return encapsulated errno value have to
do something like this:

	err = do_something(); // returns -errno
	if (err)
		return notifier_from_errno(err);
	else
		return NOTIFY_OK;

This change makes the above code simple:

	err = do_something(); // returns -errno

	return return notifier_from_errno(err);

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/notifier.h |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN include/linux/notifier.h~notifier-change-notifier_from_errno0-to-return-notify_ok include/linux/notifier.h
--- a/include/linux/notifier.h~notifier-change-notifier_from_errno0-to-return-notify_ok
+++ a/include/linux/notifier.h
@@ -164,7 +164,10 @@ extern int __srcu_notifier_call_chain(st
 /* Encapsulate (negative) errno value (in particular, NOTIFY_BAD <=> EPERM). */
 static inline int notifier_from_errno(int err)
 {
-	return NOTIFY_STOP_MASK | (NOTIFY_OK - err);
+	if (err)
+		return NOTIFY_STOP_MASK | (NOTIFY_OK - err);
+
+	return NOTIFY_OK;
 }
 
 /* Restore (negative) errno value from notify return value. */
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

intel-iommu-use-for_each_set_bit.patch
bitops-rename-for_each_bit-to-for_each_set_bit-mtd.patch
cpu-hotplug-introduce-cpu_notify-__cpu_notify-cpu_notify_nofail.patch
cpu-hotplug-return-better-errno-on-cpu-hotplug-failure.patch
notifier-change-notifier_from_errno0-to-return-notify_ok.patch
x86-convert-cpu-notifier-to-return-encapsulate-errno-value.patch
topology-convert-cpu-notifier-to-return-encapsulate-errno-value.patch
kernel-convert-cpu-notifier-to-return-encapsulate-errno-value.patch
slab-convert-cpu-notifier-to-return-encapsulate-errno-value.patch
iucv-convert-cpu-notifier-to-return-encapsulate-errno-value.patch
ehca-convert-cpu-notifier-to-return-encapsulate-errno-value.patch
s390-convert-cpu-notifier-to-return-encapsulate-errno-value.patch
md-convert-cpu-notifier-to-return-encapsulate-errno-value.patch
fault-injection-add-cpu-notifier-error-injection-module.patch
bitops-remove-temporary-for_each_bit.patch

