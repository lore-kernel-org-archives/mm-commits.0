From: akpm@linux-foundation.org
Subject: + hid-fix-tty-hid-deadlock.patch added to -mm tree
Date: Mon, 08 Sep 2008 13:36:29 -0700
Message-ID: <200809082036.m88KaTYl009080@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35827 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752618AbYIHUhO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Sep 2008 16:37:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jirislaby@gmail.com, Valdis.Kletnieks@vt.edu, alan@lxorguk.ukuu.org.uk, jkosina@suse.cz


The patch titled
     HID: fix tty<->hid deadlock
has been added to the -mm tree.  Its filename is
     hid-fix-tty-hid-deadlock.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: HID: fix tty<->hid deadlock
From: Jiri Slaby <jirislaby@gmail.com>

hid_compat_load() runs on the default workqueue, it request_module(), it
execs modprobe, it exits, tty flushes default workqueue, it hangs, because
we are still in it.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Tested-by: <Valdis.Kletnieks@vt.edu>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/hid/hid-core.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff -puN drivers/hid/hid-core.c~hid-fix-tty-hid-deadlock drivers/hid/hid-core.c
--- a/drivers/hid/hid-core.c~hid-fix-tty-hid-deadlock
+++ a/drivers/hid/hid-core.c
@@ -1655,6 +1655,7 @@ static void hid_compat_load(struct work_
 	request_module("hid-dummy");
 }
 static DECLARE_WORK(hid_compat_work, hid_compat_load);
+static struct workqueue_struct *hid_compat_wq;
 #endif
 
 static int __init hid_init(void)
@@ -1672,7 +1673,12 @@ static int __init hid_init(void)
 		goto err_bus;
 
 #ifdef CONFIG_HID_COMPAT
-	schedule_work(&hid_compat_work);
+	hid_compat_wq = create_workqueue("hid_compat");
+	if (!hid_compat_wq) {
+		hidraw_exit();
+		goto err;
+	}
+	queue_work(hid_compat_wq, &hid_compat_work);
 #endif
 
 	return 0;
@@ -1684,6 +1690,9 @@ err:
 
 static void __exit hid_exit(void)
 {
+#ifdef CONFIG_HID_COMPAT
+	destroy_workqueue(hid_compat_wq);
+#endif
 	hidraw_exit();
 	bus_unregister(&hid_bus_type);
 }
_

Patches currently in -mm which might be from jirislaby@gmail.com are

linux-next.patch
hid-fix-tty-hid-deadlock.patch
mm-owner-fix-race-between-swap-and-exit-fix.patch
serial-mpc52xx_uart-remove-code-associated-with-config_ppc_merge.patch
viafb-viafbdevc-viafbdevh.patch
viafb-viafbdevc-viafbdevh-checkpatch-fixes.patch
ip2-fix-iielliscleanup-as-it-is-static-but-not-always-used.patch
char-merge-ip2main-and-ip2base.patch
char-ip2-cleanup-globals.patch
char-ip2-fix-sparse-warnings.patch
char-ip2-init-deinit-cleanup.patch
ip2-avoid-add_timer-with-pending-timer.patch
char-ds1286-eliminate-busy-waiting.patch
applicomc-fix-apparently-broken-code-in-do_ac_read.patch
char-moxac-sparse-annotation.patch
reiser4.patch
shrink_slab-handle-bad-shrinkers.patch

