From: akpm@linux-foundation.org
Subject: +
 mm-memory_hotplugc-move-register_memory_resource-out-of-the-lock_memory_hotplug.patch added to -mm tree
Date: Tue, 14 Jan 2014 15:13:51 -0800
Message-ID: <52d5c4af.Fj+aal45MsExeMUA%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34745 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750906AbaANXNw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 14 Jan 2014 18:13:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, wency@cn.fujitsu.com, travis@sgi.com, tangchen@cn.fujitsu.com, rafael.j.wysocki@intel.com, kamezawa.hiroyu@jp.fujitsu.com, isimatu.yasuaki@jp.fujitsu.com, hedi@sgi.com, nzimmer@sgi.com

Subject: + mm-memory_hotplugc-move-register_memory_resource-out-of-the-lock_memory_hotplug.patch added to -mm tree
To: nzimmer@sgi.com,hedi@sgi.com,isimatu.yasuaki@jp.fujitsu.com,kamezawa.hiroyu@jp.fujitsu.com,rafael.j.wysocki@intel.com,tangchen@cn.fujitsu.com,travis@sgi.com,wency@cn.fujitsu.com
From: akpm@linux-foundation.org
Date: Tue, 14 Jan 2014 15:13:51 -0800


The patch titled
     Subject: mm/memory_hotplug.c: move register_memory_resource out of the lock_memory_hotplug
has been added to the -mm tree.  Its filename is
     mm-memory_hotplugc-move-register_memory_resource-out-of-the-lock_memory_hotplug.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memory_hotplugc-move-register_memory_resource-out-of-the-lock_memory_hotplug.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memory_hotplugc-move-register_memory_resource-out-of-the-lock_memory_hotplug.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Nathan Zimmer <nzimmer@sgi.com>
Subject: mm/memory_hotplug.c: move register_memory_resource out of the lock_memory_hotplug

We don't need to do register_memory_resource() since it has its own lock
and doesn't make any callbacks.

Also register_memory_resource return NULL on failure so we don't have
anything to cleanup at this point.

The reason for this rfc is I was doing some experiments with hotplugging
of memory on some of our larger systems.  While it seems to work, it can
be quite slow.  With some preliminary digging I found that
lock_memory_hotplug is clearly ripe for breakup.

It could be broken up per nid or something but it also covers the
online_page_callback.  The online_page_callback shouldn't be very hard to
break out.

Also there is the issue of various structures(wmarks come to mind) that are
only updated under the lock_memory_hotplug that would need to be dealt with.

Cc: Tang Chen <tangchen@cn.fujitsu.com>
Cc: Wen Congyang <wency@cn.fujitsu.com>
Cc: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Cc: Hedi <hedi@sgi.com>
Cc: Mike Travis <travis@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff -puN mm/memory_hotplug.c~mm-memory_hotplugc-move-register_memory_resource-out-of-the-lock_memory_hotplug mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~mm-memory_hotplugc-move-register_memory_resource-out-of-the-lock_memory_hotplug
+++ a/mm/memory_hotplug.c
@@ -1107,17 +1107,18 @@ int __ref add_memory(int nid, u64 start,
 	if (ret)
 		return ret;
 
-	lock_memory_hotplug();
