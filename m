Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24700C433EF
	for <mm-commits@archiver.kernel.org>; Thu, 30 Sep 2021 22:33:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0C75661A61
	for <mm-commits@archiver.kernel.org>; Thu, 30 Sep 2021 22:33:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348158AbhI3Wfd (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 30 Sep 2021 18:35:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:40282 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345276AbhI3Wf3 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 30 Sep 2021 18:35:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BB6E761A57;
        Thu, 30 Sep 2021 22:33:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1633041226;
        bh=l+YuHlAjmy5K0kB4ap54ZhAJ0HpUVCbUWXEjYAT6xa0=;
        h=Date:From:To:Subject:From;
        b=GY9J6xgWnPtYAqeZuAx63dwSB53ZsaMxnc0T66WzZlMxvQop/01Bk4jB41krcUjeV
         OmH6LVcU9U53K7y2nqouB0XNOOwkOpShpoS6e1di/lwEGbGm8Ys57OqWiqbXn+taIt
         T/JA7ga4P28mx5CvvsK+GCkaK3yBUhS7IROCq9es=
Date:   Thu, 30 Sep 2021 15:33:45 -0700
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
 mm-memory_hotplug-restrict-config_memory_hotplug-to-64-bit.patch added to
 -mm tree
Message-ID: <20210930223345.H7d4lRYJz%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memory_hotplug: restrict CONFIG_MEMORY_HOTPLUG to 64 bit
has been added to the -mm tree.  Its filename is
     mm-memory_hotplug-restrict-config_memory_hotplug-to-64-bit.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-memory_hotplug-restrict-config_memory_hotplug-to-64-bit.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-memory_hotplug-restrict-config_memory_hotplug-to-64-bit.patch

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
Subject: mm/memory_hotplug: restrict CONFIG_MEMORY_HOTPLUG to 64 bit

32 bit support is broken in various ways: for example, we can online
memory that should actually go to ZONE_HIGHMEM to ZONE_MOVABLE or in some
cases even to one of the other kernel zones.

We marked it BROKEN in commit b59d02ed0869 ("mm/memory_hotplug: disable
the functionality for 32b") almost one year ago.  According to that commit
it might be broken at least since 2017.  Further, there is hardly a sane
use case nowadays.

Let's just depend completely on 64bit, dropping the "BROKEN" dependency to
make clear that we are not going to support it again.  Next, we'll remove
some HIGHMEM leftovers from memory hotplug code to clean up.

Link: https://lkml.kernel.org/r/20210929143600.49379-4-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: Alex Shi <alexs@kernel.org>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jason Wang <jasowang@redhat.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/Kconfig~mm-memory_hotplug-restrict-config_memory_hotplug-to-64-bit
+++ a/mm/Kconfig
@@ -125,7 +125,7 @@ config MEMORY_HOTPLUG
 	select MEMORY_ISOLATION
 	depends on SPARSEMEM
 	depends on ARCH_ENABLE_MEMORY_HOTPLUG
-	depends on 64BIT || BROKEN
+	depends on 64BIT
 	select NUMA_KEEP_MEMINFO if NUMA
 
 config MEMORY_HOTPLUG_DEFAULT_ONLINE
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

