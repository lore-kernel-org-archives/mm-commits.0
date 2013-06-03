From: akpm@linux-foundation.org
Subject: + clean-up-scary-strncpydst-src-strlensrc-uses.patch added to -mm tree
Date: Mon, 03 Jun 2013 15:22:15 -0700
Message-ID: <51ad1717.CwfPiol0gBeqYLn0%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40844 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758798Ab3FCWWQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 3 Jun 2013 18:22:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, ursula.braun@de.ibm.com, schwidefsky@de.ibm.com, richard@nod.at, rafael.j.wysocki@intel.com, heiko.carstens@de.ibm.com, gregkh@linuxfoundation.org, blaschka@linux.vnet.ibm.com, keescook@chromium.org

Subject: + clean-up-scary-strncpydst-src-strlensrc-uses.patch added to -mm tree
To: keescook@chromium.org,blaschka@linux.vnet.ibm.com,gregkh@linuxfoundation.org,heiko.carstens@de.ibm.com,rafael.j.wysocki@intel.com,richard@nod.at,schwidefsky@de.ibm.com,ursula.braun@de.ibm.com
From: akpm@linux-foundation.org
Date: Mon, 03 Jun 2013 15:22:15 -0700


The patch titled
     Subject: clean up scary strncpy(dst, src, strlen(src)) uses
has been added to the -mm tree.  Its filename is
     clean-up-scary-strncpydst-src-strlensrc-uses.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Kees Cook <keescook@chromium.org>
Subject: clean up scary strncpy(dst, src, strlen(src)) uses

Fix various weird constructions of strncpy(dst, src, strlen(src)).  Length
limits should be about the space available in the destination, not
repurposed as a method to either always include or always exclude a
trailing NULL byte.  Either the NULL should always be copied (using
strlcpy), or it should not be copied (using something like memcpy). 
Readable code should not depend on the weird behavior of strncpy when it
hits the length limit.  Better to avoid the anti-pattern entirely.

Signed-off-by: Kees Cook <keescook@chromium.org>
Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>	[staging]
Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>	[acpi]
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Ursula Braun <ursula.braun@de.ibm.com>
Cc: Frank Blaschka <blaschka@linux.vnet.ibm.com>
Cc: Richard Weinberger <richard@nod.at>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/accounting/getdelays.c             |    3 ++-
 drivers/acpi/sysfs.c                             |    3 +--
 drivers/s390/net/qeth_l3_sys.c                   |    6 ++----
 drivers/staging/tidspbridge/rmgr/drv_interface.c |    3 +--
 fs/hppfs/hppfs.c                                 |   11 ++++++-----
 5 files changed, 12 insertions(+), 14 deletions(-)

diff -puN Documentation/accounting/getdelays.c~clean-up-scary-strncpydst-src-strlensrc-uses Documentation/accounting/getdelays.c
--- a/Documentation/accounting/getdelays.c~clean-up-scary-strncpydst-src-strlensrc-uses
+++ a/Documentation/accounting/getdelays.c
@@ -23,6 +23,7 @@
 #include <sys/socket.h>
 #include <sys/wait.h>
 #include <signal.h>
+#include <bsd/string.h>
 
 #include <linux/genetlink.h>
 #include <linux/taskstats.h>
@@ -299,7 +300,7 @@ int main(int argc, char *argv[])
 			break;
 		case 'C':
 			containerset = 1;
-			strncpy(containerpath, optarg, strlen(optarg) + 1);
+			strlcpy(containerpath, optarg, sizeof(containerpath));
 			break;
 		case 'w':
 			logfile = strdup(optarg);
diff -puN drivers/acpi/sysfs.c~clean-up-scary-strncpydst-src-strlensrc-uses drivers/acpi/sysfs.c
--- a/drivers/acpi/sysfs.c~clean-up-scary-strncpydst-src-strlensrc-uses
+++ a/drivers/acpi/sysfs.c
@@ -677,10 +677,9 @@ void acpi_irq_stats_init(void)
 		else
 			sprintf(buffer, "bug%02X", i);
 
-		name = kzalloc(strlen(buffer) + 1, GFP_KERNEL);
+		name = kstrdup(buffer, GFP_KERNEL);
 		if (name == NULL)
 			goto fail;
