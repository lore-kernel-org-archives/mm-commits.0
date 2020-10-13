Return-Path: <SRS0=1pWp=DU=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD589C35271
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:53:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A7E9222200
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:53:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602633211;
	bh=lgJeS6kPhgU63PxpSYNuxu580addU/WukjVSAQUXr40=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=QDYxcTthLe0XtckjRFff6wRYBJx1BD4ZsTySYMOfE0LIqYJUja8Rk+PzfvDrt8Fpu
	 c5ey9nq2NUsPFfyIMxYb9L9EUDVRf0w6SQr/2joUu7piaF6DU2pwjB7WRKe2OWqC4M
	 v+3l4w6rNLaumcw7vVRDYWe72owKoMDbvamP85UA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729936AbgJMXtN (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 13 Oct 2020 19:49:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:60898 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389198AbgJMXtL (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 13 Oct 2020 19:49:11 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 81D562222C;
        Tue, 13 Oct 2020 23:49:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602632950;
        bh=lgJeS6kPhgU63PxpSYNuxu580addU/WukjVSAQUXr40=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=U3npOsP1j643hjPKGwqSYMgDGVGvYIg/VzbcSe4KYJoIp7q2ON1Vi1L1jD8HQ7u/7
         Bq56uj/QN/cHTWYfUINi/6H5V+XpzarbCdTM40bZygNrZT6PrVzeOz7BzPy6SZWbg5
         nzThedzqjJ6rBS5Fw5Mp4AmudPkpWDeBmqWkRXv8=
Date:   Tue, 13 Oct 2020 16:49:08 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     airlied@linux.ie, akpm@linux-foundation.org,
        ard.biesheuvel@linaro.org, ardb@kernel.org,
        benh@kernel.crashing.org, bhelgaas@google.com,
        boris.ostrovsky@oracle.com, bp@alien8.de, Brice.Goglin@inria.fr,
        bskeggs@redhat.com, catalin.marinas@arm.com,
        dan.j.williams@intel.com, daniel@ffwll.ch,
        dave.hansen@linux.intel.com, dave.jiang@intel.com,
        david@redhat.com, gregkh@linuxfoundation.org, hpa@zytor.com,
        hulkci@huawei.com, ira.weiny@intel.com, jgg@mellanox.com,
        jglisse@redhat.com, jgross@suse.com, jmoyer@redhat.com,
        joao.m.martins@oracle.com, Jonathan.Cameron@huawei.com,
        justin.he@arm.com, linux-mm@kvack.org, lkp@intel.com,
        luto@kernel.org, mingo@redhat.com, mm-commits@vger.kernel.org,
        mpe@ellerman.id.au, pasha.tatashin@soleen.com, paulus@ozlabs.org,
        peterz@infradead.org, rafael.j.wysocki@intel.com,
        rdunlap@infradead.org, richard.weiyang@linux.alibaba.com,
        rppt@linux.ibm.com, sstabellini@kernel.org, tglx@linutronix.de,
        thomas.lendacky@amd.com, torvalds@linux-foundation.org,
        vgoyal@redhat.com, vishal.l.verma@intel.com, will@kernel.org,
        yanaijie@huawei.com
Subject:  [patch 028/181] efi/fake_mem: arrange for a resource
 entry per efi_fake_mem instance
Message-ID: <20201013234908.XeGg1H7n8%akpm@linux-foundation.org>
In-Reply-To: <20201013164658.3bfd96cc224d8923e66a9f4e@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

=46rom: Dan Williams <dan.j.williams@intel.com>
Subject: efi/fake_mem: arrange for a resource entry per efi_fake_mem instan=
ce

In preparation for attaching a platform device per iomem resource teach
the efi_fake_mem code to create an e820 entry per instance.  Similar to
E820_TYPE_PRAM, bypass merging resource when the e820 map is sanitized.

Link: https://lkml.kernel.org/r/159643096068.4062302.11590041070221681669.s=
tgit@dwillia2-desk3.amr.corp.intel.com
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Acked-by: Ard Biesheuvel <ardb@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Ben Skeggs <bskeggs@redhat.com>
Cc: Brice Goglin <Brice.Goglin@inria.fr>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Daniel Vetter <daniel@ffwll.ch>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: David Airlie <airlied@linux.ie>
Cc: David Hildenbrand <david@redhat.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Ira Weiny <ira.weiny@intel.com>
Cc: Jason Gunthorpe <jgg@mellanox.com>
Cc: Jeff Moyer <jmoyer@redhat.com>
Cc: Jia He <justin.he@arm.com>
Cc: Joao Martins <joao.m.martins@oracle.com>
Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Mike Rapoport <rppt@linux.ibm.com>
Cc: Paul Mackerras <paulus@ozlabs.org>
Cc: Pavel Tatashin <pasha.tatashin@soleen.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>
Cc: Wei Yang <richard.weiyang@linux.alibaba.com>
Cc: Will Deacon <will@kernel.org>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Cc: Hulk Robot <hulkci@huawei.com>
Cc: Jason Yan <yanaijie@huawei.com>
Cc: "J=C3=A9r=C3=B4me Glisse" <jglisse@redhat.com>
Cc: Juergen Gross <jgross@suse.com>
Cc: kernel test robot <lkp@intel.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Stefano Stabellini <sstabellini@kernel.org>
Cc: Vivek Goyal <vgoyal@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/e820.c              |   16 +++++++++++++++-
 drivers/firmware/efi/x86_fake_mem.c |   12 +++++++++---
 2 files changed, 24 insertions(+), 4 deletions(-)

--- a/arch/x86/kernel/e820.c~efi-fake_mem-arrange-for-a-resource-entry-per-=
efi_fake_mem-instance
+++ a/arch/x86/kernel/e820.c
@@ -305,6 +305,20 @@ static int __init cpcompare(const void *
 	return (ap->addr !=3D ap->entry->addr) - (bp->addr !=3D bp->entry->addr);
 }
=20
+static bool e820_nomerge(enum e820_type type)
+{
+	/*
+	 * These types may indicate distinct platform ranges aligned to
+	 * numa node, protection domain, performance domain, or other
+	 * boundaries. Do not merge them.
+	 */
+	if (type =3D=3D E820_TYPE_PRAM)
+		return true;
+	if (type =3D=3D E820_TYPE_SOFT_RESERVED)
+		return true;
+	return false;
+}
+
 int __init e820__update_table(struct e820_table *table)
 {
 	struct e820_entry *entries =3D table->entries;
@@ -380,7 +394,7 @@ int __init e820__update_table(struct e82
 		}
=20
 		/* Continue building up new map based on this information: */
-		if (current_type !=3D last_type || current_type =3D=3D E820_TYPE_PRAM) {
+		if (current_type !=3D last_type || e820_nomerge(current_type)) {
 			if (last_type !=3D 0)	 {
 				new_entries[new_nr_entries].size =3D change_point[chg_idx]->addr - las=
t_addr;
 				/* Move forward only if the new size was non-zero: */
--- a/drivers/firmware/efi/x86_fake_mem.c~efi-fake_mem-arrange-for-a-resour=
ce-entry-per-efi_fake_mem-instance
+++ a/drivers/firmware/efi/x86_fake_mem.c
@@ -38,7 +38,7 @@ void __init efi_fake_memmap_early(void)
 		m_start =3D mem->range.start;
 		m_end =3D mem->range.end;
 		for_each_efi_memory_desc(md) {
-			u64 start, end;
+			u64 start, end, size;
=20
 			if (md->type !=3D EFI_CONVENTIONAL_MEMORY)
 				continue;
@@ -58,11 +58,17 @@ void __init efi_fake_memmap_early(void)
 			 */
 			start =3D max(start, m_start);
 			end =3D min(end, m_end);
+			size =3D end - start + 1;
=20
 			if (end <=3D start)
 				continue;
-			e820__range_update(start, end - start + 1, E820_TYPE_RAM,
-					E820_TYPE_SOFT_RESERVED);
+
+			/*
+			 * Ensure each efi_fake_mem instance results in
+			 * a unique e820 resource
+			 */
+			e820__range_remove(start, size, E820_TYPE_RAM, 1);
+			e820__range_add(start, size, E820_TYPE_SOFT_RESERVED);
 			e820__update_table(e820_table);
 		}
 	}
_
