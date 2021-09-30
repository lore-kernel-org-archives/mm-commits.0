Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A087C433F5
	for <mm-commits@archiver.kernel.org>; Thu, 30 Sep 2021 20:34:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7B27861994
	for <mm-commits@archiver.kernel.org>; Thu, 30 Sep 2021 20:34:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347824AbhI3Ugg (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 30 Sep 2021 16:36:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:45202 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348030AbhI3Ugf (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 30 Sep 2021 16:36:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DCCF561A51;
        Thu, 30 Sep 2021 20:34:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1633034092;
        bh=GEZ+mg6WldSQWYrQjedbakMzQw9z87P/OA1t5/FP/2c=;
        h=Date:From:To:Subject:From;
        b=Uv3wHBejqY86r/xo8uZpBialVvuU9XrEESaU8wpyg/8AS1l5HHQp2tD0/zNn5jPKU
         tlmrDuVGV3n9fmw8nEkwX+dnFLGwhuDyonRJ/B0xuuRz1e0Dg1+wa3Ka3vHgPhnwMu
         F1jLs5f5YVUYqm9GqUfocqUhfjLXDP4BTnq9hTXo=
Date:   Thu, 30 Sep 2021 13:34:51 -0700
From:   akpm@linux-foundation.org
To:     corbet@lwn.net, david@redhat.com, mhocko@suse.com,
        mm-commits@vger.kernel.org, osalvador@suse.de, rppt@kernel.org
Subject:  +
 memory-hotplugrst-document-the-auto-movable-online-policy.patch added to
 -mm tree
Message-ID: <20210930203451.nErqTJWfd%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: memory-hotplug.rst: document the "auto-movable" online policy
has been added to the -mm tree.  Its filename is
     memory-hotplugrst-document-the-auto-movable-online-policy.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/memory-hotplugrst-document-the-auto-movable-online-policy.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/memory-hotplugrst-document-the-auto-movable-online-policy.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: memory-hotplug.rst: document the "auto-movable" online policy

In commit e83a437faa62 ("mm/memory_hotplug: introduce "auto-movable"
online policy") we introduced a new memory online policy to automatically
select a zone for memory blocks to be onlined.  We added a way to set the
active online policy and tunables for the auto-movable online policy.  In
follow-up commits we tweaked the "auto-movable" policy to also consider
memory device details when selecting zones for memory blocks to be
onlined.

Let's document the new toggles and how the two online policies we have
work.

Link: https://lkml.kernel.org/r/20210930144117.23641-4-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/mm/memory-hotplug.rst |  128 +++++++++++---
 1 file changed, 108 insertions(+), 20 deletions(-)

--- a/Documentation/admin-guide/mm/memory-hotplug.rst~memory-hotplugrst-document-the-auto-movable-online-policy
+++ a/Documentation/admin-guide/mm/memory-hotplug.rst
@@ -165,9 +165,8 @@ Or alternatively::
 
 	% echo 1 > /sys/devices/system/memory/memoryXXX/online
 
-The kernel will select the target zone automatically, usually defaulting to
-``ZONE_NORMAL`` unless ``movable_node`` has been specified on the kernel
-command line or if the memory block would intersect the ZONE_MOVABLE already.
+The kernel will select the target zone automatically, depending on the
+configured ``online_policy``.
 
 One can explicitly request to associate an offline memory block with
 ZONE_MOVABLE by::
@@ -198,6 +197,9 @@ Auto-onlining can be enabled by writing
 
 	% echo online > /sys/devices/system/memory/auto_online_blocks
 
+Similarly to manual onlining, with ``online`` the kernel will select the
+target zone automatically, depending on the configured ``online_policy``.
+
 Modifying the auto-online behavior will only affect all subsequently added
 memory blocks only.
 
@@ -393,9 +395,11 @@ command line parameters are relevant:
 ======================== =======================================================
 ``memhp_default_state``	 configure auto-onlining by essentially setting
                          ``/sys/devices/system/memory/auto_online_blocks``.
-``movable_node``	 configure automatic zone selection in the kernel. When
-			 set, the kernel will default to ZONE_MOVABLE, unless
-			 other zones can be kept contiguous.
+``movable_node``	 configure automatic zone selection in the kernel when
+			 using the ``contig-zones`` online policy. When
+			 set, the kernel will default to ZONE_MOVABLE when
+			 onlining a memory block, unless other zones can be kept
+			 contiguous.
 ======================== =======================================================
 
 Module Parameters
@@ -414,20 +418,104 @@ and they can be observed (and some even
 
 The following module parameters are currently defined:
 
-======================== =======================================================
-``memmap_on_memory``	 read-write: Allocate memory for the memmap from the
-			 added memory block itself. Even if enabled, actual
-			 support depends on various other system properties and
-			 should only be regarded as a hint whether the behavior
-			 would be desired.
-
-			 While allocating the memmap from the memory block
-			 itself makes memory hotplug less likely to fail and
-			 keeps the memmap on the same NUMA node in any case, it
-			 can fragment physical memory in a way that huge pages
-			 in bigger granularity cannot be formed on hotplugged
-			 memory.
-======================== =======================================================
+================================ ===============================================
+``memmap_on_memory``		 read-write: Allocate memory for the memmap from
+				 the added memory block itself. Even if enabled,
+				 actual support depends on various other system
+				 properties and should only be regarded as a
+				 hint whether the behavior would be desired.
+
+				 While allocating the memmap from the memory
+				 block itself makes memory hotplug less likely
+				 to fail and keeps the memmap on the same NUMA
+				 node in any case, it can fragment physical
+				 memory in a way that huge pages in bigger
+				 granularity cannot be formed on hotplugged
+				 memory.
+``online_policy``		 read-write: Set the basic policy used for
+				 automatic zone selection when onlining memory
+				 blocks without specifying a target zone.
+				 ``contig-zones`` has been the kernel default
+				 before this parameter was added. After an
+				 online policy was configured and memory was
+				 online, the policy should not be changed
+				 anymore.
+
+				 When set to ``contig-zones``, the kernel will
+				 try keeping zones contiguous. If a memory block
+				 intersects multiple zones or no zone, the
+				 behavior depends on the ``movable_node`` kernel
+				 command line parameter: default to ZONE_MOVABLE
+				 if set, default to the applicable kernel zone
+				 (usually ZONE_NORMAL) if not set.
+
+				 When set to ``auto-movable``, the kernel will
+				 try onlining memory blocks to ZONE_MOVABLE if
+				 possible according to the configuration and
+				 memory device details. With this policy, one
+				 can avoid zone imbalances when eventually
+				 hotplugging a lot of memory later and still
+				 wanting to be able to hotunplug as much as
+				 possible reliably, very desirable in
+				 virtualized environments. As one example, a
+				 hotplugged DIMM will be onlined either
+				 completely to ZONE_MOVABLE or completely to
+				 ZONE_NORMAL, not a mixture.
+				 As another example, as many memory blocks
+				 belonging to a virtio-mem device will be
+				 onlined to ZONE_MOVABLE as possible,
+				 special-casing units of memory blocks that can
+				 only get hotunplugged together. *This policy
+				 does not protect from setups that are
+				 problematic with ZONE_MOVABLE and does not
+				 change the zone of memory blocks dynamically
+				 after they were onlined.*
+``auto_movable_ratio``		 read-write: Set the maximum MOVABLE:KERNEL
+				 memory ratio in % for the ``auto-movable``
+				 online policy. Whether the ratio applies only
+				 for the system across all NUMA nodes or also
+				 per NUMA nodes depends on the
+				 ``auto_movable_numa_aware`` configuration.
+
+				 All accounting is based on present memory pages
+				 in the zones combined with accounting per
+				 memory device. Memory dedicated to the CMA
+				 allocator is accounted as MOVABLE, although
+				 residing on one of the kernel zones. The
+				 possible ratio depends on the actual workload.
+				 The kernel default is "301" %, for example,
+				 allowing for hotplugging 24 GiB to a 8 GiB VM
+				 and automatically onlining all hotplugged
+				 memory to ZONE_MOVABLE in many setups. The
+				 additional 1% deals with some pages being not
+				 present, for example, because of some firmware
+				 allocations.
+
+				 Note that ZONE_NORMAL memory provided by one
+				 memory device does not allow for more
+				 ZONE_MOVABLE memory for a different memory
+				 device. As one example, onlining memory of a
+				 hotplugged DIMM to ZONE_NORMAL will not allow
+				 for another hotplugged DIMM to get onlined to
+				 ZONE_MOVABLE automatically. In contrast, memory
+				 hotplugged by a virtio-mem device that got
+				 onlined to ZONE_NORMAL will allow for more
+				 ZONE_MOVABLE memory within *the same*
+				 virtio-mem device.
+``auto_movable_numa_aware``	 read-write: Configure whether the
+				 ``auto_movable_ratio`` in the ``auto-movable``
+				 online policy also applies per NUMA
+				 node in addition to the whole system across all
+				 NUMA nodes. The kernel default is "Y".
+
+				 Disabling NUMA awareness can be helpful when
+				 dealing with NUMA nodes that should be
+				 completely hotunpluggable, onlining the memory
+				 completely to ZONE_MOVABLE automatically if
+				 possible.
+
+				 Parameter availability depends on CONFIG_NUMA.
+================================ ===============================================
 
 ZONE_MOVABLE
 ============
_

Patches currently in -mm which might be from david@redhat.com are

memory-hotplugrst-fix-two-instances-of-movablecore-that-should-be-movable_node.patch
memory-hotplugrst-fix-wrong-sys-module-memory_hotplug-parameters-path.patch
memory-hotplugrst-document-the-auto-movable-online-policy.patch
kernel-resource-clean-up-and-optimize-iomem_is_exclusive.patch
kernel-resource-disallow-access-to-exclusive-system-ram-regions.patch
virtio-mem-disallow-mapping-virtio-mem-memory-via-dev-mem.patch

