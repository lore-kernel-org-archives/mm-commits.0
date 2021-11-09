Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2FC98C433F5
	for <mm-commits@archiver.kernel.org>; Tue,  9 Nov 2021 23:24:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0FF07611AF
	for <mm-commits@archiver.kernel.org>; Tue,  9 Nov 2021 23:24:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231722AbhKIX1J (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 9 Nov 2021 18:27:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:47626 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231572AbhKIX1H (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 9 Nov 2021 18:27:07 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DA6DD61184;
        Tue,  9 Nov 2021 23:24:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636500261;
        bh=mbcMPZcXv0zJKXUKuuFnvCvH+VH1zkANTaWJmaqXz/w=;
        h=Date:From:To:Subject:From;
        b=DiE7lZX/a/VnoKTekxTmYRWVjrR7s8eEYFW0W6ntf1RbxllMoUsu7Has2tOUwgEpb
         5k+8E5ER8K7BrDfS9DZDhy0N4bFTONFBFv67SzQX3dKJS2W6yOupuIzorc2hJAPVGi
         /R+TrdwVeJeHVrXmouLbo3eHkr4Qhyn1urERiBBg=
Date:   Tue, 09 Nov 2021 15:24:20 -0800
From:   akpm@linux-foundation.org
To:     hyc.lee@gmail.com, linkinjeon@kernel.org,
        mm-commits@vger.kernel.org, smfrench@gmail.com, willy@infradead.org
Subject:  +
 hitting-bug_on-trap-in-read_pages-mm-optimise-put_pages_list.patch added to
 -mm tree
Message-ID: <20211109232420.5X7KNcoQd%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ipc/ipc_sysctl.c:put_pages_list(): reinitialise the page list
has been added to the -mm tree.  Its filename is
     hitting-bug_on-trap-in-read_pages-mm-optimise-put_pages_list.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/hitting-bug_on-trap-in-read_pages-mm-optimise-put_pages_list.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/hitting-bug_on-trap-in-read_pages-mm-optimise-put_pages_list.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Matthew Wilcox <willy@infradead.org>
Subject: ipc/ipc_sysctl.c:put_pages_list(): reinitialise the page list


While free_unref_page_list() puts pages onto the CPU local LRU list, it
does not remove them from the list they were passed in on.  That makes the
list_head appear to be non-empty, and would lead to various corruption
problems if we didn't have an assertion that the list was empty.

Reinitialise the list after calling free_unref_page_list() to avoid this
problem.

Link: https://lkml.kernel.org/r/YYp40A2lNrxaZji8@casper.infradead.org
Fixes: 988c69f1bc23 ("mm: optimise put_pages_list()")
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reported-by: Namjae Jeon <linkinjeon@kernel.org>
Tested-by: Namjae Jeon <linkinjeon@kernel.org>
Cc: Steve French <smfrench@gmail.com>
Cc: Hyeoncheol Lee <hyc.lee@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/swap.c~hitting-bug_on-trap-in-read_pages-mm-optimise-put_pages_list
+++ a/mm/swap.c
@@ -155,6 +155,7 @@ void put_pages_list(struct list_head *pa
 	}
 
 	free_unref_page_list(pages);
+	INIT_LIST_HEAD(pages);
 }
 EXPORT_SYMBOL(put_pages_list);
 
_

Patches currently in -mm which might be from willy@infradead.org are

mm-move-kvmalloc-related-functions-to-slabh.patch
kasan-fix-tag-for-large-allocations-when-using-config_slab.patch
mm-remove-bogus-vm_bug_on.patch
mm-optimise-put_pages_list.patch
hitting-bug_on-trap-in-read_pages-mm-optimise-put_pages_list.patch

