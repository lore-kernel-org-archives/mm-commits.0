Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3985C48BD1
	for <mm-commits@archiver.kernel.org>; Thu, 10 Jun 2021 20:49:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7E16B61374
	for <mm-commits@archiver.kernel.org>; Thu, 10 Jun 2021 20:49:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229961AbhFJUv1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 10 Jun 2021 16:51:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:41458 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230001AbhFJUv1 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 10 Jun 2021 16:51:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 16818613CB;
        Thu, 10 Jun 2021 20:49:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1623358170;
        bh=cZ+m44GdpZg/8aDd0vuQYAwqB4e6dNbdMtJzMoP0tD4=;
        h=Date:From:To:Subject:From;
        b=YyTRe31B2cGsJTSPpXrPTbs1WQnjdjGOQxleM81T0D3xbKwZQGpH8vZf2JQB/a9FO
         pSkJZObExonMZMHptlZVOmpULPv2fHH3XcPtXV849kYXBeHj4eMcVx0+FPqz7EiLoR
         dw5UmpURvgx43+C+Pnj+yiOd2HLMZJT91kIzVofA=
Date:   Thu, 10 Jun 2021 13:49:29 -0700
From:   akpm@linux-foundation.org
To:     borntraeger@de.ibm.com, catalin.marinas@arm.com, david@redhat.com,
        frankja@linux.ibm.com, imbrenda@linux.ibm.com, mingo@redhat.com,
        mm-commits@vger.kernel.org, npiggin@gmail.com, rientjes@google.com,
        tglx@linutronix.de, urezki@gmail.com
Subject:  [to-be-updated]
 mm-vmalloc-export-__vmalloc_node_range.patch removed from -mm tree
Message-ID: <20210610204929.dl8N13NTk%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmalloc: export __vmalloc_node_range
has been removed from the -mm tree.  Its filename was
     mm-vmalloc-export-__vmalloc_node_range.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
Subject: mm/vmalloc: export __vmalloc_node_range

The recent patches to add support for hugepage vmalloc mappings added a
flag for __vmalloc_node_range to allow to request small pages.  This flag
is not accessible when calling vmalloc, the only option is to call
directly __vmalloc_node_range, which is not exported.

This means that a module can't vmalloc memory with small pages.

Case in point: KVM on s390x needs to vmalloc a large area, and it needs to
be mapped with small pages, because of a hardware limitation.

This patch exports __vmalloc_node_range so it can be used in modules too.

Link: https://lkml.kernel.org/r/20210608180618.477766-2-imbrenda@linux.ibm.com
Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Uladzislau Rezki (Sony) <urezki@gmail.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Janosch Frank <frankja@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/vmalloc.c~mm-vmalloc-export-__vmalloc_node_range
+++ a/mm/vmalloc.c
@@ -2937,6 +2937,7 @@ fail:
 
 	return NULL;
 }
+EXPORT_SYMBOL_GPL(__vmalloc_node_range);
 
 /**
  * __vmalloc_node - allocate virtually contiguous memory
_

Patches currently in -mm which might be from imbrenda@linux.ibm.com are

kvm-s390-fix-for-hugepage-vmalloc.patch

