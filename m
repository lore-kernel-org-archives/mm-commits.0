Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6402C433EF
	for <mm-commits@archiver.kernel.org>; Fri, 15 Oct 2021 19:24:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9EDDB61056
	for <mm-commits@archiver.kernel.org>; Fri, 15 Oct 2021 19:24:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237996AbhJOT0L (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 15 Oct 2021 15:26:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:38438 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230372AbhJOT0L (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 15 Oct 2021 15:26:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5843261151;
        Fri, 15 Oct 2021 19:24:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1634325844;
        bh=fJjTSGJjQeBoZ3uNPKounFZ3zG+XohfyrwVFlFAutew=;
        h=Date:From:To:Subject:From;
        b=xmK/R5RwbAaItMl8xOn3TdqzbxfdP5/k3z/wbP0t8/3cqkSSqToeWQ8O60zuxGOwm
         ozxmNMVS7F/5NSv5cITQZyrwzQSe1vP10ckcqAJaYvjck72jVR1Qx3OcoCP8/r1F8S
         yKTHILjjHoYG03+q5uh0XQMZzcNAa1Mh82+K2IK8=
Date:   Fri, 15 Oct 2021 12:24:03 -0700
From:   akpm@linux-foundation.org
To:     david@redhat.com, mm-commits@vger.kernel.org,
        skhan@linuxfoundation.org
Subject:  +
 selftests-vm-make-madv_populate_readwrite-use-in-tree-headers.patch added
 to -mm tree
Message-ID: <20211015192403.LbdQtxxiN%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests/vm: make MADV_POPULATE_(READ|WRITE) use in-tree headers
has been added to the -mm tree.  Its filename is
     selftests-vm-make-madv_populate_readwrite-use-in-tree-headers.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/selftests-vm-make-madv_populate_readwrite-use-in-tree-headers.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/selftests-vm-make-madv_populate_readwrite-use-in-tree-headers.patch

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
Subject: selftests/vm: make MADV_POPULATE_(READ|WRITE) use in-tree headers

The madv_populate selftest currently builds with a warning when the local
installed headers (via the distribution) don't include MADV_POPULATE_READ
and MADV_POPULATE_WRITE.  The warning is correct, because the test cannot
locate the necessary header.

Reason is that the in-tree installed headers (usr/include) have a "linux"
instead of a "sys" subdirectory.

Including "linux/mman.h" instead of "sys/mman.h" doesn't work (e.g.,
mmap() and madvise() are not defined that way).  The only thing that seems
to work is including "linux/mman.h" in addition to "sys/mman.h".

We can get rid of our availability check and simplify.

Link: https://lkml.kernel.org/r/20211015165758.41374-1-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Reported-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/madv_populate.c |   15 +--------------
 1 file changed, 1 insertion(+), 14 deletions(-)

--- a/tools/testing/selftests/vm/madv_populate.c~selftests-vm-make-madv_populate_readwrite-use-in-tree-headers
+++ a/tools/testing/selftests/vm/madv_populate.c
@@ -14,12 +14,11 @@
 #include <unistd.h>
 #include <errno.h>
 #include <fcntl.h>
+#include <linux/mman.h>
 #include <sys/mman.h>
 
 #include "../kselftest.h"
 
-#if defined(MADV_POPULATE_READ) && defined(MADV_POPULATE_WRITE)
-
 /*
  * For now, we're using 2 MiB of private anonymous memory for all tests.
  */
@@ -328,15 +327,3 @@ int main(int argc, char **argv)
 				   err, ksft_test_num());
 	return ksft_exit_pass();
 }
-
-#else /* defined(MADV_POPULATE_READ) && defined(MADV_POPULATE_WRITE) */
-
-#warning "missing MADV_POPULATE_READ or MADV_POPULATE_WRITE definition"
-
-int main(int argc, char **argv)
-{
-	ksft_print_header();
-	ksft_exit_skip("MADV_POPULATE_READ or MADV_POPULATE_WRITE not defined\n");
-}
-
-#endif /* defined(MADV_POPULATE_READ) && defined(MADV_POPULATE_WRITE) */
_

Patches currently in -mm which might be from david@redhat.com are

selftests-vm-make-madv_populate_readwrite-use-in-tree-headers.patch
memory-hotplugrst-fix-two-instances-of-movablecore-that-should-be-movable_node.patch
memory-hotplugrst-fix-wrong-sys-module-memory_hotplug-parameters-path.patch
memory-hotplugrst-document-the-auto-movable-online-policy.patch
memory-hotplugrst-document-the-auto-movable-online-policy-v2.patch
mm-memory_hotplug-remove-config_x86_64_acpi_numa-dependency-from-config_memory_hotplug.patch
mm-memory_hotplug-remove-config_memory_hotplug_sparse.patch
mm-memory_hotplug-restrict-config_memory_hotplug-to-64-bit.patch
mm-memory_hotplug-remove-highmem-leftovers.patch
mm-memory_hotplug-remove-stale-function-declarations.patch
x86-remove-memory-hotplug-support-on-x86_32.patch
mm-memory_hotplug-handle-memblock_add_node-failures-in-add_memory_resource.patch
memblock-improve-memblock_hotplug-documentation.patch
memblock-allow-to-specify-flags-with-memblock_add_node.patch
memblock-add-memblock_driver_managed-to-mimic-ioresource_sysram_driver_managed.patch
mm-memory_hotplug-indicate-memblock_driver_managed-with-ioresource_sysram_driver_managed.patch
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

