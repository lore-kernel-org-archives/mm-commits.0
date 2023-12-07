Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7FF20C4167B
	for <mm-commits@archiver.kernel.org>; Thu,  7 Dec 2023 00:14:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1442154AbjLGAN5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 6 Dec 2023 19:13:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1442173AbjLGANt (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 6 Dec 2023 19:13:49 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE134D6F
        for <mm-commits@vger.kernel.org>; Wed,  6 Dec 2023 16:13:45 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87F09C433CC;
        Thu,  7 Dec 2023 00:13:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1701908025;
        bh=Z8SslZ6pgmrdHS7lqiDzKtK69R222PuB9QQrCJ6Bs2U=;
        h=Date:To:From:Subject:From;
        b=eEa7CxAyoeztGmov10DuorDrQdolamRUq3MMCagPXHAzvYWZJQT54/ELFsxJUw/+C
         7Gm5xf5bNqVVV+lIwBa48PuwJAfi6N1UXOhCL3Am7OCqEifNcmQw3ym8Mv9hJmBmf1
         ODNoUWXndXQbEKB2BPZF7V7lbEkIILKt0dQxeKpE=
Date:   Wed, 06 Dec 2023 16:13:45 -0800
To:     mm-commits@vger.kernel.org, Kuan-Ying.Lee@mediatek.com,
        kbingham@kernel.org, jan.kiszka@siemens.com,
        gregkh@linuxfoundation.org, florian.fainelli@broadcom.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] scripts-gdb-fix-lx-device-list-bus-and-lx-device-list-class.patch removed from -mm tree
Message-Id: <20231207001345.87F09C433CC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: scripts/gdb: fix lx-device-list-bus and lx-device-list-class
has been removed from the -mm tree.  Its filename was
     scripts-gdb-fix-lx-device-list-bus-and-lx-device-list-class.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Florian Fainelli <florian.fainelli@broadcom.com>
Subject: scripts/gdb: fix lx-device-list-bus and lx-device-list-class
Date: Wed, 29 Nov 2023 20:33:16 -0800

After the conversion to bus_to_subsys() and class_to_subsys(), the gdb
scripts listing the system buses and classes respectively was broken, fix
those by returning the subsys_priv pointer and have the various caller
de-reference either the 'bus' or 'class' structure members accordingly.

Link: https://lkml.kernel.org/r/20231130043317.174188-1-florian.fainelli@broadcom.com
Fixes: 7b884b7f24b4 ("driver core: class.c: convert to only use class_to_subsys")
Signed-off-by: Florian Fainelli <florian.fainelli@broadcom.com>
Tested-by: Kuan-Ying Lee <Kuan-Ying.Lee@mediatek.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Kieran Bingham <kbingham@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/gdb/linux/device.py |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

--- a/scripts/gdb/linux/device.py~scripts-gdb-fix-lx-device-list-bus-and-lx-device-list-class
+++ a/scripts/gdb/linux/device.py
@@ -36,26 +36,26 @@ def for_each_bus():
     for kobj in kset_for_each_object(gdb.parse_and_eval('bus_kset')):
         subsys = container_of(kobj, kset_type.get_type().pointer(), 'kobj')
         subsys_priv = container_of(subsys, subsys_private_type.get_type().pointer(), 'subsys')
-        yield subsys_priv['bus']
+        yield subsys_priv
 
 
 def for_each_class():
     for kobj in kset_for_each_object(gdb.parse_and_eval('class_kset')):
         subsys = container_of(kobj, kset_type.get_type().pointer(), 'kobj')
         subsys_priv = container_of(subsys, subsys_private_type.get_type().pointer(), 'subsys')
-        yield subsys_priv['class']
+        yield subsys_priv
 
 
 def get_bus_by_name(name):
     for item in for_each_bus():
-        if item['name'].string() == name:
+        if item['bus']['name'].string() == name:
             return item
     raise gdb.GdbError("Can't find bus type {!r}".format(name))
 
 
 def get_class_by_name(name):
     for item in for_each_class():
-        if item['name'].string() == name:
+        if item['class']['name'].string() == name:
             return item
     raise gdb.GdbError("Can't find device class {!r}".format(name))
 
@@ -70,13 +70,13 @@ def klist_for_each(klist):
 
 
 def bus_for_each_device(bus):
-    for kn in klist_for_each(bus['p']['klist_devices']):
+    for kn in klist_for_each(bus['klist_devices']):
         dp = container_of(kn, device_private_type.get_type().pointer(), 'knode_bus')
         yield dp['device']
 
 
 def class_for_each_device(cls):
-    for kn in klist_for_each(cls['p']['klist_devices']):
+    for kn in klist_for_each(cls['klist_devices']):
         dp = container_of(kn, device_private_type.get_type().pointer(), 'knode_class')
         yield dp['device']
 
@@ -103,7 +103,7 @@ class LxDeviceListBus(gdb.Command):
     def invoke(self, arg, from_tty):
         if not arg:
             for bus in for_each_bus():
-                gdb.write('bus {}:\t{}\n'.format(bus['name'].string(), bus))
+                gdb.write('bus {}:\t{}\n'.format(bus['bus']['name'].string(), bus))
                 for dev in bus_for_each_device(bus):
                     _show_device(dev, level=1)
         else:
@@ -123,7 +123,7 @@ class LxDeviceListClass(gdb.Command):
     def invoke(self, arg, from_tty):
         if not arg:
             for cls in for_each_class():
-                gdb.write("class {}:\t{}\n".format(cls['name'].string(), cls))
+                gdb.write("class {}:\t{}\n".format(cls['class']['name'].string(), cls))
                 for dev in class_for_each_device(cls):
                     _show_device(dev, level=1)
         else:
_

Patches currently in -mm which might be from florian.fainelli@broadcom.com are


