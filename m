From: akpm@linux-foundation.org
Subject: [merged] ipmi_watchdog-restore-settings-when-bmc-reset.patch removed from -mm tree
Date: Wed, 28 Dec 2011 14:04:46 -0800
Message-ID: <20111228220446.B85651E0078@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gx0-f202.google.com ([209.85.161.202]:64933 "EHLO
	mail-gx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754612Ab1L1WEr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 28 Dec 2011 17:04:47 -0500
Received: by ggnv2 with SMTP id v2so1505512ggn.1
        for <mm-commits@vger.kernel.org>; Wed, 28 Dec 2011 14:04:47 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cminyard@mvista.com, a.miskiewicz@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ipmi_watchdog: restore settings when BMC reset
has been removed from the -mm tree.  Its filename was
     ipmi_watchdog-restore-settings-when-bmc-reset.patch

This patch was dropped because it was merged into mainline or a subsyst=
em tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
=46rom: Corey Minyard <cminyard@mvista.com>
Subject: ipmi_watchdog: restore settings when BMC reset

If the BMC gets reset, it will return 0x80 response errors.

In less than a week
# grep "Error 80 on cmd 22" /var/log/kernel |wc -l
378681

In this case, it is probably a good idea to restore the IPMI settings.

Signed-off-by: Corey Minyard <cminyard@mvista.com>
Tested-by: Arkadiusz Mi=C5=9Bkiewicz <a.miskiewicz@gmail.com>
Reported-by: Arkadiusz Mi=C5=9Bkiewicz <a.miskiewicz@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/ipmi/ipmi_watchdog.c |   41 +++++++++++++++++++++++++---
 1 file changed, 38 insertions(+), 3 deletions(-)

diff -puN drivers/char/ipmi/ipmi_watchdog.c~ipmi_watchdog-restore-setti=
ngs-when-bmc-reset drivers/char/ipmi/ipmi_watchdog.c
--- a/drivers/char/ipmi/ipmi_watchdog.c~ipmi_watchdog-restore-settings-=
when-bmc-reset
+++ a/drivers/char/ipmi/ipmi_watchdog.c
@@ -139,6 +139,8 @@
 #define IPMI_WDOG_SET_TIMER		0x24
 #define IPMI_WDOG_GET_TIMER		0x25
=20
+#define IPMI_WDOG_TIMER_NOT_INIT_RESP	0x80
+
 /* These are here until the real ones get into the watchdog.h interfac=
e. */
 #ifndef WDIOC_GETTIMEOUT
 #define	WDIOC_GETTIMEOUT        _IOW(WATCHDOG_IOCTL_BASE, 20, int)
@@ -596,6 +598,7 @@ static int ipmi_heartbeat(void)
 	struct kernel_ipmi_msg            msg;
 	int                               rv;
 	struct ipmi_system_interface_addr addr;
+	int				  timeout_retries =3D 0;
=20
 	if (ipmi_ignore_heartbeat)
 		return 0;
@@ -616,6 +619,7 @@ static int ipmi_heartbeat(void)
=20
 	mutex_lock(&heartbeat_lock);
=20
+restart:
 	atomic_set(&heartbeat_tofree, 2);
=20
 	/*
@@ -653,7 +657,33 @@ static int ipmi_heartbeat(void)
 	/* Wait for the heartbeat to be sent. */
 	wait_for_completion(&heartbeat_wait);
=20
-	if (heartbeat_recv_msg.msg.data[0] !=3D 0) {
+	if (heartbeat_recv_msg.msg.data[0] =3D=3D IPMI_WDOG_TIMER_NOT_INIT_RE=
SP)  {
+		timeout_retries++;
+		if (timeout_retries > 3) {
+			printk(KERN_ERR PFX ": Unable to restore the IPMI"
+			       " watchdog's settings, giving up.\n");
+			rv =3D -EIO;
+			goto out_unlock;
+		}
+
+		/*
+		 * The timer was not initialized, that means the BMC was
+		 * probably reset and lost the watchdog information.  Attempt
+		 * to restore the timer's info.  Note that we still hold
+		 * the heartbeat lock, to keep a heartbeat from happening
+		 * in this process, so must say no heartbeat to avoid a
+		 * deadlock on this mutex.
+		 */
+		rv =3D ipmi_set_timeout(IPMI_SET_TIMEOUT_NO_HB);
+		if (rv) {
+			printk(KERN_ERR PFX ": Unable to send the command to"
+			       " set the watchdog's settings, giving up.\n");
+			goto out_unlock;
+		}
+
+		/* We might need a new heartbeat, so do it now */
+		goto restart;
+	} else if (heartbeat_recv_msg.msg.data[0] !=3D 0) {
 		/*
 		 * Got an error in the heartbeat response.  It was already
 		 * reported in ipmi_wdog_msg_handler, but we should return
@@ -662,6 +692,7 @@ static int ipmi_heartbeat(void)
 		rv =3D -EINVAL;
 	}
=20
+out_unlock:
 	mutex_unlock(&heartbeat_lock);
=20
 	return rv;
@@ -922,11 +953,15 @@ static struct miscdevice ipmi_wdog_miscd
 static void ipmi_wdog_msg_handler(struct ipmi_recv_msg *msg,
 				  void                 *handler_data)
 {
-	if (msg->msg.data[0] !=3D 0) {
+	if (msg->msg.cmd =3D=3D IPMI_WDOG_RESET_TIMER &&
+			msg->msg.data[0] =3D=3D IPMI_WDOG_TIMER_NOT_INIT_RESP)
+		printk(KERN_INFO PFX "response: The IPMI controller appears"
+		       " to have been reset, will attempt to reinitialize"
+		       " the watchdog timer\n");
+	else if (msg->msg.data[0] !=3D 0)
 		printk(KERN_ERR PFX "response: Error %x on cmd %x\n",
 		       msg->msg.data[0],
 		       msg->msg.cmd);
-	}
=20
 	ipmi_free_recv_msg(msg);
 }
_

Patches currently in -mm which might be from cminyard@mvista.com are


--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
