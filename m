Return-Path: <SRS0=f579=BK=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLACK,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD9A8C433DF
	for <mm-commits@archiver.kernel.org>; Fri, 31 Jul 2020 20:05:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B3BDA22B43
	for <mm-commits@archiver.kernel.org>; Fri, 31 Jul 2020 20:05:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1596225949;
	bh=xaGvTXMe2M09gx9jyhrCAshH+q0DsQqboht5qW7JMuQ=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=DNSZ9pvpp064MPoCIGQhA3mxBykzJxa3k3G8Qqc6JAlpAg+yTnRFECs+7KnJM8jeU
	 lyXN0+BtQ3ymgic6QJ0u9oi6fAqLF/ul4RXE2BHgPjk7aw1x05C0NjxU+KGyBzypSN
	 KSgbKbnLSWmQLbRrfA8l6kZP5anQt9DSAkggXf1M=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726802AbgGaUFt (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 31 Jul 2020 16:05:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:46950 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726077AbgGaUFt (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 31 Jul 2020 16:05:49 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EE59722B42;
        Fri, 31 Jul 2020 20:05:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596225948;
        bh=xaGvTXMe2M09gx9jyhrCAshH+q0DsQqboht5qW7JMuQ=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=KoXWP/wuM9dmNQ3u7E+7dmjJ7HFQYbggS6ualaiPY6NfEpGyEIGVf1yi55xpyvyH+
         MDwhCnzF0m49eiNKmEKPTWby7tW0VD6eQnQRoyySSLorg5Kg74pzdrFRsNRlTz6f1B
         nkcaTaOqJLERp7tS9B21vAOlcurruWXPxV7P5RcU=
Date:   Fri, 31 Jul 2020 13:05:47 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     aneesh.kumar@linux.ibm.com, aneesh.kumar@linux.vnet.ibm.com,
        cai@lca.pw, dave.hansen@intel.com, david@redhat.com,
        mhocko@suse.com, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, n-horiguchi@ah.jp.nec.com,
        naoya.horiguchi@nec.com, osalvador@suse.com, osalvador@suse.de,
        tony.luck@intel.com, zeil@yandex-team.ru
Subject:  + mmmadvise-refactor-madvise_inject_error.patch added to
 -mm tree
Message-ID: <20200731200547.QUd7aMyog%akpm@linux-foundation.org>
In-Reply-To: <20200723211432.b31831a0df3bc2cbdae31b40@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm,madvise: refactor madvise_inject_error
has been added to the -mm tree.  Its filename is
     mmmadvise-refactor-madvise_inject_error.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mmmadvise-refactor-madvise_inject_error.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mmmadvise-refactor-madvise_inject_error.patch

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
Subject: mm,madvise: refactor madvise_inject_error

Make a proper if-else condition for {hard,soft}-offline.

Link: http://lkml.kernel.org/r/20200731122112.11263-5-nao.horiguchi@gmail.com
Signed-off-by: Oscar Salvador <osalvador@suse.com>
Signed-off-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Dmitry Yakunin <zeil@yandex-team.ru>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Qian Cai <cai@lca.pw>
Cc: Tony Luck <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/madvise.c |   16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

--- a/mm/madvise.c~mmmadvise-refactor-madvise_inject_error
+++ a/mm/madvise.c
@@ -869,16 +869,15 @@ static long madvise_remove(struct vm_are
 static int madvise_inject_error(int behavior,
 		unsigned long start, unsigned long end)
 {
-	struct page *page;
 	struct zone *zone;
 	unsigned long size;
 
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
 
-
 	for (; start < end; start += size) {
 		unsigned long pfn;
+		struct page *page;
 		int ret;
 
 		ret = get_user_pages_fast(start, 1, 0, &page);
@@ -908,17 +907,14 @@ static int madvise_inject_error(int beha
 
 		if (behavior == MADV_SOFT_OFFLINE) {
 			pr_info("Soft offlining pfn %#lx at process virtual address %#lx\n",
-					pfn, start);
-
+				pfn, start);
 			ret = soft_offline_page(pfn, 0);
-			if (ret)
-				return ret;
-			continue;
+		} else {
+			pr_info("Injecting memory failure for pfn %#lx at process virtual address %#lx\n",
+				pfn, start);
+			ret = memory_failure(pfn, 0);
 		}
 
-		pr_info("Injecting memory failure for pfn %#lx at process virtual address %#lx\n",
-				pfn, start);
-		ret = memory_failure(pfn, 0);
 		if (ret)
 			return ret;
 	}
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

