From: akpm@linux-foundation.org
Subject: + loop_probe-fix-return-value.patch added to -mm tree
Date: Thu, 10 May 2007 23:23:10 -0700
Message-ID: <200705110623.l4B6NA8U008684@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:36699 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754762AbXEKGYF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 11 May 2007 02:24:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kenchen@google.com, a.p.zijlstra@chello.nl, adobriyan@sw.ru, jeremy@goop.org


The patch titled
     loop_probe: fix return value
has been added to the -mm tree.  Its filename is
     loop_probe-fix-return-value.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: loop_probe: fix return value
From: "Ken Chen" <kenchen@google.com>

A BUG is actually triggered by the __module_get(THIS_MODULE) in
loop_set_fd.

It's a mis-understanding on what kobj_probe_t function is suppose to return
on success.  When we open loop device that has not been initialized, we
probe it via:

do_open
  get_gendisk
    kobj_lookup
      loop_probe

Notice that in kobj_lookup(), when p->probe() returns non-zero value (I
presume it is an -ERRNO), it breaks out of the loop and propagate the
return value, otherwise, loops back to the beginning of the for loop and
retry, and in there get_disk() will be called via p->lock() to get a ref
against the module.

kobj_look_up(...) {
retry:
        mutex_lock(domain->lock);
        for (p = domain->probes[MAJOR(dev) % 255]; p; p = p->next) {
        ...
        if (kobj)
                return kobj;
        goto retry;
}

So loop_probe() mistakenly returned wrong status and leads to future
oops on inconsistent module ref count.  The following patch fixes the
issue.

Signed-off-by: Ken Chen <kenchen@google.com>
Cc: "Jeremy Fitzhardinge" <jeremy@goop.org>
Cc: "Peter Zijlstra" <a.p.zijlstra@chello.nl>
Cc: "Alexey Dobriyan" <adobriyan@sw.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/loop.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN drivers/block/loop.c~loop_probe-fix-return-value drivers/block/loop.c
--- a/drivers/block/loop.c~loop_probe-fix-return-value
+++ a/drivers/block/loop.c
@@ -1460,6 +1460,7 @@ static void loop_del_one(struct loop_dev
 	kfree(lo);
 }
 
+/* return NULL for success, or return non-zero value if there are error */
 static struct kobject *loop_probe(dev_t dev, int *part, void *data)
 {
 	unsigned int number = dev & MINORMASK;
@@ -1474,8 +1475,8 @@ static struct kobject *loop_probe(dev_t 
 	*part = 0;
 	if (IS_ERR(lo))
 		return (void *)lo;
-	else
-		return &lo->lo_disk->kobj;
+
+	return NULL;
 }
 
 static int __init loop_init(void)
_

Patches currently in -mm which might be from kenchen@google.com are

origin.patch
loop_probe-fix-return-value.patch
cache-pipe-buf-page-address-for-non-highmem-arch.patch
