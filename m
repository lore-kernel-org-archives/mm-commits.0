From: akpm@linux-foundation.org
Subject: + mm-numa-avoid-setting-zone_reclaim_mode-unless-a-node-is-sufficiently-distant.patch added to -mm tree
Date: Wed, 24 Oct 2012 12:24:45 -0700
Message-ID: <20121024192446.28BD55C0060@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wi0-f202.google.com ([209.85.212.202]:64588 "EHLO
	mail-wi0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932145Ab2JXTYs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 24 Oct 2012 15:24:48 -0400
Received: by mail-wi0-f202.google.com with SMTP id hr7so59638wib.1
        for <mm-commits@vger.kernel.org>; Wed, 24 Oct 2012 12:24:47 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rientjes@google.com, hughd@google.com, jwollrath@web.de, patrik.kullman@gmail.com


The patch titled
     Subject: mm, numa: avoid setting zone_reclaim_mode unless a node is sufficiently distant
has been added to the -mm tree.  Its filename is
     mm-numa-avoid-setting-zone_reclaim_mode-unless-a-node-is-sufficiently-distant.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: David Rientjes <rientjes@google.com>
Subject: mm, numa: avoid setting zone_reclaim_mode unless a node is sufficiently distant

Commit 957f822a0ab9 ("mm, numa: reclaim from all nodes within reclaim
distance") caused zone_reclaim_mode to be set for all systems where two
nodes are within RECLAIM_DISTANCE of each other.  This is the opposite of
what we actually want: zone_reclaim_mode should be set if two nodes are
sufficiently distant.

Signed-off-by: David Rientjes <rientjes@google.com>
Reported-by: Julian Wollrath <jwollrath@web.de>
Tested-by: Julian Wollrath <jwollrath@web.de>
Cc: Hugh Dickins <hughd@google.com>
Cc: Patrik Kullman <patrik.kullman@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/page_alloc.c~mm-numa-avoid-setting-zone_reclaim_mode-unless-a-node-is-sufficiently-distant mm/page_alloc.c
--- a/mm/page_alloc.c~mm-numa-avoid-setting-zone_reclaim_mode-unless-a-node-is-sufficiently-distant
+++ a/mm/page_alloc.c
@@ -1809,10 +1809,10 @@ static void __paginginit init_zone_allow
 	int i;
 
 	for_each_online_node(i)
-		if (node_distance(nid, i) <= RECLAIM_DISTANCE) {
+		if (node_distance(nid, i) <= RECLAIM_DISTANCE)
 			node_set(i, NODE_DATA(nid)->reclaim_nodes);
+		else
 			zone_reclaim_mode = 1;
-		}
 }
 
 #else	/* CONFIG_NUMA */
_

Patches currently in -mm which might be from rientjes@google.com are

mm-numa-avoid-setting-zone_reclaim_mode-unless-a-node-is-sufficiently-distant.patch
linux-next.patch
acpi_memhotplugc-fix-memory-leak-when-memory-device-is-unbound-from-the-module-acpi_memhotplug.patch
acpi_memhotplugc-free-memory-device-if-acpi_memory_enable_device-failed.patch
acpi_memhotplugc-remove-memory-info-from-list-before-freeing-it.patch
acpi_memhotplugc-dont-allow-to-eject-the-memory-device-if-it-is-being-used.patch
acpi_memhotplugc-bind-the-memory-device-when-the-driver-is-being-loaded.patch
acpi_memhotplugc-auto-bind-the-memory-device-which-is-hotplugged-before-the-driver-is-loaded.patch
memory-hotplug-suppress-device-memoryx-does-not-have-a-release-function-warning.patch
memory-hotplug-suppress-device-nodex-does-not-have-a-release-function-warning.patch
mm-memcg-make-mem_cgroup_out_of_memory-static.patch
mm-use-is_enabledconfig_numa-instead-of-numa_build.patch
mm-use-is_enabledconfig_compaction-instead-of-compaction_build.patch
memory-hotplug-skip-hwpoisoned-page-when-offlining-pages.patch
memory-hotplug-update-mce_bad_pages-when-removing-the-memory.patch
memory-hotplug-update-mce_bad_pages-when-removing-the-memory-fix.patch
memory-hotplug-auto-offline-page_cgroup-when-onlining-memory-block-failed.patch
memory-hotplug-fix-nr_free_pages-mismatch.patch
memory-hotplug-allocate-zones-pcp-before-onlining-pages.patch
memory-hotplug-allocate-zones-pcp-before-onlining-pages-fix.patch
slab-ignore-internal-flags-in-cache-creation.patch

