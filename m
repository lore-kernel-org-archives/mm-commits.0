Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C885C433EF
	for <mm-commits@archiver.kernel.org>; Thu, 30 Sep 2021 22:33:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6EA6461A54
	for <mm-commits@archiver.kernel.org>; Thu, 30 Sep 2021 22:33:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345059AbhI3WfX (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 30 Sep 2021 18:35:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:40088 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348158AbhI3WfW (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 30 Sep 2021 18:35:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 36614619E7;
        Thu, 30 Sep 2021 22:33:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1633041218;
        bh=gxB6aNAGao1pNPr3kTzeDASqPJ/XzVN3n/JZWdUtL20=;
        h=Date:From:To:Subject:From;
        b=ssY2Q6xkre8mihuwyQL3jhQBBnkw2yZvJNWoPD9tMVSz+scjs3Opo+E96L5IjI+2R
         3TEfHc3vzcE09NLRGJsIj1O4SHNyb6ksBxJeYteMvSEdMgqdAkoI7oQCElk0VzQ4bd
         v0XnSuJ+1Bln8ihtNHBc6LSmz7/9v0FRjDKVvA+Y=
Date:   Thu, 30 Sep 2021 15:33:37 -0700
From:   akpm@linux-foundation.org
To:     alexs@kernel.org, benh@kernel.crashing.org, bp@alien8.de,
        corbet@lwn.net, dave.hansen@linux.intel.com, david@redhat.com,
        gregkh@linuxfoundation.org, hpa@zytor.com, jasowang@redhat.com,
        luto@kernel.org, mhocko@suse.com, mingo@redhat.com,
        mm-commits@vger.kernel.org, mpe@ellerman.id.au, mst@redhat.com,
        osalvador@suse.de, paulus@samba.org, peterz@infradead.org,
        rafael@kernel.org, rppt@kernel.org, shuah@kernel.org,
        tglx@linutronix.de
Subject:  +
 =?US-ASCII?Q?mm-memory=5Fhotplug-remove-config=5Fx86=5F64=5Facpi=5Fnuma?=
 =?US-ASCII?Q?-dependency-from-config=5Fmemory=5Fhotplug.patch?= added to
 -mm tree
Message-ID: <20210930223337.MwzwjvF3_%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memory_hotplug: remove CONFIG_X86_64_ACPI_NUMA dependency from CONFIG_MEMORY_HOTPLUG
has been added to the -mm tree.  Its filename is
     mm-memory_hotplug-remove-config_x86_64_acpi_numa-dependency-from-config_memory_hotplug.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-memory_hotplug-remove-config_x86_64_acpi_numa-dependency-from-config_memory_hotplug.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-memory_hotplug-remove-config_x86_64_acpi_numa-dependency-from-config_memory_hotplug.patch

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
Subject: mm/memory_hotplug: remove CONFIG_X86_64_ACPI_NUMA dependency from CONFIG_MEMORY_HOTPLUG

Patch series "mm/memory_hotplug: Kconfig and 32 bit cleanups".

Some cleanups around CONFIG_MEMORY_HOTPLUG, including removing 32 bit
leftovers of memory hotplug support.


This patch (of 6):

SPARSEMEM is the only possible memory model for x86-64, FLATMEM is not
possible:
	config ARCH_FLATMEM_ENABLE
		def_bool y
		depends on X86_32 && !NUMA

And X86_64_ACPI_NUMA (obviously) only supports x86-64:
	config X86_64_ACPI_NUMA
		def_bool y
		depends on X86_64 && NUMA && ACPI && PCI

Let's just remove the CONFIG_X86_64_ACPI_NUMA dependency, as it does no
longer make sense.

Link: https://lkml.kernel.org/r/20210929143600.49379-2-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Alex Shi <alexs@kernel.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>
Cc: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Jason Wang <jasowang@redhat.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Mike Rapoport <rppt@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/Kconfig~mm-memory_hotplug-remove-config_x86_64_acpi_numa-dependency-from-config_memory_hotplug
+++ a/mm/Kconfig
@@ -123,7 +123,7 @@ config ARCH_ENABLE_MEMORY_HOTPLUG
 config MEMORY_HOTPLUG
 	bool "Allow for memory hot-add"
 	select MEMORY_ISOLATION
-	depends on SPARSEMEM || X86_64_ACPI_NUMA
+	depends on SPARSEMEM
 	depends on ARCH_ENABLE_MEMORY_HOTPLUG
 	depends on 64BIT || BROKEN
 	select NUMA_KEEP_MEMINFO if NUMA
_

Patches currently in -mm which might be from david@redhat.com are

memory-hotplugrst-fix-two-instances-of-movablecore-that-should-be-movable_node.patch
memory-hotplugrst-fix-wrong-sys-module-memory_hotplug-parameters-path.patch
memory-hotplugrst-document-the-auto-movable-online-policy.patch
mm-memory_hotplug-remove-config_x86_64_acpi_numa-dependency-from-config_memory_hotplug.patch
mm-memory_hotplug-remove-config_memory_hotplug_sparse.patch
mm-memory_hotplug-restrict-config_memory_hotplug-to-64-bit.patch
mm-memory_hotplug-remove-highmem-leftovers.patch
mm-memory_hotplug-remove-stale-function-declarations.patch
x86-remove-memory-hotplug-support-on-x86_32.patch
kernel-resource-clean-up-and-optimize-iomem_is_exclusive.patch
kernel-resource-disallow-access-to-exclusive-system-ram-regions.patch
virtio-mem-disallow-mapping-virtio-mem-memory-via-dev-mem.patch

