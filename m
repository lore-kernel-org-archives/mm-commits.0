From: akpm@linux-foundation.org
Subject: + drivers-w1-make-w1_slave-flags-long-to-avoid-casts.patch added
 to -mm tree
Date: Wed, 30 Oct 2013 15:59:43 -0700
Message-ID: <52718f5f.hWKjM100JvkVteue%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49838 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754918Ab3J3W7o (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 30 Oct 2013 18:59:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, zbr@ioremap.net, greg@kroah.com, mina86@mina86.com

Subject: + drivers-w1-make-w1_slave-flags-long-to-avoid-casts.patch added to -mm tree
To: mina86@mina86.com,greg@kroah.com,zbr@ioremap.net
From: akpm@linux-foundation.org
Date: Wed, 30 Oct 2013 15:59:43 -0700


The patch titled
     Subject: drivers: w1: make w1_slave::flags long to avoid casts
has been added to the -mm tree.  Its filename is
     drivers-w1-make-w1_slave-flags-long-to-avoid-casts.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/drivers-w1-make-w1_slave-flags-long-to-avoid-casts.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/drivers-w1-make-w1_slave-flags-long-to-avoid-casts.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Michal Nazarewicz <mina86@mina86.com>
Subject: drivers: w1: make w1_slave::flags long to avoid casts

Changing flags field of the w1_slave to unsigned long may on some
architectures increase the size of the structure, but otherwise makes the
code more kosher as casting is avoided and *_bit family of calls do not
attempt to operate on an entity of bigger size than really is available.

The current behaviour does not introduce any bugs (since any bytes past
flags field are preserved) but make the code slightly more confusing then
it needs to be.

Signed-off-by: Michal Nazarewicz <mina86@mina86.com>
Cc: Evgeniy Polyakov <zbr@ioremap.net>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/w1/w1.c |   10 +++++-----
 drivers/w1/w1.h |    2 +-
 2 files changed, 6 insertions(+), 6 deletions(-)

diff -puN drivers/w1/w1.c~drivers-w1-make-w1_slave-flags-long-to-avoid-casts drivers/w1/w1.c
--- a/drivers/w1/w1.c~drivers-w1-make-w1_slave-flags-long-to-avoid-casts
+++ a/drivers/w1/w1.c
@@ -709,7 +709,7 @@ static int w1_attach_slave_device(struct
 
 	sl->owner = THIS_MODULE;
 	sl->master = dev;
-	set_bit(W1_SLAVE_ACTIVE, (long *)&sl->flags);
+	set_bit(W1_SLAVE_ACTIVE, &sl->flags);
 
 	memset(&msg, 0, sizeof(msg));
 	memcpy(&sl->reg_num, rn, sizeof(sl->reg_num));
@@ -866,7 +866,7 @@ void w1_slave_found(struct w1_master *de
 
 	sl = w1_slave_search_device(dev, tmp);
 	if (sl) {
-		set_bit(W1_SLAVE_ACTIVE, (long *)&sl->flags);
+		set_bit(W1_SLAVE_ACTIVE, &sl->flags);
 	} else {
 		if (rn && tmp->crc == w1_calc_crc8((u8 *)&rn_le, 7))
 			w1_attach_slave_device(dev, tmp);
@@ -984,14 +984,14 @@ void w1_search_process_cb(struct w1_mast
 	struct w1_slave *sl, *sln;
 
 	list_for_each_entry(sl, &dev->slist, w1_slave_entry)
-		clear_bit(W1_SLAVE_ACTIVE, (long *)&sl->flags);
+		clear_bit(W1_SLAVE_ACTIVE, &sl->flags);
 
 	w1_search_devices(dev, search_type, cb);
 
 	list_for_each_entry_safe(sl, sln, &dev->slist, w1_slave_entry) {
-		if (!test_bit(W1_SLAVE_ACTIVE, (unsigned long *)&sl->flags) && !--sl->ttl)
+		if (!test_bit(W1_SLAVE_ACTIVE, &sl->flags) && !--sl->ttl)
 			w1_slave_detach(sl);
-		else if (test_bit(W1_SLAVE_ACTIVE, (unsigned long *)&sl->flags))
+		else if (test_bit(W1_SLAVE_ACTIVE, &sl->flags))
 			sl->ttl = dev->slave_ttl;
 	}
 
diff -puN drivers/w1/w1.h~drivers-w1-make-w1_slave-flags-long-to-avoid-casts drivers/w1/w1.h
--- a/drivers/w1/w1.h~drivers-w1-make-w1_slave-flags-long-to-avoid-casts
+++ a/drivers/w1/w1.h
@@ -67,8 +67,8 @@ struct w1_slave
 	struct w1_reg_num	reg_num;
 	atomic_t		refcnt;
 	u8			rom[9];
-	u32			flags;
 	int			ttl;
+	unsigned long		flags;
 
 	struct w1_master	*master;
 	struct w1_family	*family;
_

Patches currently in -mm which might be from mina86@mina86.com are

memblock-factor-out-of-top-down-allocation.patch
memblock-introduce-bottom-up-allocation-mode.patch
x86-mm-factor-out-of-top-down-direct-mapping-setup.patch
x86-mem-hotplug-support-initialize-page-tables-in-bottom-up.patch
x86-acpi-crash-kdump-do-reserve_crashkernel-after-srat-is-parsed.patch
mem-hotplug-introduce-movable_node-boot-option.patch
drivers-memstick-core-mspro_blockc-fix-attributes-array-allocation.patch
drivers-w1-make-w1_slave-flags-long-to-avoid-casts.patch
linux-next.patch
debugging-keep-track-of-page-owners-fix-2.patch
debugging-keep-track-of-page-owners-fix-2-fix-fix.patch

