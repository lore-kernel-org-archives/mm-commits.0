Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4A11C433FE
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:47:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AC1C9610A2
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:47:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234411AbhKKCuH (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 10 Nov 2021 21:50:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:54700 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234404AbhKKCuG (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 10 Nov 2021 21:50:06 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E91E560F26;
        Thu, 11 Nov 2021 02:47:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636598838;
        bh=kiPh5TCYW03qZCjbcMgwM2Od75PbSPV7iuU1OjyABGk=;
        h=Date:From:To:Subject:From;
        b=1Ahociw/DvC0Ie6ZXs4YbzaZg8hIqdFnHSoTSJYB+y6tXUNT+oaWLlkW13PMCJdPr
         qNodkswbZABxQEcSlKI6uDY45gIR2YKopvQ8lG/E6H7XXmwDevZysRpuxf4JFKveSo
         mRWfWBL5j6LEjeI9TD6lVK8dxdpdm+u8fKLlJ69M=
Date:   Wed, 10 Nov 2021 18:47:17 -0800
From:   akpm@linux-foundation.org
To:     alexs@kernel.org, benh@kernel.crashing.org, bp@alien8.de,
        corbet@lwn.net, dave.hansen@linux.intel.com, david@redhat.com,
        gregkh@linuxfoundation.org, hpa@zytor.com, jasowang@redhat.com,
        luto@kernel.org, mhocko@suse.com, mingo@redhat.com,
        mm-commits@vger.kernel.org, mpe@ellerman.id.au, mst@redhat.com,
        osalvador@suse.de, paulus@samba.org, peterz@infradead.org,
        rafael@kernel.org, rppt@kernel.org, shuah@kernel.org,
        tglx@linutronix.de
Subject:  [merged]
 =?US-ASCII?Q?mm-memory=5Fhotplug-remove-config=5Fx86=5F64=5Facpi=5Fnuma?=
 =?US-ASCII?Q?-dependency-from-config=5Fmemory=5Fhotplug.patch?= removed
 from -mm tree
Message-ID: <20211111024717.cFnxb_pJy%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memory_hotplug: remove CONFIG_X86_64_ACPI_NUMA dependency from CONFIG_MEMORY_HOTPLUG
has been removed from the -mm tree.  Its filename was
     mm-memory_hotplug-remove-config_x86_64_acpi_numa-dependency-from-config_memory_hotplug.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
Reviewed-by: Oscar Salvador <osalvador@suse.de>
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


