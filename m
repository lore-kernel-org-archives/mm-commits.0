Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 949AEC47082
	for <mm-commits@archiver.kernel.org>; Tue,  8 Jun 2021 21:06:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 792DC61364
	for <mm-commits@archiver.kernel.org>; Tue,  8 Jun 2021 21:06:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229548AbhFHVIP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 8 Jun 2021 17:08:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:34850 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231450AbhFHVIO (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 8 Jun 2021 17:08:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2522E611BD;
        Tue,  8 Jun 2021 21:06:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1623186381;
        bh=vpsmwx94doLjTXvmRKA+koQmgraaVVcEVK6mImAlDXk=;
        h=Date:From:To:Subject:From;
        b=judWQImmt8ZNZ02/oEQT1+6e1zzmhe4xxqeDJDgVd0jeVlwutJrZotvcvGhJRsdLu
         OAJ6U6zNC0yb8isbaqmT+LEd6yFqodNTYPYfpcsRXZK4ZvNtmJyM56CJeQJXnIvFj+
         i1pPZNK7ZvnKzrFumZOuNb9FDpBr7d887rimWsHo=
Date:   Tue, 08 Jun 2021 14:06:20 -0700
From:   akpm@linux-foundation.org
To:     borntraeger@de.ibm.com, catalin.marinas@arm.com, david@redhat.com,
        frankja@linux.ibm.com, imbrenda@linux.ibm.com, mingo@redhat.com,
        mm-commits@vger.kernel.org, npiggin@gmail.com, rientjes@google.com,
        tglx@linutronix.de, urezki@gmail.com
Subject:  + mm-vmalloc-export-__vmalloc_node_range.patch added to
 -mm tree
Message-ID: <20210608210620.SAL9o0TlS%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmalloc: export __vmalloc_node_range
has been added to the -mm tree.  Its filename is
     mm-vmalloc-export-__vmalloc_node_range.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-vmalloc-export-__vmalloc_node_range.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-vmalloc-export-__vmalloc_node_range.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-vmalloc-export-__vmalloc_node_range.patch
kvm-s390-fix-for-hugepage-vmalloc.patch

