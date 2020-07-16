Return-Path: <SRS0=YRC/=A3=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93636C433E1
	for <mm-commits@archiver.kernel.org>; Thu, 16 Jul 2020 21:46:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6B71720809
	for <mm-commits@archiver.kernel.org>; Thu, 16 Jul 2020 21:46:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1594935963;
	bh=4IHSqX/NiV5S2eDC5kQZMQvwyDmZRNQXw/k+ryq3qEc=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=g+DfACn/N3174G6+HuPZItmPBiCTGE3CTc78JP6/f7IpsFC8udDkGBjpdJ57BkNKn
	 eY+F/qbR8GiIJEnBs+5vnH6jCU/PamPSIvou0LlITJbjf/KuSjbbqPSQhH83py68Mf
	 EcHItwKugx7OFAH/ph7Cyz52e5tGGRuEUVWLYYEw=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726296AbgGPVqD (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 16 Jul 2020 17:46:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:45738 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726002AbgGPVqC (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 16 Jul 2020 17:46:02 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 25CFE2076D;
        Thu, 16 Jul 2020 21:46:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594935962;
        bh=4IHSqX/NiV5S2eDC5kQZMQvwyDmZRNQXw/k+ryq3qEc=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=nkh7vhGwz+JLuRTvm+DhszD3iv84JQ9+x6pUiTM4zveDy2l6uZqGQftQPyjyYdQyI
         ZCb31VOJVfTJM+Lk/EUeY73+z4ASHk7e/chviyNmwLd7SDAzoffOTODS9IOHzVz8eN
         k3zIkPVVeQaWetW7kwGREtnm9Ay6Br0bTUkd/1b0=
Date:   Thu, 16 Jul 2020 14:46:01 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     aneesh.kumar@linux.vnet.ibm.com, dave.hansen@intel.com,
        david@redhat.com, mhocko@suse.com, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, n-horiguchi@ah.jp.nec.com,
        naoya.horiguchi@nec.com, osalvador@suse.com, osalvador@suse.de,
        tony.luck@intel.com, zeil@yandex-team.ru
Subject:  +
 mmhwpoison-un-export-get_hwpoison_page-and-make-it-static.patch added to
 -mm tree
Message-ID: <20200716214601.v1oMLYM51%akpm@linux-foundation.org>
In-Reply-To: <20200703151445.b6a0cfee402c7c5c4651f1b1@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm,hwpoison: Un-export get_hwpoison_page and make it static
has been added to the -mm tree.  Its filename is
     mmhwpoison-un-export-get_hwpoison_page-and-make-it-static.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mmhwpoison-un-export-get_hwpoison_page-and-make-it-static.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mmhwpoison-un-export-get_hwpoison_page-and-make-it-static.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Oscar Salvador <osalvador@suse.de>
Subject: mm,hwpoison: Un-export get_hwpoison_page and make it static

Since get_hwpoison_page is only used in memory-failure code now,
let us un-export it and make it private to that code.

Link: http://lkml.kernel.org/r/20200716123810.25292-7-osalvador@suse.de
Signed-off-by: Oscar Salvador <osalvador@suse.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Dmitry Yakunin <zeil@yandex-team.ru>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Tony Luck <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h  |    1 -
 mm/memory-failure.c |    3 +--
 2 files changed, 1 insertion(+), 3 deletions(-)

--- a/include/linux/mm.h~mmhwpoison-un-export-get_hwpoison_page-and-make-it-static
+++ a/include/linux/mm.h
@@ -2992,7 +2992,6 @@ extern int memory_failure(unsigned long
 extern void memory_failure_queue(unsigned long pfn, int flags);
 extern void memory_failure_queue_kick(int cpu);
 extern int unpoison_memory(unsigned long pfn);
-extern int get_hwpoison_page(struct page *page);
 #define put_hwpoison_page(page)	put_page(page)
 extern int sysctl_memory_failure_early_kill;
 extern int sysctl_memory_failure_recovery;
--- a/mm/memory-failure.c~mmhwpoison-un-export-get_hwpoison_page-and-make-it-static
+++ a/mm/memory-failure.c
@@ -925,7 +925,7 @@ static int page_action(struct page_state
  * Return: return 0 if failed to grab the refcount, otherwise true (some
  * non-zero value.)
  */
-int get_hwpoison_page(struct page *page)
+static int get_hwpoison_page(struct page *page)
 {
 	struct page *head = compound_head(page);
 
@@ -954,7 +954,6 @@ int get_hwpoison_page(struct page *page)
 
 	return 0;
 }
-EXPORT_SYMBOL_GPL(get_hwpoison_page);
 
 /*
  * Do all that is necessary to remove user space mappings. Unmap
_

Patches currently in -mm which might be from osalvador@suse.de are

mmmadvise-refactor-madvise_inject_error.patch
mmhwpoison-un-export-get_hwpoison_page-and-make-it-static.patch
mmhwpoison-kill-put_hwpoison_page.patch
mmhwpoison-unify-thp-handling-for-hard-and-soft-offline.patch
mmhwpoison-rework-soft-offline-for-free-pages.patch
mmhwpoison-rework-soft-offline-for-in-use-pages.patch
mmhwpoison-refactor-soft_offline_huge_page-and-__soft_offline_page.patch
mmhwpoison-return-0-if-the-page-is-already-poisoned-in-soft-offline.patch
mmhwpoison-introduce-mf_msg_unsplit_thp.patch

