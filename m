Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF206C11F6C
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 01:50:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D6CEC6147E
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 01:50:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238434AbhGABwi (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Jun 2021 21:52:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:42100 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238384AbhGABwi (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 30 Jun 2021 21:52:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7DB7F6135C;
        Thu,  1 Jul 2021 01:50:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625104208;
        bh=X0y+MmNBinFDW/Wm+TmdoRMm+GG9SaimXMSOqHWddiA=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=sBgZBLqBT9CLTHNqZyZn0ZgnoWqT19cSOB0+Ii7cOx+x+AMsMFZDCztUVokscM+cu
         N43ujBBqYFhBY6e9RJxOdIBzsK/jHfchuMd0viP41RTf2ExUufxa0h8B4rQQMHtFFg
         Qu/o+uqrOckvnrZrQ46txg7wFT2kfvPChJwCG8IA=
Date:   Wed, 30 Jun 2021 18:50:07 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     adobriyan@gmail.com, akpm@linux-foundation.org,
        alex.shi@linux.alibaba.com, david@redhat.com, guro@fb.com,
        haiyangz@microsoft.com, jasowang@redhat.com, jbohac@suse.cz,
        kys@microsoft.com, linux-mm@kvack.org, mhocko@suse.com,
        mike.kravetz@oracle.com, mm-commits@vger.kernel.org,
        mst@redhat.com, naoya.horiguchi@nec.com, osalvador@suse.de,
        rppt@linux.ibm.com, steven.price@arm.com, sthemmin@microsoft.com,
        torvalds@linux-foundation.org, wei.liu@kernel.org,
        willy@infradead.org, yaoaili@kingsoft.com
Subject:  [patch 055/192] fs/proc/kcore: pfn_is_ram check only
 applies to KCORE_RAM
Message-ID: <20210701015007.IRGAO9pLj%akpm@linux-foundation.org>
In-Reply-To: <20210630184624.9ca1937310b0dd5ce66b30e7@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: David Hildenbrand <david@redhat.com>
Subject: fs/proc/kcore: pfn_is_ram check only applies to KCORE_RAM

Let's resturcture the code, using switch-case, and checking pfn_is_ram()
only when we are dealing with KCORE_RAM.

Link: https://lkml.kernel.org/r/20210526093041.8800-3-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Mike Rapoport <rppt@linux.ibm.com>
Cc: Aili Yao <yaoaili@kingsoft.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Alex Shi <alex.shi@linux.alibaba.com>
Cc: Haiyang Zhang <haiyangz@microsoft.com>
Cc: Jason Wang <jasowang@redhat.com>
Cc: Jiri Bohac <jbohac@suse.cz>
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Roman Gushchin <guro@fb.com>
Cc: Stephen Hemminger <sthemmin@microsoft.com>
Cc: Steven Price <steven.price@arm.com>
Cc: Wei Liu <wei.liu@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/kcore.c |   35 +++++++++++++++++++++++++++--------
 1 file changed, 27 insertions(+), 8 deletions(-)

--- a/fs/proc/kcore.c~fs-proc-kcore-pfn_is_ram-check-only-applies-to-kcore_ram
+++ a/fs/proc/kcore.c
@@ -483,25 +483,36 @@ read_kcore(struct file *file, char __use
 				goto out;
 			}
 			m = NULL;	/* skip the list anchor */
-		} else if (!pfn_is_ram(__pa(start) >> PAGE_SHIFT)) {
-			if (clear_user(buffer, tsz)) {
-				ret = -EFAULT;
-				goto out;
-			}
-		} else if (m->type == KCORE_VMALLOC) {
+			goto skip;
+		}
+
+		switch (m->type) {
+		case KCORE_VMALLOC:
 			vread(buf, (char *)start, tsz);
 			/* we have to zero-fill user buffer even if no read */
 			if (copy_to_user(buffer, buf, tsz)) {
 				ret = -EFAULT;
 				goto out;
 			}
-		} else if (m->type == KCORE_USER) {
+			break;
+		case KCORE_USER:
 			/* User page is handled prior to normal kernel page: */
 			if (copy_to_user(buffer, (char *)start, tsz)) {
 				ret = -EFAULT;
 				goto out;
 			}
-		} else {
+			break;
+		case KCORE_RAM:
+			if (!pfn_is_ram(__pa(start) >> PAGE_SHIFT)) {
+				if (clear_user(buffer, tsz)) {
+					ret = -EFAULT;
+					goto out;
+				}
+				break;
+			}
+			fallthrough;
+		case KCORE_VMEMMAP:
+		case KCORE_TEXT:
 			if (kern_addr_valid(start)) {
 				/*
 				 * Using bounce buffer to bypass the
@@ -525,7 +536,15 @@ read_kcore(struct file *file, char __use
 					goto out;
 				}
 			}
+			break;
+		default:
+			pr_warn_once("Unhandled KCORE type: %d\n", m->type);
+			if (clear_user(buffer, tsz)) {
+				ret = -EFAULT;
+				goto out;
+			}
 		}
+skip:
 		buflen -= tsz;
 		*fpos += tsz;
 		buffer += tsz;
_
