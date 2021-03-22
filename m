Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,HK_RANDOM_FROM,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6C73C433C1
	for <mm-commits@archiver.kernel.org>; Mon, 22 Mar 2021 04:08:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6C0CF61968
	for <mm-commits@archiver.kernel.org>; Mon, 22 Mar 2021 04:08:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229450AbhCVEIB (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 22 Mar 2021 00:08:01 -0400
Received: from mail.kingsoft.com ([114.255.44.145]:16396 "EHLO
        mail.kingsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbhCVEHm (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 22 Mar 2021 00:07:42 -0400
X-Greylist: delayed 902 seconds by postgrey-1.27 at vger.kernel.org; Mon, 22 Mar 2021 00:07:41 EDT
X-AuditID: 0a580155-1f5ff7000005482e-c0-60580ca49bed
Received: from mail.kingsoft.com (localhost [10.88.1.32])
        (using TLS with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (Client did not present a certificate)
        by mail.kingsoft.com (SMG-2-NODE-85) with SMTP id 90.90.18478.4AC08506; Mon, 22 Mar 2021 11:19:00 +0800 (HKT)
Received: from alex-virtual-machine (172.16.253.254) by KSBJMAIL2.kingsoft.cn
 (10.88.1.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Mon, 22 Mar
 2021 11:52:33 +0800
Date:   Mon, 22 Mar 2021 11:52:33 +0800
From:   Aili Yao <yaoaili@kingsoft.com>
To:     <akpm@linux-foundation.org>, <willy@infradead.org>
CC:     <david@redhat.com>, <mike.kravetz@oracle.com>,
        <mm-commits@vger.kernel.org>, <naoya.horiguchi@nec.com>,
        <osalvador@suse.de>, <yaoaili@kingsoft.com>
Subject: [PATCH v4] mm/gup: check page posion status for coredump.
Message-ID: <20210322115233.05e4e82a@alex-virtual-machine>
In-Reply-To: <20210320002238.hHjZEha58%akpm@linux-foundation.org>
References: <20210320002238.hHjZEha58%akpm@linux-foundation.org>
Organization: kingsoft
X-Mailer: Claws Mail 3.17.5 (GTK+ 2.24.30; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.16.253.254]
X-ClientProxiedBy: KSBJMAIL1.kingsoft.cn (10.88.1.31) To KSBJMAIL2.kingsoft.cn
 (10.88.1.32)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrBLMWRmVeSWpSXmKPExsXCFcGooLuEJyLB4NN8aYs569ewWXxd/4vZ
        4uP+YIvXEy+wWlxsPMBocWZakcXvH3PYHNg9Nq/Q8jgx4zeLx4urG1k8Pj69xeLxft9VNo/N
        p6s9Pm+SC2CP4rJJSc3JLEst0rdL4Mp49Xcze8FKiYre64eYGhhvCncxcnJICJhILH3+jK2L
        kYtDSGA6k0TXp3lMEM4rRok1zXMZQapYBFQlnp7fxgpiswHZu+7NArNFBMwkVl//xwrSwCww
        m1Fi9ZpuZpCEsICTxKoLC8BsXgEriW2fDgIN4uDgFHCUOPtQDiQsJOAg8aPxC9gcfgExid4r
        /5kgLrKXaNuyiBGiVVDi5MwnLCA2s4COxIlVx5ghbHmJ7W/nMEPMUZQ4vOQXO0SvksSR7hls
        EHasxLJ5r1gnMArPQjJqFpJRs5CMWsDIvIqRpTg33WgTIyQyQncwzmj6qHeIkYmD8RCjBAez
        kgjvieSQBCHelMTKqtSi/Pii0pzU4kOM0hwsSuK8jpEBCUIC6YklqdmpqQWpRTBZJg5OqQam
        meLu32LDkjK3Jr/MXFYxu3zXt8MMJYnRvraLWB6LGu7UTvr0fV2kakpkjU/whcs3TjnyClmZ
        3Pdiktf3k1P8sc/ZiPO42/KUtokt775Piw852f1A6fqWfXs8u1hvT70Uv+Aip9XsgpmHi3bL
        1evvWHD4ekz24TqZj3cj40WOLw/b8lXAUeXYvbxM/TmHzl3Kees4TWXbhS/3yg0Tl3yOqoku
        n1qyL3GBz9n7bollYoUOr56ZpidbWVuq3L3nXhv88R9bc8Ky3w4zNvEdOGzpp8tg94fh6evs
        1FtZ/nsMpu2P+3GN3eFQ20eJm5tCFnK1H1vdGevUcUD+fN3F22+aP69St0iTjEtzepB5ul9E
        iaU4I9FQi7moOBEAUK7dgPsCAAA=
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

Hi Andrew:

Thanks for mergeing v3 patch into mm, but there is still a modification suggested by
Matthew Wilcox needing to finish. I am not sure how does the right process works. I post patch v4
here, if anythong wrong, please point out.

Thanks!


When we do coredump for user process signal, this may be an SIGBUS signal
with BUS_MCEERR_AR or BUS_MCEERR_AO code, which means this signal is
resulted from ECC memory fail like SRAR or SRAO, we expect the memory
recovery work is finished correctly, then the get_dump_page() will not
return the error page as its process pte is set invalid by
memory_failure().

But memory_failure() may fail, and the process's related pte may not be
correctly set invalid, for current code, we will return the poison page,
get it dumped, and then lead to system panic as its in kernel code.

So check the poison status in get_dump_page(), and if TRUE, return NULL.

There maybe other scenario that is also better to check the posion status
and not to panic, so make a wrapper for this check, Thanks to David's
suggestion(<david@redhat.com>).

Link: https://lkml.kernel.org/r/20210319104437.6f30e80d@alex-virtual-machine
Signed-off-by: Aili Yao <yaoaili@kingsoft.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Aili Yao <yaoaili@kingsoft.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---
 mm/gup.c      |  4 ++++
 mm/internal.h | 20 ++++++++++++++++++++
 2 files changed, 24 insertions(+)

diff --git a/mm/gup.c b/mm/gup.c
index e4c224c..dcabe96 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -1536,6 +1536,10 @@ struct page *get_dump_page(unsigned long addr)
 				      FOLL_FORCE | FOLL_DUMP | FOLL_GET);
 	if (locked)
 		mmap_read_unlock(mm);
+
+	if (ret == 1 && is_page_poisoned(page))
+		return NULL;
+
 	return (ret == 1) ? page : NULL;
 }
 #endif /* CONFIG_ELF_CORE */
diff --git a/mm/internal.h b/mm/internal.h
index 25d2b2439..dcd2051 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -97,6 +97,26 @@ static inline void set_page_refcounted(struct page *page)
 	set_page_count(page, 1);
 }
 
+/*
+ * When kernel touch the user page, the user page may be have been marked
+ * poison but still mapped in user space, if without this page, the kernel
+ * can guarantee the data integrity and operation success, the kernel is
+ * better to check the posion status and avoid touching it, be good not to
+ * panic, coredump for process fatal signal is a sample case matching this
+ * scenario. Or if kernel can't guarantee the data integrity, it's better
+ * not to call this function, let kernel touch the poison page and get to
+ * panic.
+ */
+static inline bool is_page_poisoned(struct page *page)
+{
+	if (PageHWPoison(page))
+		return true;
+	else if (PageHuge(page) && PageHWPoison(compound_head(page)))
+		return true;
+
+	return false;
+}
+
 extern unsigned long highest_memmap_pfn;
 
 /*
-- 
1.8.3.1

