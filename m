Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A498C433F5
	for <mm-commits@archiver.kernel.org>; Wed,  8 Sep 2021 02:55:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6A0766113C
	for <mm-commits@archiver.kernel.org>; Wed,  8 Sep 2021 02:55:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347049AbhIHC4o (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 7 Sep 2021 22:56:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:52810 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347390AbhIHC40 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 7 Sep 2021 22:56:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 97DEF61108;
        Wed,  8 Sep 2021 02:55:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1631069716;
        bh=WNGz+EtiL+kJAEIjuXINr2mmwKzBUsIDsSS3NALhNOs=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=P5tft03lAR6oJCk16f0RrZq16lmtV8WFp6Xgt9V+nYvOeCKZ0G98lGmxUY6ISiyP1
         VbFva+BAozP/g/V2lnGEGCBWKfnHoHHuw4zV2BJB8HMehEeOKXUiS0QiDUc2LAmAH6
         yqoc3/s02ZJxhIqqyzIeyXVG7KYI16nFd0YhRcbQ=
Date:   Tue, 07 Sep 2021 19:55:14 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, aneesh.kumar@linux.ibm.com,
        anshuman.khandual@arm.com, anton@ozlabs.org, ardb@kernel.org,
        bauerman@linux.ibm.com, benh@kernel.crashing.org, bhe@redhat.com,
        borntraeger@de.ibm.com, bp@alien8.de, catalin.marinas@arm.com,
        cheloha@linux.ibm.com, christophe.leroy@c-s.fr, dalias@libc.org,
        dan.j.williams@intel.com, dave.hansen@linux.intel.com,
        dave.jiang@intel.com, david@redhat.com, gor@linux.ibm.com,
        hca@linux.ibm.com, hpa@zytor.com, jasowang@redhat.com,
        joe@perches.com, justin.he@arm.com, ldufour@linux.ibm.com,
        lenb@kernel.org, linux-mm@kvack.org, luto@kernel.org,
        mhocko@kernel.org, michel@lespinasse.org, mingo@redhat.com,
        mm-commits@vger.kernel.org, mpe@ellerman.id.au, mst@redhat.com,
        nathanl@linux.ibm.com, npiggin@gmail.com, osalvador@suse.de,
        pankaj.gupta.linux@gmail.com, pankaj.gupta@ionos.com,
        pasha.tatashin@soleen.com, paulus@samba.org, peterz@infradead.org,
        pmorel@linux.ibm.com, rafael.j.wysocki@intel.com,
        richard.weiyang@linux.alibaba.com, rjw@rjwysocki.net,
        rppt@kernel.org, slyfox@gentoo.org, tglx@linutronix.de,
        torvalds@linux-foundation.org, vbabka@suse.cz,
        vishal.l.verma@intel.com, vkuznets@redhat.com,
        wangkefeng.wang@huawei.com, will@kernel.org,
        ysato@users.sourceforge.jp
Subject:  [patch 041/147] ACPI: memhotplug: memory resources cannot
 be enabled yet
Message-ID: <20210908025514.zEZRUptEJ%akpm@linux-foundation.org>
In-Reply-To: <20210907195226.14b1d22a07c085b22968b933@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: David Hildenbrand <david@redhat.com>
Subject: ACPI: memhotplug: memory resources cannot be enabled yet

We allocate + initialize everything from scratch.  In case enabling the
device fails, we free all memory resourcs.

Link: https://lkml.kernel.org/r/20210712124052.26491-5-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Reviewed-by: Pankaj Gupta <pankaj.gupta@ionos.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Anton Blanchard <anton@ozlabs.org>
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: Baoquan He <bhe@redhat.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Christophe Leroy <christophe.leroy@c-s.fr>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jason Wang <jasowang@redhat.com>
Cc: Jia He <justin.he@arm.com>
Cc: Joe Perches <joe@perches.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Laurent Dufour <ldufour@linux.ibm.com>
Cc: Len Brown <lenb@kernel.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Michel Lespinasse <michel@lespinasse.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Nathan Lynch <nathanl@linux.ibm.com>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Pankaj Gupta <pankaj.gupta.linux@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Pavel Tatashin <pasha.tatashin@soleen.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Pierre Morel <pmorel@linux.ibm.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Rich Felker <dalias@libc.org>
Cc: Scott Cheloha <cheloha@linux.ibm.com>
Cc: Sergei Trofimovich <slyfox@gentoo.org>
Cc: Thiago Jung Bauermann <bauerman@linux.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>
Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Wei Yang <richard.weiyang@linux.alibaba.com>
Cc: Will Deacon <will@kernel.org>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/acpi_memhotplug.c |    4 ----
 1 file changed, 4 deletions(-)

--- a/drivers/acpi/acpi_memhotplug.c~acpi-memhotplug-memory-resources-cannot-be-enabled-yet
+++ a/drivers/acpi/acpi_memhotplug.c
@@ -182,10 +182,6 @@ static int acpi_memory_enable_device(str
 	 * (i.e. memory-hot-remove function)
 	 */
 	list_for_each_entry(info, &mem_device->res_list, list) {
-		if (info->enabled) { /* just sanity check...*/
-			num_enabled++;
-			continue;
-		}
 		/*
 		 * If the memory block size is zero, please ignore it.
 		 * Don't try to do the following memory hotplug flowchart.
_
