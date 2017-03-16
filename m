From: akpm@linux-foundation.org
Subject: [patch 6/6] drivers core: remove assert_held_device_hotplug()
Date: Thu, 16 Mar 2017 16:40:33 -0700
Message-ID: <58cb2271.bOfO6PkhSNmgRw6T%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48064 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752437AbdCPXlk (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 16 Mar 2017 19:41:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, heiko.carstens@de.ibm.com, ben@decadent.org.uk, dan.j.williams@intel.com, gerald.schaefer@de.ibm.com, gregkh@linuxfoundation.org, mhocko@suse.com, rjw@rjwysocki.net, schwidefsky@de.ibm.com, sebott@linux.vnet.ibm.com, vdavydov.dev@gmail.com

From: Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: drivers core: remove assert_held_device_hotplug()

The last caller of assert_held_device_hotplug() is gone, so remove it again.

Link: http://lkml.kernel.org/r/20170314125226.16779-3-heiko.carstens@de.ibm.com
Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Acked-by: Dan Williams <dan.j.williams@intel.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Ben Hutchings <ben@decadent.org.uk>
Cc: Gerald Schaefer <gerald.schaefer@de.ibm.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Sebastian Ott <sebott@linux.vnet.ibm.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/core.c    |    5 -----
 include/linux/device.h |    1 -
 2 files changed, 6 deletions(-)

diff -puN drivers/base/core.c~drivers-core-remove-assert_held_device_hotplug drivers/base/core.c
--- a/drivers/base/core.c~drivers-core-remove-assert_held_device_hotplug
+++ a/drivers/base/core.c
@@ -639,11 +639,6 @@ int lock_device_hotplug_sysfs(void)
 	return restart_syscall();
 }
 
-void assert_held_device_hotplug(void)
-{
-	lockdep_assert_held(&device_hotplug_lock);
-}
