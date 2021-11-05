Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BFD7C4332F
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:44:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 07EAA61288
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:44:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233728AbhKEUrC (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 5 Nov 2021 16:47:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:41932 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233723AbhKEUrC (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Nov 2021 16:47:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3E17F6126A;
        Fri,  5 Nov 2021 20:44:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636145062;
        bh=kEqxJVXpyBcCpQjpy6DUOkt3Fq/ds2a/WHBz96lmeIE=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=WSSsqjpJUvpmo2bWGIJJJPQfZTX5f3HdBDICg4ZD6hYvttgjv9VlBTbAijqdN1TUk
         fIK/RWV8w+ba1mgi7i3pBKeSMfUxwLBDC4UAFnLwMMUlfn72MkSEs2MM6+sSuEAton
         cYH7EuElhlUEibv/ktS3dllm2dAtR8tSvZQYHEDA=
Date:   Fri, 05 Nov 2021 13:44:20 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, alexs@kernel.org,
        benh@kernel.crashing.org, bp@alien8.de, corbet@lwn.net,
        dave.hansen@linux.intel.com, david@redhat.com,
        gregkh@linuxfoundation.org, hpa@zytor.com, jasowang@redhat.com,
        linux-mm@kvack.org, luto@kernel.org, mhocko@suse.com,
        mingo@redhat.com, mm-commits@vger.kernel.org, mpe@ellerman.id.au,
        mst@redhat.com, osalvador@suse.de, paulus@samba.org,
        peterz@infradead.org, rafael@kernel.org, rppt@kernel.org,
        shuah@kernel.org, tglx@linutronix.de, torvalds@linux-foundation.org
Subject:  [patch 186/262] mm/memory_hotplug: remove
 CONFIG_X86_64_ACPI_NUMA dependency from CONFIG_MEMORY_HOTPLUG
Message-ID: <20211105204420.EwguDZQuI%akpm@linux-foundation.org>
In-Reply-To: <20211105133408.cccbb98b71a77d5e8430aba1@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
