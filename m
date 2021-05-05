Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7DDF5C43603
	for <mm-commits@archiver.kernel.org>; Wed,  5 May 2021 01:39:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 65C2161423
	for <mm-commits@archiver.kernel.org>; Wed,  5 May 2021 01:39:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231991AbhEEBks (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 4 May 2021 21:40:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:44296 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231869AbhEEBks (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 4 May 2021 21:40:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 54D3B61029;
        Wed,  5 May 2021 01:39:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620178792;
        bh=2A2mAOGGMPIzoiHn6AuwenNC8uceC84Ix+44pr0w42w=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=wiwxXO0c6ev/V/64ESM99Vo331a8FAbtRVWAdwZ/oMZGD+tPoyewMsl0oj6PraI+M
         bYxWEXV5UaSxlRpplxIMxueKLnqsspC9J3o9sVn4MqrrqC8s7gwNZcn6CgNmkWs3bH
         UHjJnaNIcaTl8PzQCH9WNDhQN0vp9icRBLDvZKgQ=
Date:   Tue, 04 May 2021 18:39:51 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, anshuman.khandual@arm.com,
        david@redhat.com, linux-mm@kvack.org, mhocko@suse.com,
        mm-commits@vger.kernel.org, osalvador@suse.de,
        pasha.tatashin@soleen.com, torvalds@linux-foundation.org,
        vbabka@suse.cz
Subject:  [patch 131/143] x86/Kconfig: introduce
 ARCH_MHP_MEMMAP_ON_MEMORY_ENABLE
Message-ID: <20210505013951.6aPcS_lkh%akpm@linux-foundation.org>
In-Reply-To: <20210504183219.a3cc46aee4013d77402276c5@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Oscar Salvador <osalvador@suse.de>
Subject: x86/Kconfig: introduce ARCH_MHP_MEMMAP_ON_MEMORY_ENABLE

Enable x86_64 platform to use the MHP_MEMMAP_ON_MEMORY feature.

Link: https://lkml.kernel.org/r/20210421102701.25051-8-osalvador@suse.de
Signed-off-by: Oscar Salvador <osalvador@suse.de>
Reviewed-by: David Hildenbrand <david@redhat.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Pavel Tatashin <pasha.tatashin@soleen.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/Kconfig |    3 +++
 1 file changed, 3 insertions(+)

--- a/arch/x86/Kconfig~x86-kconfig-introduce-arch_mhp_memmap_on_memory_enable
+++ a/arch/x86/Kconfig
@@ -2432,6 +2432,9 @@ config ARCH_HAS_ADD_PAGES
 	def_bool y
 	depends on X86_64 && ARCH_ENABLE_MEMORY_HOTPLUG
 
+config ARCH_MHP_MEMMAP_ON_MEMORY_ENABLE
+	def_bool y
+
 config USE_PERCPU_NUMA_NODE_ID
 	def_bool y
 	depends on NUMA
_
