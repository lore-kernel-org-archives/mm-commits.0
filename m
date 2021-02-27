Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F196C433E0
	for <mm-commits@archiver.kernel.org>; Sat, 27 Feb 2021 02:30:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7456964F46
	for <mm-commits@archiver.kernel.org>; Sat, 27 Feb 2021 02:30:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230081AbhB0CaW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 26 Feb 2021 21:30:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:51000 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230083AbhB0CaD (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 26 Feb 2021 21:30:03 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 994A964F21;
        Sat, 27 Feb 2021 02:29:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614392973;
        bh=3BLNJdqbNgIku6I+dfMnsdwVQp/W+v3nlsj3hKeo044=;
        h=Date:From:To:Subject:From;
        b=jlxT8yNlHMiF99D+dWNqzY2VPyaLfwIWwUxXoAM5MG10N8tcjkfTKjFHjBC1asf/j
         XpSSDBrRM9emFwU7eVwBYZXg33H+CIF+8mJc8eNKjUOrz2VKpWLCS23rVasg7tRjoU
         Ci6QJQoy6cQTOfkRn1mbbt1WnXxmLK29bykXm5Cc=
Date:   Fri, 26 Feb 2021 18:29:33 -0800
From:   akpm@linux-foundation.org
To:     corbet@lwn.net, dave.hansen@intel.com, david@redhat.com,
        geert+renesas@glider.be, gregkh@linuxfoundation.org,
        idryomov@gmail.com, Jonathan.Cameron@huawei.com,
        mchehab+huawei@kernel.org, mhocko@suse.com,
        mm-commits@vger.kernel.org, osalvador@suse.de
Subject:  [merged]
 =?US-ASCII?Q?documentation-sysfs-memory-clarify-some-memory-block-device-?=
 =?US-ASCII?Q?properties.patch?= removed from -mm tree
Message-ID: <20210227022933.-pwQWY_iZ%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: Documentation: sysfs/memory: clarify some memory block device properties
has been removed from the -mm tree.  Its filename was
     documentation-sysfs-memory-clarify-some-memory-block-device-properties.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: Documentation: sysfs/memory: clarify some memory block device properties

In commit 53cdc1cb29e8 ("drivers/base/memory.c: indicate all memory blocks
as removable") we changed the output of the "removable" property of memory
devices to return "1" if and only if the kernel supports memory offlining.

Let's update documentation, stating that the interface is legacy.  Also
update documentation of the "state" property and "valid_zones" properties.

Link: https://lkml.kernel.org/r/20210201181347.13262-3-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: David Hildenbrand <david@redhat.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: Ilya Dryomov <idryomov@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Cc: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/ABI/testing/sysfs-devices-memory  |   53 ++++++++------
 Documentation/admin-guide/mm/memory-hotplug.rst |   16 ++--
 2 files changed, 41 insertions(+), 28 deletions(-)

--- a/Documentation/ABI/testing/sysfs-devices-memory~documentation-sysfs-memory-clarify-some-memory-block-device-properties
+++ a/Documentation/ABI/testing/sysfs-devices-memory
@@ -13,13 +13,13 @@ What:		/sys/devices/system/memory/memory
 Date:		June 2008
 Contact:	Badari Pulavarty <pbadari@us.ibm.com>
 Description:
-		The file /sys/devices/system/memory/memoryX/removable
-		indicates whether this memory block is removable or not.
-		This is useful for a user-level agent to determine
-		identify removable sections of the memory before attempting
-		potentially expensive hot-remove memory operation
+		The file /sys/devices/system/memory/memoryX/removable is a
+		legacy interface used to indicated whether a memory block is
+		likely to be offlineable or not.  Newer kernel versions return
+		"1" if and only if the kernel supports memory offlining.
 Users:		hotplug memory remove tools
 		http://www.ibm.com/developerworks/wikis/display/LinuxP/powerpc-utils
+		lsmem/chmem part of util-linux
 
 What:		/sys/devices/system/memory/memoryX/phys_device
 Date:		September 2008
@@ -44,23 +44,25 @@ Date:		September 2008
 Contact:	Badari Pulavarty <pbadari@us.ibm.com>
 Description:
 		The file /sys/devices/system/memory/memoryX/state
-		is read-write.  When read, its contents show the
-		online/offline state of the memory section.  When written,
-		root can toggle the the online/offline state of a removable
-		memory section (see removable file description above)
-		using the following commands::
+		is read-write.  When read, it returns the online/offline
+		state of the memory block.  When written, root can toggle
+		the online/offline state of a memory block using the following
+		commands::
 
 		  # echo online > /sys/devices/system/memory/memoryX/state
 		  # echo offline > /sys/devices/system/memory/memoryX/state
 
-		For example, if /sys/devices/system/memory/memory22/removable
-		contains a value of 1 and
-		/sys/devices/system/memory/memory22/state contains the
-		string "online" the following command can be executed by
-		by root to offline that section::
-
-		  # echo offline > /sys/devices/system/memory/memory22/state
-
+		On newer kernel versions, advanced states can be specified
+		when onlining to select a target zone: "online_movable"
+		selects the movable zone.  "online_kernel" selects the
+		applicable kernel zone (DMA, DMA32, or Normal).  However,
+		after successfully setting one of the advanced states,
+		reading the file will return "online"; the zone information
+		can be obtained via "valid_zones" instead.
+
+		While onlining is unlikely to fail, there are no guarantees
+		that offlining will succeed.  Offlining is more likely to
+		succeed if "valid_zones" indicates "Movable".
 Users:		hotplug memory remove tools
 		http://www.ibm.com/developerworks/wikis/display/LinuxP/powerpc-utils
 
@@ -70,8 +72,19 @@ Date:           July 2014
 Contact:	Zhang Zhen <zhenzhang.zhang@huawei.com>
 Description:
 		The file /sys/devices/system/memory/memoryX/valid_zones	is
-		read-only and is designed to show which zone this memory
-		block can be onlined to.
+		read-only.
+
+		For online memory blocks, it returns in which zone memory
+		provided by a memory block is managed.  If multiple zones
+		apply (not applicable for hotplugged memory), "None" is returned
+		and the memory block cannot be offlined.
+
+		For offline memory blocks, it returns by which zone memory
+		provided by a memory block can be managed when onlining.
+		The first returned zone ("default") will be used when setting
+		the state of an offline memory block to "online".  Only one of
+		the kernel zones (DMA, DMA32, Normal) is applicable for a single
+		memory block.
 
 What:		/sys/devices/system/memoryX/nodeY
 Date:		October 2009
--- a/Documentation/admin-guide/mm/memory-hotplug.rst~documentation-sysfs-memory-clarify-some-memory-block-device-properties
+++ a/Documentation/admin-guide/mm/memory-hotplug.rst
@@ -162,14 +162,14 @@ Under each memory block, you can see 5 f
                     which will be performed on all sections in the block.
 ``phys_device``	    read-only: legacy interface only ever used on s390x to
 		    expose the covered storage increment.
-``removable``       read-only: contains an integer value indicating
-                    whether the memory block is removable or not
-                    removable.  A value of 1 indicates that the memory
-                    block is removable and a value of 0 indicates that
-                    it is not removable. A memory block is removable only if
-                    every section in the block is removable.
-``valid_zones``     read-only: designed to show which zones this memory block
-		    can be onlined to.
+``removable``	    read-only: legacy interface that indicated whether a memory
+		    block was likely to be offlineable or not.  Newer kernel
+		    versions return "1" if and only if the kernel supports
+		    memory offlining.
+``valid_zones``     read-only: designed to show by which zone memory provided by
+		    a memory block is managed, and to show by which zone memory
+		    provided by an offline memory block could be managed when
+		    onlining.
 
 		    The first column shows it`s default zone.
 
_

Patches currently in -mm which might be from david@redhat.com are


