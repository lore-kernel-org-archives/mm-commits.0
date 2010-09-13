From: akpm@linux-foundation.org
Subject: + cfq-iosched-fix-a-kernel-oops-when-usb-key-is-inserted.patch added to -mm tree
Date: Mon, 13 Sep 2010 15:48:58 -0700
Message-ID: <201009132248.o8DMmwah025752@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52575 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752257Ab0IMWtL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 13 Sep 2010 18:49:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: vgoyal@redhat.com, axboe@kernel.dk, mk.fraggod@gmail.com


The patch titled
     cfq-iosched: fix a kernel OOPs when usb key is inserted
has been added to the -mm tree.  Its filename is
     cfq-iosched-fix-a-kernel-oops-when-usb-key-is-inserted.patch

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
Subject: cfq-iosched: fix a kernel OOPs when usb key is inserted
From: Vivek Goyal <vgoyal@redhat.com>

Mike reported a kernel crash when a usb key hotplug is performed while all
kernel thrads are not in a root cgroup and are running in one of the child
cgroups of blkio controller.

	BUG: unable to handle kernel NULL pointer dereference at 0000002c
	IP: [<c11c7b08>] cfq_get_queue+0x232/0x412
	*pde = 00000000
	Oops: 0000 [#1] PREEMPT
	last sysfs file: /sys/devices/pci0000:00/0000:00:1d.7/usb2/2-1/2-1:1.0/host3/scsi_host/host3/uevent

	[..]
	Pid: 30039, comm: scsi_scan_3 Not tainted 2.6.35.2-fg.roam #1 Volvi2                         /Aspire 4315
	EIP: 0060:[<c11c7b08>] EFLAGS: 00010086 CPU: 0
	EIP is at cfq_get_queue+0x232/0x412
	EAX: f705f9c0 EBX: e977abac ECX: 00000000 EDX: 00000000
	ESI: f00da400 EDI: f00da4ec EBP: e977a800 ESP: dff8fd00
	 DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
	Process scsi_scan_3 (pid: 30039, ti=dff8e000 task=f6b6c9a0 task.ti=dff8e000)
	Stack:
	 00000000 00000000 00000001 01ff0000 f00da508 00000000 f00da524 f00da540
	<0> e7994940 dd631750 f705f9c0 e977a820 e977ac44 f00da4d0 00000001 f6b6c9a0
	<0> 00000010 00008010 0000000b 00000000 00000001 e977a800 dd76fac0 00000246
	Call Trace:
	 [<c11c7f10>] ? cfq_set_request+0x228/0x34c
	 [<c11c7ce8>] ? cfq_set_request+0x0/0x34c
	 [<c11bb3b9>] ? elv_set_request+0xf/0x1c
	 [<c11bdd51>] ? get_request+0x1ad/0x22f
	 [<c11bddf2>] ? get_request_wait+0x1f/0x11a
	 [<c11d013b>] ? kvasprintf+0x33/0x3b
	 [<c127b537>] ? scsi_execute+0x1d/0x103
	 [<c127b675>] ? scsi_execute_req+0x58/0x83
	 [<c127c391>] ? scsi_probe_and_add_lun+0x188/0x7c2
	 [<c12718c6>] ? attribute_container_add_device+0x15/0xfa
	 [<c11c95d1>] ? kobject_get+0xf/0x13
	 [<c126d1db>] ? get_device+0x10/0x14
	 [<c127be93>] ? scsi_alloc_target+0x217/0x24d
	 [<c127cbd8>] ? __scsi_scan_target+0x95/0x480
	 [<c10204eb>] ? dequeue_entity+0x14/0x1fe
	 [<c1020491>] ? update_curr+0x165/0x1ab
	 [<c1020491>] ? update_curr+0x165/0x1ab
	 [<c127d00d>] ? scsi_scan_channel+0x4a/0x76
	 [<c127d0b0>] ? scsi_scan_host_selected+0x77/0xad
	 [<c127d13c>] ? do_scan_async+0x0/0x11a
	 [<c127d137>] ? do_scsi_scan_host+0x51/0x56
	 [<c127d13c>] ? do_scan_async+0x0/0x11a
	 [<c127d14a>] ? do_scan_async+0xe/0x11a
	 [<c127d13c>] ? do_scan_async+0x0/0x11a
	 [<c10354c5>] ? kthread+0x5e/0x63
	 [<c1035467>] ? kthread+0x0/0x63
	 [<c1002af6>] ? kernel_thread_helper+0x6/0x10
	Code: 44 24 1c 54 83 44 24 18 54 83 fa 03 75 94 8b 06 c7 86 64 02 00 00 01 00 00 00 83 e0 03 09 f0 89 06 8b 44 24 28 8b 90 58 01 00 00 <8b> 42 2c 85 c0 75 03 8b 42 08 8d 54 24 48 52 8d 4c 24 50 51 68
	EIP: [<c11c7b08>] cfq_get_queue+0x232/0x412 SS:ESP 0068:dff8fd00
	CR2: 000000000000002c
	---[ end trace 9a88306573f69b12 ]---

The problem here is that we don't have bdi->dev information available when
thread does some IO.  Hence when dev_name() tries to access bdi->dev, it
crashes.

This problem does not happen if kernel threads are in root group as root
group is statically allocated at device initialization time and we don't
hit this piece of code.

Fix it by delaying the filling of major and minor number information of
device in blk_group.  Initially a blk_group is created with 0 as device
information and this information is filled later once some more IO comes
in from same group.

Reported-by: Mike Kazantsev <mk.fraggod@gmail.com>
Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 block/cfq-iosched.c |   16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff -puN block/cfq-iosched.c~cfq-iosched-fix-a-kernel-oops-when-usb-key-is-inserted block/cfq-iosched.c
--- a/block/cfq-iosched.c~cfq-iosched-fix-a-kernel-oops-when-usb-key-is-inserted
+++ a/block/cfq-iosched.c
@@ -1019,10 +1019,20 @@ cfq_find_alloc_cfqg(struct cfq_data *cfq
 	 */
 	atomic_set(&cfqg->ref, 1);
 
-	/* Add group onto cgroup list */
-	sscanf(dev_name(bdi->dev), "%u:%u", &major, &minor);
-	cfq_blkiocg_add_blkio_group(blkcg, &cfqg->blkg, (void *)cfqd,
+	/*
+	 * Add group onto cgroup list. It might happen that bdi->dev is
+	 * not initiliazed yet. Initialize this new group without major
+	 * and minor info and this info will be filled in once a new thread
+	 * comes for IO. See code above.
+	 */
+	if (bdi->dev) {
+		sscanf(dev_name(bdi->dev), "%u:%u", &major, &minor);
+		cfq_blkiocg_add_blkio_group(blkcg, &cfqg->blkg, (void *)cfqd,
 					MKDEV(major, minor));
+	} else
+		cfq_blkiocg_add_blkio_group(blkcg, &cfqg->blkg, (void *)cfqd,
+					0);
+
 	cfqg->weight = blkcg_get_weight(blkcg, cfqg->blkg.dev);
 
 	/* Add group on cfqd list */
_

Patches currently in -mm which might be from vgoyal@redhat.com are

cfq-iosched-fix-a-kernel-oops-when-usb-key-is-inserted.patch

