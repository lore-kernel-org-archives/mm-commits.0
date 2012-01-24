From: akpm@linux-foundation.org
Subject: + thermal-thermal_sys-fix-build-warning-fix.patch added to -mm tree
Date: Tue, 24 Jan 2012 14:42:17 -0800
Message-ID: <20120124224217.636B0A03A5@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fx0-f74.google.com ([209.85.161.74]:38169 "EHLO
	mail-fx0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752270Ab2AXWmT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 24 Jan 2012 17:42:19 -0500
Received: by faaa19 with SMTP id a19so163956faa.1
        for <mm-commits@vger.kernel.org>; Tue, 24 Jan 2012 14:42:18 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, durgadoss.r@intel.com, fabio.estevam@freescale.com, festevam@gmail.com, guenter.roeck@ericsson.com, khali@linux-fr.org


The patch titled
     Subject: thermal-thermal_sys-fix-build-warning-fix
has been added to the -mm tree.  Its filename is
     thermal-thermal_sys-fix-build-warning-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: thermal-thermal_sys-fix-build-warning-fix

make thermal_event_seqnum local to generate_netlink_event()

Cc: Durgadoss R <durgadoss.r@intel.com>
Cc: Fabio Estevam <fabio.estevam@freescale.com>
Cc: Fabio Estevam <festevam@gmail.com>
Cc: Guenter Roeck <guenter.roeck@ericsson.com>
Cc: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/thermal/thermal_sys.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN drivers/thermal/thermal_sys.c~thermal-thermal_sys-fix-build-warning-fix drivers/thermal/thermal_sys.c
--- a/drivers/thermal/thermal_sys.c~thermal-thermal_sys-fix-build-warning-fix
+++ a/drivers/thermal/thermal_sys.c
@@ -1302,8 +1302,6 @@ static struct genl_multicast_group therm
 	.name = THERMAL_GENL_MCAST_GROUP_NAME,
 };
 
-static unsigned int thermal_event_seqnum;
-
 int thermal_generate_netlink_event(u32 orig, enum events event)
 {
 	struct sk_buff *skb;
@@ -1312,6 +1310,7 @@ int thermal_generate_netlink_event(u32 o
 	void *msg_header;
 	int size;
 	int result;
+	static unsigned int thermal_event_seqnum;
 
 	/* allocate memory */
 	size = nla_total_size(sizeof(struct thermal_genl_event)) + \
_
Subject: Subject: thermal-thermal_sys-fix-build-warning-fix

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
linux-next-git-rejects.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
x86-olpc-xo15-sci-enable-lid-close-wakeup-control-through-sysfs.patch
drivers-platform-x86-sony-laptopc-fix-scancodes.patch
fs-btrfs-inode-mapc-fix-warnings.patch
x86-use-this_cpu_xxx-to-replace-percpu_xxx-funcs-fix.patch
drivers-scsi-mpt2sas-mpt2sas_scsihc-spell-primitive-correctly.patch
drivers-usb-misc-emi26c-emi62c-fix-warnings.patch
mm.patch
mm-add-extra-free-kbytes-tunable-update-checkpatch-fixes.patch
hpet-factor-timer-allocate-from-open.patch
prctl-add-pr_setget_child_subreaper-to-allow-simple-process-supervision-fix.patch
prctl-add-pr_setget_child_subreaper-to-allow-simple-process-supervision-fix-fix.patch
prctl-add-pr_setget_child_subreaper-to-allow-simple-process-supervision-fix-fix-fix.patch
brlocks-lglocks-cleanups-checkpatch-fixes.patch
crc32-move-long-comment-about-crc32-fundamentals-to-documentation-fix.patch
thermal-thermal_sys-fix-build-warning-fix.patch
notify_change-check-that-i_mutex-is-held.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

