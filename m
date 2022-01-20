Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ECD66C433F5
	for <mm-commits@archiver.kernel.org>; Thu, 20 Jan 2022 21:29:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377909AbiATV33 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 20 Jan 2022 16:29:29 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:59408 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377907AbiATV33 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 20 Jan 2022 16:29:29 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2A7B3B81E54
        for <mm-commits@vger.kernel.org>; Thu, 20 Jan 2022 21:29:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B171BC340E0;
        Thu, 20 Jan 2022 21:29:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642714166;
        bh=G2ypDJpwZ6UPEgsfOlgTa9w4DsfrT0S33crr8J43n28=;
        h=Date:From:To:Subject:From;
        b=VYYQP7cbrtzUfJYz8hCYVp1HOkVMtIlhmqL1j1bYt+MdPaTaMz+S2MTnWiVRMaqf2
         ZOD534Nxu5zxG8JlbmVfN9RyJ+8Cwkb1MGKJ+boJO8pVFHScYtAArb2LHV8uOkKqjk
         StDWnNtq6v4GLIRNWtVE5ZfvevcVnUuvueP2THj4=
Date:   Thu, 20 Jan 2022 13:29:26 -0800
From:   akpm@linux-foundation.org
To:     bhe@redhat.com, david@redhat.com, dyoung@redhat.com,
        mm-commits@vger.kernel.org, prudo@redhat.com, vgoyal@redhat.com
Subject:  [merged]
 =?US-ASCII?Q?proc-vmcore-dont-fake-reading-zeroes-on-surprise-vmcore?=
 =?US-ASCII?Q?=5Fcb-unregistration.patch?= removed from -mm tree
Message-ID: <20220120212926.iJHzbcOXJ%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: proc/vmcore: don't fake reading zeroes on surprise vmcore_cb unregistration
has been removed from the -mm tree.  Its filename was
     proc-vmcore-dont-fake-reading-zeroes-on-surprise-vmcore_cb-unregistration.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: proc/vmcore: don't fake reading zeroes on surprise vmcore_cb unregistration

In commit cc5f2704c934 ("proc/vmcore: convert oldmem_pfn_is_ram callback
to more generic vmcore callbacks"), we added detection of surprise
vmcore_cb unregistration after the vmcore was already opened.  Once
detected, we warn the user and simulate reading zeroes from that point on
when accessing the vmcore.

The basic reason was that unexpected unregistration, for example, by
manually unbinding a driver from a device after opening the vmcore, is not
supported and could result in reading oldmem the vmcore_cb would have
actually prohibited while registered.  However, something like that can
similarly be trigger by a user that's really looking for trouble simply by
unbinding the relevant driver before opening the vmcore -- or by
disallowing loading the driver in the first place.  So it's actually of
limited help.

Currently, unregistration can only be triggered via virtio-mem when
manually unbinding the driver from the device inside the VM; there is no
way to trigger it from the hypervisor, as hypervisors don't allow for
unplugging virtio-mem devices -- ripping out system RAM from a VM without
coordination with the guest is usually not a good idea.

The important part is that unbinding the driver and unregistering the
vmcore_cb while concurrently reading the vmcore won't crash the system,
and that is handled by the rwsem.

To make the mechanism more future proof, let's remove the "read zero"
part, but leave the warning in place.  For example, we could have a future
driver (like virtio-balloon) that will contact the hypervisor to figure
out if we already populated a page for a given PFN.  Hotunplugging such a
device and consequently unregistering the vmcore_cb could be triggered
from the hypervisor without harming the system even while kdump is
running.  In that case, we don't want to silently end up with a vmcore
that contains wrong data, because the user inside the VM might be unaware
of the hypervisor action and might easily miss the warning in the log.

Link: https://lkml.kernel.org/r/20211111192243.22002-1-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Acked-by: Baoquan He <bhe@redhat.com>
Cc: Dave Young <dyoung@redhat.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: Philipp Rudo <prudo@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/vmcore.c |   10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

--- a/fs/proc/vmcore.c~proc-vmcore-dont-fake-reading-zeroes-on-surprise-vmcore_cb-unregistration
+++ a/fs/proc/vmcore.c
@@ -65,8 +65,6 @@ static size_t vmcoredd_orig_sz;
 static DECLARE_RWSEM(vmcore_cb_rwsem);
 /* List of registered vmcore callbacks. */
 static LIST_HEAD(vmcore_cb_list);
-/* Whether we had a surprise unregistration of a callback. */
-static bool vmcore_cb_unstable;
 /* Whether the vmcore has been opened once. */
 static bool vmcore_opened;
 
@@ -94,10 +92,8 @@ void unregister_vmcore_cb(struct vmcore_
 	 * very unusual (e.g., forced driver removal), but we cannot stop
 	 * unregistering.
 	 */
-	if (vmcore_opened) {
+	if (vmcore_opened)
 		pr_warn_once("Unexpected vmcore callback unregistration\n");
-		vmcore_cb_unstable = true;
-	}
 	up_write(&vmcore_cb_rwsem);
 }
 EXPORT_SYMBOL_GPL(unregister_vmcore_cb);
@@ -108,8 +104,6 @@ static bool pfn_is_ram(unsigned long pfn
 	bool ret = true;
 
 	lockdep_assert_held_read(&vmcore_cb_rwsem);
-	if (unlikely(vmcore_cb_unstable))
-		return false;
 
 	list_for_each_entry(cb, &vmcore_cb_list, next) {
 		if (unlikely(!cb->pfn_is_ram))
@@ -581,7 +575,7 @@ static int vmcore_remap_oldmem_pfn(struc
 	 * looping over all pages without a reason.
 	 */
 	down_read(&vmcore_cb_rwsem);
-	if (!list_empty(&vmcore_cb_list) || vmcore_cb_unstable)
+	if (!list_empty(&vmcore_cb_list))
 		ret = remap_oldmem_pfn_checked(vma, from, pfn, size, prot);
 	else
 		ret = remap_oldmem_pfn_range(vma, from, pfn, size, prot);
_

Patches currently in -mm which might be from david@redhat.com are


