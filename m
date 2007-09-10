From: akpm@linux-foundation.org
Subject: + input-limit-memory-allocated-by-uinput-ff-drivers.patch added to -mm tree
Date: Mon, 10 Sep 2007 00:54:17 -0700
Message-ID: <200709100754.l8A7sHPx014275@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38439 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755231AbXIJHzG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 10 Sep 2007 03:55:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: cebbert@redhat.com, clameter@sgi.com, dtor@mail.ru


The patch titled
     input: limit memory allocated by uinput ff drivers
has been added to the -mm tree.  Its filename is
     input-limit-memory-allocated-by-uinput-ff-drivers.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: input: limit memory allocated by uinput ff drivers
From: Chuck Ebbert <cebbert@redhat.com>

Don't let force feedback drivers allocate more than 256K of kernel memory. 
On kernel 2.6.22 this causes a kernel OOPS with the SLUB memory allocator;
on later kernels the drivers may allocate large amounts of memory.

Signed-off-by: Chuck Ebbert <cebbert@redhat.com>
Cc: Dmitry Torokhov <dtor@mail.ru>
Cc: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/input/ff-core.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff -puN drivers/input/ff-core.c~input-limit-memory-allocated-by-uinput-ff-drivers drivers/input/ff-core.c
--- a/drivers/input/ff-core.c~input-limit-memory-allocated-by-uinput-ff-drivers
+++ a/drivers/input/ff-core.c
@@ -306,6 +306,7 @@ int input_ff_create(struct input_dev *de
 {
 	struct ff_device *ff;
 	int i;
+	int needed_mem;
 
 	if (!max_effects) {
 		printk(KERN_ERR
@@ -313,8 +314,11 @@ int input_ff_create(struct input_dev *de
 		return -EINVAL;
 	}
 
-	ff = kzalloc(sizeof(struct ff_device) +
-		     max_effects * sizeof(struct file *), GFP_KERNEL);
+	needed_mem = sizeof(struct ff_device) + max_effects * sizeof(struct file *);
+	if (needed_mem > 256 * 1024)
+		return -ENOMEM;
+
+	ff = kzalloc(needed_mem, GFP_KERNEL);
 	if (!ff)
 		return -ENOMEM;
 
_

Patches currently in -mm which might be from cebbert@redhat.com are

input-limit-memory-allocated-by-uinput-ff-drivers.patch
