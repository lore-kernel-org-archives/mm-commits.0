From: akpm@linux-foundation.org
Subject: + memory-hotplug-auto-offline-page_cgroup-when-onlining-memory-block-failed.patch added to -mm tree
Date: Thu, 18 Oct 2012 15:31:28 -0700
Message-ID: <20121018223129.6617F1E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:60807 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932135Ab2JRWbb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 18 Oct 2012 18:31:31 -0400
Received: by mail-qa0-f74.google.com with SMTP id a16so282767qae.1
        for <mm-commits@vger.kernel.org>; Thu, 18 Oct 2012 15:31:30 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: wency@cn.fujitsu.com, benh@kernel.crashing.org, cl@linux.com, dave@linux.vnet.ibm.com, isimatu.yasuaki@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, len.brown@intel.com, liuj97@gmail.com, mel@csn.ul.ie, minchan.kim@gmail.com, paulus@samba.org, rientjes@google.com


The patch titled
     Subject: memory-hotplug: auto offline page_cgroup when onlining memory block failed
has been added to the -mm tree.  Its filename is
     memory-hotplug-auto-offline-page_cgroup-when-onlining-memory-block-failed.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Wen Congyang <wency@cn.fujitsu.com>
Subject: memory-hotplug: auto offline page_cgroup when onlining memory block failed

When a memory block is onlined, we will try allocate memory on that node
to store page_cgroup.  If onlining the memory block failed, we don't
offline the page cgroup, and we have no chance to offline this page cgroup
unless the memory block is onlined successfully again.  It will cause that
we can't hot-remove the memory device on that node, because some memory is
used to store page cgroup.  If onlining the memory block is failed, there
is no need to stort page cgroup for this memory.  So auto offline
page_cgroup when onlining memory block failed.

Signed-off-by: Wen Congyang <wency@cn.fujitsu.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Jiang Liu <liuj97@gmail.com>
Cc: Len Brown <len.brown@intel.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Christoph Lameter <cl@linux.com>
Cc: Minchan Kim <minchan.kim@gmail.com>
Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_cgroup.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN mm/page_cgroup.c~memory-hotplug-auto-offline-page_cgroup-when-onlining-memory-block-failed mm/page_cgroup.c
--- a/mm/page_cgroup.c~memory-hotplug-auto-offline-page_cgroup-when-onlining-memory-block-failed
+++ a/mm/page_cgroup.c
@@ -251,6 +251,9 @@ static int __meminit page_cgroup_callbac
 				mn->nr_pages, mn->status_change_nid);
 		break;
 	case MEM_CANCEL_ONLINE:
+		offline_page_cgroup(mn->start_pfn,
+				mn->nr_pages, mn->status_change_nid);
+		break;
 	case MEM_GOING_OFFLINE:
 		break;
 	case MEM_ONLINE:
_

Patches currently in -mm which might be from wency@cn.fujitsu.com are

cpu_hotplug-unmap-cpu2node-when-the-cpu-is-hotremoved.patch
cpu_hotplug-unmap-cpu2node-when-the-cpu-is-hotremoved-fix.patch
acpi_memhotplugc-fix-memory-leak-when-memory-device-is-unbound-from-the-module-acpi_memhotplug.patch
acpi_memhotplugc-free-memory-device-if-acpi_memory_enable_device-failed.patch
acpi_memhotplugc-remove-memory-info-from-list-before-freeing-it.patch
acpi_memhotplugc-dont-allow-to-eject-the-memory-device-if-it-is-being-used.patch
acpi_memhotplugc-bind-the-memory-device-when-the-driver-is-being-loaded.patch
acpi_memhotplugc-auto-bind-the-memory-device-which-is-hotplugged-before-the-driver-is-loaded.patch
x86-numa-dont-check-if-node-is-numa_no_node.patch
memory-hotplug-suppress-device-memoryx-does-not-have-a-release-function-warning.patch
memory-hotplug-suppress-device-nodex-does-not-have-a-release-function-warning.patch
memory-hotplug-skip-hwpoisoned-page-when-offlining-pages.patch
memory-hotplug-update-mce_bad_pages-when-removing-the-memory.patch
memory-hotplug-update-mce_bad_pages-when-removing-the-memory-fix.patch
memory-hotplug-auto-offline-page_cgroup-when-onlining-memory-block-failed.patch
memory-hotplug-fix-nr_free_pages-mismatch.patch
memory-hotplug-allocate-zones-pcp-before-onlining-pages.patch

