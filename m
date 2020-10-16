Return-Path: <SRS0=zz/k=DX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8DAA8C43457
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 02:46:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 403472145D
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 02:46:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602816361;
	bh=7GDI2XYablzeUzkv1yO6KePHm+2rkj9CLhZSU22Y/aM=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=dqzSWKzz/Kjv+I2Pey3sr4qcszjBcxqt9JszLUq6yEE+KNIs/mmx4MH0bTdkYIVUS
	 DcujzcTRur3OJ1ZkuvoYvt6pr8J8DWtA9CGp99Yp5DHQVgOZa4KpaINdGFSa0Dh2xd
	 +/Q/HUspYAIdri/OgJhi4SXCesR+VwxVVMaScjmw=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404332AbgJPCqA (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 15 Oct 2020 22:46:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:33480 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404330AbgJPCqA (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 15 Oct 2020 22:46:00 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2A3A020897;
        Fri, 16 Oct 2020 02:45:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602816358;
        bh=7GDI2XYablzeUzkv1yO6KePHm+2rkj9CLhZSU22Y/aM=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=HKlxL/R/LwrnK6Ma+cCByHkyGJpFUBNunDBwCko996N0QmY+m5mv/wvLlL8oRMzg/
         9oPjoy9m+/IQCojilJZZ0C+dPdfvRQXMNTUvQ7C7mG+4xclzAMm0x9TmgiSfNKJ+E7
         uf14EFvxI8VNjbBCGHbXG6Elst2Viqy5NzKJXm5E=
Date:   Thu, 15 Oct 2020 19:45:55 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, anton@ozlabs.org, ardb@kernel.org,
        benh@kernel.crashing.org, bhe@redhat.com,
        boris.ostrovsky@oracle.com, borntraeger@de.ibm.com,
        dan.j.williams@intel.com, dave.jiang@intel.com, david@redhat.com,
        ebiederm@xmission.com, gor@linux.ibm.com,
        gregkh@linuxfoundation.org, haiyangz@microsoft.com,
        hca@linux.ibm.com, jasowang@redhat.com, jgg@ziepe.ca,
        jgross@suse.com, julien@xen.org, keescook@chromium.org,
        kernelfans@gmail.com, kys@microsoft.com, lenb@kernel.org,
        leobras.c@gmail.com, linux-mm@kvack.org, lpechacek@suse.cz,
        mhocko@suse.com, mm-commits@vger.kernel.org, mpe@ellerman.id.au,
        mst@redhat.com, nathanl@linux.ibm.com, oohall@gmail.com,
        pankaj.gupta.linux@gmail.com, paulus@samba.org,
        richardw.yang@linux.intel.com, rjw@rjwysocki.net,
        roger.pau@citrix.com, sstabellini@kernel.org,
        sthemmin@microsoft.com, tglx@linutronix.de,
        torvalds@linux-foundation.org, vishal.l.verma@intel.com,
        wei.liu@kernel.org
Subject:  [patch 075/156] xen/balloon: try to merge system ram
 resources
Message-ID: <20201016024555.XsJu-pAJ5%akpm@linux-foundation.org>
In-Reply-To: <20201015192732.f448da14e9854c7cb7299956@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

=46rom: David Hildenbrand <david@redhat.com>
Subject: xen/balloon: try to merge system ram resources

Let's try to merge system ram resources we add, to minimize the number of
resources in /proc/iomem.  We don't care about the boundaries of
individual chunks we added.

Link: https://lkml.kernel.org/r/20200911103459.10306-8-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Juergen Gross <jgross@suse.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Cc: Stefano Stabellini <sstabellini@kernel.org>
Cc: Roger Pau Monn=C3=A9 <roger.pau@citrix.com>
Cc: Julien Grall <julien@xen.org>
Cc: Pankaj Gupta <pankaj.gupta.linux@gmail.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Wei Yang <richardw.yang@linux.intel.com>
Cc: Anton Blanchard <anton@ozlabs.org>
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: Eric Biederman <ebiederm@xmission.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Haiyang Zhang <haiyangz@microsoft.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Jason Wang <jasowang@redhat.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
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
Cc: Stephen Hemminger <sthemmin@microsoft.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>
Cc: Wei Liu <wei.liu@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/xen/balloon.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/xen/balloon.c~xen-balloon-try-to-merge-system-ram-resources
+++ a/drivers/xen/balloon.c
@@ -331,7 +331,7 @@ static enum bp_state reserve_additional_
 	mutex_unlock(&balloon_mutex);
 	/* add_memory_resource() requires the device_hotplug lock */
 	lock_device_hotplug();
-	rc =3D add_memory_resource(nid, resource, MHP_NONE);
+	rc =3D add_memory_resource(nid, resource, MEMHP_MERGE_RESOURCE);
 	unlock_device_hotplug();
 	mutex_lock(&balloon_mutex);
=20
_
