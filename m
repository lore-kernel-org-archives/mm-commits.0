Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6DFBC433ED
	for <mm-commits@archiver.kernel.org>; Tue, 20 Apr 2021 22:55:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ABBC761406
	for <mm-commits@archiver.kernel.org>; Tue, 20 Apr 2021 22:55:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234290AbhDTW4T (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 20 Apr 2021 18:56:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:60774 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234240AbhDTW4R (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 20 Apr 2021 18:56:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C284861406;
        Tue, 20 Apr 2021 22:55:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1618959344;
        bh=WDXD723fVCXi9YMg7VVpkQtCz3D41DjPzSBmAaaVpJU=;
        h=Date:From:To:Subject:From;
        b=Gr29TsQfBDe4KTLe1YElba2A41MimiLgnPgcY2ERStuohOqTTV70HlqVOsXqq3tHJ
         5h0CixWAfIpb1JxJQaszGtxOKKu8k3x7e1bGZc/D/a/+1EjSw8k4f2iDV83l5RhAgY
         +VdrNokOpwRblhYZmkQtVbaNxzG/iTIhUZfAccd4=
Date:   Tue, 20 Apr 2021 15:55:43 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, rdunlap@infradead.org, rppt@kernel.org
Subject:  [merged] ia64-fix-discontigc-section-mismatches.patch
 removed from -mm tree
Message-ID: <20210420225543.dzkyfiynU%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ia64: fix discontig.c section mismatches
has been removed from the -mm tree.  Its filename was
     ia64-fix-discontigc-section-mismatches.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Randy Dunlap <rdunlap@infradead.org>
Subject: ia64: fix discontig.c section mismatches

Fix IA64 discontig.c Section mismatch warnings.

When CONFIG_SPARSEMEM=y and CONFIG_MEMORY_HOTPLUG=y, the functions
computer_pernodesize() and scatter_node_data() should not be marked
as __meminit because they are needed after init, on any memory
hotplug event. Also, early_nr_cpus_node() is called by
compute_pernodesize(), so early_nr_cpus_node() cannot be __meminit either.

WARNING: modpost: vmlinux.o(.text.unlikely+0x1612): Section mismatch in reference from the function arch_alloc_nodedata() to the function .meminit.text:compute_pernodesize()
The function arch_alloc_nodedata() references
the function __meminit compute_pernodesize().
This is often because arch_alloc_nodedata lacks a __meminit
annotation or the annotation of compute_pernodesize is wrong.

WARNING: modpost: vmlinux.o(.text.unlikely+0x1692): Section mismatch in reference from the function arch_refresh_nodedata() to the function .meminit.text:scatter_node_data()
The function arch_refresh_nodedata() references
the function __meminit scatter_node_data().
This is often because arch_refresh_nodedata lacks a __meminit
annotation or the annotation of scatter_node_data is wrong.

WARNING: modpost: vmlinux.o(.text.unlikely+0x1502): Section mismatch in reference from the function compute_pernodesize() to the function .meminit.text:early_nr_cpus_node()
The function compute_pernodesize() references
the function __meminit early_nr_cpus_node().
This is often because compute_pernodesize lacks a __meminit
annotation or the annotation of early_nr_cpus_node is wrong.

Link: https://lkml.kernel.org/r/20210411001201.3069-1-rdunlap@infradead.org
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Mike Rapoport <rppt@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/mm/discontig.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/arch/ia64/mm/discontig.c~ia64-fix-discontigc-section-mismatches
+++ a/arch/ia64/mm/discontig.c
@@ -95,7 +95,7 @@ static int __init build_node_maps(unsign
  * acpi_boot_init() (which builds the node_to_cpu_mask array) hasn't been
  * called yet.  Note that node 0 will also count all non-existent cpus.
  */
-static int __meminit early_nr_cpus_node(int node)
+static int early_nr_cpus_node(int node)
 {
 	int cpu, n = 0;
 
@@ -110,7 +110,7 @@ static int __meminit early_nr_cpus_node(
  * compute_pernodesize - compute size of pernode data
  * @node: the node id.
  */
-static unsigned long __meminit compute_pernodesize(int node)
+static unsigned long compute_pernodesize(int node)
 {
 	unsigned long pernodesize = 0, cpus;
 
@@ -367,7 +367,7 @@ static void __init reserve_pernode_space
 	}
 }
 
-static void __meminit scatter_node_data(void)
+static void scatter_node_data(void)
 {
 	pg_data_t **dst;
 	int node;
_

Patches currently in -mm which might be from rdunlap@infradead.org are

vfs-fs_parser-clean-up-kernel-doc-warnings.patch
lib-parser-clean-up-kernel-doc.patch

