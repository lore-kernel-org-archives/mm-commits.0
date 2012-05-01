From: akpm@linux-foundation.org
Subject: + w1-introduce-a-slave-mutex-for-serializing-io.patch added to -mm tree
Date: Tue, 01 May 2012 11:49:24 -0700
Message-ID: <20120501184927.0B64DA04C2@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-we0-f202.google.com ([74.125.82.202]:47393 "EHLO
	mail-we0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752581Ab2EASt3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 May 2012 14:49:29 -0400
Received: by werc12 with SMTP id c12so29820wer.1
        for <mm-commits@vger.kernel.org>; Tue, 01 May 2012 11:49:28 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: neilb@suse.de, greg@kroah.com, zbr@ioremap.net


The patch titled
     Subject: w1: introduce a slave mutex for serializing IO
has been added to the -mm tree.  Its filename is
     w1-introduce-a-slave-mutex-for-serializing-io.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: NeilBrown <neilb@suse.de>
Subject: w1: introduce a slave mutex for serializing IO

w1 devices need a mutex to serial IO.  Most use master->mutex.
However that is used for other purposes and they can conflict.

In particular master->mutex is held while w1_attach_slave_device is
called.

For bq27000, this registers a 'powersupply' device which tries to read the
current status.  The attempt to read will cause a deadlock on
master->mutex.

So create a new per-slave mutex and use that for serializing IO for
bq27000.

Signed-off-by: NeilBrown <neilb@suse.de>
Cc: Evgeniy Polyakov <zbr@ioremap.net>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/w1/slaves/w1_bq27000.c |    4 ++--
 drivers/w1/w1.c                |    1 +
 drivers/w1/w1.h                |    1 +
 3 files changed, 4 insertions(+), 2 deletions(-)

diff -puN drivers/w1/slaves/w1_bq27000.c~w1-introduce-a-slave-mutex-for-serializing-io drivers/w1/slaves/w1_bq27000.c
--- a/drivers/w1/slaves/w1_bq27000.c~w1-introduce-a-slave-mutex-for-serializing-io
+++ a/drivers/w1/slaves/w1_bq27000.c
@@ -31,10 +31,10 @@ static int w1_bq27000_read(struct device
 	u8 val;
 	struct w1_slave *sl = container_of(dev->parent, struct w1_slave, dev);
 
-	mutex_lock(&sl->master->mutex);
+	mutex_lock(&sl->mutex);
 	w1_write_8(sl->master, HDQ_CMD_READ | reg);
 	val = w1_read_8(sl->master);
-	mutex_unlock(&sl->master->mutex);
+	mutex_unlock(&sl->mutex);
 
 	return val;
 }
diff -puN drivers/w1/w1.c~w1-introduce-a-slave-mutex-for-serializing-io drivers/w1/w1.c
--- a/drivers/w1/w1.c~w1-introduce-a-slave-mutex-for-serializing-io
+++ a/drivers/w1/w1.c
@@ -688,6 +688,7 @@ static int w1_attach_slave_device(struct
 	memcpy(&sl->reg_num, rn, sizeof(sl->reg_num));
 	atomic_set(&sl->refcnt, 0);
 	init_completion(&sl->released);
+	mutex_init(&sl->mutex);
 
 	spin_lock(&w1_flock);
 	f = w1_family_registered(rn->family);
diff -puN drivers/w1/w1.h~w1-introduce-a-slave-mutex-for-serializing-io drivers/w1/w1.h
--- a/drivers/w1/w1.h~w1-introduce-a-slave-mutex-for-serializing-io
+++ a/drivers/w1/w1.h
@@ -75,6 +75,7 @@ struct w1_slave
 	void			*family_data;
 	struct device		dev;
 	struct completion	released;
+	struct mutex		mutex;
 };
 
 typedef void (*w1_slave_found_callback)(struct w1_master *, u64);
_
Subject: Subject: w1: introduce a slave mutex for serializing IO

Patches currently in -mm which might be from neilb@suse.de are

linux-next.patch
umem-fix-up-unplugging.patch
leds-add-new-transient-trigger-for-one-shot-timer-activation.patch
w1-introduce-a-slave-mutex-for-serializing-io.patch

