Return-Path: <SRS0=zz/k=DX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82274C433E7
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 02:45:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 30D3A20B1F
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 02:45:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602816354;
	bh=GwwDYHi8CgwGREfrI9r4HLpyt4wSx6VF17Hzsi0KT9A=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=QGRYF4dJxQlw6Tku5XE4IBnS1nKDU5yTXaXolps17I+jlB4NnbCyYYJKZTHfx77tr
	 p3fK/MD3HEXjTZlQEr6P8hLUzrEiYD8z9RZwIezGkuvI9YN+SeXng8uxzz9bW7FRCq
	 MgdO77s/pXPPfl/Wf440zqC2z1cyK2WWFa0arQKs=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404331AbgJPCpx (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 15 Oct 2020 22:45:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:33370 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404330AbgJPCpx (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 15 Oct 2020 22:45:53 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4A455208C7;
        Fri, 16 Oct 2020 02:45:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602816352;
        bh=GwwDYHi8CgwGREfrI9r4HLpyt4wSx6VF17Hzsi0KT9A=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=bcD/eG6kazOR+xIev+uttF3HHqS0wWMnofUYEKxe6EzeztPlUPaGT5J6WyEqxcjMd
         NmI7BRcKxcD8RJCD1b+P8RYt97kFLT+DZ0aGH5sKdMCqemTbvnfgFHgEghagCUItJy
         oo513jBgpq5Z03FFcqZJJ0jgWMMVDWJsIKjjtyhA=
Date:   Thu, 15 Oct 2020 19:45:49 -0700
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
Subject:  [patch 074/156] virtio-mem: try to merge system ram
 resources
Message-ID: <20201016024549.OL5yeCPAO%akpm@linux-foundation.org>
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
Subject: virtio-mem: try to merge system ram resources

virtio-mem adds memory in memory block granularity, to be able to remove
it in the same granularity again later, and to grow slowly on demand.=20
This, however, results in quite a lot of resources when adding a lot of
memory.  Resources are effectively stored in a list-based tree.  Having a
lot of resources not only wastes memory, it also makes traversing that
tree more expensive, and makes /proc/iomem explode in size (e.g.,
requiring kexec-tools to manually merge resources later when e.g., trying
to create a kdump header).

Before this patch, we get (/proc/iomem) when hotplugging 2G via virtio-mem
on x86-64:
        [...]
        100000000-13fffffff : System RAM
        140000000-33fffffff : virtio0
          140000000-147ffffff : System RAM (virtio_mem)
          148000000-14fffffff : System RAM (virtio_mem)
          150000000-157ffffff : System RAM (virtio_mem)
          158000000-15fffffff : System RAM (virtio_mem)
          160000000-167ffffff : System RAM (virtio_mem)
          168000000-16fffffff : System RAM (virtio_mem)
          170000000-177ffffff : System RAM (virtio_mem)
          178000000-17fffffff : System RAM (virtio_mem)
          180000000-187ffffff : System RAM (virtio_mem)
          188000000-18fffffff : System RAM (virtio_mem)
          190000000-197ffffff : System RAM (virtio_mem)
          198000000-19fffffff : System RAM (virtio_mem)
          1a0000000-1a7ffffff : System RAM (virtio_mem)
          1a8000000-1afffffff : System RAM (virtio_mem)
          1b0000000-1b7ffffff : System RAM (virtio_mem)
          1b8000000-1bfffffff : System RAM (virtio_mem)
        3280000000-32ffffffff : PCI Bus 0000:00

With this patch, we get (/proc/iomem):
        [...]
        fffc0000-ffffffff : Reserved
        100000000-13fffffff : System RAM
        140000000-33fffffff : virtio0
          140000000-1bfffffff : System RAM (virtio_mem)
        3280000000-32ffffffff : PCI Bus 0000:00

Of course, with more hotplugged memory, it gets worse.  When unplugging
memory blocks again, try_remove_memory() (via offline_and_remove_memory())
will properly split the resource up again.

Link: https://lkml.kernel.org/r/20200911103459.10306-7-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Pankaj Gupta <pankaj.gupta.linux@gmail.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Michael S. Tsirkin <mst@redhat.com>
Cc: Jason Wang <jasowang@redhat.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Wei Yang <richardw.yang@linux.intel.com>
Cc: Anton Blanchard <anton@ozlabs.org>
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: Eric Biederman <ebiederm@xmission.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Haiyang Zhang <haiyangz@microsoft.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Juergen Gross <jgross@suse.com>
Cc: Julien Grall <julien@xen.org>
Cc: Kees Cook <keescook@chromium.org>
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: Len Brown <lenb@kernel.org>
Cc: Leonardo Bras <leobras.c@gmail.com>
Cc: Libor Pechacek <lpechacek@suse.cz>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nathan Lynch <nathanl@linux.ibm.com>
Cc: "Oliver O'Halloran" <oohall@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Pingfan Liu <kernelfans@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Roger Pau Monn=C3=A9 <roger.pau@citrix.com>
Cc: Stefano Stabellini <sstabellini@kernel.org>
Cc: Stephen Hemminger <sthemmin@microsoft.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>
Cc: Wei Liu <wei.liu@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/virtio/virtio_mem.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/virtio/virtio_mem.c~virtio-mem-try-to-merge-system-ram-resour=
ces
+++ a/drivers/virtio/virtio_mem.c
@@ -424,7 +424,8 @@ static int virtio_mem_mb_add(struct virt
=20
 	dev_dbg(&vm->vdev->dev, "adding memory block: %lu\n", mb_id);
 	return add_memory_driver_managed(nid, addr, memory_block_size_bytes(),
-					 vm->resource_name, MHP_NONE);
+					 vm->resource_name,
+					 MEMHP_MERGE_RESOURCE);
 }
=20
 /*
_
