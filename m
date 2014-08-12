From: akpm@linux-foundation.org
Subject: [merged]
 init-make-rootdelay=n-consistent-with-rootwait-behaviour.patch removed from -mm tree
Date: Tue, 12 Aug 2014 12:38:18 -0700
Message-ID: <53ea6d2a.xu3uo4ctvPtzJK1R%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:37537 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754871AbaHLTiT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 12 Aug 2014 15:38:19 -0400
Received: by mail-qa0-f74.google.com with SMTP id j15so1309495qaq.1
        for <mm-commits@vger.kernel.org>; Tue, 12 Aug 2014 12:38:18 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: paul.gortmaker@windriver.com, mm-commits@vger.kernel.org


The patch titled
     Subject: init: make rootdelay=N consistent with rootwait behaviour
has been removed from the -mm tree.  Its filename was
     init-make-rootdelay=n-consistent-with-rootwait-behaviour.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: init: make rootdelay=N consistent with rootwait behaviour

Currently rootdelay=N and rootwait behave differently (aside from the
obvious unbounded wait duration) because they are at different places in
the init sequence.

The difference manifests itself for md devices because the call to
md_run_setup() lives between rootdelay and rootwait, so if you try to use
rootdelay=20 to try and allow a slow RAID0 array to assemble, you get
this:

[    4.526011] sd 6:0:0:0: [sdc] Attached SCSI removable disk
[   22.972079] md: Waiting for all devices to be available before autodetect

i.e.  you've achieved nothing other than delaying the probing 20s, when
what you wanted was a 20s delay _after_ the probing for md devices was
initiated.

Here we move the rootdelay code to be right beside the rootwait code, so
that their behaviour is consistent.

It should be noted that in doing so, the actions based on the
saved_root_name[0] and initrd_load() were previously put on hold by
rootdelay=N and now currently will not be delayed.  However, I think
consistent behaviour is more important than matching historical behaviour
of delaying the above two operations.

Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/do_mounts.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff -puN init/do_mounts.c~init-make-rootdelay=n-consistent-with-rootwait-behaviour init/do_mounts.c
--- a/init/do_mounts.c~init-make-rootdelay=n-consistent-with-rootwait-behaviour
+++ a/init/do_mounts.c
@@ -539,12 +539,6 @@ void __init prepare_namespace(void)
 {
 	int is_floppy;
 
-	if (root_delay) {
-		printk(KERN_INFO "Waiting %d sec before mounting root device...\n",
-		       root_delay);
-		ssleep(root_delay);
-	}
