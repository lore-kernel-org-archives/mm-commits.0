Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	URIBL_RED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ACF76C11F66
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 01:50:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9A9126146D
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 01:50:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238440AbhGABwi (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Jun 2021 21:52:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:42012 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238436AbhGABwe (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 30 Jun 2021 21:52:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D626C61468;
        Thu,  1 Jul 2021 01:50:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625104204;
        bh=l0/S+LLQunTS3Zar5n1r2cgGpT8Ax0M5iwOAkUwL3XY=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=sqv76ERwmL46uFLB/6ugHWrV0ac+cG6uzVl5V5N66qFQG0yVXftKIkEmZhiuYWv6v
         bdDyuxQdBuNpZMLH9tuNO1ob3agu2TmtleNhGtwKhuzU4CxojtrAYs64fx4+Nxhd32
         YD2CmtZ5iRCjJfE4Y/JQ8adLXefAcXPSU06GJt3E=
Date:   Wed, 30 Jun 2021 18:50:03 -0700
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
Subject:  [patch 054/192] fs/proc/kcore: drop KCORE_REMAP and
 KCORE_OTHER
Message-ID: <20210701015003.2E6L6dEh3%akpm@linux-foundation.org>
In-Reply-To: <20210630184624.9ca1937310b0dd5ce66b30e7@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: David Hildenbrand <david@redhat.com>
Subject: fs/proc/kcore: drop KCORE_REMAP and KCORE_OTHER

Patch series "fs/proc/kcore: don't read offline sections, logically offline pages and hwpoisoned pages", v3.

Looking for places where the kernel might unconditionally read
PageOffline() pages, I stumbled over /proc/kcore; turns out /proc/kcore
needs some more love to not touch some other pages we really don't want to
read -- i.e., hwpoisoned ones.

Examples for PageOffline() pages are pages inflated in a balloon, memory
unplugged via virtio-mem, and partially-present sections in memory added
by the Hyper-V balloon.

When reading pages inflated in a balloon, we essentially produce
unnecessary load in the hypervisor; holes in partially present sections in
case of Hyper-V are not accessible and already were a problem for
/proc/vmcore, fixed in makedumpfile by detecting PageOffline() pages.  In
the future, virtio-mem might disallow reading unplugged memory -- marked
as PageOffline() -- in some environments, resulting in undefined behavior
when accessed; therefore, I'm trying to identify and rework all these
(corner) cases.

With this series, there is really only access via /dev/mem, /proc/vmcore
and kdb left after I ripped out /dev/kmem.  kdb is an advanced corner-case
use case -- we won't care for now if someone explicitly tries to do nasty
things by reading from/writing to physical addresses we better not touch. 
/dev/mem is a use case we won't support for virtio-mem, at least for now,
so we'll simply disallow mapping any virtio-mem memory via /dev/mem next. 
/proc/vmcore is really only a problem when dumping the old kernel via
something that's not makedumpfile (read: basically never), however, we'll
try sanitizing that as well in the second kernel in the future.

Tested via kcore_dump:
	https://github.com/schlafwandler/kcore_dump
	


This patch (of 6):

Commit db779ef67ffe ("proc/kcore: Remove unused kclist_add_remap()")
removed the last user of KCORE_REMAP.

Commit 595dd46ebfc1 ("vfs/proc/kcore, x86/mm/kcore: Fix SMAP fault when
dumping vsyscall user page") removed the last user of KCORE_OTHER.

Let's drop both types.  While at it, also drop vaddr in "struct
kcore_list", used by KCORE_REMAP only.

Link: https://lkml.kernel.org/r/20210526093041.8800-1-david@redhat.com
Link: https://lkml.kernel.org/r/20210526093041.8800-2-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Mike Rapoport <rppt@linux.ibm.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Jason Wang <jasowang@redhat.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Roman Gushchin <guro@fb.com>
Cc: Alex Shi <alex.shi@linux.alibaba.com>
Cc: Steven Price <steven.price@arm.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Aili Yao <yaoaili@kingsoft.com>
Cc: Jiri Bohac <jbohac@suse.cz>
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: Haiyang Zhang <haiyangz@microsoft.com>
Cc: Stephen Hemminger <sthemmin@microsoft.com>
Cc: Wei Liu <wei.liu@kernel.org>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/kcore.c       |    7 ++-----
 include/linux/kcore.h |    3 ---
 2 files changed, 2 insertions(+), 8 deletions(-)

--- a/fs/proc/kcore.c~fs-proc-kcore-drop-kcore_remap-and-kcore_other
+++ a/fs/proc/kcore.c
@@ -380,11 +380,8 @@ read_kcore(struct file *file, char __use
 			phdr->p_type = PT_LOAD;
 			phdr->p_flags = PF_R | PF_W | PF_X;
 			phdr->p_offset = kc_vaddr_to_offset(m->addr) + data_offset;
-			if (m->type == KCORE_REMAP)
-				phdr->p_vaddr = (size_t)m->vaddr;
-			else
-				phdr->p_vaddr = (size_t)m->addr;
-			if (m->type == KCORE_RAM || m->type == KCORE_REMAP)
+			phdr->p_vaddr = (size_t)m->addr;
+			if (m->type == KCORE_RAM)
 				phdr->p_paddr = __pa(m->addr);
 			else if (m->type == KCORE_TEXT)
 				phdr->p_paddr = __pa_symbol(m->addr);
--- a/include/linux/kcore.h~fs-proc-kcore-drop-kcore_remap-and-kcore_other
+++ a/include/linux/kcore.h
@@ -11,14 +11,11 @@ enum kcore_type {
 	KCORE_RAM,
 	KCORE_VMEMMAP,
 	KCORE_USER,
-	KCORE_OTHER,
-	KCORE_REMAP,
 };
 
 struct kcore_list {
 	struct list_head list;
 	unsigned long addr;
-	unsigned long vaddr;
 	size_t size;
 	int type;
 };
_
