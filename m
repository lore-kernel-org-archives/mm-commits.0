Return-Path: <SRS0=1pWp=DU=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B988C433DF
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:02:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C40CF21D7B
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:02:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602630126;
	bh=HN3OklejoVZTpnZAOZC3IT49A8Glg8qedtDWqbK650M=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=A4x12+DNNkNMMk3dUDO6bA/ffFTIBqdPHmybyYFZToAegRCg/RTf1shMfqqk5jcfE
	 vBjIbbn7h7LMtDjML/xwFmAIHLA2WrDI7CncEKsTDCW6ieH8qIkCCYMcq2oiIkfqOd
	 f3YZ+XZyBdTF9CUUdCAZWNOCSAdmKmbRLzt+9rxE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729625AbgJMXCG (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 13 Oct 2020 19:02:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:41544 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726894AbgJMXCG (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 13 Oct 2020 19:02:06 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 79A2120B1F;
        Tue, 13 Oct 2020 23:02:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602630125;
        bh=HN3OklejoVZTpnZAOZC3IT49A8Glg8qedtDWqbK650M=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=rB0qs4X6cUynaga/OgbXWG5EQoTjspO4O0UtzLJ0dhVOYlaFO9v52ub11embSNwE+
         oy0BjTHmCWvpr3n90e3rbscSho5m6IOu5r4m/o4TYr4EqjJdndiuaLx1BtrcZeEl+V
         9dJGGgGxX7h/cq4Vd2xe1jxEBIg4EauuHD9kmXGA=
Date:   Tue, 13 Oct 2020 16:02:01 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     airlied@linux.ie, ard.biesheuvel@linaro.org, ardb@kernel.org,
        benh@kernel.crashing.org, bhelgaas@google.com,
        boris.ostrovsky@oracle.com, bp@alien8.de, Brice.Goglin@inria.fr,
        bskeggs@redhat.com, catalin.marinas@arm.com,
        dan.j.williams@intel.com, daniel@ffwll.ch,
        dave.hansen@linux.intel.com, dave.jiang@intel.com,
        david@redhat.com, gregkh@linuxfoundation.org, hpa@zytor.com,
        hulkci@huawei.com, ira.weiny@intel.com, jgg@mellanox.com,
        jglisse@redhat.com, jgross@suse.com, jmoyer@redhat.com,
        joao.m.martins@oracle.com, Jonathan.Cameron@huawei.com,
        justin.he@arm.com, lkp@intel.com, luto@kernel.org,
        mingo@redhat.com, mm-commits@vger.kernel.org, mpe@ellerman.id.au,
        pasha.tatashin@soleen.com, paulus@ozlabs.org, peterz@infradead.org,
        rafael.j.wysocki@intel.com, rdunlap@infradead.org,
        richard.weiyang@linux.alibaba.com, rppt@linux.ibm.com,
        sstabellini@kernel.org, tglx@linutronix.de,
        thomas.lendacky@amd.com, vgoyal@redhat.com,
        vishal.l.verma@intel.com, will@kernel.org, yanaijie@huawei.com
Subject:  [folded-merged] x86-numa-add-nohmat-option-fix.patch
 removed from -mm tree
Message-ID: <20201013230201.Pt17f5X2s%akpm@linux-foundation.org>
In-Reply-To: <20201010231559.e148a66f744d0b4870301450@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: x86/numa: fix build when CONFIG_ACPI is not set
has been removed from the -mm tree.  Its filename was
     x86-numa-add-nohmat-option-fix.patch

This patch was dropped because it was folded into x86-numa-add-nohmat-optio=
n.patch

------------------------------------------------------
=46rom: Randy Dunlap <rdunlap@infradead.org>
Subject: x86/numa: fix build when CONFIG_ACPI is not set

Fix build errors when CONFIG_ACPI is not set/enabled by adding
<acpi/acpi_numa.h> in the #else (!CONFIG_ACPI) block.

../arch/x86/mm/numa.c: In function `numa_setup':
../arch/x86/mm/numa.c:43:3: error: implicit declaration of function `disabl=
e_srat'; did you mean `disable_irq'? [-Werror=3Dimplicit-function-declarati=
on]
   disable_srat();
   ^~~~~~~~~~~~
../arch/x86/mm/numa.c:45:3: error: implicit declaration of function `disabl=
e_hmat'; did you mean `disable_dma'? [-Werror=3Dimplicit-function-declarati=
on]
   disable_hmat();
   ^~~~~~~~~~~~

Link: https://lkml.kernel.org/r/70e5ee34-9809-a997-7b49-499e4be61307@infrad=
ead.org
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Ben Skeggs <bskeggs@redhat.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Cc: Brice Goglin <Brice.Goglin@inria.fr>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Daniel Vetter <daniel@ffwll.ch>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: David Airlie <airlied@linux.ie>
Cc: David Hildenbrand <david@redhat.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Hulk Robot <hulkci@huawei.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Ira Weiny <ira.weiny@intel.com>
Cc: Jason Gunthorpe <jgg@mellanox.com>
Cc: Jason Yan <yanaijie@huawei.com>
Cc: Jeff Moyer <jmoyer@redhat.com>
Cc: "J=C3=A9r=C3=B4me Glisse" <jglisse@redhat.com>
Cc: Jia He <justin.he@arm.com>
Cc: Joao Martins <joao.m.martins@oracle.com>
Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: Juergen Gross <jgross@suse.com>
Cc: kernel test robot <lkp@intel.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Mike Rapoport <rppt@linux.ibm.com>
Cc: Paul Mackerras <paulus@ozlabs.org>
Cc: Pavel Tatashin <pasha.tatashin@soleen.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Cc: Stefano Stabellini <sstabellini@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: Wei Yang <richard.weiyang@linux.alibaba.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/acpi.h |    2 ++
 1 file changed, 2 insertions(+)

--- a/include/linux/acpi.h~x86-numa-add-nohmat-option-fix
+++ a/include/linux/acpi.h
@@ -709,6 +709,8 @@ static inline u64 acpi_arch_get_root_poi
 #define ACPI_HANDLE_FWNODE(fwnode)	(NULL)
 #define ACPI_DEVICE_CLASS(_cls, _msk)	.cls =3D (0), .cls_msk =3D (0),
=20
+#include <acpi/acpi_numa.h>
+
 struct fwnode_handle;
=20
 static inline bool acpi_dev_found(const char *hid)
_

Patches currently in -mm which might be from rdunlap@infradead.org are

fs-ocfs2-delete-repeated-words-in-comments.patch
fs-xattrc-fix-kernel-doc-warnings-for-setxattr-removexattr.patch
x86-numa-add-nohmat-option.patch
mm-memoryc-fix-spello-of-function.patch
fs-configfs-delete-repeated-words-in-comments.patch
kernel-fix-repeated-words-in-comments.patch
kernel-acctc-fix-some-kernel-doc-nits.patch
lib-bitmap-delete-duplicated-words.patch
lib-libcrc32c-delete-duplicated-words.patch
lib-decompress_bunzip2-delete-duplicated-words.patch
lib-devres-delete-duplicated-words.patch
lib-dynamic_queue_limits-delete-duplicated-words-fix-typo.patch
lib-earlycpio-delete-duplicated-words.patch
lib-radix-tree-delete-duplicated-words.patch
lib-syscall-delete-duplicated-words.patch
lib-test_sysctl-delete-duplicated-words.patch
lib-mpi-fix-spello-of-functions.patch

