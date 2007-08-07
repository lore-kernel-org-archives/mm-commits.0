From: akpm@linux-foundation.org
Subject: - request_firmware-skip-timeout-if-userspace-was-not-notified.patch removed from -mm tree
Date: Tue, 07 Aug 2007 13:44:27 -0700
Message-ID: <200708072044.l77KiRMw003084@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56316 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760716AbXHGUpH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Aug 2007 16:45:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: javier.pello@urjc.es, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     request_firmware: skip timeout if userspace was not  notified
has been removed from the -mm tree.  Its filename was
     request_firmware-skip-timeout-if-userspace-was-not-notified.patch

This patch was dropped because it was nacked

------------------------------------------------------
Subject: request_firmware: skip timeout if userspace was not  notified
From: Javier Pello <javier.pello@urjc.es>

Make request_firmware skip the usual grace period that it gives firmware
images to show up, if it determines that userspace was not notified at all.

When request_firmware is called, it sends an event to userspace to ask for
the firmware image that is needed, and then it installs a timeout so that
it will not wait forever for the image.  However, if userspace did not
receive the event at all (no /sbin/hotplug, for instance), then having the
kernel wait is pointless.  This is particularly true during boot, when the
wait is done synchronously and the whole kernel freezes for a minute.

The attached patch fixes this by making _request_firmware check whether the
firmware loading event was succesfully sent to userspace, and skip the
timeout if it has not.  The patch comes in two parts:

1. The first part changes kobject_uevent_env in lib/kobject_uevent.c
to report a failure if both netlink_broadcast (if applicable) and
call_usermodehelper fail to send the event to userspace. Nothing in
the kernel seems to care about the return value of kobject_uevent_env,
so this should not break anything.

2. The second part changes _request_firmware in
drivers/base/firmware_class.c to actually check the return value of
kobject_uevent and skip the loading_timeout delay if the loading event

Signed-off-by: Javier Pello <javier.pello@urjc.es>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/firmware_class.c |    8 ++++++--
 lib/kobject_uevent.c          |   16 ++++++++++++++--
 2 files changed, 20 insertions(+), 4 deletions(-)

diff -puN drivers/base/firmware_class.c~request_firmware-skip-timeout-if-userspace-was-not-notified drivers/base/firmware_class.c
--- a/drivers/base/firmware_class.c~request_firmware-skip-timeout-if-userspace-was-not-notified
+++ a/drivers/base/firmware_class.c
@@ -421,8 +421,12 @@ _request_firmware(const struct firmware 
 			add_timer(&fw_priv->timeout);
 		}
 
-		kobject_uevent(&f_dev->kobj, KOBJ_ADD);
-		wait_for_completion(&fw_priv->completion);
+		retval = kobject_uevent(&f_dev->kobj, KOBJ_ADD);
+		if (retval) {
+			fw_load_abort(fw_priv);
+		} else {
+			wait_for_completion(&fw_priv->completion);
+		}
 		set_bit(FW_STATUS_DONE, &fw_priv->status);
 		del_timer_sync(&fw_priv->timeout);
 	} else
diff -puN lib/kobject_uevent.c~request_firmware-skip-timeout-if-userspace-was-not-notified lib/kobject_uevent.c
--- a/lib/kobject_uevent.c~request_firmware-skip-timeout-if-userspace-was-not-notified
+++ a/lib/kobject_uevent.c
@@ -186,7 +186,8 @@ int kobject_uevent_env(struct kobject *k
 			}
 
 			NETLINK_CB(skb).dst_group = 1;
-			netlink_broadcast(uevent_sock, skb, 0, 1, GFP_KERNEL);
+			retval = netlink_broadcast(uevent_sock, skb, 0, 1,
+						GFP_KERNEL);
 		}
 	}
 #endif
@@ -198,7 +199,18 @@ int kobject_uevent_env(struct kobject *k
 		argv [0] = uevent_helper;
 		argv [1] = (char *)subsystem;
 		argv [2] = NULL;
-		call_usermodehelper (argv[0], argv, envp, UMH_WAIT_EXEC);
+#if defined(CONFIG_NET)
+		if (retval) {
+			retval = call_usermodehelper (argv[0], argv, envp,
+						UMH_WAIT_EXEC);
+		} else {
+			call_usermodehelper (argv[0], argv, envp,
+						UMH_WAIT_EXEC);
+		}
+#else
+		retval = call_usermodehelper (argv[0], argv, envp,
+						UMH_WAIT_EXEC);
+#endif
 	}
 
 exit:
_

Patches currently in -mm which might be from javier.pello@urjc.es are

request_firmware-skip-timeout-if-userspace-was-not-notified.patch
request_firmware-skip-timeout-if-userspace-was-not-notified-fix.patch
