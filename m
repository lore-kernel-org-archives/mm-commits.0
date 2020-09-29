Return-Path: <SRS0=qjDH=DG=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A09B6C4727C
	for <mm-commits@archiver.kernel.org>; Tue, 29 Sep 2020 20:24:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4E9B22076D
	for <mm-commits@archiver.kernel.org>; Tue, 29 Sep 2020 20:24:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1601411044;
	bh=gaZwUvy4idtI1cuSgnuMRekFkcst7xN6tS2k+JVMfSI=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=Vsx+3I+wLJq8NLbca95QPisLbvVrIZCbUKCJQQiDcq6lhuNnFoC1+4hO7t7ClX5NU
	 cO/euxdOcY0y1ChdHJWGb0X0UovmtLLVje7PEO5xri9RHy0RWmEAXP6WO8Z7BYYhsk
	 dOc4MbAcRvye1eNXxOMCmhDAC5DNkgPAjHsT30Rc=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728859AbgI2UYD (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 29 Sep 2020 16:24:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:32812 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725372AbgI2UYD (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 29 Sep 2020 16:24:03 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CE1D72076B;
        Tue, 29 Sep 2020 20:24:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601411041;
        bh=gaZwUvy4idtI1cuSgnuMRekFkcst7xN6tS2k+JVMfSI=;
        h=Date:From:To:Subject:From;
        b=N7rTpXR2RYeXZv9BLQdmA44We/cAW0jRxWybhseBSGLc9tAKz1AYGJ/9m209vYGyM
         Uxtef/KCh6uTQ3IMWDtyfjdMvRy8vZ8whVWsWwyTrkQVVQL5qXy/WQwCW5MnMB/DkT
         IAF1+4/RCRTM3/AifsMsjM9Xete7fR+gkNRQRj64=
Date:   Tue, 29 Sep 2020 13:24:00 -0700
From:   akpm@linux-foundation.org
To:     david@redhat.com, mhocko@suse.com, mm-commits@vger.kernel.org,
        paulmck@linux.vnet.ibm.com, tglx@linutronix.de, urezki@gmail.com
Subject:  +
 mm-clarify-usage-of-gfp_atomic-in-preemptible-contexts.patch added to -mm
 tree
Message-ID: <20200929202400.xjqU3pkAM%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: include/linux/gfp.h: clarify usage of GFP_ATOMIC in !preemptible contexts
has been added to the -mm tree.  Its filename is
     mm-clarify-usage-of-gfp_atomic-in-preemptible-contexts.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-clarify-usage-of-gfp_atomic-in-preemptible-contexts.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-clarify-usage-of-gfp_atomic-in-preemptible-contexts.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Michal Hocko <mhocko@suse.com>
Subject: include/linux/gfp.h: clarify usage of GFP_ATOMIC in !preemptible contexts

There is a general understanding that GFP_ATOMIC/GFP_NOWAIT are to be used
from atomic contexts.  E.g.  from within a spin lock or from the IRQ
context.  This is correct but there are some atomic contexts where the
above doesn't hold.  One of them would be an NMI context.  Page allocator
has never supported that and the general fear of this context didn't let
anybody to actually even try to use the allocator there.  Good, but let's
be more specific about that.

Another such a context, and that is where people seem to be more daring,
is raw_spin_lock.  Mostly because it simply resembles regular spin lock
which is supported by the allocator and there is not any implementation
difference with !RT kernels in the first place.  Be explicit that such a
context is not supported by the allocator.  The underlying reason is that
zone->lock would have to become raw_spin_lock as well and that has turned
out to be a problem for RT
(http://lkml.kernel.org/r/87mu305c1w.fsf@nanos.tec.linutronix.de).

Link: https://lkml.kernel.org/r/20200929123010.5137-1-mhocko@kernel.org
Signed-off-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/gfp.h |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/include/linux/gfp.h~mm-clarify-usage-of-gfp_atomic-in-preemptible-contexts
+++ a/include/linux/gfp.h
@@ -238,7 +238,9 @@ struct vm_area_struct;
  * %__GFP_FOO flags as necessary.
  *
  * %GFP_ATOMIC users can not sleep and need the allocation to succeed. A lower
- * watermark is applied to allow access to "atomic reserves"
+ * watermark is applied to allow access to "atomic reserves".
+ * The current implementation doesn't support NMI and few other strict
+ * non-preemptive contexts (e.g. raw_spin_lock). The same applies to %GFP_NOWAIT.
  *
  * %GFP_KERNEL is typical for kernel-internal allocations. The caller requires
  * %ZONE_NORMAL or a lower zone for direct access but can direct reclaim.
_

Patches currently in -mm which might be from mhocko@suse.com are

mm-clarify-usage-of-gfp_atomic-in-preemptible-contexts.patch

