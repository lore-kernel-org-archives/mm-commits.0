From: akpm@linux-foundation.org
Subject: [merged] xen_balloon-support-memory-auto-onlining-policy.patch
 removed from -mm tree
Date: Wed, 16 Mar 2016 12:56:28 -0700
Message-ID: <56e9ba6c.gOamhGO6pi8jihgi%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39003 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755590AbcCPT4a (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 16 Mar 2016 15:56:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vkuznets@redhat.com, boris.ostrovsky@oracle.com, corbet@lwn.net, dan.j.williams@intel.com, daniel.kiper@oracle.com, david.vrabel@citrix.com, gregkh@linuxfoundation.org, imammedo@redhat.com, kay@vrfy.org, konrad.wilk@oracle.com, kys@microsoft.com, mgorman@techsingularity.net, n-horiguchi@ah.jp.nec.com, qiuxishi@huawei.com, rientjes@google.com, tangchen@cn.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     Subject: xen_balloon: support memory auto onlining policy
has been removed from the -mm tree.  Its filename was
     xen_balloon-support-memory-auto-onlining-policy.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: xen_balloon: support memory auto onlining policy

Add support for the newly added kernel memory auto onlining policy to Xen
ballon driver.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Suggested-by: Daniel Kiper <daniel.kiper@oracle.com>
Reviewed-by: Daniel Kiper <daniel.kiper@oracle.com>
Acked-by: David Vrabel <david.vrabel@citrix.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Daniel Kiper <daniel.kiper@oracle.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Tang Chen <tangchen@cn.fujitsu.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Xishi Qiu <qiuxishi@huawei.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: Igor Mammedov <imammedo@redhat.com>
Cc: Kay Sievers <kay@vrfy.org>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/xen/Kconfig   |   23 +++++++++++++++--------
 drivers/xen/balloon.c |   11 ++++++++++-
 2 files changed, 25 insertions(+), 9 deletions(-)

diff -puN drivers/xen/Kconfig~xen_balloon-support-memory-auto-onlining-policy drivers/xen/Kconfig
--- a/drivers/xen/Kconfig~xen_balloon-support-memory-auto-onlining-policy
+++ a/drivers/xen/Kconfig
@@ -37,23 +37,30 @@ config XEN_BALLOON_MEMORY_HOTPLUG
 
 	  Memory could be hotplugged in following steps:
 
-	    1) dom0: xl mem-max <domU> <maxmem>
+	    1) target domain: ensure that memory auto online policy is in
+	       effect by checking /sys/devices/system/memory/auto_online_blocks
+	       file (should be 'online').
+
+	    2) control domain: xl mem-max <target-domain> <maxmem>
 	       where <maxmem> is >= requested memory size,
 
-	    2) dom0: xl mem-set <domU> <memory>
+	    3) control domain: xl mem-set <target-domain> <memory>
 	       where <memory> is requested memory size; alternatively memory
 	       could be added by writing proper value to
 	       /sys/devices/system/xen_memory/xen_memory0/target or
-	       /sys/devices/system/xen_memory/xen_memory0/target_kb on dumU,
+	       /sys/devices/system/xen_memory/xen_memory0/target_kb on the
+	       target domain.
 
-	    3) domU: for i in /sys/devices/system/memory/memory*/state; do \
-	               [ "`cat "$i"`" = offline ] && echo online > "$i"; done
+	  Alternatively, if memory auto onlining was not requested at step 1
+	  the newly added memory can be manually onlined in the target domain
+	  by doing the following:
 
-	  Memory could be onlined automatically on domU by adding following line to udev rules:
+		for i in /sys/devices/system/memory/memory*/state; do \
+		  [ "`cat "$i"`" = offline ] && echo online > "$i"; done
 
-	  SUBSYSTEM=="memory", ACTION=="add", RUN+="/bin/sh -c '[ -f /sys$devpath/state ] && echo online > /sys$devpath/state'"
+	  or by adding the following line to udev rules:
 
-	  In that case step 3 should be omitted.
+	  SUBSYSTEM=="memory", ACTION=="add", RUN+="/bin/sh -c '[ -f /sys$devpath/state ] && echo online > /sys$devpath/state'"
 
 config XEN_BALLOON_MEMORY_HOTPLUG_LIMIT
 	int "Hotplugged memory limit (in GiB) for a PV guest"
diff -puN drivers/xen/balloon.c~xen_balloon-support-memory-auto-onlining-policy drivers/xen/balloon.c
--- a/drivers/xen/balloon.c~xen_balloon-support-memory-auto-onlining-policy
+++ a/drivers/xen/balloon.c
@@ -338,7 +338,16 @@ static enum bp_state reserve_additional_
 	}
 #endif
 
-	rc = add_memory_resource(nid, resource, false);
+	/*
+	 * add_memory_resource() will call online_pages() which in its turn
+	 * will call xen_online_page() callback causing deadlock if we don't
+	 * release balloon_mutex here. Unlocking here is safe because the
+	 * callers drop the mutex before trying again.
+	 */
+	mutex_unlock(&balloon_mutex);
+	rc = add_memory_resource(nid, resource, memhp_auto_online);
+	mutex_lock(&balloon_mutex);
+
 	if (rc) {
 		pr_warn("Cannot add additional memory (%i)\n", rc);
 		goto err;
_

Patches currently in -mm which might be from vkuznets@redhat.com are


