Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D27CC433EF
	for <mm-commits@archiver.kernel.org>; Thu, 20 Jan 2022 02:08:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232689AbiATCIA (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 19 Jan 2022 21:08:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229589AbiATCIA (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 19 Jan 2022 21:08:00 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16DDBC061574
        for <mm-commits@vger.kernel.org>; Wed, 19 Jan 2022 18:08:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 952AE6157F
        for <mm-commits@vger.kernel.org>; Thu, 20 Jan 2022 02:07:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2F20C340E4;
        Thu, 20 Jan 2022 02:07:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642644478;
        bh=oXTiz8bgm2yyRMJ9IjFGvVMYI9DBH4p4inEGj6yoaMU=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=yhNwuacDw7oNdeWaQpMKQzTDTYiGfKHO+rxqL6vsWcWhyZ16JfoXbAddTR9rkBsk3
         cnUxXDS87onZd3bb0a/Atv6Ce+3wdV32A+pJn0U6sGu+Betzm2euEVuGP1ft93H94m
         dIrpiKa1rdkDycUV85tnwmf9LtewKrWLMJ7Sr3yU=
Date:   Wed, 19 Jan 2022 18:07:57 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, bhe@redhat.com, david@redhat.com,
        dyoung@redhat.com, linux-mm@kvack.org, mm-commits@vger.kernel.org,
        prudo@redhat.com, torvalds@linux-foundation.org, vgoyal@redhat.com
Subject:  [patch 05/55] proc/vmcore: don't fake reading zeroes on
 surprise vmcore_cb unregistration
Message-ID: <20220120020757.dOiHTk8NT%akpm@linux-foundation.org>
In-Reply-To: <20220119180714.9e187ce100e4510de3cd9f7d@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
