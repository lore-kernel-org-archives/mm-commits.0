Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6ADEC433F5
	for <mm-commits@archiver.kernel.org>; Tue,  5 Oct 2021 21:31:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AC568614C8
	for <mm-commits@archiver.kernel.org>; Tue,  5 Oct 2021 21:31:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236085AbhJEVcv (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 5 Oct 2021 17:32:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:51000 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235679AbhJEVcv (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 5 Oct 2021 17:32:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 063CB61222;
        Tue,  5 Oct 2021 21:30:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1633469460;
        bh=N8oEXjMIvpXmdO6UtQg0LDXASUqeedmAavmwx3+puAg=;
        h=Date:From:To:Subject:From;
        b=rqx5N+CuXd3gQAbqtU+idEtVUy1NC7tV0TLMjRbpMd+W/zZvAg0HJJVMO5VnYCrKt
         vBUlu4MvFaNB2DZGwFJt33hmhcihHiqhOrUt99OnjGGBiCl41EiNbN3xTUtihxuSsd
         Hk6owKFvYtMOOqIBRoduizFavM+O/D72V/woAlhs=
Date:   Tue, 05 Oct 2021 14:30:59 -0700
From:   akpm@linux-foundation.org
To:     bhe@redhat.com, boris.ostrovsky@oracle.com,
        boris.ostrvsky@oracle.com, bp@alien8.de, david@redhat.com,
        dyoung@redhat.com, hpa@zytor.com, jasowang@redhat.com,
        jgross@suse.com, mhocko@suse.com, mingo@redhat.com,
        mm-commits@vger.kernel.org, mst@redhat.com, osalvador@suse.de,
        rafael.j.wysocki@intel.com, rppt@kernel.org,
        sstabellini@kernel.org, tglx@linutronix.de, vgoyal@redhat.com
Subject:  + proc-vmcore-let-pfn_is_ram-return-a-bool.patch added to
 -mm tree
Message-ID: <20211005213059.ZZgsB-fuv%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: proc/vmcore: let pfn_is_ram() return a bool
has been added to the -mm tree.  Its filename is
     proc-vmcore-let-pfn_is_ram-return-a-bool.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/proc-vmcore-let-pfn_is_ram-return-a-bool.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/proc-vmcore-let-pfn_is_ram-return-a-bool.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: proc/vmcore: let pfn_is_ram() return a bool

The callback should deal with errors internally, it doesn't make sense to
expose these via pfn_is_ram().  We'll rework the callbacks next.  Right
now we consider errors as if "it's RAM"; no functional change.

Link: https://lkml.kernel.org/r/20211005121430.30136-5-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Cc: Boris Ostrovsky <boris.ostrvsky@oracle.com>
Cc: Dave Young <dyoung@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jason Wang <jasowang@redhat.com>
Cc: Juergen Gross <jgross@suse.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Cc: Stefano Stabellini <sstabellini@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vivek Goyal <vgoyal@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/vmcore.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/fs/proc/vmcore.c~proc-vmcore-let-pfn_is_ram-return-a-bool
+++ a/fs/proc/vmcore.c
@@ -84,11 +84,11 @@ void unregister_oldmem_pfn_is_ram(void)
 }
 EXPORT_SYMBOL_GPL(unregister_oldmem_pfn_is_ram);
 
-static int pfn_is_ram(unsigned long pfn)
+static bool pfn_is_ram(unsigned long pfn)
 {
 	int (*fn)(unsigned long pfn);
 	/* pfn is ram unless fn() checks pagetype */
-	int ret = 1;
+	bool ret = true;
 
 	/*
 	 * Ask hypervisor if the pfn is really ram.
@@ -97,7 +97,7 @@ static int pfn_is_ram(unsigned long pfn)
 	 */
 	fn = oldmem_pfn_is_ram;
 	if (fn)
-		ret = fn(pfn);
+		ret = !!fn(pfn);
 
 	return ret;
 }
@@ -124,7 +124,7 @@ ssize_t read_from_oldmem(char *buf, size
 			nr_bytes = count;
 
 		/* If pfn is not ram, return zeros for sparse dump files */
-		if (pfn_is_ram(pfn) == 0)
+		if (!pfn_is_ram(pfn))
 			memset(buf, 0, nr_bytes);
 		else {
 			if (encrypted)
_

Patches currently in -mm which might be from david@redhat.com are

memory-hotplugrst-fix-two-instances-of-movablecore-that-should-be-movable_node.patch
memory-hotplugrst-fix-wrong-sys-module-memory_hotplug-parameters-path.patch
memory-hotplugrst-document-the-auto-movable-online-policy.patch
mm-memory_hotplug-remove-config_x86_64_acpi_numa-dependency-from-config_memory_hotplug.patch
mm-memory_hotplug-remove-config_memory_hotplug_sparse.patch
mm-memory_hotplug-restrict-config_memory_hotplug-to-64-bit.patch
mm-memory_hotplug-remove-highmem-leftovers.patch
mm-memory_hotplug-remove-stale-function-declarations.patch
x86-remove-memory-hotplug-support-on-x86_32.patch
x86-xen-update-xen_oldmem_pfn_is_ram-documentation.patch
x86-xen-simplify-xen_oldmem_pfn_is_ram.patch
x86-xen-print-a-warning-when-hvmop_get_mem_type-fails.patch
proc-vmcore-let-pfn_is_ram-return-a-bool.patch
proc-vmcore-convert-oldmem_pfn_is_ram-callback-to-more-generic-vmcore-callbacks.patch
virtio-mem-factor-out-hotplug-specifics-from-virtio_mem_init-into-virtio_mem_init_hotplug.patch
virtio-mem-factor-out-hotplug-specifics-from-virtio_mem_probe-into-virtio_mem_init_hotplug.patch
virtio-mem-factor-out-hotplug-specifics-from-virtio_mem_remove-into-virtio_mem_deinit_hotplug.patch
virtio-mem-kdump-mode-to-sanitize-proc-vmcore-access.patch
kernel-resource-clean-up-and-optimize-iomem_is_exclusive.patch
kernel-resource-disallow-access-to-exclusive-system-ram-regions.patch
virtio-mem-disallow-mapping-virtio-mem-memory-via-dev-mem.patch

