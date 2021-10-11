Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64AE6C433EF
	for <mm-commits@archiver.kernel.org>; Mon, 11 Oct 2021 21:15:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 47FB060F3A
	for <mm-commits@archiver.kernel.org>; Mon, 11 Oct 2021 21:15:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235122AbhJKVRb (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 11 Oct 2021 17:17:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:41932 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231718AbhJKVRa (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 11 Oct 2021 17:17:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B7D3D60E78;
        Mon, 11 Oct 2021 21:15:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1633986929;
        bh=rrRgVZITArk1DTsXf4xXbzbNpxo1kgTlds6MO9lvqmU=;
        h=Date:From:To:Subject:From;
        b=QCU69A9e1p+wCLlF/7YLQeP4baih0XxcNzUARLyPmcfmNi/Afd5dXRankDDwMO5vE
         yERJ6xdD2sLzCuO6u3NPYZnxtH+sD3fcrrlkS8JE1g8q8todHQB4TedTJ0qrAH0Gdh
         3vDfvO1zrdKobPTS+ang5NQsO1XRguQBWEc3DZXU=
Date:   Mon, 11 Oct 2021 14:15:29 -0700
From:   akpm@linux-foundation.org
To:     corbet@lwn.net, david@redhat.com, mhocko@suse.com,
        mm-commits@vger.kernel.org, osalvador@suse.de, rppt@linux.ibm.com
Subject:  +
 memory-hotplugrst-document-the-auto-movable-online-policy-v2.patch added to
 -mm tree
Message-ID: <20211011211529.qgMhhbEd8%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: memory-hotplug.rst: document the "auto-movable" online policy
has been added to the -mm tree.  Its filename is
     memory-hotplugrst-document-the-auto-movable-online-policy-v2.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/memory-hotplugrst-document-the-auto-movable-online-policy-v2.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/memory-hotplugrst-document-the-auto-movable-online-policy-v2.patch

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

- "memory-hotplug.rst: document the "auto-movable" online policy"
-- Add a pointer to generic command line parameter documentation
-- Explain relationship of "auto-movable" and "movable_node" command
   line parameter, also indicating in which setups "auto-movable" doesn't
   really make sense.

Link: https://lkml.kernel.org/r/20211011082058.6076-4-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Acked-by: Mike Rapoport <rppt@linux.ibm.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Oscar Salvador <osalvador@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/mm/memory-hotplug.rst |   15 +++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

--- a/Documentation/admin-guide/mm/memory-hotplug.rst~memory-hotplugrst-document-the-auto-movable-online-policy-v2
+++ a/Documentation/admin-guide/mm/memory-hotplug.rst
@@ -402,6 +402,9 @@ command line parameters are relevant:
 			 contiguous.
 ======================== =======================================================
 
+See Documentation/admin-guide/kernel-parameters.txt for a more generic
+description of these command line parameters.
+
 Module Parameters
 ------------------
 
@@ -457,7 +460,17 @@ The following module parameters are curr
 				 hotplugging a lot of memory later and still
 				 wanting to be able to hotunplug as much as
 				 possible reliably, very desirable in
-				 virtualized environments. As one example, a
+				 virtualized environments. This policy ignores
+				 the ``movable_node`` kernel command line
+				 parameter and isn't really applicable in
+				 environments that require it (e.g., bare metal
+				 with hotunpluggable nodes) where hotplugged
+				 memory might be exposed via the
+				 firmware-provided memory map early during boot
+				 to the system instead of getting detected,
+				 added and onlined  later during boot (such as
+				 done by virtio-mem or by some hypervisors
+				 implementing emulated DIMMs). As one example, a
 				 hotplugged DIMM will be onlined either
 				 completely to ZONE_MOVABLE or completely to
 				 ZONE_NORMAL, not a mixture.
_

Patches currently in -mm which might be from david@redhat.com are

memory-hotplugrst-fix-two-instances-of-movablecore-that-should-be-movable_node.patch
memory-hotplugrst-fix-wrong-sys-module-memory_hotplug-parameters-path.patch
memory-hotplugrst-document-the-auto-movable-online-policy.patch
memory-hotplugrst-document-the-auto-movable-online-policy-v2.patch
mm-memory_hotplug-remove-config_x86_64_acpi_numa-dependency-from-config_memory_hotplug.patch
mm-memory_hotplug-remove-config_memory_hotplug_sparse.patch
mm-memory_hotplug-restrict-config_memory_hotplug-to-64-bit.patch
mm-memory_hotplug-remove-highmem-leftovers.patch
mm-memory_hotplug-remove-stale-function-declarations.patch
x86-remove-memory-hotplug-support-on-x86_32.patch
mm-memory_hotplug-handle-memblock_add_node-failures-in-add_memory_resource.patch
memblock-improve-memblock_hotplug-documentation.patch
memblock-allow-to-specify-flags-with-memblock_add_node.patch
memblock-add-memblock_driver_managed-to-mimic-ioresource_sysram_driver_managed.patch
mm-memory_hotplug-indicate-memblock_driver_managed-with-ioresource_sysram_driver_managed.patch
x86-xen-update-xen_oldmem_pfn_is_ram-documentation.patch
x86-xen-simplify-xen_oldmem_pfn_is_ram.patch
x86-xen-print-a-warning-when-hvmop_get_mem_type-fails.patch
proc-vmcore-let-pfn_is_ram-return-a-bool.patch
proc-vmcore-convert-oldmem_pfn_is_ram-callback-to-more-generic-vmcore-callbacks.patch
virtio-mem-factor-out-hotplug-specifics-from-virtio_mem_init-into-virtio_mem_init_hotplug.patch
virtio-mem-factor-out-hotplug-specifics-from-virtio_mem_probe-into-virtio_mem_init_hotplug.patch
virtio-mem-factor-out-hotplug-specifics-from-virtio_mem_remove-into-virtio_mem_deinit_hotplug.patch
virtio-mem-kdump-mode-to-sanitize-proc-vmcore-access.patch
kernel-resource-clean-up-and-optimize-iomem_is_exclusive.patch
kernel-resource-disallow-access-to-exclusive-system-ram-regions.patch
virtio-mem-disallow-mapping-virtio-mem-memory-via-dev-mem.patch

