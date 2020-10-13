Return-Path: <SRS0=1pWp=DU=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1714DC4363A
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:50:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DB3F222228
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:50:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602633026;
	bh=afnh+svjHaI4xJrEHEekjDaK/jrPFtkfWOgQ5yjGNaM=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=165yQoyMgWrcStZ+AIz2vY3ph7SqW/vhgJbwGXHGt/JSrIQrX1RXql2T0f23TdQ6E
	 ZKmbVAGKBP5fk/Wx6z3hDINuzIdf34ew/UzdK4toJWR/416//aw4ygVjhqn/qfuXur
	 SPif11k1MHkToB12d8QTPLcEWiBgq5Goj+N6rb5A=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389326AbgJMXuZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 13 Oct 2020 19:50:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:33164 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730075AbgJMXtU (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 13 Oct 2020 19:49:20 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C84B722227;
        Tue, 13 Oct 2020 23:49:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602632960;
        bh=afnh+svjHaI4xJrEHEekjDaK/jrPFtkfWOgQ5yjGNaM=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=Ub+9ru4dNjCBsq/Ki3L4dBLh1BB/JkVdzYdpGNDcmdlHMJ+Qb7X40eqP17OtwOvKf
         +X3GcXsCrpWPKGScuD2zIRLiL61DMmiQWQ6kuOaZkbQ3MGTNX6FGzSHji/Zt8MTFE1
         FwPsB6TodPOv4XR084dC1vj0fJ/6FP+YJMgHq+To=
Date:   Tue, 13 Oct 2020 16:49:18 -0700
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
Subject:  [patch 030/181] resource: report parent to
 walk_iomem_res_desc() callback
Message-ID: <20201013234918.e6szkz-gk%akpm@linux-foundation.org>
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
Subject: resource: report parent to walk_iomem_res_desc() callback

In support of detecting whether a resource might have been been claimed,
report the parent to the walk_iomem_res_desc() callback.  For example, the
ACPI HMAT parser publishes "hmem" platform devices per target range.=20
However, if the HMAT is disabled / missing a fallback driver can attach
devices to the raw memory ranges as a fallback if it sees unclaimed /
orphan "Soft Reserved" resources in the resource tree.

Otherwise, find_next_iomem_res() returns a resource with garbage data from
the stack allocation in __walk_iomem_res_desc() for the res->parent field.

There are currently no users that expect ->child and ->sibling to be
valid, and the resource_lock would be needed to traverse them.  Use a
compound literal to implicitly zero initialize the fields that are not
being returned in addition to setting ->parent.

Link: https://lkml.kernel.org/r/159643097166.4062302.11875688887228572793.s=
tgit@dwillia2-desk3.amr.corp.intel.com
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Cc: Jason Gunthorpe <jgg@mellanox.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Wei Yang <richard.weiyang@linux.alibaba.com>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Ben Skeggs <bskeggs@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Brice Goglin <Brice.Goglin@inria.fr>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Daniel Vetter <daniel@ffwll.ch>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: David Airlie <airlied@linux.ie>
Cc: David Hildenbrand <david@redhat.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Ira Weiny <ira.weiny@intel.com>
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
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vishal Verma <vishal.l.verma@intel.com>
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

 kernel/resource.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

--- a/kernel/resource.c~resource-report-parent-to-walk_iomem_res_desc-callb=
ack
+++ a/kernel/resource.c
@@ -382,10 +382,13 @@ static int find_next_iomem_res(resource_
=20
 	if (p) {
 		/* copy data */
-		res->start =3D max(start, p->start);
-		res->end =3D min(end, p->end);
-		res->flags =3D p->flags;
-		res->desc =3D p->desc;
+		*res =3D (struct resource) {
+			.start =3D max(start, p->start),
+			.end =3D min(end, p->end),
+			.flags =3D p->flags,
+			.desc =3D p->desc,
+			.parent =3D p->parent,
+		};
 	}
=20
 	read_unlock(&resource_lock);
_