-		strncpy(name, buffer, strlen(buffer) + 1);
 
 		sysfs_attr_init(&counter_attrs[i].attr);
 		counter_attrs[i].attr.name = name;
diff -puN drivers/s390/net/qeth_l3_sys.c~clean-up-scary-strncpydst-src-strlensrc-uses drivers/s390/net/qeth_l3_sys.c
--- a/drivers/s390/net/qeth_l3_sys.c~clean-up-scary-strncpydst-src-strlensrc-uses
+++ a/drivers/s390/net/qeth_l3_sys.c
@@ -315,10 +315,8 @@ static ssize_t qeth_l3_dev_hsuid_store(s
 	if (qeth_configure_cq(card, QETH_CQ_ENABLED))
 		return -EPERM;
 
-	for (i = 0; i < 8; i++)
-		card->options.hsuid[i] = ' ';
-	card->options.hsuid[8] = '\0';
-	strncpy(card->options.hsuid, tmp, strlen(tmp));
+	snprintf(card->options.hsuid, sizeof(card->options.hsuid),
+		 "%-8s", tmp);
 	ASCEBC(card->options.hsuid, 8);
 	if (card->dev)
 		memcpy(card->dev->perm_addr, card->options.hsuid, 9);
diff -puN drivers/staging/tidspbridge/rmgr/drv_interface.c~clean-up-scary-strncpydst-src-strlensrc-uses drivers/staging/tidspbridge/rmgr/drv_interface.c
--- a/drivers/staging/tidspbridge/rmgr/drv_interface.c~clean-up-scary-strncpydst-src-strlensrc-uses
+++ a/drivers/staging/tidspbridge/rmgr/drv_interface.c
@@ -421,12 +421,11 @@ static int omap3_bridge_startup(struct p
 	drv_datap->tc_wordswapon = tc_wordswapon;
 
 	if (base_img) {
-		drv_datap->base_img = kmalloc(strlen(base_img) + 1, GFP_KERNEL);
+		drv_datap->base_img = kstrdup(base_img, GFP_KERNEL);
 		if (!drv_datap->base_img) {
 			err = -ENOMEM;
 			goto err2;
 		}
-		strncpy(drv_datap->base_img, base_img, strlen(base_img) + 1);
 	}
 
 	dev_set_drvdata(bridge, drv_datap);
diff -puN fs/hppfs/hppfs.c~clean-up-scary-strncpydst-src-strlensrc-uses fs/hppfs/hppfs.c
--- a/fs/hppfs/hppfs.c~clean-up-scary-strncpydst-src-strlensrc-uses
+++ a/fs/hppfs/hppfs.c
@@ -69,7 +69,7 @@ static char *dentry_name(struct dentry *
 	struct dentry *parent;
 	char *root, *name;
 	const char *seg_name;
-	int len, seg_len;
+	int len, seg_len, root_len;
 
 	len = 0;
 	parent = dentry;
@@ -81,7 +81,8 @@ static char *dentry_name(struct dentry *
 	}
 
 	root = "proc";
-	len += strlen(root);
+	root_len = strlen(root);
+	len += root_len;
 	name = kmalloc(len + extra + 1, GFP_KERNEL);
 	if (name == NULL)
 		return NULL;
@@ -91,7 +92,7 @@ static char *dentry_name(struct dentry *
 	while (parent->d_parent != parent) {
 		if (is_pid(parent)) {
 			seg_name = "pid";
-			seg_len = strlen("pid");
+			seg_len = strlen(seg_name);
 		}
 		else {
 			seg_name = parent->d_name.name;
@@ -100,10 +101,10 @@ static char *dentry_name(struct dentry *
 
 		len -= seg_len + 1;
 		name[len] = '/';
-		strncpy(&name[len + 1], seg_name, seg_len);
+		memcpy(&name[len + 1], seg_name, seg_len);
 		parent = parent->d_parent;
 	}
-	strncpy(name, root, strlen(root));
+	memcpy(name, root, root_len);
 	return name;
 }
 
_

Patches currently in -mm which might be from keescook@chromium.org are

origin.patch
kmsg-honor-dmesg_restrict-sysctl-on-dev-kmsg.patch
kmsg-honor-dmesg_restrict-sysctl-on-dev-kmsg-fix.patch
drivers-mtd-chips-gen_probec-refactor-call-to-request_module.patch
clean-up-scary-strncpydst-src-strlensrc-uses.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch

