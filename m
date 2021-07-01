Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5323BC11F66
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 01:52:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3E19A61477
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 01:52:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238490AbhGABzH (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Jun 2021 21:55:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:44658 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238416AbhGABzH (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 30 Jun 2021 21:55:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9185F6146D;
        Thu,  1 Jul 2021 01:52:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625104357;
        bh=RTUhqYV1WD2G2rFObE1mtcRv7J3g9N/bdf5NQpakank=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=AvqPlZEFbb0BVSsEiI2WGe4/gAv+3ayBXklaBG1ODTmDvPZ1wvNrfmxtVw6ejVqZM
         4yNTvWphuAZtJldd1TrSxgzU3OzmC9SZncvNXk5sidYne7+8PzAIrbgMIrLGf78I3p
         4D/O1b/Hxe4RhBWjuah1g/zE9yaWgbuA9fo/qClY=
Date:   Wed, 30 Jun 2021 18:52:36 -0700
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
        peterx@redhat.com, riel@surriel.com, rth@twiddle.net,
        shuah@kernel.org, torvalds@linux-foundation.org,
        tsbogend@alpha.franken.de, vbabka@suse.cz, willy@infradead.org
Subject:  [patch 101/192] selftests/vm: add protection_keys_32 /
 protection_keys_64 to gitignore
Message-ID: <20210701015236.2NNlPctlq%akpm@linux-foundation.org>
In-Reply-To: <20210630184624.9ca1937310b0dd5ce66b30e7@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: David Hildenbrand <david@redhat.com>
Subject: selftests/vm: add protection_keys_32 / protection_keys_64 to gitignore

We missed adding two binaries to gitignore.

Link: https://lkml.kernel.org/r/20210419135443.12822-5-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Peter Xu <peterx@redhat.com>
Cc: Ram Pai <linuxram@us.ibm.com>
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
Cc: Richard Henderson <rth@twiddle.net>
Cc: Rik van Riel <riel@surriel.com>
Cc: Rolf Eike Beer <eike-kernel@sf-tec.de>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/.gitignore |    2 ++
 1 file changed, 2 insertions(+)

--- a/tools/testing/selftests/vm/.gitignore~selftests-vm-add-protection_keys_32-protection_keys_64-to-gitignore
+++ a/tools/testing/selftests/vm/.gitignore
@@ -12,6 +12,8 @@ mremap_test
 on-fault-limit
 transhuge-stress
 protection_keys
+protection_keys_32
+protection_keys_64
 userfaultfd
 mlock-intersect-test
 mlock-random-test
_
