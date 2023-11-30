Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35281C4167B
	for <mm-commits@archiver.kernel.org>; Thu, 30 Nov 2023 21:52:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377035AbjK3VwR (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 30 Nov 2023 16:52:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377025AbjK3VwQ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 30 Nov 2023 16:52:16 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D821510FA
        for <mm-commits@vger.kernel.org>; Thu, 30 Nov 2023 13:52:22 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56D79C433C8;
        Thu, 30 Nov 2023 21:52:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1701381142;
        bh=Ar780reYLQvXDt5M0WZABNwLLCI6Z9Fo3YNbHMTtqaY=;
        h=Date:To:From:Subject:From;
        b=Sr+SKuuD5NCMg1BPrlDMwTLqNhq5slCIv09CQVLZpv+nF4L/RseuXX2l1LozVgVXc
         beQh0S+V9q17cLRiCinHDorTg9B307Q20bmiUcDqMbOWxif3hs19Zgcu7QC2QpjSXV
         uT6gdhaw/a4L2qQ5bdMRCSOQDRvOLSf416rkSxrQ=
Date:   Thu, 30 Nov 2023 13:52:21 -0800
To:     mm-commits@vger.kernel.org, Kuan-Ying.Lee@mediatek.com,
        kbingham@kernel.org, jan.kiszka@siemens.com,
        gregkh@linuxfoundation.org, florian.fainelli@broadcom.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + scripts-gdb-fix-lx-device-list-bus-and-lx-device-list-class.patch added to mm-hotfixes-unstable branch
Message-Id: <20231130215222.56D79C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: scripts/gdb: fix lx-device-list-bus and lx-device-list-class
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     scripts-gdb-fix-lx-device-list-bus-and-lx-device-list-class.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/scripts-gdb-fix-lx-device-list-bus-and-lx-device-list-class.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Florian Fainelli <florian.fainelli@broadcom.com>
Subject: scripts/gdb: fix lx-device-list-bus and lx-device-list-class
Date: Wed, 29 Nov 2023 20:33:16 -0800

After the conversion to bus_to_subsys() and class_to_subsys(), the gdb
scripts listing the system buses and classes respectively was broken, fix
those by returning the subsys_priv pointer and have the various caller
de-reference either the 'bus' or 'class' structure members accordingly.

Link: https://lkml.kernel.org/r/20231130043317.174188-1-florian.fainelli@broadcom.com
Fixes: 83b9148df2c9 ("driver core: bus: bus iterator cleanups")
Fixes: 7b884b7f24b4 ("driver core: class.c: convert to only use class_to_subsys")
Signed-off-by: Florian Fainelli <florian.fainelli@broadcom.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Kieran Bingham <kbingham@kernel.org>
Cc: Kuan-Ying Lee <Kuan-Ying.Lee@mediatek.com>
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

scripts-gdb-fix-lx-device-list-bus-and-lx-device-list-class.patch

