Return-Path: <SRS0=lrFz=DV=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC525C433E7
	for <mm-commits@archiver.kernel.org>; Wed, 14 Oct 2020 20:58:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9D67422258
	for <mm-commits@archiver.kernel.org>; Wed, 14 Oct 2020 20:58:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602709083;
	bh=7cEqAqtQbGjG8MaL9rqs9JY8s/5Ay5kJgWg6Rw13RpA=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=js1cTBHo1yK8EsacJmdjOuNcCFF4/rDkQBAZ1llNkZsDUOAc2EodEuS37Lx96HOCu
	 m6l6lszmlMKE7uRU+TcWWO2xmmF1cYjRRTxGABQ2WmnDzfdgygpKhPsYfvgwmryifo
	 8tI/sWP6wKGsP7px+Le4R90XG+i8TR/al25lzrYk=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389483AbgJNU6D (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 14 Oct 2020 16:58:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:48540 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387573AbgJNU6C (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 14 Oct 2020 16:58:02 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 97FAF20725;
        Wed, 14 Oct 2020 20:57:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602709080;
        bh=7cEqAqtQbGjG8MaL9rqs9JY8s/5Ay5kJgWg6Rw13RpA=;
        h=Date:From:To:Subject:From;
        b=1nYN0JO06/v/7OsjkEcbfkJnDIPXNd/mPd9BUOkXPCOs5ueHkhRZe4CAzZUEmpvhz
         JFAv8SUDHqfBNs/ZHGYUVIQtb03igSwy3OIU4tFglppLmUbL38YOQ53xgWKdWTcCgb
         4PhENsUd30zPihDAxD7OefJcQBAMa7DRzpx7SqVY=
Date:   Wed, 14 Oct 2020 13:57:58 -0700
From:   akpm@linux-foundation.org
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
Subject:  [merged]
 =?US-ASCII?Q?drivers-base-make-device=5Ffind=5Fchild=5Fby=5Fname-compat?=
 =?US-ASCII?Q?ible-with-sysfs-inputs.patch?= removed from -mm tree
Message-ID: <20201014205758.kt6a4JHR7%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/base: make device_find_child_by_name() compatible wit=
h sysfs inputs
has been removed from the -mm tree.  Its filename was
     drivers-base-make-device_find_child_by_name-compatible-with-sysfs-inpu=
ts.patch

This patch was dropped because it was merged into mainline or a subsystem t=
ree

------------------------------------------------------
=46rom: Dan Williams <dan.j.williams@intel.com>
Subject: drivers/base: make device_find_child_by_name() compatible with sys=
fs inputs

Use sysfs_streq() in device_find_child_by_name() to allow it to use a
sysfs input string that might contain a trailing newline.

The other "device by name" interfaces,
{bus,driver,class}_find_device_by_name(), already account for sysfs
strings.

Link: https://lkml.kernel.org/r/159643102106.4062302.12229802117645312104.s=
tgit@dwillia2-desk3.amr.corp.intel.com
Link: https://lkml.kernel.org/r/160106114576.30709.2960091665444712180.stgi=
t@dwillia2-desk3.amr.corp.intel.com
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
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
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Stefano Stabellini <sstabellini@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: Wei Yang <richard.weiyang@linux.alibaba.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/base/core.c~drivers-base-make-device_find_child_by_name-compa=
tible-with-sysfs-inputs
+++ a/drivers/base/core.c
@@ -3324,7 +3324,7 @@ struct device *device_find_child_by_name
=20
 	klist_iter_init(&parent->p->klist_children, &i);
 	while ((child =3D next_device(&i)))
-		if (!strcmp(dev_name(child), name) && get_device(child))
+		if (sysfs_streq(dev_name(child), name) && get_device(child))
 			break;
 	klist_iter_exit(&i);
 	return child;
_

Patches currently in -mm which might be from dan.j.williams@intel.com are


