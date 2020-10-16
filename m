Return-Path: <SRS0=zz/k=DX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47E26C433E7
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 20:51:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DA16321D40
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 20:51:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602881488;
	bh=iTsxoVwbtrhZJvdUk0LUCNLx9PmAQxqGC/MKZvmoNIM=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=sr7jy1HicdG/OdVA3ULpYpIkpBOW2tfSfer6e5e9lTlk6wIzZhFh/iPPhlwh501Pu
	 MUDh1155zJpCsmgXWYornVoX1yiZvBmcQD0kB+HwpHsimAIuD0cmoIeDmUTHv9wjqa
	 DPXM466fz9JOft+x0B76zQMY949PJ4emrK1AP/fs=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406098AbgJPUv2 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 16 Oct 2020 16:51:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:40156 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732579AbgJPUv2 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 16 Oct 2020 16:51:28 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5CBA4218AC;
        Fri, 16 Oct 2020 20:51:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602881487;
        bh=iTsxoVwbtrhZJvdUk0LUCNLx9PmAQxqGC/MKZvmoNIM=;
        h=Date:From:To:Subject:From;
        b=BXEBQAQvrDUyYz5UjDTyd60IGPn8SQRLMoUkb6hA47M/4QxX8nHNR8qxmMXNhH8bq
         oQI66PvH2ba0gfqitc//p31GHRWk+hLEy5qDagQfHL0oIPRMYM88UfUsgkb7aBUO0f
         F0PqO3KHT4bJYbhd+G6+D3e10LZF6uEW+0lQYZ3g=
Date:   Fri, 16 Oct 2020 13:51:24 -0700
From:   akpm@linux-foundation.org
To:     anton@ozlabs.org, ardb@kernel.org, benh@kernel.crashing.org,
        bhe@redhat.com, boris.ostrovsky@oracle.com, borntraeger@de.ibm.com,
        dan.j.williams@intel.com, dave.jiang@intel.com, david@redhat.com,
        ebiederm@xmission.com, gor@linux.ibm.com,
        gregkh@linuxfoundation.org, haiyangz@microsoft.com,
        hca@linux.ibm.com, jasowang@redhat.com, jgg@ziepe.ca,
        jgross@suse.com, julien@xen.org, keescook@chromium.org,
        kernelfans@gmail.com, kys@microsoft.com, lenb@kernel.org,
        leobras.c@gmail.com, lpechacek@suse.cz, mhocko@suse.com,
        mm-commits@vger.kernel.org, mpe@ellerman.id.au, mst@redhat.com,
        nathanl@linux.ibm.com, oohall@gmail.com,
        pankaj.gupta.linux@gmail.com, paulus@samba.org,
        richardw.yang@linux.intel.com, rjw@rjwysocki.net,
        roger.pau@citrix.com, sstabellini@kernel.org,
        sthemmin@microsoft.com, tglx@linutronix.de,
        vishal.l.verma@intel.com, wei.liu@kernel.org
Subject:  [merged]
 hv_balloon-try-to-merge-system-ram-resources.patch removed from -mm tree
Message-ID: <20201016205124.KdiFcDzTd%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: hv_balloon: try to merge system ram resources
has been removed from the -mm tree.  Its filename was
     hv_balloon-try-to-merge-system-ram-resources.patch

This patch was dropped because it was merged into mainline or a subsystem t=
ree

------------------------------------------------------
=46rom: David Hildenbrand <david@redhat.com>
Subject: hv_balloon: try to merge system ram resources

Let's try to merge system ram resources we add, to minimize the number of
resources in /proc/iomem.  We don't care about the boundaries of
individual chunks we added.

Link: https://lkml.kernel.org/r/20200911103459.10306-9-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Wei Liu <wei.liu@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: Haiyang Zhang <haiyangz@microsoft.com>
Cc: Stephen Hemminger <sthemmin@microsoft.com>
Cc: Wei Liu <wei.liu@kernel.org>
Cc: Pankaj Gupta <pankaj.gupta.linux@gmail.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Wei Yang <richardw.yang@linux.intel.com>
Cc: Anton Blanchard <anton@ozlabs.org>
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: Eric Biederman <ebiederm@xmission.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Jason Wang <jasowang@redhat.com>
Cc: Juergen Gross <jgross@suse.com>
Cc: Julien Grall <julien@xen.org>
Cc: Kees Cook <keescook@chromium.org>
Cc: Len Brown <lenb@kernel.org>
Cc: Leonardo Bras <leobras.c@gmail.com>
Cc: Libor Pechacek <lpechacek@suse.cz>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Nathan Lynch <nathanl@linux.ibm.com>
Cc: "Oliver O'Halloran" <oohall@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Pingfan Liu <kernelfans@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Roger Pau Monn=C3=A9 <roger.pau@citrix.com>
Cc: Stefano Stabellini <sstabellini@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/hv/hv_balloon.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/hv/hv_balloon.c~hv_balloon-try-to-merge-system-ram-resources
+++ a/drivers/hv/hv_balloon.c
@@ -726,7 +726,7 @@ static void hv_mem_hot_add(unsigned long
=20
 		nid =3D memory_add_physaddr_to_nid(PFN_PHYS(start_pfn));
 		ret =3D add_memory(nid, PFN_PHYS((start_pfn)),
-				(HA_CHUNK << PAGE_SHIFT), MHP_NONE);
+				(HA_CHUNK << PAGE_SHIFT), MEMHP_MERGE_RESOURCE);
=20
 		if (ret) {
 			pr_err("hot_add memory failed error is %d\n", ret);
_

Patches currently in -mm which might be from david@redhat.com are


