Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9812C11F66
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 01:52:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 936FC61476
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 01:52:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238489AbhGABzE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Jun 2021 21:55:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:44572 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238416AbhGABzE (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 30 Jun 2021 21:55:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A087661469;
        Thu,  1 Jul 2021 01:52:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625104353;
        bh=ZNxVERlcr2LCNKpnWm4DVoTM9z6dFw/JmTX8WyB3LAI=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=RqO58282e0VwBmCbqjery53x40u3qCsh5EJFio7SQp0g6rkTxE013HSuRkrtaof+B
         CEgMdKFBvZDnCHsIfAXeJ8YEqpAeIz7UyRFiZt+buU/fu5aiI7PxzdwKVh533COk9L
         fpwN7Qpf8lnwH3O6BqqVpVGLom5OdoAAESlDcmTM=
Date:   Wed, 30 Jun 2021 18:52:32 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     aarcange@redhat.com, akpm@linux-foundation.org, arnd@arndb.de,
        chris@zankel.net, dave.hansen@intel.com, david@redhat.com,
        deller@gmx.de, eike-kernel@sf-tec.de, hughd@google.com,
        ink@jurassic.park.msu.ru, James.Bottomley@HansenPartnership.com,
        jannh@google.com, jcmvbkbc@gmail.com, jgg@ziepe.ca,
        kirill.shutemov@linux.intel.com, linux-mm@kvack.org,
        linuxram@us.ibm.com, mattst88@gmail.com, mhocko@suse.com,
        mike.kravetz@oracle.com, minchan@kernel.org,
        mm-commits@vger.kernel.org, mst@redhat.com, osalvador@suse.de,
        peterx@redhat.com, riel@surriel.com, rppt@linux.ibm.com,
        rth@twiddle.net, shuah@kernel.org, torvalds@linux-foundation.org,
        tsbogend@alpha.franken.de, vbabka@suse.cz, willy@infradead.org
Subject:  [patch 100/192] MAINTAINERS: add
 tools/testing/selftests/vm/ to MEMORY MANAGEMENT
Message-ID: <20210701015232.9MuCJeYCJ%akpm@linux-foundation.org>
In-Reply-To: <20210630184624.9ca1937310b0dd5ce66b30e7@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: David Hildenbrand <david@redhat.com>
Subject: MAINTAINERS: add tools/testing/selftests/vm/ to MEMORY MANAGEMENT

MEMORY MANAGEMENT seems to be a good fit.

Link: https://lkml.kernel.org/r/20210419135443.12822-4-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Acked-by: Mike Rapoport <rppt@linux.ibm.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Peter Xu <peterx@redhat.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Chris Zankel <chris@zankel.net>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Helge Deller <deller@gmx.de>
Cc: Hugh Dickins <hughd@google.com>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: Jann Horn <jannh@google.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Matt Turner <mattst88@gmail.com>
Cc: Max Filippov <jcmvbkbc@gmail.com>
Cc: Michael S. Tsirkin <mst@redhat.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Ram Pai <linuxram@us.ibm.com>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Rik van Riel <riel@surriel.com>
Cc: Rolf Eike Beer <eike-kernel@sf-tec.de>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    1 +
 1 file changed, 1 insertion(+)

--- a/MAINTAINERS~maintainers-add-tools-testing-selftests-vm-to-memory-management
+++ a/MAINTAINERS
@@ -11828,6 +11828,7 @@ F:	include/linux/mmzone.h
 F:	include/linux/pagewalk.h
 F:	include/linux/vmalloc.h
 F:	mm/
+F:	tools/testing/selftests/vm/
 
 MEMORY TECHNOLOGY DEVICES (MTD)
 M:	Miquel Raynal <miquel.raynal@bootlin.com>
_
