Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77CF1C433F5
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:44:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5BE876136F
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:44:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233740AbhKEUrN (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 5 Nov 2021 16:47:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:42152 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233739AbhKEUrK (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Nov 2021 16:47:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 904A361357;
        Fri,  5 Nov 2021 20:44:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636145069;
        bh=3A4nZhu029sBU0tdcSR7GUPafBaYK4IeubSP84Q2m/Y=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=o7a6hnO3KVY4qHDb3PBMW02C5XxcppbniN8Q3BvkSf/8+qrXeUYiyfsAREkSnTPBZ
         6Clxu1YiI75voca6J1CONSQMrlQsPnquuTgeft9tbZIR8SISdkkDJxeAdWLzSrB3hR
         P/DErO47g8E9z3bWNFKLQq6og4zhMb9tytDxE860=
Date:   Fri, 05 Nov 2021 13:44:28 -0700
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
Subject:  [patch 188/262] mm/memory_hotplug: restrict
 CONFIG_MEMORY_HOTPLUG to 64 bit
Message-ID: <20211105204428.ikPIxSeQt%akpm@linux-foundation.org>
In-Reply-To: <20211105133408.cccbb98b71a77d5e8430aba1@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
Reviewed-by: Oscar Salvador <osalvador@suse.de>
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
