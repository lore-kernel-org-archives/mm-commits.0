From: akpm@linux-foundation.org
Subject: - kernel-ksysfsc-fix-dependence-on-config_net.patch removed from -mm tree
Date: Thu, 20 Nov 2008 12:43:43 -0800
Message-ID: <200811202043.mAKKhhvQ007668@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58546 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755209AbYKTUuG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 20 Nov 2008 15:50:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tom.leiming@gmail.com, greg@kroah.com, kay.sievers@vrfy.org, mm-commits@vger.kernel.org


The patch titled
     kernel/ksysfs.c:fix dependence on CONFIG_NET
has been removed from the -mm tree.  Its filename was
     kernel-ksysfsc-fix-dependence-on-config_net.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kernel/ksysfs.c:fix dependence on CONFIG_NET
From: Ming Lei <tom.leiming@gmail.com>

Access to uevent_seqnum and uevent_helper does not need to depend on
CONFIG_NET, so remove it.

Signed-off-by: Ming Lei <tom.leiming@gmail.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/ksysfs.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN kernel/ksysfs.c~kernel-ksysfsc-fix-dependence-on-config_net kernel/ksysfs.c
--- a/kernel/ksysfs.c~kernel-ksysfsc-fix-dependence-on-config_net
+++ a/kernel/ksysfs.c
@@ -24,7 +24,7 @@ static struct kobj_attribute _name##_att
 static struct kobj_attribute _name##_attr = \
 	__ATTR(_name, 0644, _name##_show, _name##_store)
 
-#if defined(CONFIG_HOTPLUG) && defined(CONFIG_NET)
+#if defined(CONFIG_HOTPLUG)
 /* current uevent sequence number */
 static ssize_t uevent_seqnum_show(struct kobject *kobj,
 				  struct kobj_attribute *attr, char *buf)
@@ -137,7 +137,7 @@ struct kobject *kernel_kobj;
 EXPORT_SYMBOL_GPL(kernel_kobj);
 
 static struct attribute * kernel_attrs[] = {
-#if defined(CONFIG_HOTPLUG) && defined(CONFIG_NET)
+#if defined(CONFIG_HOTPLUG)
 	&uevent_seqnum_attr.attr,
 	&uevent_helper_attr.attr,
 #endif
_

Patches currently in -mm which might be from tom.leiming@gmail.com are

linux-next.patch

