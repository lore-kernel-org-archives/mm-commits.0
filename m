Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A014DC433FE
	for <mm-commits@archiver.kernel.org>; Mon, 15 Nov 2021 22:42:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7C60363219
	for <mm-commits@archiver.kernel.org>; Mon, 15 Nov 2021 22:42:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238186AbhKOWpJ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 15 Nov 2021 17:45:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:43364 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1353205AbhKOWXB (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 15 Nov 2021 17:23:01 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CF3E861B4A;
        Mon, 15 Nov 2021 22:20:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1637014804;
        bh=Ji4mfdDwCiIF+Wnh8j8PsXIaJnFnNkGfPLFJuPJtyrM=;
        h=Date:From:To:Subject:From;
        b=lJiPzfM8FsHOrFuVZx8uUv8+LcMLHrZleV3KlY1kPvDZgwKrj4w5f6ORjEkpjrOdH
         hAE8T+nbjLVxHbM7LA1ZnsAFWjUWsaz0T4PIvKhGqjc6AXmmVVY714sHq/Ig9L1y23
         RaywlzxlR/qwz7pPyUVF61SaBBp5JthVQoFNhzTE=
Date:   Mon, 15 Nov 2021 14:20:03 -0800
From:   akpm@linux-foundation.org
To:     bhe@redhat.com, david@redhat.com, dyoung@redhat.com,
        mm-commits@vger.kernel.org, prudo@redhat.com, vgoyal@redhat.com
Subject:  +
 =?US-ASCII?Q?proc-vmcore-dont-fake-reading-zeroes-on-surprise-vmcore?=
 =?US-ASCII?Q?=5Fcb-unregistration.patch?= added to -mm tree
Message-ID: <20211115222003.QYkcdi4zM%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: proc/vmcore: don't fake reading zeroes on surprise vmcore_cb unregistration
has been added to the -mm tree.  Its filename is
     proc-vmcore-dont-fake-reading-zeroes-on-surprise-vmcore_cb-unregistration.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/proc-vmcore-dont-fake-reading-zeroes-on-surprise-vmcore_cb-unregistration.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/proc-vmcore-dont-fake-reading-zeroes-on-surprise-vmcore_cb-unregistration.patch

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

proc-vmcore-fix-clearing-user-buffer-by-properly-using-clear_user.patch
proc-vmcore-dont-fake-reading-zeroes-on-surprise-vmcore_cb-unregistration.patch

